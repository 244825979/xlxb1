//
//  QWChatSendVoiceView.swift
//  NEChatUIKit
//
//  Created by 心聊想伴 on 2024/11/04.
//  发送语音

import UIKit

@objc
public protocol ChatRecordViewDelegate: NSObjectProtocol {
  func startRecord()
  func moveOutView()
  func moveInView()
  func endRecord(insideView: Bool)
}

@objcMembers
public class QWChatSendVoiceView: UIView {

    var voiceButton = UIButton()
    var voiceGifView = VoiceGifAnimationView()
    
    public weak var delegate: ChatRecordViewDelegate?
    private var outView = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonUI() {
        
        voiceGifView.backgroundColor = HexRGBAlpha(0x333333, 1)
        voiceGifView.layer.cornerRadius = 10
        
        voiceButton.setTitle("按住说话", for: .normal)
        voiceButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        voiceButton.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        voiceButton.addTarget(self, action: #selector(beginRecordVoice), for: .touchDown)
        voiceButton.addTarget(self, action: #selector(endRecordVoice), for: .touchUpInside)
        voiceButton.addTarget(self, action: #selector(cancelRecordVoice), for: .touchUpOutside)
        voiceButton.addTarget(self, action: #selector(cancelRecordVoice), for: .touchCancel)
        voiceButton.addTarget(self, action: #selector(remindDragExit), for: .touchDragExit)
        voiceButton.addTarget(self, action: #selector(remindDragEnter), for: .touchDragEnter)
        addSubview(voiceButton)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        voiceButton.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height)
    }
    
    public func stopRecordAnimation() {
        voiceGifView.recordImageView.stopAnimating()
    }
    
    func beginRecordVoice(button: UIButton) {
        //有无麦克风权限
        if NEAuthManager.hasAudioAuthoriztion() {
            button.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                //code
                button.isEnabled = true
            }
            print("beginRecordVoice====开始录音")
            voiceGifView.frame = CGRectMake(kScreenWidth/2 - 80, kScreenHeight/2 - 80 - KStatusBarHeight/2 - 22, 160, 160)
            voiceGifView.state = .normal
            voiceGifView.recordImageView.startAnimating()
            UIApplication.shared.keyWindow?.addSubview(voiceGifView)
            delegate?.startRecord()
        } else {
            NEAuthManager.requestAudioAuthorization { granted in
                if granted {
                    
                } else {
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: Notification.Name("openRecordPowerNotification"), object: nil)
                    }
                }
            }
        }
    }
    
    func endRecordVoice(button: UIButton) {
        print("endRecordVoice====结束录音")
        voiceGifView.state = .finished
        stopRecordAnimation()
        delegate?.endRecord(insideView: true)
        voiceGifView.removeFromSuperview()
    }
    
    func cancelRecordVoice(button: UIButton) {
        print("cancelRecordVoice====取消录音")
        voiceGifView.state = .cancel
        stopRecordAnimation()
        delegate?.endRecord(insideView: false)
        voiceGifView.removeFromSuperview()
    }
    
    func remindDragExit(button: UIButton) {
        print("cancelRecordVoice====将要取消录音")
        voiceGifView.state = .willCancel
    }
    
    func remindDragEnter(button: UIButton) {
        print("cancelRecordVoice====继续录音")
        voiceGifView.state = .normal
    }
    
    private func moveOutView() {
      delegate?.moveOutView()
    }

    private func moveInView() {
      delegate?.moveInView()
    }
}

public enum VoiceStateType: Int {
    case normal = 0
    case willCancel
    case cancel
    case finished
}

//加载录音动画
class VoiceGifAnimationView: UIView {
    //录音
    lazy var recordImageView: UIImageView = {
        let imageView = UIImageView()
        //显示倒计时动画
        if let image1 = UIImage.ne_imageNamed(name: "voice_00000"),
           let image2 = UIImage.ne_imageNamed(name: "voice_00001"),
           let image3 = UIImage.ne_imageNamed(name: "voice_00002"),
           let image4 = UIImage.ne_imageNamed(name: "voice_00003"),
           let image5 = UIImage.ne_imageNamed(name: "voice_00004"),
           let image6 = UIImage.ne_imageNamed(name: "voice_00005"),
           let image7 = UIImage.ne_imageNamed(name: "voice_00006"),
           let image8 = UIImage.ne_imageNamed(name: "voice_00007"),
           let image9 = UIImage.ne_imageNamed(name: "voice_00008"),
           let image10 = UIImage.ne_imageNamed(name: "voice_00009"),
           let image11 = UIImage.ne_imageNamed(name: "voice_00010"),
           let image12 = UIImage.ne_imageNamed(name: "voice_00011"),
           let image13 = UIImage.ne_imageNamed(name: "voice_00012"),
           let image14 = UIImage.ne_imageNamed(name: "voice_00013"),
           let image15 = UIImage.ne_imageNamed(name: "voice_00014"),
           let image16 = UIImage.ne_imageNamed(name: "voice_00015"),
           let image17 = UIImage.ne_imageNamed(name: "voice_00016"),
           let image18 = UIImage.ne_imageNamed(name: "voice_00017"),
           let image19 = UIImage.ne_imageNamed(name: "voice_00018"),
           let image20 = UIImage.ne_imageNamed(name: "voice_00019"),
           let image21 = UIImage.ne_imageNamed(name: "voice_00020"),
           let image22 = UIImage.ne_imageNamed(name: "voice_00021"),
           let image23 = UIImage.ne_imageNamed(name: "voice_00022"),
           let image24 = UIImage.ne_imageNamed(name: "voice_00023"),
           let image25 = UIImage.ne_imageNamed(name: "voice_00024")
        {
            imageView.animationImages = [image1, image2, image3, image4, image5, image6, image7,
                                         image8, image9, image10, image11, image12,image13, image14,
                                         image15, image16, image17, image18, image19, image20, image21,
                                         image22, image23, image24, image25]
        }
        imageView.contentMode = .scaleAspectFill
        imageView.animationRepeatCount = 0
        imageView.animationDuration = 1
        imageView.startAnimating()
        return imageView
    }()
    
    //取消图标
    lazy var cancelImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.image = UIImage.ne_imageNamed(name: "production_voice_back");
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //隐藏状态文案
    lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var state: VoiceStateType = .normal {//语音状态
        didSet {
            switch state {
            case .normal://开始录音
                recordImageView.isHidden = false
                cancelImageView.isHidden = true
                stateLabel.text = "手指上划，取消发送"
            case .willCancel:
                recordImageView.isHidden = true
                cancelImageView.isHidden = false
                stateLabel.isHidden = false
                stateLabel.text = "手指松开，取消发送"
            case .cancel:
                recordImageView.isHidden = true
                cancelImageView.isHidden = false
                stateLabel.text = "手指松开，取消发送"
            case .finished:
                recordImageView.isHidden = false
                cancelImageView.isHidden = true
                stateLabel.text = "手指上划，取消发送"
            default:
                print("")
            }
        }
    }
    
    func commonUI() {
        addSubview(recordImageView)
        addSubview(cancelImageView)
        addSubview(stateLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        recordImageView.frame = CGRect(x: 160/2 - 70/2, y:31, width: 70, height: 70)
        cancelImageView.frame = CGRect(x: 160/2 - 70/2, y:31, width: 70, height: 70)
        stateLabel.frame = CGRect(x: 0, y: 107, width: 160, height: 22)
    }
}
