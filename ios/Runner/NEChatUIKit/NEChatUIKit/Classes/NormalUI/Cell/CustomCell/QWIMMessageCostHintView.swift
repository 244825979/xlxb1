//
//  QWIMMessageCostHintView.swift
//  NEChatUIKit
//
//  Created by 心聊想伴 on 2024/8/26.
//  价格提示

import UIKit

@objcMembers
open class QWIMMessageCostHintView: UIView {
    public lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .justified
        label.textColor = UIColor(hexString: "#999999")
        return label
    }()
    
    public lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func commonUI() {
        addSubview(title)
        addSubview(icon)
        
        NSLayoutConstraint.activate([
            icon.leftAnchor.constraint(equalTo: leftAnchor),
            icon.centerYAnchor.constraint(equalTo: centerYAnchor),
            icon.heightAnchor.constraint(equalToConstant: 12),
            icon.widthAnchor.constraint(equalToConstant: 12),
        ])
        
        NSLayoutConstraint.activate([
            title.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 2),
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    open func setData(_ data: [String: AnyObject]) {
        if let isCut = data["is_cut"] as? NSInteger {
            if isCut == 1 {
                if let isCutCard = data["is_chat_card"] as? NSInteger {//聊天卡扣费
                    if isCutCard == 1 {
                        icon.image = UIImage.ne_imageNamed(name: "cell_liaotianka")
                    } else {
                        icon.image = UIImage.ne_imageNamed(name: "cell_money")
                    }
                    let string = data["money"] as? String ?? ""
                    title.text = "回复+" + string
                } else {
                    icon.image = UIImage.ne_imageNamed(name: "cell_money")
                    let string = data["money"] as? String ?? ""
                    title.text = "回复+" + string
                }
            } else {
                if let isVip = data["vip"] as? NSInteger, isVip == 1 {
                    icon.image = UIImage.ne_imageNamed(name: "cell_vip")
                    title.text = "会员免费消息"
                }
            }
        }
    }
}
