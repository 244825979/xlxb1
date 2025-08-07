//
//  QWChatImageCustomCell.swift
//  NEChatUIKit
//
//  Created by 心聊想伴 on 2024/6/28.
//

import UIKit
import NIMSDK

class QWChatImageCustomCell: NEBaseChatMessageCell {
    public let contentImageViewLeft = UIImageView()
    public let contentImageViewRight = UIImageView()
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func commonUI() {
        commonUIRight()
        commonUILeft()
    }
    
    open func commonUILeft() {
        contentImageViewLeft.translatesAutoresizingMaskIntoConstraints = false
        contentImageViewLeft.contentMode = .scaleAspectFill
        contentImageViewLeft.clipsToBounds = true
        contentImageViewLeft.layer.cornerRadius = 12
        contentImageViewLeft.layer.masksToBounds = true
        bubbleImageLeft.backgroundColor = UIColor.clear
        bubbleImageLeft.addSubview(contentImageViewLeft)
        NSLayoutConstraint.activate([
            contentImageViewLeft.rightAnchor.constraint(equalTo: bubbleImageLeft.rightAnchor),
            contentImageViewLeft.leftAnchor.constraint(equalTo: bubbleImageLeft.leftAnchor),
            contentImageViewLeft.topAnchor.constraint(equalTo: bubbleImageLeft.topAnchor),
            contentImageViewLeft.bottomAnchor.constraint(equalTo: bubbleImageLeft.bottomAnchor),
        ])
    }
    
    open func commonUIRight() {
        contentImageViewRight.translatesAutoresizingMaskIntoConstraints = false
        contentImageViewRight.contentMode = .scaleAspectFill
        contentImageViewRight.clipsToBounds = true
        contentImageViewRight.layer.cornerRadius = 12
        contentImageViewRight.layer.masksToBounds = true
        bubbleImageRight.backgroundColor = UIColor.clear
        bubbleImageRight.addSubview(contentImageViewRight)
        NSLayoutConstraint.activate([
            contentImageViewRight.rightAnchor.constraint(equalTo: bubbleImageRight.rightAnchor),
            contentImageViewRight.leftAnchor.constraint(equalTo: bubbleImageRight.leftAnchor),
            contentImageViewRight.topAnchor.constraint(equalTo: bubbleImageRight.topAnchor),
            contentImageViewRight.bottomAnchor.constraint(equalTo: bubbleImageRight.bottomAnchor),
        ])
    }
    
    override open func showLeftOrRight(showRight: Bool) {
        super.showLeftOrRight(showRight: showRight)
        contentImageViewLeft.isHidden = showRight
        contentImageViewRight.isHidden = !showRight
    }

    override open func setModel(_ model: MessageContentModel, _ isSend: Bool) {
        super.setModel(model, isSend)
        let contentImageView = isSend ? contentImageViewRight : contentImageViewLeft
        
        if let obj = model.message?.messageObject as? NIMCustomObject {
            if let m = model as? MessageCustomModel {
                if m.url.hasPrefix("http") {
                    contentImageView.sd_setImage(
                        with: URL(string: m.url),
                        placeholderImage: nil,
                        options: .retryFailed,
                        progress: nil,
                        completed: nil
                    )
                } else {
                    contentImageView.image = UIImage(contentsOfFile: m.url)
                }
            }
        } else {
            contentImageView.image = nil
        }
    }
}
