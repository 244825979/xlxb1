//
//  ASIMFriendListController.swift
//  AS
//
//  Created by SA on 2025/5/15.
//

import UIKit
import NEConversationUIKit
import NIMSDK

class ASIMFriendListController: IMFriendConversationController, NIMConversationManagerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        NIMSDK.shared().conversationManager.add(self)
        tableView.backgroundColor = .clear
        topConstant = 0
        viewModel.imListType = .friend
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadTableView()
    }
    
    override func onselectedTableRow(sessionType: NIMSessionType, sessionId: String, indexPath: IndexPath) {
        let session = NIMSession(sessionId, type: .P2P)
        let p2pVC = ASIMChatController.init(session: session)
        p2pVC.userID = sessionId
        p2pVC.myAvatarUrl = ASUserDataManager.shared().avatar
        self.navigationController?.pushViewController(p2pVC, animated: true)
    }
    
    // MARK: NIMConversationManagerDelegate
    func messagesRead(of type: NIMSessionType) {
        self.reloadTableView()
    }
}
