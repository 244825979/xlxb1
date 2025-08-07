
// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NECoreIMKit
import NIMSDK

@objcMembers
open class MessageUtils: NSObject {
    open class func textMessage(text: String, session: NIMSession) -> NIMMessage {
        let message = NIMMessage()
        message.setting = messageSetting()
        message.env = NEKitChatConfig.shared.env
        message.text = text
        message.apnsPayload = apnsPayload(session: session, myUserID: "") as! [AnyHashable : Any]
        return message
    }
    
    open class func textMessage(text: String, remoteExt: [String: Any]?, session: NIMSession, myUserID: String) -> NIMMessage {
        let message = NIMMessage()
        message.setting = messageSetting()
        message.env = NEKitChatConfig.shared.env
        message.text = text
        if remoteExt?.count ?? 0 > 0 {
            message.remoteExt = remoteExt
        }
        message.apnsPayload = apnsPayload(session: session, myUserID: myUserID) as! [AnyHashable : Any]
        return message
    }
    
    open class func imageMessage(image: UIImage, session: NIMSession, myUserID: String) -> NIMMessage {
        imageMessage(imageObject: NIMImageObject(image: image), session: session, myUserID: myUserID)
    }
    
    open class func imageMessage(path: String, session: NIMSession) -> NIMMessage {
        imageMessage(imageObject: NIMImageObject(filepath: path), session: session, myUserID: "")
    }
    
    open class func imageMessage(data: Data, ext: String, session: NIMSession) -> NIMMessage {
        imageMessage(imageObject: NIMImageObject(data: data, extension: ext), session: session, myUserID: "")
    }
    
    open class func imageMessage(imageObject: NIMImageObject, session: NIMSession, myUserID: String) -> NIMMessage {
        let message = NIMMessage()
        let option = NIMImageOption()
        option.compressQuality = 0.8
        imageObject.option = option
        message.messageObject = imageObject
        message.apnsContent = chatLocalizable("send_picture")
        message.env = NEKitChatConfig.shared.env
        message.setting = messageSetting()
        message.apnsPayload = apnsPayload(session: session, myUserID: myUserID) as! [AnyHashable : Any]
        return message
    }
    
    open class func audioMessage(filePath: String, session: NIMSession, myUserID: String) -> NIMMessage {
        let messageObject = NIMAudioObject(sourcePath: filePath)
        let message = NIMMessage()
        message.messageObject = messageObject
        message.apnsContent = chatLocalizable("send_voice")
        message.env = NEKitChatConfig.shared.env
        message.setting = messageSetting()
        message.apnsPayload = apnsPayload(session: session, myUserID: myUserID) as! [AnyHashable : Any]
        return message
    }
    
    open class func videoMessage(filePath: String) -> NIMMessage {
        let messageObject = NIMVideoObject(sourcePath: filePath)
        let message = NIMMessage()
        message.messageObject = messageObject
        message.apnsContent = chatLocalizable("send_video")
        message.env = NEKitChatConfig.shared.env
        message.setting = messageSetting()
        return message
    }
    
    open class func locationMessage(_ lat: Double, _ lng: Double, _ title: String, _ address: String) -> NIMMessage {
        let messageObject = NIMLocationObject(latitude: lat, longitude: lng, title: address)
        let message = NIMMessage()
        message.messageObject = messageObject
        message.text = title
        message.apnsContent = chatLocalizable("send_location")
        message.env = NEKitChatConfig.shared.env
        message.setting = messageSetting()
        return message
    }
    
    open class func fileMessage(filePath: String, displayName: String?) -> NIMMessage {
        let messageObject = NIMFileObject(sourcePath: filePath)
        if let dpName = displayName {
            messageObject.displayName = dpName
        }
        let message = NIMMessage()
        message.messageObject = messageObject
        message.apnsContent = chatLocalizable("send_file")
        message.env = NEKitChatConfig.shared.env
        message.setting = messageSetting()
        return message
    }
    
    open class func fileMessage(data: Data, displayName: String?) -> NIMMessage {
        let dpName = displayName ?? ""
        let pointIndex = dpName.lastIndex(of: ".") ?? dpName.startIndex
        let suffix = dpName[dpName.index(after: pointIndex) ..< dpName.endIndex]
        let messageObject = NIMFileObject(data: data, extension: String(suffix))
        messageObject.displayName = dpName
        let message = NIMMessage()
        message.messageObject = messageObject
        message.apnsContent = chatLocalizable("send_file")
        message.env = NEKitChatConfig.shared.env
        message.setting = messageSetting()
        return message
    }
    
    open class func customMessage(attachment: NIMCustomAttachment?,
                                  remoteExt: [String: Any]?,
                                  apnsContent: String?) -> NIMMessage {
        let messageObject = NIMCustomObject()
        messageObject.attachment = attachment
        let message = NIMMessage()
        message.messageObject = messageObject
        message.apnsContent = apnsContent
        message.remoteExt = remoteExt
        message.env = NEKitChatConfig.shared.env
        message.setting = messageSetting()
        return message
    }
    
    open class func messageSetting() -> NIMMessageSetting {
        let setting = NIMMessageSetting()
        setting.teamReceiptEnabled = SettingProvider.shared.getMessageRead()
        return setting
    }
    
    open class func apnsPayload(session: NIMSession, myUserID: String) -> [AnyHashable : Any] {
        var apnsPayload = [:] as [AnyHashable : Any]
        apnsPayload["sessionType"] = NSNumber(0)
        apnsPayload["sessionID"] = myUserID
        apnsPayload["oppoField"] = ["channel_id": "1000000"]
        apnsPayload["vivoField"] = ["classification": NSNumber(1),
                                    "category":"IM"]
        apnsPayload["channel_id"] = NSNumber(107995)
        apnsPayload["hwField"] = ["android": getJSONStringFromDictionary(["category": "IM"])]
        return apnsPayload
    }
}
