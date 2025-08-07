//
//  IMFriendConversationController.swift
//  NEConversationUIKit
//

import UIKit

@objcMembers
open class IMFriendConversationController: NEBaseConversationController {
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        className = "IMFriendConversationController"
        cellRegisterDic = [0: IMFriendConversationListCell.self]
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func setupSubviews() {
        super.setupSubviews()
        
        tableView.rowHeight = 80
        tableView.backgroundColor = .white
    }
}
