
// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NECommonUIKit
import NECoreKit
import NIMSDK
import UIKit

@objc
public protocol NEBaseConversationControllerDelegate {
    func onDataLoaded()
}

@objcMembers
open class NEBaseConversationController: UIViewController, NIMChatManagerDelegate, UIGestureRecognizerDelegate {
    var className = "NEBaseConversationController"
    public var deleteBottonBackgroundColor: UIColor = NEConstant.hexRGB(0xA8ABB6)
    public var brokenNetworkViewHeight = 36.0
    private var bodyTopViewHeightAnchor: NSLayoutConstraint?
    private var bodyBottomViewHeightAnchor: NSLayoutConstraint?
    public var contentViewTopAnchor: NSLayoutConstraint?
    public var topConstant: CGFloat = 0
    public var popListView = NEBasePopListView()
    public var delegate: NEBaseConversationControllerDelegate?
    public var bodyTopViewHeight: CGFloat = 0 {
        didSet {
            bodyTopViewHeightAnchor?.constant = bodyTopViewHeight
            bodyTopView.isHidden = bodyTopViewHeight <= 0
        }
    }
    
    public var bodyBottomViewHeight: CGFloat = 0 {
        didSet {
            bodyBottomViewHeightAnchor?.constant = bodyBottomViewHeight
            bodyBottomView.isHidden = bodyBottomViewHeight <= 0
        }
    }
    
