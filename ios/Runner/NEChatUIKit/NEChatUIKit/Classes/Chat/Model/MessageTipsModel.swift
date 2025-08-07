
// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

@objcMembers
open class MessageTipsModel: MessageContentModel {
    var text: String?
    
    public var attributeStr: NSMutableAttributedString?
    
    public required init(message: NIMMessage?) {
        super.init(message: message)
        commonInit()
    }
    
    func setText() {
        if let msg = message {
            if msg.messageType == .notification {
                text = NotificationMessageUtils.textForNotification(message: msg)
                type = .notification
            } else if msg.messageType == .tip {
                text = msg.text
                type = .tip
            }
        }
    }
    
    func commonInit() {
        setText()
        var font: UIFont = .systemFont(ofSize: NEKitChatConfig.shared.ui.messageProperties.timeTextSize)
        attributeStr = NEEmotionTool.getAttWithStr(
            str: text ?? "",
            font: font,
            lineSpacing: 2,
            color: UIColor(hexString: "#999999")
        )
        let textSize = attributeStr?.finalSize(font,
                                               CGSize(width: kScreenWidth - 32 - chat_content_left_right_margin*2, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
        
        
        contentSize = CGSize(width: textSize.width + chat_content_left_right_margin * 2, height: textSize.height + chat_content_top_bottom_margin * 2)
        height = ceil(contentSize.height + chat_content_margin)
        
        // time
        if let time = timeContent, !time.isEmpty {
            height += chat_timeCellH
        }
    }
}
