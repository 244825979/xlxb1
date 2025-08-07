//
//  QWCallStateCustomCell.swift
//  NEChatUIKit
//
//  Created by 心聊想伴 on 2024/6/25.
//

import UIKit
import NIMSDK

class QWCallStateCustomCell: NEBaseChatMessageCell {

    public lazy var contentLabelLeft: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.backgroundColor = .clear
        label.textAlignment = .justified
        label.textColor = .black;
        return label
    }()
    
    public lazy var iconLeft: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public lazy var contentLabelRight: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.backgroundColor = .clear
        label.textAlignment = .justified
        label.textColor = .white;
        return label
    }()
    
    public lazy var iconRight: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func commonUI() {
        bubbleImageLeft.addSubview(contentLabelLeft)
        NSLayoutConstraint.activate([
            contentLabelLeft.leftAnchor.constraint(equalTo: bubbleImageLeft.leftAnchor, constant: 38),
            contentLabelLeft.topAnchor.constraint(equalTo: bubbleImageLeft.topAnchor, constant: 0),
            contentLabelLeft.rightAnchor.constraint(equalTo: bubbleImageLeft.rightAnchor, constant: -10),
            contentLabelLeft.bottomAnchor.constraint(equalTo: bubbleImageLeft.bottomAnchor, constant: 0),
        ])
        
        bubbleImageLeft.addSubview(iconLeft)
        NSLayoutConstraint.activate([
            iconLeft.leftAnchor.constraint(equalTo: bubbleImageLeft.leftAnchor, constant: 10),
            iconLeft.centerYAnchor.constraint(equalTo: bubbleImageLeft.centerYAnchor),
            iconLeft.widthAnchor.constraint(equalToConstant: 20),
            iconLeft.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        bubbleImageRight.addSubview(contentLabelRight)
        NSLayoutConstraint.activate([
            contentLabelRight.leftAnchor.constraint(equalTo: bubbleImageRight.leftAnchor, constant: 10),
            contentLabelRight.topAnchor.constraint(equalTo: bubbleImageRight.topAnchor, constant: 0),
            contentLabelRight.rightAnchor.constraint(equalTo: bubbleImageRight.rightAnchor, constant: -38),
            contentLabelRight.bottomAnchor.constraint(equalTo: bubbleImageRight.bottomAnchor, constant: 0),
        ])
        
        bubbleImageRight.addSubview(iconRight)
        NSLayoutConstraint.activate([
            iconRight.rightAnchor.constraint(equalTo: bubbleImageRight.rightAnchor, constant: -10),
            iconRight.centerYAnchor.constraint(equalTo: bubbleImageRight.centerYAnchor),
            iconRight.widthAnchor.constraint(equalToConstant: 20),
            iconRight.heightAnchor.constraint(equalToConstant: 20),
        ])
    }

    override open func showLeftOrRight(showRight: Bool) {
        super.showLeftOrRight(showRight: showRight)
        contentLabelLeft.isHidden = showRight
        contentLabelRight.isHidden = !showRight
    }
    
    override open func setModel(_ model: MessageContentModel, _ isSend: Bool) {
        super.setModel(model, isSend)
        let contentLabel = isSend ? contentLabelRight : contentLabelLeft
        
        if let obj = model.message?.messageObject as? NIMCustomObject {
            if let m = model as? MessageCustomModel {
                contentLabelRight.text = m.callRightText
                contentLabelLeft.text = m.callLeftText
                iconLeft.image = UIImage.ne_imageNamed(name: m.callLeftIcon)
                iconRight.image = UIImage.ne_imageNamed(name: m.callRightIcon)
            }
        }
    }
}