    public var cellRegisterDic = [0: NEBaseConversationListCell.self]
    public let viewModel = ConversationViewModel()
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showTitleBar()
        viewModel.loadStickTopSessionInfos { [weak self] error, sessionInfos in
            NELog.infoLog(
                ModuleName + " " + (self?.className ?? "NEBaseConversationController"),
                desc: "CALLBACK loadStickTopSessionInfos " + (error?.localizedDescription ?? "no error")
            )
            if let infos = sessionInfos {
                self?.viewModel.stickTopInfos = infos
                self?.reloadTableView()
                self?.delegate?.onDataLoaded()
            }
        }
        NEChatDetectNetworkTool.shareInstance.netWorkReachability { [weak self] status in
            if status == .notReachable {
                self?.brokenNetworkView.isHidden = false
                self?.contentViewTopAnchor?.constant = (self?.brokenNetworkViewHeight ?? 36) + (self?.topConstant ?? 0)
                NotificationCenter.default.post(name: Notification.Name("netWorkReachabilityNotify"), object: 0)
            } else {
                self?.brokenNetworkView.isHidden = true
                self?.contentViewTopAnchor?.constant = self?.topConstant ?? 0
                NotificationCenter.default.post(name: Notification.Name("netWorkReachabilityNotify"), object: 1)
            }
        }
        if navigationController?.viewControllers.count ?? 0 > 0 {
            if let root = navigationController?.viewControllers[0] as? UIViewController {
                if root.isKind(of: NEBaseConversationController.self) {
                    navigationController?.interactivePopGestureRecognizer?.delegate = self
                }
            }
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        showTitleBar()
        setupSubviews()
        requestData()
        initialConfig()
        NIMSDK.shared().chatManager.add(self)
        NotificationCenter.default.addObserver(self, selector: #selector(didRefreshTable), name: NENotificationName.updateFriendInfo, object: nil)
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        popListView.removeSelf()
    }
    
    deinit {
        NIMSDK.shared().chatManager.remove(self)
    }
    
    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let navigationController = navigationController,
           navigationController.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)),
           gestureRecognizer == navigationController.interactivePopGestureRecognizer,
           navigationController.visibleViewController == navigationController.viewControllers.first {
            return false
        }
        return true
    }
    
    open func showTitleBar() {
        if let useSystemNav = NEConfigManager.instance.getParameter(key: useSystemNav) as? Bool, useSystemNav {
            if NEKitConversationConfig.shared.ui.showTitleBar {
                navigationController?.isNavigationBarHidden = false
            } else {
                navigationController?.isNavigationBarHidden = true
            }
        } else {
            navigationController?.isNavigationBarHidden = true
        }
    }
    
    open func setupSubviews() {
        view.addSubview(bodyTopView)
        view.addSubview(bodyView)
        view.addSubview(bodyBottomView)
        
        NSLayoutConstraint.activate([
            bodyTopView.topAnchor.constraint(equalTo: view.topAnchor),
            bodyTopView.leftAnchor.constraint(equalTo: view.leftAnchor),
            bodyTopView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        bodyTopViewHeightAnchor = bodyTopView.heightAnchor.constraint(equalToConstant: bodyTopViewHeight)
        bodyTopViewHeightAnchor?.isActive = true
        
        NSLayoutConstraint.activate([
            bodyView.topAnchor.constraint(equalTo: bodyTopView.bottomAnchor),
            bodyView.leftAnchor.constraint(equalTo: view.leftAnchor),
            bodyView.rightAnchor.constraint(equalTo: view.rightAnchor),
            bodyView.bottomAnchor.constraint(equalTo: bodyBottomView.topAnchor),
        ])
        
        NSLayoutConstraint.activate([
            bodyBottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bodyBottomView.leftAnchor.constraint(equalTo: view.leftAnchor),
            bodyBottomView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        bodyBottomViewHeightAnchor = bodyBottomView.heightAnchor.constraint(equalToConstant: bodyBottomViewHeight)
        bodyBottomViewHeightAnchor?.isActive = true
        
        cellRegisterDic.forEach { (key: Int, value: NEBaseConversationListCell.Type) in
            tableView.register(value, forCellReuseIdentifier: "\(key)")
        }
        
        if let customController = NEKitConversationConfig.shared.ui.customController {
            customController(self)
        }
    }
    
    open func initialConfig() {
        viewModel.delegate = self
    }
    
    public func requestData() {
        let params = NIMFetchServerSessionOption()
        params.minTimestamp = 0
        params.maxTimestamp = Date().timeIntervalSince1970 * 1000
        params.limit = 50
        weak var weakSelf = self
        viewModel.fetchServerSessions(option: params) { error, recentSessions in
            if error == nil {
                NELog.infoLog(ModuleName + " " + self.className, desc: "✅CALLBACK fetchServerSessions SUCCESS")
                if let recentList = recentSessions {
                    NELog.infoLog(ModuleName + " " + self.className, desc: "✅CALLBACK fetchServerSessions SUCCESS count : \(recentList.count)")
                    if recentList.count > 0 {
                        weakSelf?.emptyView.isHidden = true
                        weakSelf?.reloadTableView()
                        weakSelf?.delegate?.onDataLoaded()
                    } else {
                        weakSelf?.emptyView.isHidden = false
                    }
                }
                
            } else {
                NELog.errorLog(
                    ModuleName + " " + self.className,
                    desc: "❌CALLBACK fetchServerSessions failed，error = \(error!)"
                )
                weakSelf?.emptyView.isHidden = false
            }
        }
    }
    
    public lazy var bodyTopView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    public lazy var bodyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        view.addSubview(brokenNetworkView)
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            brokenNetworkView.topAnchor.constraint(equalTo: view.topAnchor),
            brokenNetworkView.leftAnchor.constraint(equalTo: view.leftAnchor),
            brokenNetworkView.rightAnchor.constraint(equalTo: view.rightAnchor),
            brokenNetworkView.heightAnchor.constraint(equalToConstant: brokenNetworkViewHeight),
        ])
        
        contentViewTopAnchor = contentView.topAnchor.constraint(equalTo: view.topAnchor)
        contentViewTopAnchor?.isActive = true
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: view.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        return view
    }()
    
    public lazy var brokenNetworkView: NEBrokenNetworkView = {
        let view = NEBrokenNetworkView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    public lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.addSubview(tableView)
        view.addSubview(emptyView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: tableView.topAnchor, constant: topConstant),
            emptyView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            emptyView.leftAnchor.constraint(equalTo: tableView.leftAnchor),
            emptyView.rightAnchor.constraint(equalTo: tableView.rightAnchor),
        ])
        
        return view
    }()
    
    public lazy var emptyView: NEEmptyDataView = {
        let view = NEEmptyDataView(
            image: UIImage.ne_imageNamed(name: "conversation_nodata"),
            content: "\n暂无消息",
            frame: CGRect.zero
        )
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.backgroundColor = .clear
        return view
    }()
    
    public lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        return tableView
    }()
    
    public lazy var bodyBottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
}

extension NEBaseConversationController: TabNavigationViewDelegate {
    /// 标题栏左侧按钮点击事件
    func brandBtnClick() {
        NEKitConversationConfig.shared.ui.titleBarLeftClick?()
    }
    
    open func searchAction() {
        if let searchBlock = NEKitConversationConfig.shared.ui.titleBarRight2Click {
            searchBlock()
            return
        }
        
        Router.shared.use(
            SearchContactPageRouter,
            parameters: ["nav": navigationController as Any],
            closure: nil
        )
    }
    
