//
//  QWChatSystemCustomCell.swift
//  NEChatUIKit
//
//  Created by 心聊想伴 on 2024/6/28.
//

import UIKit
import NIMSDK

class QWChatSystemCustomCell: NEBaseChatMessageCell {

    public lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.backgroundColor = .clear
        label.textAlignment = .justified
        label.textColor = UIColor(hexString: "#FF4167")
        return label
    }()

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
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func commonUI() {
        bubbleImageLeft.addSubview(title)
        NSLayoutConstraint.activate([
            title.rightAnchor.constraint(equalTo: bubbleImageLeft.rightAnchor, constant: -10),
            title.leftAnchor.constraint(equalTo: bubbleImageLeft.leftAnchor, constant: 10),
            title.topAnchor.constraint(equalTo: bubbleImageLeft.topAnchor, constant: 10),
            title.heightAnchor.constraint(equalToConstant: 23)
        ])
        
        bubbleImageLeft.addSubview(contentLabel)
        NSLayoutConstraint.activate([
            contentLabel.rightAnchor.constraint(equalTo: title.rightAnchor),
            contentLabel.leftAnchor.constraint(equalTo: title.leftAnchor),
            contentLabel.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8)
        ])
    }
    
    override open func setModel(_ model: MessageContentModel, _ isSend: Bool) {
        super.setModel(model, isSend)
        if let obj = model.message?.messageObject as? NIMCustomObject {
            if let m = model as? MessageCustomModel {
                title.text = m.title
                contentLabel.attributedText = m.attributeStr
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
