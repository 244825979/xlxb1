
// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import UIKit

@objcMembers
public class NEKitConversationConfig: NSObject {
    public static let shared = NEKitConversationConfig()
    //conversation ui 配置
    public var ui = ConversationUIConfig()
    //服务器地址
    public var serverUrl = ""
    public var imageURL = ""
    public var h5URL = ""
    //环境配置
    public var kAppType: NSInteger = 1
    //消息IM列表前缀是否显示
    public var recommendMsgBeautifyOpen: NSInteger = 0
    //Ta对我隐身用户列表
    public var hiddenMeUserList: [String] = []
    //系统消息的ID，都不可进行删除，不可发消息
    public var xitongxiaoxi_id = ""//系统消息1、默认进行置顶。
    public var huodongxiaozushou_id = ""//活动小助手
    public var xiaomishu_id = ""//小秘书
    public var kefuzushou_id = ""//客服小助手。私聊页面有引导去客服H5
}