    open func getPopListView() -> NEBasePopListView {
        NEBasePopListView()
    }
    
    open func getPopListItems() -> [PopListItem] {
        weak var weakSelf = self
        var items = [PopListItem]()
        let addFriend = PopListItem()
        addFriend.completion = {
            Router.shared.use(
                ContactAddFriendRouter,
                parameters: ["nav": self.navigationController as Any],
                closure: nil
            )
        }
        items.append(addFriend)
        
        let createGroup = PopListItem()
        createGroup.completion = {
            weakSelf?.createDiscussGroup()
        }
        items.append(createGroup)
        
        let createDicuss = PopListItem()
        createDicuss.completion = {
            weakSelf?.createSeniorGroup()
        }
        items.append(createDicuss)
        
        return items
    }
    
    open func didClickAddBtn() {
        if let addBlock = NEKitConversationConfig.shared.ui.titleBarRightClick {
            addBlock()
            return
        }
        
        if IMKitClient.instance.getConfigCenter().teamEnable {
            popListView.itemDatas = getPopListItems()
            popListView.frame = CGRect(origin: .zero, size: view.frame.size)
            popListView.removeSelf()
            view.addSubview(popListView)
        } else {
            Router.shared.use(
                ContactAddFriendRouter,
                parameters: ["nav": navigationController as Any],
                closure: nil
            )
        }
    }
    
    open func createDiscussGroup() {
        Router.shared.register(ContactSelectedUsersRouter) { param in
            print("user setting accids : ", param)
            Router.shared.use(TeamCreateDisuss, parameters: param, closure: nil)
        }
        Router.shared.use(
            ContactUserSelectRouter,
            parameters: ["nav": navigationController as Any, "limit": inviteNumberLimit],
            closure: nil
        )
        weak var weakSelf = self
        Router.shared.register(TeamCreateDiscussResult) { param in
            print("create discuss ", param)
            if let code = param["code"] as? Int, let teamid = param["teamId"] as? String,
               code == 0 {
                let session = weakSelf?.viewModel.repo.createTeamSession(teamid)
                Router.shared.use(
                    PushTeamChatVCRouter,
                    parameters: ["nav": weakSelf?.navigationController as Any,
                                 "session": session as Any],
                    closure: nil
                )
            } else if let msg = param["msg"] as? String {
                weakSelf?.showToast(msg)
            }
        }
    }
    
    open func createSeniorGroup() {
        Router.shared.register(ContactSelectedUsersRouter) { param in
            Router.shared.use(TeamCreateSenior, parameters: param, closure: nil)
        }
        Router.shared.use(
            ContactUserSelectRouter,
            parameters: ["nav": navigationController as Any, "limit": 200],
            closure: nil
        )
        weak var weakSelf = self
        Router.shared.register(TeamCreateSeniorResult) { param in
            print("create senior : ", param)
            if let code = param["code"] as? Int, let teamid = param["teamId"] as? String,
               code == 0 {
                let session = weakSelf?.viewModel.repo.createTeamSession(teamid)
                Router.shared.use(
                    PushTeamChatVCRouter,
                    parameters: ["nav": weakSelf?.navigationController as Any,
                                 "session": session as Any],
                    closure: nil
                )
            } else if let msg = param["msg"] as? String {
                weakSelf?.showToast(msg)
            }
        }
    }
    
    // MARK: =========================NIMChatManagerDelegate========================
    
    open func onRecvRevokeMessageNotification(_ notification: NIMRevokeMessageNotification) {
        guard let msg = notification.message else {
            return
        }
        
        if ConversationDeduplicationHelper.instance.isRevokeMessageSaved(messageId: msg.messageId) {
            return
        }
        saveRevokeMessage(msg) { [weak self] error in
        }
    }
    
