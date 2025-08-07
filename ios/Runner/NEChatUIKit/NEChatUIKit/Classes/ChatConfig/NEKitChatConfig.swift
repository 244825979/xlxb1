
// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import UIKit

@objcMembers
public class NEKitChatConfig: NSObject {
    public static let shared = NEKitChatConfig()
    public var maxReadingNum = 200 //群未读显示限制数，默认超过200人不显示已读未读进度
    //chat UI配置相关
    public var ui = ChatUIConfig()
    //chat 其他配置 待扩展
    //服务器地址
    public var serverUrl = ""
    public var imageURL = ""
    public var h5URL = ""
    public var env = ""
    //环境配置
    public var kAppType: NSInteger = 1
    //系统消息的ID，都不可进行删除，不可发消息
    public var xitongxiaoxi_id = ""//系统消息1、默认进行置顶。
    public var huodongxiaozushou_id = ""//活动小助手
    public var xiaomishu_id = ""//小秘书
    public var kefuzushou_id = ""//客服小助手。私聊页面有引导去客服H5
}
