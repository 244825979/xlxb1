
// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK
import NEChatUIKit

open class NEMessageUtil {
    /// last message
    /// - Parameter message: message
    /// - Returns: result
    open class func messageContent(message: NIMMessage) -> String {
        var text = ""
        switch message.messageType {
        case .text:
            if let messageText = message.text {
                text = messageText
            }
        case .tip:
            return localizable("tip")
        case .audio:
            text = localizable("voice")
        case .image:
            text = localizable("picture")
        case .video:
            text = localizable("video")
        case .location:
            text = localizable("location")
        case .notification:
            text = localizable("notification")
        case .file:
            text = localizable("file")
        case .custom:
            text = contentOfCustomMessage(message: message)
        case .rtcCallRecord:
            let record = message.messageObject as? NIMRtcCallRecordObject
            text = (record?.callType == .audio) ? localizable("internet_phone") :
            localizable("video_chat")
        default:
            text = localizable("unknown")
        }
        return text
    }
    
    static func messagePrefixContent(message: NIMMessage?) -> String {
        if message?.messageType == .custom {
            if let object = message?.messageObject as? NIMCustomObject {
                var text = ""
                if let obj1 = object.attachment as? IMCustomAttachment {
                    let attachmentModel = IMCustomDataModel(obj1.data)
                    switch obj1.type {
                    case 203://自定义文本消息
                        if (attachmentModel.sourceText.count > 0) {
                            text = "【" + attachmentModel.sourceText + "】 "
                        } else {
                            text = ""
                        }
                    default:
                        text = ""
                    }
                }
                return text
            }
        }
        return ""
    }
    /// 返回自定义消息的外显文案
    static func contentOfCustomMessage(message: NIMMessage?) -> String {
        if message?.messageType == .custom {
            if let object = message?.messageObject as? NIMCustomObject {
                var text = "【提醒消息】"
                if let obj1 = object.attachment as? IMCustomAttachment {
                    let attachmentModel = IMCustomDataModel(obj1.data)
                    switch obj1.type {
                    case 11://系统通知
                        text = attachmentModel.title
                    case 15, 73://语音视频状态消息
                        let isSend = message?.isOutgoingMsg ?? false
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
                return text
            }
        }
        return localizable("unknown")
    }
}
