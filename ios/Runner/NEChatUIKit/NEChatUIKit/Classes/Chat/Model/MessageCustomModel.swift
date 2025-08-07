// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK
import UIKit

@objc
open class MessageCustomModel: MessageContentModel {
    /*自定义新增的一些字段*/
    public var title: String = ""
    public var attributeStr: NSMutableAttributedString?
    public var textHeight: CGFloat = 0
    public var callLeftText: String = ""
    public var callRightText: String = ""
    public var callLeftIcon: String = ""
    public var callRightIcon: String = ""
    public var icon: String = ""
    public var giftName: String = "" //礼物消息
    public var giftUrl: String = "" //礼物消息
    public var url: String = ""
    public var duration: NSInteger = 0
    public var isPlaying = false
    public var activityStyle: NSInteger = 0//活动小助手显示样式 0文本，1图片加文本
    
    public required init(message: NIMMessage?) {
        super.init(message: message)
        type = .custom
        if let obj = message?.messageObject as? NIMCustomObject {
            if let obj1 = obj.attachment as? IMCustomAttachment {
                let attachmentModel = IMCustomDataModel(obj1.data)
                switch obj1.type {
                case 11://系统通知
                    var text = ""
                    if attachmentModel.txt1.count > 0 {
                        text += attachmentModel.txt1 + "\n"
                    }
                    if attachmentModel.txt2.count > 0 {
                        text += attachmentModel.txt2 + "\n"
                    }
                    var fieldsText = ""
                    for (i, dict) in attachmentModel.fields.enumerated() {
                        let nValue = dict["n"] as? String ?? ""
                        let vValue = dict["v"] as? String ?? ""
                        var valueText = ""
                        if i == attachmentModel.fields.count - 1 {
                            valueText = nValue + "：" + vValue
                        } else {
                            valueText = nValue + "：" + vValue + "\n"
                        }
                        fieldsText += valueText
                    }
                    
                    if fieldsText.count > 0 {
                        text += fieldsText
                    }
                    
                    title = attachmentModel.title
                    attributeStr = NEEmotionTool.getAttWithStr(
                        str: text,
                        font: UIFont.systemFont(ofSize: 14),
                        lineSpacing: 2,
                        color: UIColor(hexString: "#999999")
                    )
                    
                    let textSize = attributeStr?.finalSize(UIFont.systemFont(ofSize: 14),
                                                           CGSize(width: kScreenWidth - 95 - 20, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
                    
                    contentSize = CGSize(width: kScreenWidth - 95, height: textSize.height + 23 + 28)
                    height = contentSize.height + chat_content_margin
                case 15, 73://语音视频状态消息
                    let isVideo = obj1.type == 15 ? true : false
                    callLeftIcon = isVideo ? "left_call_video" : "left_call_voice"
                    callRightIcon = isVideo ? "right_video" :"right_call_voice"
                    switch attachmentModel.status {
                    case 1:
                        callRightText = "已取消"
                        callLeftText = "对方已取消"
                    case 2:
                        callRightText = "对方已拒绝"
                        callLeftText = "已拒绝"
                    case 3:
                        callRightText = "对方未接听"
                        callLeftText = "超时未接听"
                    case 4:
                        callRightText = "通话时长：" + NEChatTool.secondsToTimeString(seconds: attachmentModel.call_time)
                        callLeftText = "通话时长：" + NEChatTool.secondsToTimeString(seconds: attachmentModel.call_time)
                    case 5:
                        callRightText = "对方忙碌中"
                        callRightIcon = isVideo ? "right_video" : "right_call_voice1"
                        callLeftText = ""
                        callLeftIcon = ""
                    default:
                        callRightText = ""
                        callLeftText = ""
                    }
                    
                    guard let isSend = message?.isOutgoingMsg else {
                        return
                    }
                    let contentText = isSend ? callRightText : callLeftText
                    
                    attributeStr = NEEmotionTool.getAttWithStr(
                        str: contentText,
                        font: UIFont.systemFont(ofSize: 15),
                        color: UIColor(hexString: "#999999")
                    )
                    
                    let textSize = attributeStr?.finalSize(UIFont.systemFont(ofSize: 15),
                                                           CGSize(width: CGFloat.greatestFiniteMagnitude, height: 20)) ?? .zero
                    contentSize = CGSize(width: textSize.width + 48, height: chat_min_h)
                    height = contentSize.height + chat_content_margin + 4
                case 14://礼物消息
                    giftUrl = attachmentModel.gift_url
                    giftName = attachmentModel.gift_name + "x" + "\(attachmentModel.gift_count)"
                    
                    attributeStr = NEEmotionTool.getAttWithStr(
                        str: giftName,
                        font: UIFont.systemFont(ofSize: 14),
                        color: UIColor(hexString: "#333333")
                    )
                    let textSize = attributeStr?.finalSize(UIFont.systemFont(ofSize: 14),
                                                           CGSize(width: CGFloat.greatestFiniteMagnitude, height: 20)) ?? .zero
                    let textWidth = textSize.width < 60 ? 60 : textSize.width
                    contentSize = CGSize(width: textWidth + 60 + 12 + 12 + 12, height: 76)
                    height = contentSize.height + chat_content_margin + 4
                case 72, 110://小助手及一键搭讪
                    //是否小助手
                    let isLittle = obj1.type == 72 ? true : false
                    icon = isLittle ? "cell_xiaozhushou" : "cell_dashan"
                    var contentText = ""
                    if isLittle {//小助手
                        contentText = attachmentModel.content
                    } else {//一键搭讪
                        contentText = attachmentModel.assistantContent
                    }
                    attributeStr = NEEmotionTool.getAttWithStr(
                        str: contentText,
                        font: .systemFont(ofSize: 14),
                        lineSpacing: 2,
                        color: UIColor(hexString: "#999999")
                    )
                    
                    let textSize = attributeStr?.finalSize(.systemFont(ofSize: 14),
                                                           CGSize(width: kScreenWidth - 42 - 12 - 32, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
                    
                    
                    contentSize = CGSize(width: textSize.width + 12 + 42, height: textSize.height + chat_content_margin * 2)
                    height = contentSize.height + chat_content_margin
                case 95://客服小助手
                    title = attachmentModel.title
                    attributeStr = NEEmotionTool.getAttWithStr(
                        str: attachmentModel.content,
                        font: UIFont.systemFont(ofSize: 14),
                        color: UIColor(hexString: "#999999")
                    )
                    let textSize = attributeStr?.finalSize(UIFont.systemFont(ofSize: 14),
                                                           CGSize(width: kScreenWidth - 95 - 20, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
                    
                    contentSize = CGSize(width: kScreenWidth - 95, height: textSize.height + 23 + 28)
                    height = contentSize.height + chat_content_margin
                case 99://活动小助手
                    activityStyle = attachmentModel.activityStyle
                    url = attachmentModel.activityBanner
                    title = attachmentModel.linkTxt
                    attributeStr = NEEmotionTool.getAttWithStr(
                        str: attachmentModel.activityContent,
                        font: UIFont.systemFont(ofSize: 14),
                        color: UIColor(hexString: "#999999")
                    )
                    let textSize = attributeStr?.finalSize(UIFont.systemFont(ofSize: 14),
                                                           CGSize(width: kScreenWidth - 90 - 32, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
                    if activityStyle == 1 {
                        contentSize = CGSize(width: kScreenWidth - 90, height: textSize.height + 22 + 148 + 44)
                    } else {
                        contentSize = CGSize(width: kScreenWidth - 90, height: textSize.height + 12 + 44)
                    }
                    height = contentSize.height + chat_content_margin
                case 100://图片链接
                    url = attachmentModel.url
                    contentSize = ChatMessageHelper.getSizeWithMaxSize(
                      chat_pic_size,
                      size: CGSize(width: attachmentModel.width, height: attachmentModel.height),
                      miniWH: chat_min_h
                    )
                    if url.count < 5 {
                        contentSize = chat_pic_size
                    }
                    height = contentSize.height + chat_content_top_bottom_margin * 2 + remoteHeight
                case 101://语音链接
                    url = attachmentModel.url
                    duration = attachmentModel.duration/1000
                    var audioW = 90.0
                    let audioTotalWidth = 160.0
                    if duration > 2 {
                        audioW = min(Double(duration) * 1 + audioW, audioTotalWidth)
                    }
                    contentSize = CGSize(width: audioW, height: chat_min_h)
                    height = contentSize.height + 12 + 2 + remoteHeight
                case 203://纯文本展示的自定义消息
                    if (message?.isOutgoingMsg == true) {
                        //是发的消息
                        attributeStr = NEEmotionTool.getAttWithStr(
                            str: attachmentModel.text,
                            font: .systemFont(ofSize: NEKitChatConfig.shared.ui.messageProperties.messageTextSize),
                            color: UIColor(hexString: "#ffffff")
                        )
                    } else {
                        //接收的消息
                        attributeStr = NEEmotionTool.getAttWithStr(
                            str: attachmentModel.text,
                            font: .systemFont(ofSize: NEKitChatConfig.shared.ui.messageProperties.messageTextSize),
                            color: UIColor(hexString: "#000000")
                        )
                    }
                    let textSize = attributeStr?.finalSize(.systemFont(ofSize: NEKitChatConfig.shared.ui.messageProperties.messageTextSize), CGSize(width: chat_text_maxW, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
                    
                    textHeight = textSize.height
                    contentSize = CGSize(width: textSize.width + chat_content_left_right_margin * 2, height: textHeight + chat_content_top_bottom_margin * 2)
                    height = contentSize.height + chat_content_top_bottom_margin * 2 + fullNameHeight + remoteHeight
                default:
                    height = 0
                }
                obj1.cellHeight = CGFloat(height)
            }
        }
    }
}
