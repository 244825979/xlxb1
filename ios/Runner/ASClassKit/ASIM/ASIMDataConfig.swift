//
//  ASIMDataConfig.swift
//  AS
//
//  Created by SA on 2025/5/14.
//

import UIKit
import NEConversationUIKit
import NEChatUIKit

class ASIMDataConfig: NSObject {
    @objc class func configIMServer(serverUrl: String, imageURL: String, h5URL: String, env: String) {
        //私聊页配置
        NEKitChatConfig.shared.serverUrl = serverUrl
        NEKitChatConfig.shared.imageURL = imageURL
        NEKitChatConfig.shared.h5URL = h5URL
        NEKitChatConfig.shared.env = env
        //会话列表配置
        NEKitConversationConfig.shared.serverUrl = serverUrl
        NEKitConversationConfig.shared.imageURL = imageURL
        NEKitConversationConfig.shared.h5URL = h5URL
    }
    @objc class func configIMKit() {
        NEKitConversationConfig.shared.ui.showTitleBar = false//会话列表隐藏导航
        NEKitConversationConfig.shared.ui.conversationProperties.avatarType = .cycle
    }
    @objc class func configIMBaseData() {
        NEKitChatConfig.shared.xitongxiaoxi_id = "7536235"
        NEKitChatConfig.shared.huodongxiaozushou_id = "7536244"
        NEKitChatConfig.shared.xiaomishu_id = "7536236"
        NEKitChatConfig.shared.kefuzushou_id = "7536239"
        NEKitConversationConfig.shared.xitongxiaoxi_id = "7536235"
        NEKitConversationConfig.shared.huodongxiaozushou_id = "7536244"
        NEKitConversationConfig.shared.xiaomishu_id = "7536236"
        NEKitConversationConfig.shared.kefuzushou_id = "7536239"
    }
    //配置IM需要用到的基础数据
    @objc class func configAppLoginData() {
        NEKitConversationConfig.shared.kAppType = ASUserDataManager.shared().systemIndexModel.mtype
        NEKitConversationConfig.shared.recommendMsgBeautifyOpen = ASUserDataManager.shared().systemIndexModel.recommendMsgBeautifyOpen
        NEKitChatConfig.shared.kAppType = ASUserDataManager.shared().systemIndexModel.mtype
    }
    //配置Ta对我隐身用户列表
    @objc class func hiddenMeUserListData(users:[String]) {
        NEKitConversationConfig.shared.hiddenMeUserList = users;
    }
}
