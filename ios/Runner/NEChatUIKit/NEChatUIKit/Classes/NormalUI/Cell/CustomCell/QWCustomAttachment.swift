//
//  IMCustomAttachment.swift
//  NEChatUIKit
//

import UIKit
import NIMSDK

@objcMembers
open class IMCustomAttachment: NSObject, NIMCustomAttachment, NECustomAttachmentProtocol {
    open var customType: Int = 0
    open var cellHeight: CGFloat = 0
    /// 11、系统消息 14、礼物消息 15、视频通话消息 72、匹配小助手消息 73、语音通话消息 100、图片链接消息 101、语音链接消息 110、今日缘分一键搭讪消息 99、活动小助手 95、客服小助手 203纯文本展示的自定义消息
    open var type = 0
    /// json数据字符串
    open var data : [String: Any] = [:]
    open func encode() -> String {
        let info = ["type": type,
                    "data": data
        ] as [String: Any]
        let jsonData = try? JSONSerialization.data(withJSONObject: info, options: .prettyPrinted)
        var content = ""
        if let data = jsonData {
            content = String(data: data, encoding: .utf8) ?? ""
        }
        return content
    }
}

//MARK: - 消息解析器
open class NTMCustomAttachmentDecoder: NSObject, NIMCustomAttachmentCoding {
    open func decodeAttachment(_ content: String?) -> NIMCustomAttachment? {
        var attachment: NIMCustomAttachment?
        let data = content?.data(using: .utf8)
        guard let dataInfo = data else {
            return attachment
        }
        let info = try? JSONSerialization.jsonObject (
            with: dataInfo,
            options: .mutableContainers
        )
        attachment = decodeCustomMessage(info: info as? [String: Any] ?? [String(): String()])
        return attachment
    }
    open func decodeCustomMessage(info: [String: Any]) -> IMCustomAttachment {
        let customAttachment = IMCustomAttachment()
        customAttachment.type = info["type"] as? NSInteger ?? 0
        customAttachment.data = info["data"] as? [String: Any] ?? [:]
        customAttachment.customType = customAttachment.type
        customAttachment.cellHeight = 0
        return customAttachment
    }
}

@objcMembers
open class IMCustomDataModel {
    open var from_uid: String = ""
    open var to_uid: String = ""
    open var title: String = ""//标题
    open var txt1: String = ""//有数据展示，无数据隐藏
    open var fields: [[String:String]] = []//有数据展示，无数据隐藏
    open var txt2: String = ""//有数据展示，无数据隐藏
    //礼物
    open var gift_name: String = ""//礼物的名称
    open var gift_count: NSInteger = 0//礼物的数量
    open var gift_type: NSInteger = 0//
    open var gift_url: String = ""//礼物的图片
    open var gift_svga: String = ""//礼物的SVGA特效
    //音视频通话消息
    open var call_time: NSInteger = 0
    open var status: NSInteger = 0//1=取消 2=拒绝 3=超时 4=已接通 5=对方忙碌中
    //小助手
    open var content: String = ""//小助手提示的标题内容
    //今日缘分一键搭讪消息
    open var assistantContent: String = ""//搭讪消息标题内容
    
    open var width: NSInteger = 0
    open var height: NSInteger = 0
    open var url: String = ""//图片、语音url
    open var duration: NSInteger = 0//毫秒
    open var scene: String = ""//场景，是不是视频秀
    //活动小助手
    open var activityId: String = ""//活动id
    open var activityTitle: String = ""//标题
    open var activityContent: String = ""//内容
    open var activityBanner: String = ""//活动图片
    open var activityStyle: NSInteger = 0//0文本，1图片加文本
    open var linkTxt: String = ""//点击立即查看>>
    open var linkType: NSInteger = 0//0 不可点击 1打开H5页面 2打开原生 为0的时候，隐藏下方的详情区域 type=3为执行本地程序逻辑
    open var linkUrl: String = ""//对应的为H5页面地址，或者原生页面名称，注意如果找不到支持的原生页面，默认点击无响应接口
    open var link_type: NSInteger = 0//0 不可点击 1打开H5页面 2打开原生 
    open var link_url: String = ""//对应的为H5页面地址，或者原生页面名称，注意如果找不到支持的原生页面，默认点击无响应接口
    //纯文本自定义消息
    open var sourceType: NSInteger = 0
    open var sourceText: String = ""
    open var text: String = ""
    
    public init(_ dict: [String:Any]) {
        
        let from_uid = dict["from_uid"] as? String ?? ""
        let to_uid = dict["to_uid"] as? String ?? ""
        let title = dict["title"] as? String ?? ""
        let txt1 = dict["txt1"] as? String ?? ""
        let fields = dict["fields"] as? [[String:String]] ?? []
        let txt2 = dict["txt2"] as? String ?? ""
        let gift_name = dict["gift_name"] as? String ?? ""
        let gift_count  = dict["gift_count"] as? NSInteger ?? 0
        let gift_type  = dict["gift_type"] as? NSInteger ?? 0
        let gift_url = dict["gift_url"] as? String ?? ""
        let gift_svga = dict["gift_svga"] as? String ?? ""
        let call_time  = dict["call_time"] as? NSInteger ?? 0
        let status = dict["status"] as? NSInteger ?? 0
        let content = dict["content"] as? String ?? ""
        let assistantContent = dict["assistantContent"] as? String ?? ""
        
        let width = dict["width"] as? NSInteger ?? 0
        let height = dict["height"] as? NSInteger ?? 0
        let url = dict["url"] as? String ?? ""
        let duration = dict["duration"] as? NSInteger ?? 0
        let scene = dict["scene"] as? String ?? ""
        
        let activityId = dict["activityId"] as? String ?? ""
        let activityTitle = dict["activityTitle"] as? String ?? ""
        let activityContent = dict["activityContent"] as? String ?? ""
        let activityBanner = dict["activityBanner"] as? String ?? ""
        let activityStyle = dict["activityStyle"] as? NSInteger ?? 0
        let linkTxt = dict["linkTxt"] as? String ?? ""
        let linkType = dict["linkType"] as? NSInteger ?? 0
        let linkUrl = dict["linkUrl"] as? String ?? ""
        let link_type = dict["link_type"] as? NSInteger ?? 0
        let link_url = dict["link_url"] as? String ?? ""
        
        let sourceType = dict["sourceType"] as? NSInteger ?? 0
        let sourceText = dict["sourceText"] as? String ?? ""
        let text = dict["text"] as? String ?? ""
        
        self.from_uid = from_uid
        self.to_uid = to_uid
        self.title = title
        self.txt1 = txt1
        self.fields = fields
        self.txt2 = txt2
        self.gift_name = gift_name
        self.gift_count = gift_count
        self.gift_type = gift_type
        self.gift_url = gift_url
        self.gift_svga = gift_svga
        self.call_time = call_time
        self.status = status
        self.content = content
        self.assistantContent = assistantContent
        
        self.width = width
        self.height = height
        self.url = url
        self.duration = duration
        self.scene = scene
    
        self.activityId = activityId
        self.activityTitle = activityTitle
        self.activityContent = activityContent
        self.activityBanner = activityBanner
        self.activityStyle = activityStyle
        self.linkTxt = linkTxt
        self.linkType = linkType
        self.linkUrl = linkUrl
        self.link_type = link_type
        self.link_url = link_url
        
        self.sourceType = sourceType
        self.sourceText = sourceText
        self.text = text
    }
}
