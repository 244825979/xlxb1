//
//  QWChatActivityCustomCell.swift
//  NEChatUIKit
//
//  Created by 心聊想伴 on 2024/8/14.
//

import UIKit
import NIMSDK

class QWChatActivityCustomCell: NEBaseChatMessageCell {
    public lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = .clear
        label.textAlignment = .justified
        label.textColor = UIColor(hexString: "#999999")
        return label
    }()
    
    public lazy var goText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(hexString: "#FF4167")
        return label
    }()
    
    public lazy var activityImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 6
        image.layer.masksToBounds = true
        image.isHidden = true
        return image
    }()
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func commonUI() {
        bubbleImageLeft.addSubview(contentLabel)
        NSLayoutConstraint.activate([
            contentLabel.rightAnchor.constraint(equalTo: bubbleImageLeft.rightAnchor, constant: -16),
            contentLabel.leftAnchor.constraint(equalTo: bubbleImageLeft.leftAnchor, constant: 16),
            contentLabel.topAnchor.constraint(equalTo: bubbleImageLeft.topAnchor, constant: 12)
        ])
        
        bubbleImageLeft.addSubview(activityImage)
        NSLayoutConstraint.activate([
            activityImage.leftAnchor.constraint(equalTo: contentLabel.leftAnchor),
            activityImage.rightAnchor.constraint(equalTo: contentLabel.rightAnchor),
            activityImage.heightAnchor.constraint(equalToConstant: 148),
            activityImage.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 10)
        ])
        
        bubbleImageLeft.addSubview(goText)
        NSLayoutConstraint.activate([
            goText.leftAnchor.constraint(equalTo: bubbleImageLeft.leftAnchor, constant: 16),
            goText.heightAnchor.constraint(equalToConstant: 20),
            goText.bottomAnchor.constraint(equalTo: bubbleImageLeft.bottomAnchor, constant: -12)
        ])
    }
    
    override open func setModel(_ model: MessageContentModel, _ isSend: Bool) {
        super.setModel(model, isSend)
        if let obj = model.message?.messageObject as? NIMCustomObject {
            if let m = model as? MessageCustomModel {
                contentLabel.attributedText = m.attributeStr
                goText.text = m.title
                if m.activityStyle == 1 {
                    if m.url.count > 0 {
                        self.activityImage.isHidden = false
                        var avatarURL = NEKitChatConfig.shared.imageURL + m.url
                        activityImage
                            .sd_setImage(with: URL(string: avatarURL)) { [weak self] image, error, type, url in
                                guard let self = self else { return }
                                if image != nil {
                                    self.activityImage.image = image
                                } else {
                                    self.activityImage.image = nil
                                }
                            }
                    }
                } else {
                    self.activityImage.isHidden = true
                }
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
