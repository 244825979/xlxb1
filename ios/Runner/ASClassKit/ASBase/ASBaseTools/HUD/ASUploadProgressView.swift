//
//  ASUploadProgressView.swift
//  AS
//
//  Created by SA on 2025/4/11.
//

import UIKit
import NECommonUIKit

class ASUploadProgressView: UIView {
    let progressView = ASCircleProgressView()
    lazy var progressBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.alpha = 0.7
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var progressLabel: UILabel = {
        let lable = UILabel()
        lable.text = "0"
        lable.textColor = UIColor.white
        lable.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        lable.textAlignment = .center
        return lable
    }()
    
    lazy var uploadingTitle: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.white
        lable.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        lable.textAlignment = .center
        return lable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        configSubviews()
        configLayoutSubviews()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        configSubviews()
        configLayoutSubviews()
    }
    
    func configSubviews() {
        addSubview(progressBgView)
        progressBgView.addSubview(progressView)
        progressBgView.addSubview(progressLabel)
        progressBgView.addSubview(uploadingTitle)
    }
    
    func configLayoutSubviews() {
        progressBgView.frame = CGRectMake(kScreenWidth/2 - 132/2, kScreenHeight/2 - 150, 132, 132)
        progressView.frame = CGRectMake(132/2 - 50/2, 27, 50, 50)
        progressLabel.frame = CGRectMake(0, 27+15, 132, 20)
        uploadingTitle.frame = CGRectMake(0, 90, 132, 30)
    }
    
    @objc func show(title: String = "正在上传", fromView: UIView?) {
        guard let view = fromView else { return }
        uploadingTitle.text = title
        view.addSubview(self)
        self.frame = CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height)
    }
    
    @objc public func dismiss(){
        self.removeFromSuperview()
    }
    
    @objc func setProgress(progress: Int) {
        progressLabel.text = "\(progress)%"
        progressView.setProgress(progress, animated: true)
    }
    
    @objc func setPhotoProgress(text: String, progress: Int) {
        progressLabel.text = text
        progressView.setProgress(progress, animated: true)
    }

}

//圆型进度
public class ASCircleProgressView: UIView {
    struct Constant {
        static let lineWidth: CGFloat = 2
        static let trackColor = UIColor(named: "#979797")
        static let progressColoar = UIColor.white
    }
    
    let trackLayer = CAShapeLayer()
    let progressLayer = CAShapeLayer()
    let path = UIBezierPath()
    public var progress: Int = 0 {
        didSet {
            if progress > 100 {
                progress = 100
            }else if progress < 0 {
                progress = 0
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override public func draw(_ rect: CGRect) {
        let path = UIBezierPath.init(ovalIn: bounds)
        self.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2);
        //绘制进度槽
        trackLayer.frame = bounds
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = Constant.trackColor?.cgColor
        trackLayer.lineWidth = Constant.lineWidth
        trackLayer.path = path.cgPath
        layer.addSublayer(trackLayer)
        //绘制进度条
        progressLayer.frame = bounds
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = Constant.progressColoar.cgColor
        progressLayer.lineWidth = Constant.lineWidth
        progressLayer.path = path.cgPath
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = CGFloat(progress)/100.0
        layer.addSublayer(progressLayer)
    }
    
   public func  setProgress(_ pro: Int,animated anim: Bool) {
        if progress == pro {return}
        progress = pro
        setProgress(pro, animated: anim, withDuration: 0.55)
    }
    
    public func setProgress(_ progress: Int,animated anim: Bool, withDuration duration: Double) {
        progressLayer.strokeEnd = CGFloat(progress)/100.0
    }
}
