//
//  ASIMFuncManager.swift
//  AS
//
//  Created by SA on 2025/5/14.
//

import UIKit
import NEChatUIKit

@objcMembers
open class ASIMFuncManager: NSObject {
    //判断当前页面是不是私聊页
    @objc class func isP2PCartController() -> Bool {
        if ASCommonFunc.currentVc().isKind(of: ASIMChatController.self) {
            return true
        } else {
            return false
        }
    }
    //IM的会话列表
    @objc class func conversationListController() -> UIViewController {
        let vc = ASIMConversationListController.init()
        return vc
    }
    //亲密度列表
    @objc class func friendListController() -> UIViewController {
        let vc = ASIMFriendListController.init()
        return vc
    }
    //搭讪列表
    @objc class func dashanListController() -> UIViewController {
        let vc = ASIMDashanListController.init()
        return vc
    }
    //聊天会话页面
    @objc class func chatViewController(userId: String, nickName: String) {
        if userId.count == 0 {
            return
        }
        let session = NIMSession(userId, type: .P2P)
        let p2pVC = ASIMChatController.init(session: session)
        p2pVC.userID = userId
        p2pVC.nickName = nickName
        p2pVC.myAvatarUrl = ASUserDataManager.shared().avatar
        ASCommonFunc.currentVc().navigationController?.pushViewController(p2pVC, animated: true)
    }
    //聊天会话页面，只保证有一个私聊页
    @objc class func chatOneViewController(userId: String, nickName: String) {
        if userId.count == 0 {
            return
        }
        let session = NIMSession(userId, type: .P2P)
        let p2pVC = ASIMChatController.init(session: session)
        p2pVC.userID = userId
        p2pVC.nickName = nickName
        p2pVC.myAvatarUrl = ASUserDataManager.shared().avatar
        ASIMFuncManager.popP2PViewController(p2pVC)
    }
    //聊天会话页面，匹配小助手页面进入
    @objc class func littleHelperChatController(userId: String, nickName: String, sendFirstBlock:@escaping()->()) {
        if userId.count == 0 {
            return
        }
        let session = NIMSession(userId, type: .P2P)
        let p2pVC = ASIMChatController.init(session: session)
        p2pVC.userID = userId
        p2pVC.nickName = nickName
        p2pVC.myAvatarUrl = ASUserDataManager.shared().avatar
        p2pVC.isTID = 1
        p2pVC.sendBankBlock = {
            sendFirstBlock()
        }
        ASCommonFunc.currentVc().navigationController?.pushViewController(p2pVC, animated: true)
    }
    //自定义消息最后一条文本提示
    @objc class func backMessgeHint(message: NIMMessage) -> String {
        var text = "【提醒消息】"
        if let obj = message.messageObject as? NIMCustomObject {
            if let obj1 = obj.attachment as? IMCustomAttachment {
                let attachmentModel = IMCustomDataModel(obj1.data)
                switch obj1.type {
                case 11://系统通知
                    text = attachmentModel.title
                case 15, 73://语音视频状态消息
                    let isSend = message.isOutgoingMsg
                    var isVideo = ""
                    if (obj1.type == 15) {
                        if attachmentModel.scene == "video_show" {
                            isVideo = "【视频秀通话】 "
                        } else {
                            isVideo = "【视频通话】 "
                        }
                    } else {
                        isVideo = "【语音通话】 "
                    }
                    switch attachmentModel.status {
                    case 1:
                        text = isVideo + (isSend ? "已取消" : "对方已取消")
                    case 2:
                        text = isVideo + (isSend ? "对方已拒绝" : "已拒绝")
                    case 3:
                        text = isVideo + (isSend ? "对方未接听" : "超时未接听")
                    case 4:
                        text = isVideo + NEChatTool.secondsToTimeString(seconds: attachmentModel.call_time)
                    case 5:
                        text = isVideo + (isSend ? "对方忙碌中" : "")
                    default:
                        text = isVideo
                    }
                case 14://礼物消息
                    text = "【礼物】"
                case 72, 110://小助手及一键搭讪
                    text = obj1.type == 72 ? attachmentModel.content : attachmentModel.assistantContent
                case 95://客服小助手
                    text = attachmentModel.content
                case 99://活动小助手
                    text = attachmentModel.activityContent
                case 100://自定义图片
                    text = "【图片】"
                case 101://自定义语音
                    text = "【语音】"
                case 203://自定义文本消息
                    text = attachmentModel.text
                default:
                    text = "【提醒消息】"
                }
            }
        }
        return text
    }
    //跳转私聊页，只保证有一个私聊页
    @objc class func popP2PViewController(_ popVc: UIViewController){
        let vcs = ASCommonFunc.currentVc().navigationController?.viewControllers
        var newVCList = [UIViewController]()
        if let vcList = vcs, vcList.count == 1 {
            ASCommonFunc.currentVc().navigationController?.pushViewController(popVc, animated: true)
            return
        }
        if let vcList = vcs, vcList.count > 0 {
            for (index, vc) in vcList.enumerated() {
                if !vc.isKind(of: ASIMChatController.self) && !vc.isKind(of: ASIMChatController.self) {
                    newVCList.append(vcList[index])
                }
            }
        }
        ASCommonFunc.currentVc().navigationController?.setViewControllers(newVCList, animated: true)
        ASCommonFunc.currentVc().navigationController?.pushViewController(popVc, animated: true)
    }
}
