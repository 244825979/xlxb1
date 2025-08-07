//
//  QWChatIAudioCustomCell.swift
//  NEChatUIKit
//
//  Created by 心聊想伴 on 2024/10/28.
//

import UIKit
import NIMSDK

class QWChatAudioCustomCell: NEBaseChatMessageCell, ChatAudioCellProtocol {

    public var messageId: String?
    public var isPlaying: Bool = false
    
    public var audioImageViewLeft = UIImageView(image: UIImage.ne_imageNamed(name: "left_voice3"))
    public var timeLabelLeft = UILabel()
    public var message: NIMMessage?
    public var voiceRedPoint = UIView()//语音未读红点
    
    public var audioImageViewRight = UIImageView(image: UIImage.ne_imageNamed(name: "right_voice3"))
    public var timeLabelRight = UILabel()
    
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
        audioImageViewLeft.contentMode = .center
        audioImageViewLeft.translatesAutoresizingMaskIntoConstraints = false
        audioImageViewLeft.accessibilityIdentifier = "id.animation"
        bubbleImageLeft.addSubview(audioImageViewLeft)
        NSLayoutConstraint.activate([
            audioImageViewLeft.leftAnchor.constraint(equalTo: bubbleImageLeft.leftAnchor, constant: 16),
            audioImageViewLeft.centerYAnchor.constraint(equalTo: bubbleImageLeft.centerYAnchor),
            audioImageViewLeft.widthAnchor.constraint(equalToConstant: 24),
            audioImageViewLeft.heightAnchor.constraint(equalToConstant: 24),
        ])
        
        timeLabelLeft.font = UIFont.systemFont(ofSize: 14)
        timeLabelLeft.textColor = .black
        timeLabelLeft.textAlignment = .left
        timeLabelLeft.translatesAutoresizingMaskIntoConstraints = false
        timeLabelLeft.accessibilityIdentifier = "id.time"
        bubbleImageLeft.addSubview(timeLabelLeft)
        NSLayoutConstraint.activate([
            timeLabelLeft.leftAnchor.constraint(equalTo: audioImageViewLeft.rightAnchor, constant: 12),
            timeLabelLeft.centerYAnchor.constraint(equalTo: bubbleImageLeft.centerYAnchor),
            timeLabelLeft.rightAnchor.constraint(equalTo: bubbleImageLeft.rightAnchor, constant: -12),
            timeLabelLeft.heightAnchor.constraint(equalToConstant: 28),
        ])
        audioImageViewLeft.animationDuration = 1
        if let leftImage1 = UIImage.ne_imageNamed(name: "left_voice1"),
           let leftmage2 = UIImage.ne_imageNamed(name: "left_voice2"),
           let leftmage3 = UIImage.ne_imageNamed(name: "left_voice3") {
            audioImageViewLeft.animationImages = [leftImage1, leftmage2, leftmage3]
        }
        
