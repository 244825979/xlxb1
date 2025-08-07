
// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK
import UIKit

@objc
@objcMembers
open class NEChatUIKitClient: NSObject {
    public static let instance = NEChatUIKitClient()
    private var customRegisterDic = [String: UITableViewCell.Type]()
    public var moreAction = [NEMoreItemModel]()
    
    override init() {
        let hiding = NEMoreItemModel()
        hiding.image = UIImage.ne_imageNamed(name: "bottom_hiding1")
        hiding.selImage = UIImage.ne_imageNamed(name: "bottom_hiding")
        hiding.title = "对Ta隐身"
        hiding.type = .hiding
        moreAction.append(hiding)
        
        let sendVip = NEMoreItemModel()
        sendVip.image = UIImage.ne_imageNamed(name: "bottom_vip")
        sendVip.title = "赠送vip"
        sendVip.type = .sendVip
        moreAction.append(sendVip)
    }
    
    /// 获取更多面板数据
    /// - Returns: 返回更多操作数据
    open func getMoreActionData(sessionType: NIMSessionType, isHiding: Bool) -> [NEMoreItemModel] {
        var more = [NEMoreItemModel]()
        moreAction.forEach { model in
            if sessionType == .P2P {
                if model.type == .hiding {
                    model.isSelect = isHiding
                    if isHiding == true {
                        model.title = "已隐身"
                    } else {
                        model.title = "对Ta隐身"
                    }
                }
                more.append(model)
            }
        }
        if let chatInputMenu = NEKitChatConfig.shared.ui.chatInputMenu {
            chatInputMenu(&more)
        }
        
        return more
    }
    
    /// 新增聊天页针对自定义消息的cell扩展，以及现有cell样式覆盖
    open func regsiterCustomCell(_ registerDic: [String: UITableViewCell.Type]) {
        registerDic.forEach { (key: String, value: UITableViewCell.Type) in
            customRegisterDic[key] = value
        }
    }
    
    open func getRegisterCustomCell() -> [String: UITableViewCell.Type] {
        customRegisterDic
    }
}
