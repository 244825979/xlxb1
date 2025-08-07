
// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NECommonUIKit
import NECoreKit
import UIKit

@objcMembers
open class ChatBaseViewController: UIViewController, UIGestureRecognizerDelegate {
    var topConstant: CGFloat = 0
    public var isSystemUser = false//判断是否是系统用户
    public var myUserID : String = ""//记录一下自己的用户ID
    public var userID : String?//记录一下用户ID
    public var nickName : String = ""//昵称
    //是否开启对对方隐身
    public lazy var isOpenHiding: Bool = false {
        didSet {
            if self.isSystemUser == false && NEKitChatConfig.shared.kAppType == 0 {
                if isOpenHiding == false {
                    titleBarView.isHidden = false
                    openHidingBarView.isHidden = true
                } else {
                    titleBarView.isHidden = true
                    openHidingBarView.isHidden = false
                }
            } else {
                titleBarView.isHidden = true
                openHidingBarView.isHidden = true
            }
        }
    }
    
    public let navigationView = NENavigationView()
    public let titleBarView = UIView()
    public let intimacyText = UIButton()
    public let leftHeader = UIImageView()
    public let rightHeader = UIImageView()
    
    public let openHidingBarView = UIView()
    public let openHidingIcon = UIImageView()//隐身图标
    public let openHidingText = UILabel()//隐身标题
    override open var title: String? {
        get {
            super.title
        }
        set {
            super.title = newValue
            navigationView.navTitle.text = newValue
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        view.backgroundColor = NEKitChatConfig.shared.ui.messageProperties.chatViewBackground ?? .white
        
        if userID == NEKitChatConfig.shared.xitongxiaoxi_id ||
            userID == NEKitChatConfig.shared.huodongxiaozushou_id ||
            userID == NEKitChatConfig.shared.xiaomishu_id ||
            userID == NEKitChatConfig.shared.kefuzushou_id {
            isSystemUser = true//属于系统用户
        } else {
            isSystemUser = false
        }
        
        if !NEKitChatConfig.shared.ui.messageProperties.showTitleBar {
            navigationController?.isNavigationBarHidden = true
            return
        }
        
        if let useSystemNav = NEConfigManager.instance.getParameter(key: useSystemNav) as? Bool, useSystemNav {
            navigationController?.isNavigationBarHidden = false
            setupBackUI()
            topConstant = NEConstant.navigationAndStatusHeight
        } else {
            navigationController?.isNavigationBarHidden = true
            topConstant = NEConstant.navigationAndStatusHeight
            navigationView.translatesAutoresizingMaskIntoConstraints = false
            navigationView.addBackButtonTarget(target: self, selector: #selector(backEvent))
            navigationView.addMoreButtonTarget(target: self, selector: #selector(toSetting))
            view.addSubview(navigationView)
            NSLayoutConstraint.activate([
                navigationView.leftAnchor.constraint(equalTo: view.leftAnchor),
                navigationView.rightAnchor.constraint(equalTo: view.rightAnchor),
                navigationView.topAnchor.constraint(equalTo: view.topAnchor),
                navigationView.heightAnchor.constraint(equalToConstant: topConstant),
            ])
            
            titleBarView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(titleBarView)
            NSLayoutConstraint.activate([
                titleBarView.leftAnchor.constraint(equalTo: navigationView.leftAnchor, constant: 60),
                titleBarView.rightAnchor.constraint(equalTo: navigationView.rightAnchor, constant: -60),
                titleBarView.bottomAnchor.constraint(equalTo: navigationView.bottomAnchor),
                titleBarView.heightAnchor.constraint(equalToConstant: 44),
            ])
            
            let intimacyIcon = UIButton()
            intimacyIcon.setBackgroundImage(UIImage.ne_imageNamed(name: "chat_intimate"), for: .normal)
            intimacyIcon.adjustsImageWhenHighlighted = false
            intimacyIcon.addTarget(self, action: #selector(intimateEvent), for: .touchUpInside)
            intimacyIcon.translatesAutoresizingMaskIntoConstraints = false
            titleBarView.addSubview(intimacyIcon)
            NSLayoutConstraint.activate([
                intimacyIcon.centerXAnchor.constraint(equalTo: titleBarView.centerXAnchor),
                intimacyIcon.widthAnchor.constraint(equalToConstant: 30),
                intimacyIcon.heightAnchor.constraint(equalToConstant: 30),
                intimacyIcon.topAnchor.constraint(equalTo: titleBarView.topAnchor),
            ])
            
            intimacyText.setTitleColor(UIColor(hexString: "#FD6E6A"), for: .normal)
            intimacyText.titleLabel?.font = NEConstant.defaultTextFont(10)
            intimacyText.addTarget(self, action: #selector(intimateEvent), for: .touchUpInside)
            intimacyText.translatesAutoresizingMaskIntoConstraints = false
            intimacyText.setTitle("0℃", for: .normal)
            titleBarView.addSubview(intimacyText)
            NSLayoutConstraint.activate([
                intimacyText.centerXAnchor.constraint(equalTo: intimacyIcon.centerXAnchor),
                intimacyText.topAnchor.constraint(equalTo: intimacyIcon.bottomAnchor),
                intimacyText.widthAnchor.constraint(greaterThanOrEqualToConstant: 36),
                intimacyText.heightAnchor.constraint(equalToConstant: 15)
            ])
            
            leftHeader.layer.cornerRadius = 17
            leftHeader.layer.masksToBounds = true
            leftHeader.contentMode = .scaleAspectFill
            leftHeader.translatesAutoresizingMaskIntoConstraints = false
            titleBarView.addSubview(leftHeader)
            NSLayoutConstraint.activate([
                leftHeader.centerYAnchor.constraint(equalTo: titleBarView.centerYAnchor),
                leftHeader.rightAnchor.constraint(equalTo: intimacyText.leftAnchor, constant: -7),
                leftHeader.widthAnchor.constraint(equalToConstant: 34),
                leftHeader.heightAnchor.constraint(equalToConstant: 34),
            ])
            
            rightHeader.layer.cornerRadius = 17
            rightHeader.layer.masksToBounds = true
            rightHeader.contentMode = .scaleAspectFill
            rightHeader.translatesAutoresizingMaskIntoConstraints = false
            titleBarView.addSubview(rightHeader)
            NSLayoutConstraint.activate([
                rightHeader.centerYAnchor.constraint(equalTo: titleBarView.centerYAnchor),
                rightHeader.leftAnchor.constraint(equalTo: intimacyText.rightAnchor, constant: 7),
                rightHeader.widthAnchor.constraint(equalToConstant: 34),
                rightHeader.heightAnchor.constraint(equalToConstant: 34),
            ])
            
            openHidingBarView.translatesAutoresizingMaskIntoConstraints = false
            openHidingBarView.isHidden = true
            view.addSubview(openHidingBarView)
            NSLayoutConstraint.activate([
                openHidingBarView.leftAnchor.constraint(equalTo: navigationView.leftAnchor, constant: 60),
                openHidingBarView.rightAnchor.constraint(equalTo: navigationView.rightAnchor, constant: -60),
                openHidingBarView.bottomAnchor.constraint(equalTo: navigationView.bottomAnchor),
                openHidingBarView.heightAnchor.constraint(equalToConstant: 44),
            ])
            
            openHidingText.textColor = UIColor(hexString: "#999999")
            openHidingText.font = NEConstant.defaultTextFont(12)
            openHidingText.translatesAutoresizingMaskIntoConstraints = false
            openHidingText.text = "已对Ta隐身"
            openHidingBarView.addSubview(openHidingText)
            NSLayoutConstraint.activate([
                openHidingText.centerXAnchor.constraint(equalTo: openHidingBarView.centerXAnchor, constant: 10),
                openHidingText.centerYAnchor.constraint(equalTo: openHidingBarView.centerYAnchor),
                openHidingText.heightAnchor.constraint(equalToConstant: 18)
            ])
            
            openHidingIcon.image = UIImage.ne_imageNamed(name: "chat_nav_hid")
            openHidingIcon.translatesAutoresizingMaskIntoConstraints = false
            openHidingBarView.addSubview(openHidingIcon)
            NSLayoutConstraint.activate([
                openHidingIcon.rightAnchor.constraint(equalTo: openHidingText.leftAnchor, constant: -4),
                openHidingIcon.widthAnchor.constraint(equalToConstant: 14),
                openHidingIcon.heightAnchor.constraint(equalToConstant: 14),
                openHidingIcon.centerYAnchor.constraint(equalTo: openHidingBarView.centerYAnchor),
            ])
            
            if NEKitChatConfig.shared.kAppType == 1 {//A面显示昵称
                titleBarView.isHidden = true
            } else {
                titleBarView.isHidden = false
            }
        }
    }
    
    private func setupBackUI() {
        let image = UIImage.ne_imageNamed(name: "chat_back")?.withRenderingMode(.alwaysOriginal)
        let backItem = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(backEvent)
        )
        backItem.accessibilityIdentifier = "id.backArrow"
        navigationItem.leftBarButtonItem = backItem
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem()
        navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .ne_darkText
    }
    
    func backEvent() {
        navigationController?.popViewController(animated: true)
    }
    
    func toSetting() {}
    
    open func intimateEvent() {}
}
