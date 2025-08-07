
// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK
import UIKit

@objcMembers
open class ConversationListCell: NEBaseConversationListCell {
    override open func setupSubviews() {
        super.setupSubviews()
        
        contentView.addSubview(intimateIcon)
        contentView.addSubview(intimateValue)
        
        NSLayoutConstraint.activate([
            headImge.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 16),
            headImge.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            headImge.widthAnchor.constraint(equalToConstant: 60),
            headImge.heightAnchor.constraint(equalToConstant: 60),
        ])
        
        NSLayoutConstraint.activate([
            title.leftAnchor.constraint(equalTo: headImge.rightAnchor, constant: 12),
            title.topAnchor.constraint(equalTo: headImge.topAnchor, constant: 2),
            title.heightAnchor.constraint(equalToConstant: 24),
            title.widthAnchor.constraint(lessThanOrEqualToConstant: 150)
        ])
        
        NSLayoutConstraint.activate([
            intimateIcon.leftAnchor.constraint(equalTo: title.rightAnchor, constant: 6),
            intimateIcon.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            intimateIcon.heightAnchor.constraint(equalToConstant: 18),
            intimateIcon.widthAnchor.constraint(equalToConstant: 18),
        ])
        
        NSLayoutConstraint.activate([
            intimateValue.leftAnchor.constraint(equalTo: intimateIcon.rightAnchor, constant:4),
            intimateValue.centerYAnchor.constraint(equalTo: intimateIcon.centerYAnchor),
        ])
    }
    
    override func initSubviewsLayout() {
        if NEKitConversationConfig.shared.ui.conversationProperties.avatarType == .rectangle {
            headImge.layer.cornerRadius = NEKitConversationConfig.shared.ui.conversationProperties.avatarCornerRadius
        } else if NEKitConversationConfig.shared.ui.conversationProperties.avatarType == .cycle {
            headImge.layer.cornerRadius = 30.0
        } else {
            headImge.layer.cornerRadius = 8.0
        }
    }
    
    override open func configData(sessionModel: ConversationListModel?) {
        super.configData(sessionModel: sessionModel)
        guard let conversationModel = sessionModel else { return }
        // backgroundColor
        if let session = sessionModel?.recentSession?.session {
            let isTop = topStickInfos[session] != nil
            if isTop {
                contentView.backgroundColor = NEKitConversationConfig.shared.ui.conversationProperties.itemStickTopBackground ?? UIColor(hexString: "0xF5F5F5")
            } else {
                contentView.backgroundColor = NEKitConversationConfig.shared.ui.conversationProperties.itemBackground ?? .white
            }
        }
        
        if conversationModel.recentSession?.session?.sessionType == .P2P {
            if NEKitConversationConfig.shared.kAppType == 1 {
                intimateValue.isHidden = true
                intimateIcon.isHidden = true
            } else {
                if conversationModel.userInfo?.userId == NEKitConversationConfig.shared.xitongxiaoxi_id ||
                    conversationModel.userInfo?.userId == NEKitConversationConfig.shared.huodongxiaozushou_id ||
                    conversationModel.userInfo?.userId == NEKitConversationConfig.shared.xiaomishu_id ||
                    conversationModel.userInfo?.userId == NEKitConversationConfig.shared.kefuzushou_id {
                    intimateValue.isHidden = true
                    intimateIcon.isHidden = true
                } else {
                    let myUserID = UserDefaults.standard.value(forKey: "userinfo_user_id") as? String ?? ""
                    let intimateKey = myUserID + "_intimate_" + (conversationModel.userInfo?.userId ?? "")
                    let intimateData = UserDefaults.standard.value(forKey: intimateKey) as? NSDictionary ?? [:]
                    let score = intimateData["score"] as? NSString ?? ""
                    let grade = intimateData["grade"] as? NSInteger ?? 0
                    if score.floatValue > 0 {
                        intimateValue.isHidden = false
                        intimateIcon.isHidden = false
                        intimateValue.text = "\(score)℃"
                    } else {
                        intimateValue.isHidden = true
                        intimateIcon.isHidden = true
                    }
                }
            }
        }
    }
    
    // 亲密度图标
    lazy var intimateIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.ne_imageNamed(name: "intimate")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if NEKitConversationConfig.shared.kAppType == 1 {
            imageView.isHidden = true
        }
        return imageView
    }()
    
    // 亲密值
    lazy var intimateValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.textColor = UIColor(hexString: "0xFD6E6A")
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .right
        if NEKitConversationConfig.shared.kAppType == 1 {
            label.isHidden = true
        }
        return label
    }()
}
