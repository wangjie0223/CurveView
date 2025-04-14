//
//  ScrollableCurveView.swift
//  ZhongYangQiXiangTai
//
//  Created by 王杰 on 2025/4/14.
//
import UIKit

class ScrollableCurveView: UIView {
    
    private let scrollView = UIScrollView()
    private let curveView = DailyCurveView()
    
    /// 单个点之间的水平间距（默认 60，可外部修改）
    var xSpacing: CGFloat {
        get { curveView.xSpacing }
        set {
            curveView.xSpacing = newValue
            updateCurveLayout()
        }
    }
    
    var dailyWeatherList: [DailyCurveModel] = [] {
        didSet {
            curveView.dailyWeatherList = dailyWeatherList
            updateCurveLayout()
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
        scrollView.backgroundColor = .lightGray
        curveView.backgroundColor = .clear
        scrollView.alwaysBounceHorizontal = true
        addSubview(scrollView)
        scrollView.addSubview(curveView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
        updateCurveLayout()
    }
    
    private func updateCurveLayout() {
        let margin: CGFloat = 50  // 与 DailyCurveView 内部使用的边距一致
        let maxCount = dailyWeatherList.count
        // 将左右 margin 考虑进内容宽度
        let contentWidth = maxCount > 0 ? CGFloat(maxCount - 1) * xSpacing + 2 * margin : bounds.width
        let minWidth = max(contentWidth, bounds.width)
        curveView.frame = CGRect(x: 0, y: 0, width: minWidth, height: bounds.height)
        scrollView.contentSize = CGSize(width: minWidth, height: bounds.height)
    }
    
}
