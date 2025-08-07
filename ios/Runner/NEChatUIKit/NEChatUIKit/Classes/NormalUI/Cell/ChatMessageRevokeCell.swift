
// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import UIKit

@objcMembers
open class ChatMessageRevokeCell: NormalChatMessageBaseCell {
    
    var tipViewWidthAnchor: NSLayoutConstraint?
    public lazy var tipView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: NEKitChatConfig.shared.ui.messageProperties.timeTextSize)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(hexString: "#999999");
        return label
    }()
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func commonUI() {
        bubbleImageLeft.isHidden = true
        bubbleImageRight.isHidden = true
        avatarImageLeft.isHidden = true
        avatarImageRight.isHidden = true
        
        contentView.addSubview(tipView)
        NSLayoutConstraint.activate([
            tipView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 5),
            tipView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            tipView.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        tipViewWidthAnchor = tipView.widthAnchor.constraint(equalToConstant: kScreenWidth - 32)
        tipViewWidthAnchor?.isActive = true
        
        tipView.addSubview(contentLabel)
        NSLayoutConstraint.activate([
            contentLabel.centerXAnchor.constraint(equalTo: tipView.centerXAnchor),
            contentLabel.centerYAnchor.constraint(equalTo: tipView.centerYAnchor)
        ])
    }
    
    override open func showLeftOrRight(showRight: Bool) {
        super.showLeftOrRight(showRight: showRight)
        
        activityView.isHidden = true
        readView.isHidden = true
        seletedBtn.isHidden = true
        pinLabelLeft.isHidden = true
        pinImageLeft.isHidden = true
        pinLabelRight.isHidden = true
        pinImageRight.isHidden = true
        bubbleImageLeft.isHidden = true
        bubbleImageRight.isHidden = true
    }
    
    override open func setModel(_ model: MessageContentModel, _ isSend: Bool) {
        super.setModel(model, isSend)
        bubbleImageLeft.isHidden = true
        bubbleImageRight.isHidden = true
        avatarImageLeft.isHidden = true
        avatarImageRight.isHidden = true
        contentLabel.text = isSend ? chatLocalizable("你撤回了一条消息") : chatLocalizable("对方撤回了一条消息")
        tipViewWidthAnchor?.constant = isSend ? 130 : 148
    }
}
