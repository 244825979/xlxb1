
// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import UIKit

@objcMembers
open class NEBaseChatMessageTipCell: UITableViewCell {
    var timeLabelHeightAnchor: NSLayoutConstraint? // 消息时间高度约束
    var tipViewWidthAnchor: NSLayoutConstraint?
    var tipViewHeightAnchor: NSLayoutConstraint?
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        commonUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func commonUI() {
        contentView.addSubview(timeLabel)
        timeLabelHeightAnchor = timeLabel.heightAnchor.constraint(equalToConstant: 22)
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            timeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            timeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            timeLabelHeightAnchor!,
        ])
        
        contentView.addSubview(tipView)
        NSLayoutConstraint.activate([
            tipView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 5),
            tipView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
        //提醒内容宽
        tipViewWidthAnchor = tipView.widthAnchor.constraint(equalToConstant: kScreenWidth - 32)
        tipViewWidthAnchor?.isActive = true
        //提醒内容高
        tipViewHeightAnchor = tipView.heightAnchor.constraint(equalToConstant: 38)
        tipViewHeightAnchor?.isActive = true
        
        tipView.addSubview(contentLabel)
        NSLayoutConstraint.activate([
            contentLabel.leftAnchor.constraint(equalTo: tipView.leftAnchor, constant: chat_content_left_right_margin),
            contentLabel.rightAnchor.constraint(equalTo: tipView.rightAnchor, constant: -chat_content_left_right_margin),
            contentLabel.centerYAnchor.constraint(equalTo: tipView.centerYAnchor)
        ])
    }
    
    func setModel(_ model: MessageTipsModel) {
        // time
        if let time = model.timeContent, !time.isEmpty {
            timeLabelHeightAnchor?.constant = chat_timeCellH
            timeLabel.text = time
            timeLabel.isHidden = false
        } else {
            timeLabelHeightAnchor?.constant = 0
            timeLabel.text = ""
            timeLabel.isHidden = true
        }
        
        contentLabel.attributedText = model.attributeStr
        tipViewWidthAnchor?.constant = model.contentSize.width
        tipViewHeightAnchor?.constant = model.contentSize.height
    }
    
    public lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: NEKitChatConfig.shared.ui.messageProperties.timeTextSize)
        label.textColor = UIColor(hexString: "#999999")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "id.messageTipText"
        label.backgroundColor = .clear
        return label
    }()
    
    public lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: NEKitChatConfig.shared.ui.messageProperties.timeTextSize)
        label.textColor = UIColor(hexString: "#999999")
        label.backgroundColor = UIColor(hexString: "#FFFFFF")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "id.messageTipText"
        return label
    }()
    
    public lazy var tipView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}