        voiceRedPoint.backgroundColor = .red
        voiceRedPoint.layer.masksToBounds = true
        voiceRedPoint.layer.cornerRadius = 4
        voiceRedPoint.translatesAutoresizingMaskIntoConstraints = false
        voiceRedPoint.isHidden = true
        contentView.addSubview(voiceRedPoint)
        NSLayoutConstraint.activate([
            voiceRedPoint.leftAnchor.constraint(equalTo: bubbleImageLeft.rightAnchor, constant: 8),
            voiceRedPoint.centerYAnchor.constraint(equalTo: bubbleImageLeft.centerYAnchor, constant: 0),
            voiceRedPoint.widthAnchor.constraint(equalToConstant: 8),
            voiceRedPoint.heightAnchor.constraint(equalToConstant: 8),
        ])
    }
    
    open func commonUIRight() {
        audioImageViewRight.contentMode = .center
        audioImageViewRight.translatesAutoresizingMaskIntoConstraints = false
        audioImageViewRight.accessibilityIdentifier = "id.animation"
        bubbleImageRight.addSubview(audioImageViewRight)
        NSLayoutConstraint.activate([
            audioImageViewRight.rightAnchor.constraint(equalTo: bubbleImageRight.rightAnchor, constant: -16),
            audioImageViewRight.centerYAnchor.constraint(equalTo: bubbleImageRight.centerYAnchor),
            audioImageViewRight.widthAnchor.constraint(equalToConstant: 24),
            audioImageViewRight.heightAnchor.constraint(equalToConstant: 24),
        ])
        
        timeLabelRight.font = UIFont.systemFont(ofSize: 14)
        timeLabelRight.textColor = .white
        timeLabelRight.textAlignment = .right
        timeLabelRight.translatesAutoresizingMaskIntoConstraints = false
        timeLabelRight.accessibilityIdentifier = "id.time"
        bubbleImageRight.addSubview(timeLabelRight)
        NSLayoutConstraint.activate([
            timeLabelRight.rightAnchor.constraint(equalTo: audioImageViewRight.leftAnchor, constant: -12),
            timeLabelRight.centerYAnchor.constraint(equalTo: bubbleImageRight.centerYAnchor),
            timeLabelRight.heightAnchor.constraint(equalToConstant: 28),
        ])
        
        audioImageViewRight.animationDuration = 1
        if let image1 = UIImage.ne_imageNamed(name: "right_voice1"),
           let image2 = UIImage.ne_imageNamed(name: "right_voice2"),
           let image3 = UIImage.ne_imageNamed(name: "right_voice3") {
            audioImageViewRight.animationImages = [image1, image2, image3]
        }
    }
    
    open func startAnimation(byRight: Bool) {
        if byRight {
            if !audioImageViewRight.isAnimating {
                audioImageViewRight.startAnimating()
            }
        } else if !audioImageViewLeft.isAnimating {
            audioImageViewLeft.startAnimating()
        }
        if let m = contentModel as? MessageAudioModel {
            m.isPlaying = true
            isPlaying = true
        }
        
        if !byRight {
            //如果已播放，更新已播放标记
            if var message = self.message, var localExt = message.localExt {
                //取需要改的值进行插入数据
                localExt["isReadAudio"] = "0"
                message.localExt = localExt
                NIMSDK.shared().conversationManager.update(message, for: message.session ?? NIMSession())
                voiceRedPoint.isHidden = true
            }
        }
    }
    
    open func stopAnimation(byRight: Bool) {
        if audioImageViewRight.isAnimating {
            audioImageViewRight.stopAnimating()
        }
        if audioImageViewLeft.isAnimating {
            audioImageViewLeft.stopAnimating()
        }
        if let m = contentModel as? MessageAudioModel {
            m.isPlaying = false
            isPlaying = false
        }
    }
    
    override open func showLeftOrRight(showRight: Bool) {
        super.showLeftOrRight(showRight: showRight)
        audioImageViewLeft.isHidden = showRight
        timeLabelLeft.isHidden = showRight
        
        audioImageViewRight.isHidden = !showRight
        timeLabelRight.isHidden = !showRight
    }
    
    override open func setModel(_ model: MessageContentModel, _ isSend: Bool) {
        super.setModel(model, isSend)
        if let obj = model.message?.messageObject as? NIMCustomObject {
            if let m = model as? MessageCustomModel {
                if isSend {
                    timeLabelRight.text = "\(m.duration)" + "\""
                } else {
                    timeLabelLeft.text = "\(m.duration)" + "\""
                    self.message = m.message
                    
                    //如果本地字段有值，且未1，表示未播放，显示红点
                    if let isReadAudio = m.message?.localExt?["isReadAudio"] as? String, isReadAudio == "1" {
                        voiceRedPoint.isHidden = false
                    } else {
                        voiceRedPoint.isHidden = true
                    }
                }
                m.isPlaying ? startAnimation(byRight: isSend) : stopAnimation(byRight: isSend)
                messageId = m.message?.messageId
            }
        }
    }
}
