// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation

@objcMembers
open class ChatInputView: NEBaseChatInputView {
    public var backViewHeightConstraint: NSLayoutConstraint?
    
    override open func commonUI() {
        backgroundColor = UIColor.normalChatInputBg
        addSubview(textView)
        textView.delegate = self
        textviewLeftConstraint = textView.leftAnchor.constraint(equalTo: leftAnchor, constant: 52)
        textviewRightConstraint = textView.rightAnchor.constraint(equalTo: rightAnchor, constant: -120)
        NSLayoutConstraint.activate([
            textviewLeftConstraint!,
            textviewRightConstraint!,
            textView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            textView.heightAnchor.constraint(equalToConstant: 40),
        ])
        textInput = textView
        
        voiceButton.setImage(UIImage.ne_imageNamed(name: "bottom_keyboard"), for: .normal)
        voiceButton.setImage(UIImage.ne_imageNamed(name: "bottom_voice"), for: .selected)
        voiceButton.translatesAutoresizingMaskIntoConstraints = false
        voiceButton.adjustsImageWhenHighlighted = false//去掉点击效果
        voiceButton.addTarget(self, action: #selector(buttonEvent), for: .touchUpInside)
        voiceButton.isSelected = false
        voiceButton.tag = 1010
        addSubview(voiceButton)
        NSLayoutConstraint.activate([
            voiceButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 6),
            voiceButton.centerYAnchor.constraint(equalTo: textView.centerYAnchor),
            voiceButton.heightAnchor.constraint(equalToConstant: 40),
            voiceButton.widthAnchor.constraint(equalToConstant: 40),
        ])
        
        pressSpeak.translatesAutoresizingMaskIntoConstraints = false
        pressSpeak.clipsToBounds = true
        pressSpeak.layer.cornerRadius = 20
        pressSpeak.isHidden = true
        pressSpeak.backgroundColor = UIColor(hexString: "#F5F5F5")
        pressSpeak.delegate = self
        addSubview(pressSpeak)
        NSLayoutConstraint.activate([
            pressSpeak.leftAnchor.constraint(equalTo: leftAnchor, constant: 52),
            pressSpeak.rightAnchor.constraint(equalTo: textView.rightAnchor),
            pressSpeak.centerYAnchor.constraint(equalTo: voiceButton.centerYAnchor),
            pressSpeak.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        sendButton.setBackgroundImage(UIImage.ne_imageNamed(name: "bottom_send1"), for: .normal)
        sendButton.setBackgroundImage(UIImage.ne_imageNamed(name: "bottom_send"), for: .selected)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(buttonEvent), for: .touchUpInside)
        sendButton.adjustsImageWhenHighlighted = false//去掉点击效果
        sendButton.tag = 1011
        addSubview(sendButton)
        NSLayoutConstraint.activate([
            sendButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -14),
            sendButton.centerYAnchor.constraint(equalTo: textView.centerYAnchor),
            sendButton.heightAnchor.constraint(equalToConstant: 26),
            sendButton.widthAnchor.constraint(equalToConstant: 54),
        ])
        
        emojiButton.setImage(UIImage.ne_imageNamed(name: "bottom_face"), for: .normal)
        emojiButton.translatesAutoresizingMaskIntoConstraints = false
        emojiButton.addTarget(self, action: #selector(buttonEvent), for: .touchUpInside)
        emojiButton.adjustsImageWhenHighlighted = false//去掉点击效果
        emojiButton.tag = 1012
        addSubview(emojiButton)
        NSLayoutConstraint.activate([
            emojiButton.rightAnchor.constraint(equalTo: self.sendButton.leftAnchor, constant: -6),
            emojiButton.centerYAnchor.constraint(equalTo: textView.centerYAnchor),
            emojiButton.heightAnchor.constraint(equalToConstant: 40),
            emojiButton.widthAnchor.constraint(equalToConstant: 40),
        ])
        var imageNames: [String] = []
        var imageNamesSelected: [String] = []
        if NEKitChatConfig.shared.kAppType == 0 {
            imageNames = ["bottom_photo", "bottom_gift", "bottom_call", "bottom_usefulLan", "bottom_more"]
            imageNamesSelected = ["bottom_photo", "bottom_gift", "bottom_call", "bottom_usefulLan", "bottom_more"]
        } else {
            imageNames = ["bottom_photo", "bottom_usefulLan", "bottom_call1"]
            imageNamesSelected = ["bottom_photo", "bottom_usefulLan", "bottom_call1"]
        }
        var items = [UIButton]()
        for i in 0 ..< imageNames.count {
            let button = UIButton(type: .custom)
            button.setImage(UIImage.ne_imageNamed(name: imageNames[i]), for: .normal)
            button.setImage(UIImage.ne_imageNamed(name: imageNamesSelected[i]), for: .selected)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(buttonEvent), for: .touchUpInside)
            button.adjustsImageWhenHighlighted = false
            button.tag = i + 1000
            button.accessibilityIdentifier = "id.chatMessageActionItemBtn"
            items.append(button)
        }
        
        if let chatInputBar = NEKitChatConfig.shared.ui.chatInputBar {
            chatInputBar(&items)
        }
        
        stackView = UIStackView(arrangedSubviews: items)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 40),
            stackView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 10),
        ])
        
        greyView.translatesAutoresizingMaskIntoConstraints = false
        greyView.backgroundColor = .white
        greyView.isHidden = true
        addSubview(greyView)
        NSLayoutConstraint.activate([
            greyView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            greyView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            greyView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            greyView.heightAnchor.constraint(equalToConstant: 400),
        ])
        
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.heightAnchor.constraint(equalToConstant: contentHeight),
            contentView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0),
        ])
        contentView.addSubview(emojiView)
        contentView.addSubview(chatAddMoreView)
    }
}
