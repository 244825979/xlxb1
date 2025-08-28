//
//  ASIMChatController.swift
//  AS
//
//  Created by SA on 2025/5/15.
//

import UIKit
import NEChatUIKit
import NIMSDK

class ASIMChatController: P2PChatViewController {
    var horPageView = ASIMRollScrollView()
    let topView = ASIMChatTopView()
    lazy var videoShowView: ASVideoShowPlayerView = {
        let view = ASVideoShowPlayerView()
        view.isHidenIcon = false
        view.isPopType = true
        view.isHidden = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addDragableAction { rect in }
        return view
    }()
    lazy var activityFloatingView: ASIMActivityFloatingView = {
        let view = ASIMActivityFloatingView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.closeBlock = { [weak self] in
            guard let self = self else { return }
            self.activityFloatingView.isHidden = true
        }
        view.addDragableAction { rect in }
        return view
    }()
    var isTID = 0//是否小助手进入私聊
    var isSendMsg = false//是否发送了消息
    typealias backBlock = ()->()
    var sendBankBlock: backBlock?//发送了IM消息回调
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shouldNavigationBarHidden = true
        homeData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ASIMManager.shared().updateUnreadCount()
        if self.isBeingDismissed || self.isMovingFromParent {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    func createUI() {
        horPageView.backgroundColor = .clear
        horPageView.frame = CGRectMake(0, kNavigationHeight + KStatusBarHeight, kScreenWidth, 46)
        view.addSubview(horPageView)
        topView.frame = CGRectMake(0, 46, kScreenWidth, 189 + 46)
        tableView.tableHeaderView = topView
    }
    
    override func commonUI() {
        super.commonUI()
    }
    
    func homeData() {
        myUserID = ASUserDataManager.shared().user_id
        p2pChatDelegate = self
        if isSystemUser == false {
            createUI()
            if ASUserDataManager.shared().systemIndexModel.mtype == 0 {
                requestIntimateData()
                getMoreRecentSessions()
            }
            requestData()
            requestUsefulExpressionsData()
            if let list = ASUserDataManager.shared().usesHiddenListModel.hiddenToUserID as? Array<String>, list.contains(userID ?? "") {
                self.isOpenHiding = true
                self.viewmodel.isOpenHiding = true
            }
            NotificationCenter.default.rac_addObserver(forName: "closeToHidingNotify", object: nil).subscribeNext { [weak self] notification in
                guard let self = self else { return }
                let userid = notification?.object as? String ?? ""
                if userid == self.userID {
                    self.isOpenHiding = false
                    self.viewmodel.isOpenHiding = false
                    self.expandMoreAction()
                }
            }
        } else {
            if (userID == NEKitChatConfig.shared.kefuzushou_id) {
                let serviceBtn = UIButton()
                serviceBtn.setBackgroundImage(UIImage.init(named: "button_bg"), for: .normal)
                serviceBtn.setTitle("联系客服", for: .normal)
                serviceBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
                serviceBtn.addTarget(self, action: #selector(serviceCliked), for: .touchUpInside)
                serviceBtn.translatesAutoresizingMaskIntoConstraints = false
                serviceBtn.setTitleColor(.white, for: .normal)
                serviceBtn.adjustsImageWhenHighlighted = false//去掉点击效果
                view.addSubview(serviceBtn)
                NSLayoutConstraint.activate([
                    serviceBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    serviceBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
                    serviceBtn.heightAnchor.constraint(equalToConstant: 50),
                    serviceBtn.widthAnchor.constraint(equalToConstant: 319),
                ])
            }
        }
        NotificationCenter.default.rac_addObserver(forName: "netWorkChatReachabilityNotify", object: nil).subscribeNext { [weak self] notification in
            guard let self = self else { return }
            let status = notification?.object as? NSNumber
            if status == 0 {
                horPageView.y = kNavigationHeight + KStatusBarHeight + 36
            } else {
                horPageView.y = kNavigationHeight + KStatusBarHeight
            }
        }
    }
    
    func requestData() {
        ASIMRequest.requestChatCardData(withUserID: userID ?? "") { [weak self] cardModel in
            guard let self = self else { return }
            if let model = cardModel as? ASIMChatCardModel {
                self.topView.model = model
                self.topView.frame = CGRectMake(0, 46, kScreenWidth, model.viewHeight + 46)
                self.tableView.reloadData()
                self.requestChatPriceData()
                if model.gender == 1 {
                    self.requestVideoData()
                }
            }
        } errorBack: { code, msg in }
        ASIMRequest.requestOpenHidingState(withID: userID ?? "") { [weak self] data in
            guard let self = self else { return }
            if let model = data as? ASUsersHiddenStateModel {
                self.isOpenHiding = model.from_hidden
            }
            self.expandMoreAction()
        } errorBack: { code, msg in }
        ASIMRequest.requestIMChatActive(withCateId: "8") { [weak self] data in
            guard let self = self else { return }
            if let model = data as? ASBannerModel {
                self.view.addSubview(self.activityFloatingView)
                if model.img.isEmpty {
                    self.activityFloatingView.isHidden = true
                } else {
                    self.activityFloatingView.isHidden = false
                }
                self.activityFloatingView.model = model
                NSLayoutConstraint.activate([
                    self.activityFloatingView.bottomAnchor.constraint(equalTo: self.usefulExpressionsView.topAnchor, constant: -150),
                    self.activityFloatingView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
                    self.activityFloatingView.widthAnchor.constraint(equalToConstant: 64),
                    self.activityFloatingView.heightAnchor.constraint(equalToConstant: 88)
                ])
            }
        } errorBack: { code, msg in }
    }
    //视频秀数据
    func requestVideoData() {
        ASIMRequest.requestIMVideoShow(withUserID: userID ?? "") { [weak self] videoShowModel in
            guard let self = self else { return }
            if let model = videoShowModel as? ASVideoShowDataModel, model.video_url.count > 0 {
                self.view.addSubview(self.videoShowView)
                NSLayoutConstraint.activate([
                    self.videoShowView.bottomAnchor.constraint(equalTo: self.usefulExpressionsView.topAnchor, constant: -50),
                    self.videoShowView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
                    self.videoShowView.widthAnchor.constraint(equalToConstant: 64),
                    self.videoShowView.heightAnchor.constraint(equalToConstant: 76)
                ])
                self.videoShowView.isHidden = false
                self.videoShowView.model = model
                if model.showDuration > 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + model.showDuration) {
                        self.videoShowView.isHidden = true
                    }
                }
                if model.showDuration == 0 {
                    self.videoShowView.isHidden = true
                }
            } else {
                self.videoShowView.isHidden = true
            }
        } errorBack: { code, msg in
            self.videoShowView.isHidden = true
        }
    }
    //男用户价格
    func requestChatPriceData() {
        ASIMRequest.requestIMChatPriceWith(toUserId: userID ?? "") { [weak self] data in
            guard let self = self else { return }
            if let msgPrice = data as? String, msgPrice.count > 0 {
                self.chatInputView.textView.placeholder = msgPrice
            }
        } errorBack: { code, msg in
            
        }
    }
    func requestIntimateData() {
        ASIMRequest.requestIntimateList(withIds: self.userID ?? "") { response in
            let responseDict = response as? NSArray ?? []
            let list = ASIntimateListModel.mj_objectArray(withKeyValuesArray: responseDict) as? [ASIntimateListModel] ?? []
            if (list.count > 0) {
                for model in list {
                    let score = model.score
                    if score.count > 0 {
                        let dict = ["user_id": model.user_id, "grade": model.grade, "score": score] as [String : Any];
                        let key = ASUserDataManager.shared().user_id + "_intimate_" + "\(model.user_id)"
                        UserDefaults.standard.set(dict, forKey: key)
                        NotificationCenter.default.post(name: Notification.Name("updataIntimateValueNitification"), object: nil)
                    }
                    if model.grade > 0 {
                        NotificationCenter.default.post(name: Notification.Name("refreshMiyouNotification"), object: "2")
                    }
                }
            }
        } errorBack: { code, msg in }
    }
    
