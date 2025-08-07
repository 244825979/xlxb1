
// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NECommonUIKit
import NECoreKit
import NIMSDK
import UIKit

@objcMembers
open class ConversationController: NEBaseConversationController {
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        className = "ConversationController"
        cellRegisterDic = [0: ConversationListCell.self]
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func setupSubviews() {
        super.setupSubviews()
        tableView.rowHeight = 76
        tableView.backgroundColor = .white
    }
}
