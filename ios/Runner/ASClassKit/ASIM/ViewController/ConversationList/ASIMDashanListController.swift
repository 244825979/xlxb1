//
//  ASIMDashanListController.swift
//  AS
//
//  Created by SA on 2025/7/8.
//

import UIKit
import NEConversationUIKit
import NIMSDK

class ASIMDashanListController: ConversationController, NIMConversationManagerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.imListType = .dashan
        topConstant = 0
        view.backgroundColor = .white
        NIMSDK.shared().conversationManager.add(self)
        title = "搭讪消息"
        let leftButton = UIBarButtonItem(image: UIImage(named: "back")?.withRenderingMode(.alwaysOriginal),
                                         style: .plain,
                                         target: self,
                                         action: #selector(leftButtonTapped))
        navigationItem.leftBarButtonItem = leftButton
        let rightButton = UIBarButtonItem(image: UIImage(named: "im_clear")?.withRenderingMode(.alwaysOriginal),
                                          style: .plain,
                                          target: self,
                                          action: #selector(rightButtonTapped))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    func leftButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func rightButtonTapped() {
        ASIMActionManager.dashanClearMessage()
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
