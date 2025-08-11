//
//  ASIMConversationListController.swift
//  AS
//
//  Created by SA on 2025/5/14.
//

import UIKit
import NEConversationUIKit
import NIMSDK

let kScreenWidth: CGFloat = UIScreen.main.bounds.size.width
let kScreenHeight: CGFloat = UIScreen.main.bounds.size.height

class ASIMConversationListController: ConversationController, JXCategoryListContentViewDelegate, NIMConversationManagerDelegate {
    lazy var foldView: ASIMConversationFoldView = {
        let view = ASIMConversationFoldView()
        view.backgroundColor = UIColor(hexString: "#FFF1F1")
        return view
    }()
    lazy var topBtn: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setBackgroundImage(UIImage(named: "up_top"), for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.rac_signal(for: .touchUpInside).subscribeNext { [weak self] control in
            guard let self = self else { return }
            self.tableView.setContentOffset(.zero, animated: true)
        }
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.imListType = .conversation
        NIMSDK.shared().conversationManager.add(self)
        topConstant = 100//顶部预留100的高度显示item
        if ASUserDataManager.shared().gender == 2 && ASIMHelperDataManager.shared().dashanList.count == 0 {//判断男用户切没有折叠用户
            foldView.isHidden = true
            foldView.frame = CGRectMake(0, 0, kScreenWidth, 0)
        } else {
            foldView.isHidden = false
            foldView.frame = CGRectMake(0, 0, kScreenWidth, 76)
        }
        foldView.dashanAmount = ASIMHelperDataManager.shared().dashanAmount
        tableView.tableHeaderView = foldView
        view.addSubview(topBtn)
        topBtn.frame = CGRectMake(kScreenWidth - 80, kScreenHeight - (ASUserDataManager.shared().gender == 1 ? 450 : 340), 70, 70)
        notificationDispose()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTableView()
        foldView.isUnread = ASIMManager.shared().dashanIsUnread()
    }
    
