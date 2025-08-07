
// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import UIKit

@objcMembers
open class NEInputMoreCell: UICollectionViewCell {
    public var cellData: NEMoreItemModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupViews() {
        contentView.addSubview(avatarImage)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            avatarImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImage.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 4),
            avatarImage.widthAnchor.constraint(equalToConstant: 40),
            avatarImage.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 4),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 27),
        ])
    }
    
    lazy var avatarImage: UIButton = {
        let imageView = UIButton()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = false
        imageView.adjustsImageWhenHighlighted = false
        imageView.accessibilityIdentifier = "id.actionIcon"
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = UIColor(hexString: "#666666")
        title.font = UIFont.systemFont(ofSize: 13)
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        title.accessibilityIdentifier = "id.menuIcon"
        return title
    }()
    
    func config(_ itemModel: NEMoreItemModel) {
        cellData = itemModel
        avatarImage.setImage(itemModel.customImage == nil ? itemModel.image : itemModel.customImage, for: .normal)
        avatarImage.setImage(itemModel.selImage, for: .selected)
        avatarImage.isSelected = itemModel.isSelect
        titleLabel.text = itemModel.title
    }
    
    /// 获取大小
    /// - Returns: 返回单元大小
    public static func getSize() -> CGSize {
        return CGSize(width: (kScreenWidth-10)/4, height: 72)
    }
}