    open func saveRevokeMessage(_ message: NIMMessage, _ completion: @escaping (Error?) -> Void) {
        let messageNew = NIMMessage()
        messageNew.text = localizable("message_recalled")
        var muta = [String: Any]()
        muta[revokeLocalMessage] = true
        //    if message.messageType == .text {
        //      muta[revokeLocalMessageContent] = message.text
        //    }
        messageNew.timestamp = message.timestamp
        messageNew.from = message.from
        messageNew.localExt = muta
        let setting = NIMMessageSetting()
        setting.shouldBeCounted = false
        setting.isSessionUpdate = false
        messageNew.setting = setting
        if let session = message.session {
            viewModel.repo.saveMessageToDB(messageNew, session, completion)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension NEBaseConversationController: UITableViewDelegate, UITableViewDataSource {
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.conversationListArray?.count ?? 0
        NELog.infoLog(ModuleName + " " + "ConversationController",
                      desc: "numberOfRowsInSection count : \(count)")
        return count
    }
    
    open func tableView(_ tableView: UITableView,
                        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.conversationListArray?[indexPath.row]
        let reusedId = "\(model?.customType ?? 0)"
        let cell = tableView.dequeueReusableCell(withIdentifier: reusedId, for: indexPath)
        
        if let c = cell as? NEBaseConversationListCell {
            c.topStickInfos = viewModel.stickTopInfos
            c.configData(sessionModel: model)
            
            if let userID = model?.userInfo?.userId {
                if userID == NEKitConversationConfig.shared.xitongxiaoxi_id { //表示系统消息，进行置顶
                    //添加置顶
                    let params = NIMAddStickTopSessionParams(session: model?.recentSession?.session ?? NIMSession())
                    NIMSDK.shared().chatExtendManager.addStickTopSession(params)
                } else {
                    if userID != NEKitConversationConfig.shared.huodongxiaozushou_id ||
                        userID != NEKitConversationConfig.shared.xiaomishu_id ||
                        userID != NEKitConversationConfig.shared.kefuzushou_id { //小助手
                        //进行在线状态订阅
                        let request = NIMSubscribeRequest()
                        request.type = 1
                        request.expiry = 60*60*24*1
                        request.syncEnabled = true
                        request.publishers = [userID]
                        NIMSDK.shared().subscribeManager.subscribeEvent(request) { error, list in
                            print(error)
                        }
                    }
                }
            }
        }
        return cell
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversationModel = viewModel.conversationListArray?[indexPath.row]
        if let didClick = NEKitConversationConfig.shared.ui.itemClick {
            didClick(conversationModel, indexPath)
            return
        }
        let sid = conversationModel?.recentSession?.session?.sessionId ?? ""
        let sessionType = conversationModel?.recentSession?.session?.sessionType ?? .P2P
        onselectedTableRow(sessionType: sessionType, sessionId: sid, indexPath: indexPath)
    }
    
    open func tableView(_ tableView: UITableView,
                        editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        weak var weakSelf = self
        var rowActions = [UITableViewRowAction]()
        
        let conversationModel = weakSelf?.viewModel.conversationListArray?[indexPath.row]
        guard let recentSession = conversationModel?.recentSession,
              let session = recentSession.session else {
            return rowActions
        }
        
        let deleteAction = UITableViewRowAction(style: .destructive,
                                                title: NEKitConversationConfig.shared.ui.deleteBottonTitle) { action, indexPath in
            weakSelf?.deleteActionHandler(action: action, indexPath: indexPath)
        }
        
        // 置顶和取消置顶
        let isTop = viewModel.stickTopInfos[session] != nil
        let topAction = UITableViewRowAction(style: .destructive,
                                             title: isTop ? NEKitConversationConfig.shared.ui.stickTopBottonCancelTitle :
                                                NEKitConversationConfig.shared.ui.stickTopBottonTitle) { action, indexPath in
            weakSelf?.topActionHandler(action: action, indexPath: indexPath, isTop: isTop)
        }
        deleteAction.backgroundColor = NEKitConversationConfig.shared.ui.deleteBottonBackgroundColor ?? deleteBottonBackgroundColor
        topAction.backgroundColor = NEKitConversationConfig.shared.ui.stickTopBottonBackgroundColor ?? NEConstant.hexRGB(0x337EFF)
        
        if let userID = conversationModel?.userInfo?.userId {
            if userID == NEKitConversationConfig.shared.xitongxiaoxi_id {//系统消息
                return rowActions
            }
            if userID == NEKitConversationConfig.shared.huodongxiaozushou_id ||//活动小助手
                userID == NEKitConversationConfig.shared.xiaomishu_id ||//小秘书
                userID == NEKitConversationConfig.shared.kefuzushou_id  { //客服小助手
                rowActions.append(topAction)
                return rowActions
            }
        }
        rowActions.append(deleteAction)
        rowActions.append(topAction)
        return rowActions
    }
    
    /*
     @available(iOS 11.0, *)
     open func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
     
     var rowActions = [UIContextualAction]()
     
     let deleteAction = UIContextualAction(style: .normal, title: "删除") { (action, sourceView, completionHandler) in
     
     //            self.dataSource.remove(at: indexPath.row)
     //            tableView.deleteRows(at: [indexPath], with: .automatic)
     // 需要返回true，否则没有反应
     completionHandler(true)
     }
     deleteAction.backgroundColor = NEConstant.hexRGB(0xA8ABB6)
     rowActions.append(deleteAction)
     
     let topAction = UIContextualAction(style: .normal, title: "置顶") { (action, sourceView, completionHandler) in
     
     //            self.dataSource.remove(at: indexPath.row)
     //            tableView.deleteRows(at: [indexPath], with: .automatic)
     // 需要返回true，否则没有反应
     completionHandler(true)
     }
     topAction.backgroundColor = NEConstant.hexRGB(0x337EFF)
     rowActions.append(topAction)
     
     let actionConfig = UISwipeActionsConfiguration.init(actions: rowActions)
     actionConfig.performsFirstActionWithFullSwipe = false
     
     return actionConfig
     }
     */
    
    open func deleteActionHandler(action: UITableViewRowAction?, indexPath: IndexPath) {
        let conversationModel = viewModel.conversationListArray?[indexPath.row]
        
        if let deleteBottonClick = NEKitConversationConfig.shared.ui.deleteBottonClick {
            deleteBottonClick(conversationModel, indexPath)
            return
        }
        
        if let recentSession = conversationModel?.recentSession {
//            viewModel.deleteRecentSession(recentSession: recentSession)
            NotificationCenter.default.post(name: Notification.Name("removeRecentSessionNotification"), object: ["session": recentSession.session])
            
            didDeleteConversationCell(
                model: conversationModel ?? ConversationListModel(),
                indexPath: indexPath
            )
        }
    }
    
    open func topActionHandler(action: UITableViewRowAction?, indexPath: IndexPath, isTop: Bool) {
        if !NEChatDetectNetworkTool.shareInstance.isNetworkRecahability() {
            showToast(localizable("network_error"))
            return
        }
        let conversationModel = viewModel.conversationListArray?[indexPath.row]
        
        if let stickTopBottonClick = NEKitConversationConfig.shared.ui.stickTopBottonClick {
            stickTopBottonClick(conversationModel, indexPath)
            return
        }
        
        if let recentSession = conversationModel?.recentSession {
            onTopRecentAtIndexPath(
                rencent: recentSession,
                indexPath: indexPath,
                isTop: isTop
            ) { [weak self] error, sessionInfo in
                if error == nil {
                    if isTop {
                        self?.didRemoveStickTopSession(
                            model: conversationModel ?? ConversationListModel(),
                            indexPath: indexPath
                        )
                    } else {
                        self?.didAddStickTopSession(
                            model: conversationModel ?? ConversationListModel(),
                            indexPath: indexPath
                        )
                    }
                }
            }
        }
    }
    
    private func onTopRecentAtIndexPath(rencent: NIMRecentSession, indexPath: IndexPath,
                                        isTop: Bool,
                                        _ completion: @escaping (NSError?, NIMStickTopSessionInfo?)
                                        -> Void) {
        guard let session = rencent.session else {
            NELog.errorLog(ModuleName + " " + className, desc: "❌session is nil")
            return
        }
        weak var weakSelf = self
        if isTop {
            guard let params = viewModel.stickTopInfos[session] else {
                return
            }
            
            viewModel.removeStickTopSession(params: params) { error, topSessionInfo in
                if let err = error {
                    NELog.errorLog(
                        ModuleName + " " + (weakSelf?.className ?? "ConversationController"),
                        desc: "❌CALLBACK removeStickTopSession failed，error = \(err)"
                    )
                    completion(error as NSError?, nil)
                    
                    return
                } else {
                    NELog.infoLog(
                        ModuleName + " " + (weakSelf?.className ?? "ConversationController"),
                        desc: "✅CALLBACK removeStickTopSession SUCCESS"
                    )
                    weakSelf?.viewModel.stickTopInfos[session] = nil
                    weakSelf?.reloadTableView()
                    completion(nil, topSessionInfo)
                }
            }
            
        } else {
            viewModel.addStickTopSession(session: session) { error, newInfo in
                if let err = error {
                    NELog.errorLog(
                        ModuleName + " " + (weakSelf?.className ?? "ConversationController"),
                        desc: "❌CALLBACK addStickTopSession failed，error = \(err)"
                    )
                    completion(error as NSError?, nil)
                    return
                } else {
                    NELog.infoLog(ModuleName + " " + (weakSelf?.className ?? "ConversationController"),
                                  desc: "✅CALLBACK addStickTopSession callback SUCCESS")
                    weakSelf?.viewModel.stickTopInfos[session] = newInfo
                    weakSelf?.reloadTableView()
                    completion(nil, newInfo)
                }
            }
        }
    }
}

// MARK: UI UIKit提供的重写方法

extension NEBaseConversationController {
    /// cell点击事件,可重写该事件处理自己的逻辑业务，例如跳转到指定的会话页面
    /// - Parameters:
    ///   - sessionType: 会话类型
    ///   - sessionId: 会话id
    ///   - indexPath: indexpath
    open func onselectedTableRow(sessionType: NIMSessionType, sessionId: String,
                                 indexPath: IndexPath) {
        if sessionType == .P2P {
            let session = NIMSession(sessionId, type: .P2P)
            Router.shared.use(
                PushP2pChatVCRouter,
                parameters: ["nav": navigationController as Any, "session": session as Any],
                closure: nil
            )
        } else if sessionType == .team {
            let session = NIMSession(sessionId, type: .team)
            Router.shared.use(
                PushTeamChatVCRouter,
                parameters: ["nav": navigationController as Any, "session": session as Any],
                closure: nil
            )
        }
    }
    
    /// 删除会话
    /// - Parameters:
    ///   - model: 会话模型
    ///   - indexPath: indexpath
    open func didDeleteConversationCell(model: ConversationListModel, indexPath: IndexPath) {}
    
    /// 删除一条置顶记录
    /// - Parameters:
    ///   - model: 会话模型
    ///   - indexPath: indexpath
    open func didRemoveStickTopSession(model: ConversationListModel, indexPath: IndexPath) {}
    
    /// 添加一条置顶记录
    /// - Parameters:
    ///   - model: 会话模型
    ///   - indexPath: indexpath
    open func didAddStickTopSession(model: ConversationListModel, indexPath: IndexPath) {}
}

// MARK: ================= ConversationViewModelDelegate===================
extension NEBaseConversationController: ConversationViewModelDelegate {
    open func didAddRecentSession() {
        NELog.infoLog("ConversationController", desc: "didAddRecentSession")
        let myUserID = UserDefaults.standard.value(forKey: "userinfo_user_id") as? String ?? ""
        if viewModel.imListType == .friend {//亲密度列表
            //过滤掉小于2级亲密度的用户
            viewModel.conversationListArray = viewModel.conversationListArray?.filter { model in
                if let recentSession = model.recentSession, let sid = recentSession.session?.sessionId {
                    let intimateKey = myUserID + "_intimate_" + sid
                    let intimateData = UserDefaults.standard.value(forKey: intimateKey) as? NSDictionary ?? [:]
                    let grade = intimateData["grade"] as? NSInteger ?? 0
                    if grade < 2 {
                        return false
                    } else {
                        return true
                    }
                }
                return false
            }
        } else if viewModel.imListType == .dashan {
            //搭讪列表仅显示搭讪用户，筛选掉除了搭讪以为的数据
            let dashanList = UserDefaults.standard.value(forKey: "userinfo_dashan_list_" + myUserID) as? [String] ?? []
            viewModel.conversationListArray = viewModel.filterConversations(conversations: viewModel.conversationListArray ?? [], sessionIds: dashanList)
        } else {
            //过滤掉小助手、搭讪、系统通知、活动通知的数据
            let dashanList = UserDefaults.standard.value(forKey: "userinfo_dashan_list_" + myUserID) as? [String] ?? []
            let helperList = UserDefaults.standard.value(forKey: "userinfo_helper_list_" + myUserID) as? [String] ?? []
            var userList = NSMutableArray.init(array: dashanList) as? [String] ?? []
            userList.append(contentsOf: helperList)
            userList.append(NEKitConversationConfig.shared.huodongxiaozushou_id)
            userList.append(NEKitConversationConfig.shared.xitongxiaoxi_id)
            viewModel.conversationListArray = viewModel.filterConversationsExcluding(conversations: viewModel.conversationListArray ?? [], excludeSessionIds: userList)
        }
        reloadTableView()
    }
    
    open func didUpdateRecentSession(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    open func reloadData() {
        delegate?.onDataLoaded()
    }
    
    open func didRefreshTable() {
        tableView.reloadData()
    }
    
    open func reloadTableView() {
        emptyView.isHidden = (viewModel.conversationListArray?.count ?? 0) > 0
        viewModel.sortRecentSession()
        didRefreshTable()
    }
}