    func notificationDispose() {
        //删除会话列表消息
        NotificationCenter.default.rac_addObserver(forName: "deleteMsgListNotification", object: nil).subscribeNext { [weak self] notification in
            guard let self = self else { return }
            if let conversationListArray = self.viewModel.conversationListArray, conversationListArray.count > 0 {
                //移除会话消息
                for n in 0 ..< conversationListArray.count {
                    let model = conversationListArray[n]
                    if let recentSession = model.recentSession, let session = recentSession.session {
                        if let localExt = recentSession.localExt {
                            let conversationType = localExt["conversation_type"] as? String ?? ""
                            if conversationType == "1" || conversationType == "2" {
                                continue
                            }
                        }
                        if session.sessionId == NEKitConversationConfig.shared.xitongxiaoxi_id ||
                            session.sessionId == NEKitConversationConfig.shared.huodongxiaozushou_id ||
                            session.sessionId == NEKitConversationConfig.shared.xiaomishu_id ||
                            session.sessionId == NEKitConversationConfig.shared.kefuzushou_id {
                            continue
                        }
                        let intimateKey = ASUserDataManager.shared().user_id + "_intimate_" + session.sessionId
                        let intimateData = UserDefaults.standard.value(forKey: intimateKey) as? NSDictionary ?? [:]
                        let grade = intimateData["grade"] as? NSInteger ?? 0
                        if grade < 2 {
                            //清空聊天内容，删除会话消息
                            let messagesOption = NIMDeleteMessagesOption()
                            messagesOption.removeSession = true
                            messagesOption.removeTable = true
                            NIMSDK.shared().conversationManager.deleteAllmessages(in: session, option: messagesOption)
                            let cloudOption = NIMClearMessagesOption()
                            cloudOption.removeRoam = true
                            NIMSDK.shared().conversationManager.deleteSelfRemoteSession(session, option: cloudOption)
                            //取消在线状态订阅
                            let request = NIMSubscribeRequest()
                            request.type = 1
                            request.expiry = 60*60*24*1
                            request.syncEnabled = true
                            request.publishers = [session.sessionId]
                            NIMSDK.shared().subscribeManager.unSubscribeEvent(request) { error, list in
                            }
                        } else {
                            //清空聊天内容，不删除会话
                            let messagesOption = NIMDeleteMessagesOption()
                            messagesOption.removeSession = false
                            messagesOption.removeTable = true
                            NIMSDK.shared().conversationManager.deleteAllmessages(in: session, option: messagesOption)
                            let cloudOption = NIMClearMessagesOption()
                            cloudOption.removeRoam = true
                            NIMSDK.shared().conversationManager.deleteSelfRemoteSession(session, option: cloudOption)
                        }
                    }
                }
            }
        }
        //自动清理会话列表消息
        NotificationCenter.default.rac_addObserver(forName: "clearDeleteMsgListNotification", object: nil).subscribeNext { [weak self] notification in
            guard let self = self else { return }
            //获取当前时间
            let timeStr = (ASCommonFunc.currentTimeStr() as NSString).intValue
            //处理搭讪列表的会话数据
            if ASIMHelperDataManager.shared().dashanList.count > 0 {
                var dashanList = ASIMHelperDataManager.shared().dashanList//没处理前的搭讪用户
                for userid in ASIMHelperDataManager.shared().dashanList {
                    let session = NIMSession.init(userid as? String ?? "", type: .P2P)
                    //获取亲密度判断，有亲密度不处理
                    let intimateKey = ASUserDataManager.shared().user_id + "_intimate_" + session.sessionId
                    let intimateData = UserDefaults.standard.value(forKey: intimateKey) as? NSDictionary ?? [:]
                    let score = intimateData["score"] as? NSString ?? ""
                    if score.floatValue > 0 {
                        continue
                    }
                    let recentSession = NIMSDK.shared().conversationManager.recentSession(by: session)
                    if let rs = recentSession, Int(timeStr) - Int(rs.lastMessage?.timestamp ?? 0.0) > 43200 {
                        //清空聊天内容，删除会话消息
                        let messagesOption = NIMDeleteMessagesOption()
                        messagesOption.removeSession = true
                        messagesOption.removeTable = true
                        NIMSDK.shared().conversationManager.deleteAllmessages(in: session, option: messagesOption)
                        let cloudOption = NIMClearMessagesOption()
                        cloudOption.removeRoam = true
                        NIMSDK.shared().conversationManager.deleteSelfRemoteSession(session, option: cloudOption)
                        //取消在线状态订阅
                        let request = NIMSubscribeRequest()
                        request.type = 1
                        request.expiry = 60*60*24*1
                        request.syncEnabled = true
                        request.publishers = [session.sessionId]
                        NIMSDK.shared().subscribeManager.unSubscribeEvent(request) { error, list in
                        }
                        if dashanList.contains(userid) {
                            dashanList.remove(userid)
                        }
                    }
                }
                //同步搭讪列表的用户数据
                ASIMHelperDataManager.shared().dashanList = dashanList
                ASUserDefaults.setValue(dashanList, forKey: "userinfo_dashan_list_" + ASUserDataManager.shared().user_id)
            }
            
            if let conversationListArray = self.viewModel.conversationListArray, conversationListArray.count > 0 {
                for n in 0 ..< conversationListArray.count {
                    let model = conversationListArray[n]
                    if let recentSession = model.recentSession, let session = recentSession.session {
                        if session.sessionId == NEKitConversationConfig.shared.xitongxiaoxi_id ||
                            session.sessionId == NEKitConversationConfig.shared.huodongxiaozushou_id ||
                            session.sessionId == NEKitConversationConfig.shared.xiaomishu_id ||
                            session.sessionId == NEKitConversationConfig.shared.kefuzushou_id {
                            continue
                        }
                        //是否置顶，置顶消息不删除
                        if viewModel.stickTopInfos[session] != nil {
                            continue
                        }
                        //获取亲密度判断，有亲密度不处理
                        let intimateKey = ASUserDataManager.shared().user_id + "_intimate_" + session.sessionId
                        let intimateData = UserDefaults.standard.value(forKey: intimateKey) as? NSDictionary ?? [:]
                        let score = intimateData["score"] as? NSString ?? ""
                        if score.floatValue > 0 {
                            continue
                        }
                        //消息时间超过12小时
                        if (Int(timeStr) - Int(recentSession.lastMessage?.timestamp ?? 0.0)) > 43200 {
                            //清空聊天内容，删除会话消息
                            let messagesOption = NIMDeleteMessagesOption()
                            messagesOption.removeSession = true
                            messagesOption.removeTable = true
                            NIMSDK.shared().conversationManager.deleteAllmessages(in: session, option: messagesOption)
                            let cloudOption = NIMClearMessagesOption()
                            cloudOption.removeRoam = true
                            NIMSDK.shared().conversationManager.deleteSelfRemoteSession(session, option: cloudOption)
                            //取消在线状态订阅
                            let request = NIMSubscribeRequest()
                            request.type = 1
                            request.expiry = 60*60*24*1
                            request.syncEnabled = true
                            request.publishers = [session.sessionId]
                            NIMSDK.shared().subscribeManager.unSubscribeEvent(request) { error, list in
                            }
                        }
                    }
                }
                showToast("已为您清除过期消息会话")
                ASUserDefaults.setValue("\(timeStr)", forKey: "lastClearTime")
            }
        }
        NotificationCenter.default.rac_addObserver(forName: "refreshMessageListNotification", object: nil).subscribeNext { [weak self] notification in
            guard let self = self else { return }
            self.reloadTableView()
        }
        //更新搭讪topView样式
        NotificationCenter.default.rac_addObserver(forName: "refreshDashanDataNotify", object: nil).subscribeNext { [weak self] notification in
            guard let self = self else { return }
            if ASUserDataManager.shared().gender == 2 {
                if ASIMHelperDataManager.shared().dashanList.count > 0 {
                    foldView.isHidden = false
                    foldView.frame = CGRectMake(0, 0, kScreenWidth, 76)
                    foldView.dashanAmount = ASIMHelperDataManager.shared().dashanAmount
                } else {
                    foldView.isHidden = true
                    foldView.frame = CGRectMake(0, 0, kScreenWidth, 0)
                    foldView.dashanAmount = 0
                }
                foldView.isUnread = ASIMManager.shared().dashanIsUnread()
                self.tableView.reloadData()
            } else {
                foldView.dashanAmount = ASIMHelperDataManager.shared().dashanAmount
            }
        }
    }
    
    override func onselectedTableRow(sessionType: NIMSessionType, sessionId: String, indexPath: IndexPath) {
        let session = NIMSession(sessionId, type: .P2P)
        let p2pVC = ASIMChatController.init(session: session)
        p2pVC.userID = sessionId
        p2pVC.myAvatarUrl = ASUserDataManager.shared().avatar
        self.navigationController?.pushViewController(p2pVC, animated: true)
    }
    
    func messagesRead(of type: NIMSessionType) {
        self.reloadTableView()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.topBtn.isHidden = scrollView.contentOffset.y > 400 ? false : true
    }
    
    func listView() -> UIView! {
        self.view
    }
}
