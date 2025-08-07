
// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NEChatKit
import NIMSDK
import UIKit

@objcMembers
open class P2PChatViewController: NormalChatViewController {
    public var myAvatarUrl : String?
    public init(session: NIMSession, anchor: NIMMessage?) {
        super.init(session: session)
        viewmodel = ChatViewModel(session: session, anchor: anchor)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        //右边的更多
        navigationView.setMoreButtonImage(UIImage.ne_imageNamed(name: "chat_more"))
    }

    override open func getSessionInfo(session: NIMSession) {
        var showName = session.sessionId
        ChatUserCache.getUserInfo(session.sessionId) { [weak self] user, error in
            if let name = user?.showName() {
                showName = name
            }
            self?.title = showName;
            self?.titleContent = showName
            self?.userID = user?.userId
            //系统通知类型
            if self?.isSystemUser == true {
                self?.titleBarView.isHidden = true
                self?.navigationView.navTitle.textColor = UIColor.black
                self?.chatInputView.isHidden = true
                self?.navigationView.moreButton.isHidden = true
            } else {
                self?.navigationView.moreButton.isHidden = false
                self?.chatInputView.isHidden = false
                self?.chatInputView.textView.placeholder = "请输入想说的话..."
                self?.chatInputView.textView.setNeedsLayout()
                if NEKitChatConfig.shared.kAppType == 1 {//A面显示昵称
                    self?.navigationView.navTitle.textColor = UIColor.black
                    self?.titleBarView.isHidden = true
                } else {
                    self?.navigationView.navTitle.textColor = UIColor.clear
                    if self?.isOpenHiding == true {
                        self?.titleBarView.isHidden = true
                    } else {
                        self?.titleBarView.isHidden = false
                    }
                    if let avatarUrl = user?.userInfo?.avatarUrl {
                        self?.leftHeader.sd_setImage(with: URL(string: NEKitChatConfig.shared.imageURL + avatarUrl), completed: nil)
                    }
                    if let myavatarUrl = self?.myAvatarUrl {
                        self?.rightHeader.sd_setImage(with: URL(string: NEKitChatConfig.shared.imageURL + myavatarUrl), completed: nil)
                    }
                }
            }
        }
    }
    
    /// 创建个人聊天页构造方法
    /// - Parameter sessionId: 会话id
    public init(sessionId: String) {
        let session = NIMSession(sessionId, type: .P2P)
        super.init(session: session)
    }
    
    /// 重写父类的构造方法
    /// - Parameter session: sessionId
    override public init(session: NIMSession) {
        super.init(session: session)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
