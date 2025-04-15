//
//  ScrollableCurveView.swift
//  ZhongYangQiXiangTai
//
//  Created by 王杰 on 2025/4/14.
//
import UIKit
import SnapKit

class ScrollableCurveView: UIView {
        
    let curveView: DailyCurveView = {
        let customV = DailyCurveView(frame: .init(x: 0, y: 0, width: 1800, height: 400))
        customV.backgroundColor = .white
        return customV
    }()
    
    
    /// 单个点之间的水平间距（默认 60，可外部修改）
    var xSpacing: CGFloat {
        get { curveView.xSpacing }
        set {
            curveView.xSpacing = newValue
        }
    }
    
    var dailyWeatherList: [DailyCurveModel] = [] {
        didSet {
            curveView.dailyWeatherList = dailyWeatherList
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        
        backgroundColor = .white
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 1
        layer.shadowRadius = 12
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        
        addSubview(myScrollView)
        myScrollView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
        myScrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.height.equalTo(400)
            make.right.equalToSuperview() // 👈 关键点
        }
        
        contentView.addSubview(curveView)
        let contentWidth = (30 - 1) * 60 + 40
        curveView.snp.makeConstraints { make in
            make.left.equalTo(contentView)
            make.top.equalTo(contentView)
            make.height.equalTo(400)
            make.width.equalTo(contentWidth)
            make.right.equalToSuperview()
        }
       
    }
    
    lazy var myScrollView: UIScrollView = {
        let scrollV = UIScrollView()
        scrollV.alwaysBounceHorizontal = true
        scrollV.backgroundColor = .clear
        scrollV.contentInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        return scrollV
    }()
    
    lazy var contentView: UIView = {
        let customV = UIView()
        customV.backgroundColor = .white
        return customV
    }()
 
}
