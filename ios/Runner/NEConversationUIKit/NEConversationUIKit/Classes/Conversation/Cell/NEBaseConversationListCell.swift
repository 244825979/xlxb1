
// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK
import UIKit
import NEChatUIKit

@objcMembers
open class NEBaseConversationListCell: UITableViewCell {
    //  private var viewModel = ConversationViewModel()
    public var topStickInfos = [NIMSession: NIMStickTopSessionInfo]()
    private let repo = ConversationRepo.shared
    private var timeWidth: NSLayoutConstraint?
    public var redAngleViewWidth: NSLayoutConstraint?//红点宽度
    public var userID: String?
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        initSubviewsLayout()
        ///用户在线状态通知
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(statusNotification(_:)),
                                               name: NSNotification.Name(rawValue: "userStatusNotification"),
                                               object: nil);
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupSubviews() {
        selectionStyle = .none
        if let bgColor = NEKitConversationConfig.shared.ui.conversationProperties.itemBackground {
            backgroundColor = bgColor
        }
        contentView.addSubview(headImge)
        contentView.addSubview(redAngleView)
        contentView.addSubview(statusView)
        contentView.addSubview(title)
        contentView.addSubview(subTitle)
        contentView.addSubview(timeLabel)
        redAngleViewWidth = redAngleView.widthAnchor.constraint(equalToConstant: 18)
        NSLayoutConstraint.activate([
            redAngleView.centerYAnchor.constraint(equalTo: subTitle.centerYAnchor),
            redAngleView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -14),
            redAngleView.heightAnchor.constraint(equalToConstant: 18),
        ])
        redAngleViewWidth?.isActive = true
        NSLayoutConstraint.activate([
            statusView.rightAnchor.constraint(equalTo: headImge.rightAnchor),
            statusView.bottomAnchor.constraint(equalTo: headImge.bottomAnchor),
            statusView.heightAnchor.constraint(equalToConstant: 12),
            statusView.widthAnchor.constraint(equalToConstant: 12),
        ])
        timeWidth = timeLabel.widthAnchor.constraint(equalToConstant: 0)
        timeWidth?.isActive = true
        NSLayoutConstraint.activate([
            timeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant: -14),
            timeLabel.centerYAnchor.constraint(equalTo: title.centerYAnchor),
        ])
        NSLayoutConstraint.activate([
            subTitle.leftAnchor.constraint(equalTo: headImge.rightAnchor, constant: 12),
            subTitle.bottomAnchor.constraint(equalTo: headImge.bottomAnchor, constant: -5),
            subTitle.heightAnchor.constraint(equalToConstant: 20),
            subTitle.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -50)
        ])
    }
    
    //根据状态事件刷新是否在线
    @objc private func statusNotification(_ notify: NSNotification) {
        if var states = notify.object as? [NIMSubscribeEvent] {
            for state in states {
                if state.from == userID {
                    if state.value == 1 {
                        if let userID = userID, NEKitConversationConfig.shared.hiddenMeUserList.contains(userID) {
                            statusView.isHidden = true
                        } else {
                            statusView.isHidden = false
                        }
                    } else {
                        statusView.isHidden = true
                    }
                }
            }
        }
    }
    
    func initSubviewsLayout() {}
    
    open func configData(sessionModel: ConversationListModel?) {
        guard let conversationModel = sessionModel else { return }
        
        if let userId = conversationModel.userInfo?.userId,
           let user = ChatUserCache.getUserInfo(userId) {
            conversationModel.userInfo = user
        }
        
        if conversationModel.recentSession?.session?.sessionType == .P2P {
            // p2p head image
            if let imageName = conversationModel.userInfo?.userInfo?.avatarUrl, !imageName.isEmpty {
                headImge.setTitle("")
                headImge.sd_setImage(with: URL(string: NEKitConversationConfig.shared.imageURL + imageName), completed: nil)
                headImge.backgroundColor = .clear
            } else {
                headImge.setTitle(conversationModel.userInfo?.shortName(showAlias: false, count: 2) ?? "")
                headImge.sd_setImage(with: nil, completed: nil)
                headImge.backgroundColor = UIColor
                    .colorWithString(string: conversationModel.userInfo?.userId)
            }
            // p2p nickName
            title.text = conversationModel.userInfo?.showName()
            //记录用户ID
            userID = conversationModel.userInfo?.userId
            //判断是否开启vip，获取扩展字段
            if let ext = conversationModel.userInfo?.userInfo?.ext {
                let infoDict = self.getDictionaryFromJSONString(ext)
                let vip = infoDict["vip"] as? Int ?? 0
                if vip == 1 {
                    title.textColor = UIColor.red
                } else {
                    title.textColor = NEKitConversationConfig.shared.ui.conversationProperties.itemTitleColor
                }
            }
        }
        
        // last 最后一条消息显示文本
        if let lastMessage = conversationModel.recentSession?.lastMessage {
            var text = contentForRecentSession(message: lastMessage)
            let prefixText = NEMessageUtil.messagePrefixContent(message: lastMessage)
            if (prefixText.count > 0 && NEKitConversationConfig.shared.recommendMsgBeautifyOpen == 1) {
                text = prefixText + text
                //文字前缀颜色修改
                subTitle.attributedText = NEEmotionTool.getPrefixAttWithStr(str: text,
                                                                            prefixText: prefixText,
                                                                            font: .systemFont(ofSize: 14))
            } else {
                if text.contains("【视频秀通话】 ") {
                    //【视频秀通话】文字颜色修改
                    subTitle.attributedText = NEEmotionTool.getPrefixAttWithStr(str: text,
                                                                                prefixText: "【视频秀通话】 ",
                                                                                font: .systemFont(ofSize: 14))
                } else {
                    subTitle.attributedText = NEEmotionTool.getAttWithStr(
                        str: text,
                        font: .systemFont(ofSize: 14),
                        color: NEKitConversationConfig.shared.ui.conversationProperties.itemContentColor
                    )
                }
            }
        } else {
            subTitle.attributedText = nil
        }
        
        // unRead 未读消息
        if let unReadCount = conversationModel.recentSession?.unreadCount {
            if unReadCount <= 0 {
                redAngleView.isHidden = true
            } else {
                redAngleView.isHidden = false
                if unReadCount < 10 {
                    redAngleView.text = "\(unReadCount)"
                    redAngleViewWidth?.constant = 18
                } else if unReadCount > 9 && unReadCount <= 99 {
                    redAngleView.text = "\(unReadCount)"
                    redAngleViewWidth?.constant = 22
                } else {
                    redAngleView.text = "99+"
                    redAngleViewWidth?.constant = 28
                }
            }
        }
        
        // time时间处理
        if let rencentSession = conversationModel.recentSession {
            timeLabel
                .text =
            dealTime(time: timestampDescriptionForRecentSession(recentSession: rencentSession))
            if let text = timeLabel.text {
                let maxSize = CGSize(width: UIScreen.main.bounds.width, height: 0)
                let attibutes = [NSAttributedString.Key.font: timeLabel.font]
                let labelSize = NSString(string: text).boundingRect(with: maxSize, attributes: attibutes, context: nil)
                timeWidth?.constant = labelSize.width + 1 // ceil()
            }
        }
        
        //处理是否处于在线状态字段
        if let userdaID = conversationModel.userInfo?.userId {
            let userStatusValue = UserDefaults.standard.value(forKey: "event_state_\(userdaID)") as? NSString ?? ""
            if userStatusValue.integerValue == 1 {
                if let userID = userID, NEKitConversationConfig.shared.hiddenMeUserList.contains(userID) {
                    statusView.isHidden = true
                } else {
                    statusView.isHidden = false
                }
            } else {
                statusView.isHidden = true
            }
        }
    }
    
    //json字符串转字典
    func getDictionaryFromJSONString(_ jsonString:String) ->NSDictionary {
        let jsonData:Data = jsonString.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
    
    func timestampDescriptionForRecentSession(recentSession: NIMRecentSession) -> TimeInterval {
        if let lastMessage = recentSession.lastMessage {
            return lastMessage.timestamp
        }
        return 0
    }
    
    func dealTime(time: TimeInterval) -> String {
        if time <= 0 {
            return ""
        }
        let targetDate = Date(timeIntervalSince1970: time)
        let fmt = DateFormatter()
        if targetDate.isToday() {
            fmt.dateFormat = localizable("hm")
            return fmt.string(from: targetDate)
        } else {
            if targetDate.isThisYear() {
                fmt.dateFormat = "MM月dd日"
                return fmt.string(from: targetDate)
            } else {
                fmt.dateFormat = "yyyy年MM月dd日"
                return fmt.string(from: targetDate)
            }
        }
    }
    
    open func contentForRecentSession(message: NIMMessage) -> String {
        let text = NEMessageUtil.messageContent(message: message)
        return text
    }
    
    // MARK: lazy Method
    public lazy var headImge: NEUserHeaderView = {
        let headView = NEUserHeaderView(frame: .zero)
        headView.titleLabel.textColor = .white
        headView.titleLabel.font = NEConstant.defaultTextFont(14)
        headView.translatesAutoresizingMaskIntoConstraints = false
        headView.layer.cornerRadius = 8
        headView.clipsToBounds = true
        return headView
    }()
    
    // 单条会话未读数
    public lazy var redAngleView: RedAngleLabel = {
        let label = RedAngleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = NEConstant.defaultTextFont(12)
        label.textColor = .white
        label.text = "99+"
        label.backgroundColor = UIColor.red
        label.layer.cornerRadius = 9
        label.clipsToBounds = true
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    
    // 在线状态
    public lazy var statusView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#40D64F")
        view.layer.cornerRadius = 6
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        view.isHidden = true
        return view
    }()
    
    // 会话列表会话名称
    public lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = NEKitConversationConfig.shared.ui.conversationProperties.itemTitleColor
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.text = "Oliver"
        label.accessibilityIdentifier = "id.name"
        return label
    }()
    
    // 会话列表外露消息
    public lazy var subTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = NEKitConversationConfig.shared.ui.conversationProperties.itemContentColor
        label.font = .systemFont(ofSize: 14)
        label.accessibilityIdentifier = "id.message"
        return label
    }()
    
    // 会话列表显示时间
    public lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = NEKitConversationConfig.shared.ui.conversationProperties.itemDateColor
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .right
        label.accessibilityIdentifier = "id.time"
        return label
    }()
}
