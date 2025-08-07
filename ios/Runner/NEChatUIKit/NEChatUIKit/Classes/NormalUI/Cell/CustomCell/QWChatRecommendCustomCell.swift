//
//  QWChatRecommendCustom.swift
//  NEChatUIKit
//
//  Created by 心聊想伴 on 2024/6/28.
//

import UIKit
import NIMSDK

class QWChatRecommendCustomCell: NEBaseChatMessageCell {

    var tipViewWidthAnchor: NSLayoutConstraint?
    var tipViewHeightAnchor: NSLayoutConstraint?
    
    public lazy var tipView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public lazy var icon: UIImageView = {
        let label = UIImageView()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor(hexString: "#999999")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
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
        ])
        
        tipViewWidthAnchor = tipView.widthAnchor.constraint(equalToConstant: kScreenWidth - 32)
        tipViewWidthAnchor?.isActive = true
        
        tipViewHeightAnchor = tipView.heightAnchor.constraint(equalToConstant: 44)
        tipViewHeightAnchor?.isActive = true
        
        tipView.addSubview(contentLabel)
        NSLayoutConstraint.activate([
            contentLabel.leftAnchor.constraint(equalTo: tipView.leftAnchor, constant: 42),
            contentLabel.rightAnchor.constraint(equalTo: tipView.rightAnchor, constant: -12),
            contentLabel.centerYAnchor.constraint(equalTo: tipView.centerYAnchor)
        ])
        
        tipView.addSubview(icon)
        NSLayoutConstraint.activate([
            icon.leftAnchor.constraint(equalTo: tipView.leftAnchor, constant: 12),
            icon.topAnchor.constraint(equalTo: contentLabel.topAnchor),
            icon.heightAnchor.constraint(equalToConstant: 20),
            icon.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    override open func showLeftOrRight(showRight: Bool) {
        super.showLeftOrRight(showRight: showRight)
        seletedBtn.isHidden = true
        pinLabelLeft.isHidden = true
        pinImageLeft.isHidden = true
        pinLabelRight.isHidden = true
        pinImageRight.isHidden = true
    }
    
    override open func setModel(_ model: MessageContentModel, _ isSend: Bool) {
        super.setModel(model, isSend)
        bubbleImageLeft.isHidden = true
        bubbleImageRight.isHidden = true
        avatarImageLeft.isHidden = true
        avatarImageRight.isHidden = true
        if let obj = model.message?.messageObject as? NIMCustomObject {
            if let m = model as? MessageCustomModel {
                tipViewWidthAnchor?.constant = m.contentSize.width
                tipViewHeightAnchor?.constant = m.contentSize.height
                contentLabel.attributedText = m.attributeStr
                icon.image = UIImage.ne_imageNamed(name: m.icon)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
