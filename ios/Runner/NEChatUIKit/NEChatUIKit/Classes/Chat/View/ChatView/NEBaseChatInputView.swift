
// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NECommonKit
import NECommonUIKit
import NECoreKit
import UIKit

@objc
public enum ChatMenuType: Int {
    case text = 0
    case audio
    case emoji
    case image
    case addMore
}

@objc
public enum ChatInputMode: Int {
    case normal
    case multipleSend
    case multipleReturn
}

public let yxAtMsg = "yxAitMsg"
public let atRangeOffset = 1
public let atSegmentsKey = "segments"
public let atTextKey = "text"
public protocol ChatInputMultilineDelegate: NSObject {
    func expandButtonDidClick()
    func didHideMultipleButtonClick()
}

@objcMembers
open class NEBaseChatInputView: UIView, ChatRecordViewDelegate,
                                InputEmoticonContainerViewDelegate, UITextViewDelegate, NEMoreViewDelegate, UITextFieldDelegate {
    public weak var multipleLineDelegate: ChatInputMultilineDelegate?
    public weak var delegate: ChatInputViewDelegate?
    public var currentType: ChatMenuType = .text
    public var voiceButton = UIButton()//语音图标
    public var pressSpeak = QWChatSendVoiceView()//按住说话
    public var emojiButton = UIButton()//表情图标
    public var sendButton = UIButton()//发送按钮
    public var isOpenHiding = false//是否开启隐身模式
    
    public var menuHeight = 104.0
    public var contentHeight = 194.0
    public var atCache: NIMInputAtCache?
    public var atRangeCache = [String: MessageAtCacheModel]()
    public var nickAccidDic = [String: String]()
    public var chatInpuMode = ChatInputMode.normal
    // 换行输入框 标题限制字数
    public var textLimit = 20
    
    public var textView: NETextView = {
        let textView = NETextView()
        textView.placeholderLabel.numberOfLines = 1
        textView.layer.cornerRadius = 20
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.clipsToBounds = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor(hexString: "#F5F5F5")
        textView.returnKeyType = .send
        textView.allowsEditingTextAttributes = true
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.typingAttributes = [NSAttributedString.Key.foregroundColor: UIColor.ne_darkText, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        textView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.ne_darkText, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        textView.dataDetectorTypes = []
        textView.accessibilityIdentifier = "id.chatMessageInput"
        return textView
    }()
    
    public var stackView = UIStackView()
    var contentView = UIView()
    public var contentSubView: UIView?
    public var greyView = UIView()
    public var textInput: UITextInput?
    public var textviewLeftConstraint: NSLayoutConstraint?
    public var textviewRightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    open func commonUI() {}
    
    open func addEmojiView() {
        currentType = .emoji
        textView.resignFirstResponder()
        contentSubView?.isHidden = true
        contentSubView = emojiView
        contentSubView?.isHidden = false
    }
    
    open func addMoreActionView() {
        currentType = .addMore
        textView.resignFirstResponder()
        contentSubView?.isHidden = true
        contentSubView = chatAddMoreView
        contentSubView?.isHidden = false
    }
    
    open func sendText(textView: NETextView) {
        guard let text = getRealSendText(textView.attributedText) else {
            return
        }
        delegate?.sendText(text: text, attribute: textView.attributedText)
        if isOpenHiding == false {
            textView.text = ""
            atCache?.clean()
        }
    }
    
    // MARK: ===================== lazy method =====================
    public lazy var emojiView: UIView = {
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 200))
        let view = InputEmoticonContainerView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 200))
        view.delegate = self
        backView.isHidden = true
        backView.backgroundColor = UIColor.clear
        backView.addSubview(view)
        let tap = UITapGestureRecognizer()
        backView.addGestureRecognizer(tap)
        tap.addTarget(self, action: #selector(missClickEmoj))
        return backView
    }()
    
    public lazy var chatAddMoreView: NEChatMoreActionView = {
        let view = NEChatMoreActionView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 90))
        view.isHidden = true
        view.delegate = self
        return view
    }()

    open func textViewDidChange(_ textView: UITextView) {
        delegate?.textFieldDidChange(textView.text)
    }
    
    open func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.textFieldDidEndEditing(textView.text)
    }
    
    open func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.textFieldDidBeginEditing(textView.text)
    }
    
    open func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        currentType = .text
        return true
    }
    
    open func checkRemoveAtMessage(range: NSRange, attribute: NSAttributedString) -> NSRange? {
        var temRange: NSRange?
        let start = range.location
        attribute.enumerateAttribute(
            NSAttributedString.Key.foregroundColor,
            in: NSMakeRange(0, attribute.length)
        ) { value, findRange, stop in
            guard let findColor = value as? UIColor else {
                return
            }
            if isEqualToColor(findColor, UIColor.ne_blueText) == false {
                return
            }
            if findRange.location <= start, start < findRange.location + findRange.length + atRangeOffset {
                temRange = NSMakeRange(findRange.location, findRange.length + atRangeOffset)
                stop.pointee = true
            }
        }
        return temRange
    }
    
    // 查找at消息位置并且根据光标位置距离高亮前段或者后端更近判断光标最终显示在前还是在后
    open func findShowPosition(range: NSRange, attribute: NSAttributedString) -> NSRange? {
        var showRange: NSRange?
        let start = range.location
        attribute.enumerateAttribute(
            NSAttributedString.Key.foregroundColor,
            in: NSMakeRange(0, attribute.length)
        ) { value, findRange, stop in
            guard let findColor = value as? UIColor else {
                return
            }
            if isEqualToColor(findColor, UIColor.ne_blueText) == false {
                return
            }
            let findStart = findRange.location
            let findEnd = findRange.location + findRange.length + atRangeOffset
            if findStart <= start, start < findEnd {
                if findEnd - start > start - findStart {
                    showRange = NSMakeRange(findStart, 0)
                } else {
                    showRange = NSMakeRange(findRange.location, findRange.length + atRangeOffset)
                }
                stop.pointee = true
            }
        }
        return showRange
    }
    
    open func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,
                       replacementText text: String) -> Bool {
        textView.typingAttributes = [NSAttributedString.Key.foregroundColor: UIColor.ne_darkText, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        
        if chatInpuMode == .normal || chatInpuMode == .multipleSend, text == "\n" {
            guard var realText = getRealSendText(textView.attributedText) else {
                return true
            }
            if realText.trimmingCharacters(in: .whitespaces).isEmpty {
                realText = ""
            }
            delegate?.sendText(text: realText, attribute: textView.attributedText)
            if isOpenHiding == false {
                textView.text = ""
                atCache?.clean()
            }
            return false
        }
        
        // 处理粘贴，表情解析（存在表情则字符数量>=3）
        if text.count >= 3 {
            let mutaString = NSMutableAttributedString(attributedString: textView.attributedText)
            let addString = NEEmotionTool.getAttWithStr(str: text, font: .systemFont(ofSize: 16))
            mutaString.replaceCharacters(in: range, with: addString)
            textView.attributedText = mutaString
            DispatchQueue.main.async {
                textView.selectedRange = NSMakeRange(range.location + addString.length, 0)
            }
            return false
        }
        
        if text.count == 0 {
            let temRange = checkRemoveAtMessage(range: range, attribute: textView.attributedText)
            if let findRange = temRange {
                let mutableAttri = NSMutableAttributedString(attributedString: textView.attributedText)
                if mutableAttri.length >= findRange.location + findRange.length {
                    mutableAttri.removeAttribute(NSAttributedString.Key.foregroundColor, range: findRange)
                    mutableAttri.removeAttribute(NSAttributedString.Key.font, range: findRange)
                    if range.length == 1 {
                        mutableAttri.replaceCharacters(in: findRange, with: "")
                    }
                    if mutableAttri.length <= 0 {
                        textView.attributedText = nil
                    } else {
                        textView.attributedText = mutableAttri
                    }
                    textView.selectedRange = NSMakeRange(findRange.location, 0)
                }
                return false
            }
            return true
        } else {
            delegate?.textChanged(text: text)
        }
        return true
    }
    
    open func textViewDidChangeSelection(_ textView: UITextView) {
        let range = textView.selectedRange
        if let findRange = findShowPosition(range: range, attribute: textView.attributedText) {
            textView.selectedRange = NSMakeRange(findRange.location + findRange.length, 0)
        }
    }
    
    @available(iOS 10.0, *)
    open func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        print("action : ", interaction)
        
        return true
    }
    
    open func buttonEvent(button: UIButton) {
        switch button.tag - 1000 {
        case 0://相册
            if isOpenHiding == false {
                currentType = .image
            }
        case 1://礼物
            print("点击礼物")
        case 2://点击视频
            print("点击视频")
        case 3://常用语
            print("常用语")
        case 4://更多
            currentType = .addMore
            addMoreActionView()
        case 10://语音录制
            if isOpenHiding == false {
                currentType = .audio
                button.isSelected = !button.isSelected
                if button.isSelected {
                    pressSpeak.isHidden = false
                    textView.isHidden = true
                } else {
                    pressSpeak.isHidden = true
                    textView.isHidden = false
                }
            }
        case 11://发送
            if textView.text.count == 0 {
                return
            }
            if isOpenHiding == false {
                guard let text = getRealSendText(textView.attributedText) else {
                    return
                }
                delegate?.sendText(text: text, attribute: textView.attributedText)
                textView.text = ""
                atCache?.clean()
            }
        case 12://表情
            currentType = .emoji
            voiceButton.isSelected = false
            pressSpeak.isHidden = true
            textView.isHidden = false
            addEmojiView()
        default:
            print("default")
        }
        delegate?.willSelectItem(button: button, index: button.tag - 1000)
    }
    
    // MARK: NIMInputEmoticonContainerViewDelegate
    open func selectedEmoticon(emoticonID: String, emotCatalogID: String, description: String) {
        if emoticonID.isEmpty { // 删除键
            textView.deleteBackward()
            print("delete ward")
        } else {
            sendButton.isSelected = true
            if let font = textView.font {
                let attribute = NEEmotionTool.getAttWithStr(
                    str: description,
                    font: font,
                    CGPoint(x: 0, y: -4)
                )
                print("attribute : ", attribute)
                let mutaAttribute = NSMutableAttributedString()
                if let origin = textView.attributedText {
                    mutaAttribute.append(origin)
                }
                attribute.enumerateAttribute(
                    NSAttributedString.Key.attachment,
                    in: NSMakeRange(0, attribute.length)
                ) { value, range, stop in
                    if let neAttachment = value as? NEEmotionAttachment {
                        print("ne attachment bounds ", neAttachment.bounds)
                    }
                }
                mutaAttribute.append(attribute)
                mutaAttribute.addAttribute(
                    NSAttributedString.Key.font,
                    value: font,
                    range: NSMakeRange(0, mutaAttribute.length)
                )
                textView.attributedText = mutaAttribute
                textView.scrollRangeToVisible(NSMakeRange(textView.attributedText.length, 1))
            }
        }
    }
    
    open func didPressSend(sender: UIButton) {
        guard let text = getRealSendText(textView.attributedText) else {
            return
        }
        delegate?.sendText(text: text, attribute: textView.attributedText)
        if isOpenHiding == false {
            textView.text = ""
            atCache?.clean()
        }
    }
    
    open func stopRecordAnimation() {
        pressSpeak.voiceGifView.recordImageView.stopAnimating()
    }
    
    //MARK: NEMoreViewDelagate
    open func moreViewDidSelectMoreCell(moreView: NEChatMoreActionView, cell: NEInputMoreCell) {
        delegate?.didSelectMoreCell(cell: cell)
    }
    
    //MARK: ChatRecordViewDelegate
    open func startRecord() {
        delegate?.startRecord()
    }
    
    open func moveOutView() {
        delegate?.moveOutView()
    }
    
    open func moveInView() {
        delegate?.moveInView()
    }
    
    open func endRecord(insideView: Bool) {
        delegate?.endRecord(insideView: insideView)
    }
    
    func getRealSendText(_ attribute: NSAttributedString) -> String? {
        let muta = NSMutableString()
        
        attribute.enumerateAttributes(
            in: NSMakeRange(0, attribute.length),
            options: NSAttributedString.EnumerationOptions(rawValue: 0)
        ) { dics, range, stop in
            
            if let neAttachment = dics[NSAttributedString.Key.attachment] as? NEEmotionAttachment,
               let des = neAttachment.emotion?.tag {
                muta.append(des)
            } else {
                let sub = attribute.attributedSubstring(from: range).string
                muta.append(sub)
            }
        }
        return muta as String
    }
    
    open func getRemoteExtension(_ attri: NSAttributedString?) -> [String: Any]? {
        guard let attribute = attri else {
            return nil
        }
        var atDic = [String: [String: Any]]()
        let string = attribute.string
        attribute.enumerateAttribute(
            NSAttributedString.Key.foregroundColor,
            in: NSMakeRange(0, attribute.length)
        ) { value, findRange, stop in
            guard let findColor = value as? UIColor else {
                return
            }
            if isEqualToColor(findColor, UIColor.ne_blueText) == false {
                return
            }
            if let range = Range(findRange, in: string) {
                let text = string[range]
                let model = MessageAtInfoModel()
                print("range text : ", String(text))
                model.start = findRange.location
                model.end = model.start + findRange.length
                var dic: [String: Any]?
                var array: [Any]?
                if let accid = nickAccidDic[String(text)] {
                    if let atCacheDic = atDic[accid] {
                        dic = atCacheDic
                    } else {
                        dic = [String: Any]()
                    }
                    
                    if let atCacheArray = dic?[atSegmentsKey] as? [Any] {
                        array = atCacheArray
                    } else {
                        array = [Any]()
                    }
                    
                    if let object = model.yx_modelToJSONObject() {
                        array?.append(object)
                    }
                    dic?[atSegmentsKey] = array
                    dic?[atTextKey] = String(text) + " "
                    dic?[#keyPath(MessageAtCacheModel.accid)] = accid
                    atDic[accid] = dic
                }
            }
        }
        if atDic.count > 0 {
            return [yxAtMsg: atDic]
        }
        return nil
    }
    
    open func getAtRemoteExtension() -> [String: Any]? {
        var atDic = [String: Any]()
        NELog.infoLog(className(), desc: "at range cache : \(atRangeCache)")
        atRangeCache.forEach { (key: String, value: MessageAtCacheModel) in
            if let userValue = atDic[value.accid] as? [String: AnyObject], var array = userValue[atSegmentsKey] as? [Any], let object = value.atModel.yx_modelToJSONObject() {
                array.append(object)
                if var dic = atDic[value.accid] as? [String: Any] {
                    dic[atSegmentsKey] = array
                    atDic[value.accid] = dic
                }
            } else if let object = value.atModel.yx_modelToJSONObject() {
                var array = [Any]()
                array.append(object)
                var dic = [String: Any]()
                dic[atTextKey] = value.text
                dic[atSegmentsKey] = array
                atDic[value.accid] = dic
            }
        }
        NELog.infoLog(className(), desc: "at dic value : \(atDic)")
        if atDic.count > 0 {
            return [yxAtMsg: atDic]
        }
        return nil
    }
    
    open func cleartAtCache() {
        nickAccidDic.removeAll()
    }
    
    private func convertRangeToNSRange(range: UITextRange?) -> NSRange? {
        if let start = range?.start, let end = range?.end {
            let startIndex = textInput?.offset(from: textInput?.beginningOfDocument ?? start, to: start) ?? 0
            let endIndex = textInput?.offset(from: textInput?.beginningOfDocument ?? end, to: end) ?? 0
            return NSMakeRange(startIndex, endIndex - startIndex)
        }
        return nil
    }
    
    private func isEqualToColor(_ color1: UIColor, _ color2: UIColor) -> Bool {
        guard let components1 = color1.cgColor.components,
              let components2 = color2.cgColor.components,
              color1.cgColor.colorSpace == color2.cgColor.colorSpace,
              color1.cgColor.numberOfComponents == 4,
              color2.cgColor.numberOfComponents == 4
        else {
            return false
        }
        
        return components1[0] == components2[0] && // Red
        components1[1] == components2[1] && // Green
        components1[2] == components2[2] && // Blue
        components1[3] == components2[3] // Alpha
    }
    
    func missClickEmoj() {
        print("click one px space")
    }
}
