//
//  SANEChatTool.swift
//  NEChatUIKit
//
//  Created by 心聊想伴 on 2024/6/20.
//

import UIKit

@objcMembers
public class NEChatTool {
    public class func secondsToTimeString(seconds: Int) -> String {
        //小时计算
        let hours = (seconds)%(24*3600)/3600
        //分钟计算
        let minutes = (seconds)%3600/60
        //秒计算
        let second = (seconds)%60
        var timeString = ""
        if seconds < 3600 {
            timeString = String(format: "%02lu:%02lu", minutes, second)
        } else {
            timeString = String(format: "%02lu:%02lu:%02lu", hours, minutes, second)
        }
        return timeString
    }
}
