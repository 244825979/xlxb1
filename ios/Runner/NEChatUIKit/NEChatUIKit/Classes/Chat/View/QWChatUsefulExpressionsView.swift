//
//  QWChatUsefulExpressionsView.swift
//  NEChatUIKit
//
//  Created by 心聊想伴 on 2024/11/4.
//

import UIKit

open class UsefulExpressionsModel {
    public var id: NSInteger = 0
    public var word: String = ""
    public var gender: NSInteger = 0
    public var status: NSInteger = 0
    public var user_id: String = ""
    public var create_time_text: String = ""
    public var update_time_text: String = ""
    public var is_system: NSInteger = 0
    
    public init(_ dict: [String:Any]) {
        
        let id = dict["id"] as? NSInteger ?? 0
        let word = dict["word"] as? String ?? ""
        let gender = dict["gender"] as? NSInteger ?? 0
        let status = dict["status"] as? NSInteger ?? 0
        let user_id = dict["user_id"] as? String ?? ""
        let create_time_text = dict["create_time_text"] as? String ?? ""
        let update_time_text = dict["update_time_text"] as? String ?? ""
        let is_system  = dict["is_system"] as? NSInteger ?? 0
        
        self.id = id
        self.word = word
        self.gender = gender
        self.status = status
        self.user_id = user_id
        self.create_time_text = create_time_text
        self.update_time_text = update_time_text
        self.is_system = is_system
    }
}

open class QWChatUsefulExpressionsView: UIView {
    var clikeBackBlock: ((String)->())?
    
    public lazy var collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        flow.minimumLineSpacing = 0
        flow.minimumInteritemSpacing = 12//行间距
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flow)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    public var titles: [[String: Any]?] = [] {//常用语
        didSet {
            collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonUI() {
        addSubview(collectionView)
        collectionView.frame = CGRect(x: 16, y: 10, width: kScreenWidth - 16, height: 28)
        
        collectionView.register(
            UsefulExpressionsCell.self,
            forCellWithReuseIdentifier: "\(UsefulExpressionsCell.self)"
        )
    }
}

extension QWChatUsefulExpressionsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        titles.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "\(UsefulExpressionsCell.self)",
            for: indexPath
        ) as? UsefulExpressionsCell {
            let item = titles[indexPath.row]
            if let dict = item {
                let model = UsefulExpressionsModel(dict)
                cell.textLabel.text = model.word
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = titles[indexPath.row]
        if let dict = item {
            let model = UsefulExpressionsModel(dict)
            let width = self.getWidth(string: model.word, height: 28, font: NEConstant.defaultTextFont(12.0))
            return CGSize(width: width + 20, height: 28)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    //MARK: UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath) {
        
        let item = titles[indexPath.row]
        if let dict = item {
            let model = UsefulExpressionsModel(dict)
            clikeBackBlock?(model.word)
        }
    }
    
    //计算文本宽度
    func getWidth(string: String, height: CGFloat, font: UIFont, lineSpacing: CGFloat = 0) -> CGFloat {
        let attStr = NSMutableAttributedString(string: string)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        attStr.addAttributes([NSAttributedString.Key.font : font, NSAttributedString.Key.paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: attStr.length))
        let width = attStr.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: [.usesLineFragmentOrigin], context: nil).size.width
        
        return ceil(width)
    }
}

public class UsefulExpressionsCell: UICollectionViewCell {
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = NEConstant.defaultTextFont(12.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.backgroundColor = UIColor.white
        label.clipsToBounds = true
        label.layer.cornerRadius = 14.0
        return label
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupUI() {
        contentView.addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            textLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            textLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            textLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
        ])
    }
}