    func getMoreRecentSessions() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: DispatchWorkItem(block: {
            let unreadCount = ASIMManager.shared().conversationCount()
            if unreadCount > 0 {//未读消息大于0，才显示
                let recentSessions = NIMSDK.shared().conversationManager.allRecentSessions()
                if let sessions = recentSessions {
                    //判断会话的扩展字段，1表示小助手，2为搭讪列表。判断系统类型的消息
                    self.unreadSessions = sessions.filter { recentSession in
                        if let localExt = recentSession.localExt {
                            let conversationType = localExt["conversation_type"] as? String ?? ""
                            if conversationType == "1" || conversationType == "2" || conversationType == "3" {
                                return false
                            }
                        }
                        if let sessionID = recentSession.session?.sessionId {
                            if sessionID == NEKitChatConfig.shared.xitongxiaoxi_id ||
                                sessionID == NEKitChatConfig.shared.huodongxiaozushou_id {
                                return false
                            }
                        }
                        if recentSession.unreadCount == 0 {
                            return false
                        }
                        return true
                    }
                }
            }
        }))
    }
    
    func requestUsefulExpressionsData() {
        let option = NIMMessageSearchOption()
        option.limit = 1
        option.order = .desc
        option.fromIds = [ASUserDataManager.shared().user_id]
        option.messageTypes = [0,1,2]//文本、图片、语音类型检索
        NIMSDK.shared().conversationManager.searchMessages(viewmodel.session, option: option) { [weak self] error, messages in
            guard let self = self else { return }
            if error == nil {
                self.requestUsefulExpressions(messages: messages?.count ?? 0)
            } else {
                self.requestUsefulExpressions(messages: 0)
            }
        }
    }
    
    func requestUsefulExpressions(messages: NSInteger) {
        ASIMRequest.requestUsefulExpressionsList(withScene: 1, isReply: messages > 0 ? 0 : 1) { [weak self] dict in
            guard let self = self else { return }
            self.usefulExpressionsTitles = dict as? [[String: Any]?] ?? []
        } errorBack: { code, msg in
            
        }
    }
    func serviceCliked() {
        let vc = ASBaseWebViewController();
        vc.webUrl = "\(String(ASConfigConst.shared().server_h5_url))\(ASUserDataManager.shared().systemIndexModel.mtype == 0 ? "app/customer" : "app/customer-a")"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override open func toSetting() {
        let vc = ASIMChatSetController()
        vc.userID = self.userID ?? ""
        vc.delBlock = {
            self.viewmodel.messages.removeAll()
            self.tableView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    override open func intimateEvent() {
        ASIMRequest.requestUserIntimate(withUserID: userID ?? "") { data in
            ASAlertViewManager.popIntimacyDetails(with: data as? ASIMIntimateUserModel ?? ASIMIntimateUserModel())
        } errorBack: { code, msg in
            
        }
    }
}

extension ASIMChatController: IMP2PChatDelegate {
    func nextBtnCliked(userID: String) {
        if self.isSystemUser == true {
            return
        }
        ASIMFuncManager.chatOneViewController(userId: userID, nickName: "")
    }
    
    func sendMessage(message: NIMMessage, type: NSInteger) {
        if self.isSystemUser == true {
            return
        }
        ASIMActionManager.send(message, type: type, isTid: self.isTID, toUserID: self.userID ?? "") { [weak self] msg, model in
            guard let self = self else { return }
            self.verifySendMessage(message: msg as? NIMMessage ?? NIMMessage())
            if (self.isSendMsg == false) {
                self.isSendMsg = true
                if (self.sendBankBlock != nil) {
                    self.sendBankBlock!()
                }
            }
            if model.is_chat_card == 1 {//聊天卡消息
                self.requestChatPriceData()
            }
        } errorBack: { [weak self] code, msg in
            guard let self = self else { return }
            self.chatInputView.textView.resignFirstResponder()
        }
    }
    
    func buttonClikedItem(type: ChatTabbarItemType) {
        if self.isSystemUser == true {
            return
        }
        ASIMActionManager.chatInputViewItem(with: type, toUserID:self.userID ?? "") { [weak self] data in
            guard let self = self else { return }
            switch type {
            case .image:
                let image = data as? UIImage ?? UIImage()
                self.sendMediaMessage(didFinishPickingMediaWithInfo: image)
            case .expressions:
                if let text = data as? String {
                    self.sendText(text: text, attribute: nil)
                }
            default:
                print("item点击事件")
            }
        }
    }
    
    func tapUserHeader(isLeft: Bool) {
        if self.isSystemUser == true {
            return
        }
        ASIMActionManager.goPersonalHomeWith(toUserID: self.userID ?? "", isMy: !isLeft)
    }
    
    //播放语音操作
    func playAudio(url: String) {
        if self.isSystemUser == true {
            return
        }
        if ASAudioPlayManager.shared().isPlay == true {
            ASAudioPlayManager.shared().stop()
        } else {
            ASAudioPlayManager.shared().play(from: url)
        }
    }
    
    //语音暂停
    func stopAudio() {
        if self.isSystemUser == true {
            return
        }
        ASAudioPlayManager.shared().stop()
    }
    
    //是否在播放语音中
    func isPlayingAudio() -> Bool {
        return ASAudioPlayManager.shared().isPlay
    }
    
    //自定义消息点击单点
    func didTapCustomCell(customModel: IMCustomDataModel, type: NSInteger) {
        if customModel.linkType == 0 && customModel.link_type == 0 {
            return
        }
        let model = ASBannerModel()
        model.link_url = customModel.linkUrl.count > 0 ? customModel.linkUrl : customModel.link_url
        model.link_type = customModel.linkType == 1 ? customModel.linkType : customModel.link_type
        ASMyAppCommonFunc.bannerCliked(with: model, viewController: self) { data in }
    }
    
    func moreViewClikedItem(type: NEMoreActionType) {
        switch type {
        case .hiding:
            openHidingAction()
        case .sendVip:
            ASMyAppCommonFunc.sendVip(withUserID: self.userID ?? "") { }
        default:
            print("更多点击")
        }
    }
    
    func openHidingAction() {
        self.view.endEditing(true)
        ASMyAppCommonFunc.openHidingCliked(withIsOpen: self.isOpenHiding, userID: self.userID ?? "", nickName: self.title ?? "") { [weak self] isOpen in
            guard let self = self else { return }
            self.isOpenHiding = isOpen
            self.viewmodel.isOpenHiding = isOpen
            self.expandMoreAction()
            ASMsgTool.showTips(self.isOpenHiding == false ? "已解除" : "已开启")
        }
    }
}
