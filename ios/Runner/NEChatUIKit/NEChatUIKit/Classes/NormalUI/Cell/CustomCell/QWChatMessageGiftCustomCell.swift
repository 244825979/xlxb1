//
//  QWChatMessageGiftCustomCell.swift
//  NEChatUIKit
//
//  Created by 心聊想伴 on 2024/6/20.
//

import UIKit
import NIMSDK

class QWChatMessageGiftCustomCell: NEBaseChatMessageCell {

    public lazy var titleLeft: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = .clear
        label.textAlignment = .justified
        label.textColor = .black;
        label.text = "收到礼物"
        return label
    }()
    
    public lazy var imageLeft: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public lazy var nameLeft: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = .clear
        label.textAlignment = .justified
        label.textColor = UIColor(hexString: "#FF1832")
        return label
    }()
    
    public lazy var titleRight: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = .clear
        label.textAlignment = .justified
        label.textColor = .white;
        label.text = "送出礼物"
        return label
    }()
    
    public lazy var imageRight: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public lazy var nameRight: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = .clear
        label.textAlignment = .justified
        label.textColor = .white;
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
        bubbleImageLeft.addSubview(imageLeft)
        NSLayoutConstraint.activate([
            imageLeft.rightAnchor.constraint(equalTo: bubbleImageLeft.rightAnchor, constant: -12),
            imageLeft.centerYAnchor.constraint(equalTo: bubbleImageLeft.centerYAnchor),
            imageLeft.widthAnchor.constraint(equalToConstant: 60),
            imageLeft.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        bubbleImageLeft.addSubview(titleLeft)
        NSLayoutConstraint.activate([
            titleLeft.leftAnchor.constraint(equalTo: bubbleImageLeft.leftAnchor, constant: 12),
            titleLeft.topAnchor.constraint(equalTo: imageLeft.topAnchor, constant: 8),
            titleLeft.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        bubbleImageLeft.addSubview(nameLeft)
        NSLayoutConstraint.activate([
            nameLeft.leftAnchor.constraint(equalTo: titleLeft.leftAnchor, constant: 0),
            nameLeft.topAnchor.constraint(equalTo: titleLeft.bottomAnchor, constant: 5),
            nameLeft.heightAnchor.constraint(equalToConstant: 18),
        ])
    
        bubbleImageRight.addSubview(imageRight)
        NSLayoutConstraint.activate([
            imageRight.leftAnchor.constraint(equalTo: bubbleImageRight.leftAnchor, constant: 12),
            imageRight.centerYAnchor.constraint(equalTo: bubbleImageRight.centerYAnchor),
            imageRight.widthAnchor.constraint(equalToConstant: 60),
            imageRight.heightAnchor.constraint(equalToConstant: 60),
        ])
        
        bubbleImageRight.addSubview(titleRight)
        NSLayoutConstraint.activate([
            titleRight.leftAnchor.constraint(equalTo: imageRight.rightAnchor, constant: 8),
            titleRight.topAnchor.constraint(equalTo: imageRight.topAnchor, constant: 8),
            titleRight.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        bubbleImageRight.addSubview(nameRight)
        NSLayoutConstraint.activate([
            nameRight.leftAnchor.constraint(equalTo: titleRight.leftAnchor, constant: 0),
            nameRight.topAnchor.constraint(equalTo: titleRight.bottomAnchor, constant: 5),
            nameRight.heightAnchor.constraint(equalToConstant: 18),
        ])
    }
    
    override open func setModel(_ model: MessageContentModel, _ isSend: Bool) {
        super.setModel(model, isSend)
        let giftName = isSend ? nameRight : nameLeft
        let giftImage = isSend ? imageRight : imageLeft
 
        if let obj = model.message?.messageObject as? NIMCustomObject {
            if let m = model as? MessageCustomModel {
                giftName.text = m.giftName
                giftImage.sd_setImage(with: URL(string: NEKitChatConfig.shared.imageURL + m.giftUrl)) { image, error, type, url in
                    if image != nil {
                        giftImage.image = image
                    } else {
                        giftImage.image = nil
                    }
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
