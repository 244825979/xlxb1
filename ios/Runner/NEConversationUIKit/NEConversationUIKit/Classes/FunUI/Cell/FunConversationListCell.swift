// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK
import UIKit

@objcMembers
open class FunConversationListCell: NEBaseConversationListCell {
    var contentModel: ConversationListModel?
    
    override open func setupSubviews() {
        super.setupSubviews()
        NSLayoutConstraint.activate([
            headImge.leftAnchor.constraint(
                equalTo: contentView.leftAnchor,
                constant: 14
            ),
            headImge.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            headImge.widthAnchor.constraint(equalToConstant: 60),
            headImge.heightAnchor.constraint(equalToConstant: 60),
        ])
        
        NSLayoutConstraint.activate([
            title.leftAnchor.constraint(equalTo: headImge.rightAnchor, constant: 10),
            title.rightAnchor.constraint(equalTo: timeLabel.leftAnchor, constant: -5),
            title.topAnchor.constraint(equalTo: headImge.topAnchor, constant: 6),
            title.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    override func initSubviewsLayout() {
        if NEKitConversationConfig.shared.ui.conversationProperties.avatarType == .rectangle {
            headImge.layer.cornerRadius = NEKitConversationConfig.shared.ui.conversationProperties.avatarCornerRadius
        } else if NEKitConversationConfig.shared.ui.conversationProperties.avatarType == .cycle {
            headImge.layer.cornerRadius = 30.0
        } else {
            headImge.layer.cornerRadius = 9.0
        }
    }
    
    override open func configData(sessionModel: ConversationListModel?) {
        super.configData(sessionModel: sessionModel)
        contentModel = sessionModel
        
        // backgroundColor
        if let session = sessionModel?.recentSession?.session {
            let isTop = topStickInfos[session] != nil
            if isTop {
                contentView.backgroundColor = NEKitConversationConfig.shared.ui.conversationProperties.itemStickTopBackground ?? .funConversationBackgroundColor
            } else {
                contentView.backgroundColor = NEKitConversationConfig.shared.ui.conversationProperties.itemBackground ?? .white
            }
        }
    }
}
