//
//  DailyCurveView.swift
//  ZhongYangQiXiangTai
//
//  Created by 王杰 on 2025/4/10.
//

import UIKit

class DailyCurveView: UIView {
    var xSpacing: CGFloat = 60.0  // 固定的 x 轴间距

    // MARK: - 数据属性
    var dailyWeatherList: [DailyCurveModel] = [] {
        didSet { setNeedsDisplay() }
    }
    
    // 白天曲线相关
    var curveColor: UIColor = .systemBlue
    /// 夜间曲线颜色
    var nightCurveColor: UIColor = .systemOrange
    /// 曲线线宽（两条曲线共用）
    var lineWidth: CGFloat = 1.5
    
    // 点的属性（白天）
    var pointRadius: CGFloat = 3.0
    /// 白天点内部填充色
    var pointFillColor: UIColor = .white
    /// 白天点描边颜色
    var pointStrokeColor: UIColor = .systemBlue
    /// 白天点描边线宽
    var pointLineWidth: CGFloat = 1.0

    // 夜间点的属性
    var nightPointFillColor: UIColor = .white
    var nightPointStrokeColor: UIColor = .systemOrange
    var nightPointLineWidth: CGFloat = 1.0

    // MARK: - 绘制
    /// 自定义视图绘制方法，绘制白天和夜间的温度曲线、数据点和温度标签
    override func draw(_ rect: CGRect) {
        // 如果数据为空，直接跳过绘制
        guard !dailyWeatherList.isEmpty else { return }

        // 定义左右和上下的绘图边距，确保图形不贴边
        let margin: CGFloat = 50
        
        let effectiveRect = CGRect(x: rect.origin.x + margin,
                                   y: rect.origin.y + 150,
                                   width: rect.width - margin * 2.0,
                                   height: 100)  // 只在视图中间 100 高度区域绘制
        
        // ✅ 可视化绘图区域（调试用，红色半透明背景）
        let debugPath = UIBezierPath(rect: effectiveRect)
        UIColor.red.withAlphaComponent(0.1).setFill()
        debugPath.fill()
        
        
        // 获取当前绘图上下文
        let context = UIGraphicsGetCurrentContext()!

        // 生成白天原始点，x 根据间距偏移，y 是原始温度值（未缩放）
        
        
        let dayRawPoints = dailyWeatherList.enumerated().map {
            CGPoint(x: CGFloat($0.offset) * xSpacing + margin, y: $0.element.dayTemp)
        }
    
        // 生成夜间原始点
        let nightRawPoints = dailyWeatherList.enumerated().map {
            CGPoint(x: CGFloat($0.offset) * xSpacing + margin, y: $0.element.nightTemp)
        }

        // 合并所有数据，便于计算统一的最小值和最大值（用于 y 轴缩放）
        let allValues = dailyWeatherList.flatMap { [$0.dayTemp, $0.nightTemp] }
        
        let minValue = allValues.min() ?? 0
        var maxValue = allValues.max() ?? 1

        // 如果所有温度相同，避免除以 0，手动调整最大值
        if minValue == maxValue { maxValue += 1 }

        
        let temperatureValues = dailyWeatherList.map { item in
            item.dayTemp
        }
        
        
        // 绘制白天气温曲线 + 数据点 + 温度文字（文字显示在点上方）
        drawCurveAndPointsAndLabels(
            context: context,
            values: temperatureValues,
            rawPoints: dayRawPoints,
            effectiveRect: effectiveRect,
            minValue: minValue,
            maxValue: maxValue,
            curveColor: curveColor,
            pointFillColor: pointFillColor,
            pointStrokeColor: pointStrokeColor,
            pointLineWidth: pointLineWidth,
            textAbove: true
        )

        
        
        // 绘制夜间气温曲线 + 数据点 + 温度文字（文字显示在点下方）
        let nightTemperatureValues = dailyWeatherList.map { item in
            item.nightTemp
        }
        drawCurveAndPointsAndLabels(
            context: context,
            values: nightTemperatureValues,
            rawPoints: nightRawPoints,
            effectiveRect: effectiveRect,
            minValue: minValue,
            maxValue: maxValue,
            curveColor: nightCurveColor,
            pointFillColor: nightPointFillColor,
            pointStrokeColor: nightPointStrokeColor,
            pointLineWidth: nightPointLineWidth,
            textAbove: false
        )
        
        let weekTextY = 22.0 // 固定在绘图区域顶部
        
      
        let weekTextAttributes = makeTextAttributes(fontSize: 14, color: .colorDarkGray)
        let dateAttributes = makeTextAttributes(fontSize: 12, color: .color102)
        let dayWeatherAttributes = makeTextAttributes(fontSize: 14, color: .colorDarkGray)
        let nightWeatherAttributes = makeTextAttributes(fontSize: 14, color: .colorDarkGray)
        let wdAttributes = makeTextAttributes(fontSize: 12, color: .color102)
        let wfAttributes = makeTextAttributes(fontSize: 12, color: .color102)

        // 布局常量（统一控制）
        let iconSize: CGFloat = 26
        
        for (index, point) in dayRawPoints.enumerated() {
            let item = dailyWeatherList[index]
            let centerX = point.x

            // 星期
            var lastFrame = drawText(item.date.friendlyWeekdayDescription ?? "", centerX: centerX, topY: weekTextY, attributes: weekTextAttributes)

            // 日期
            lastFrame = drawText(item.date.toMonthDayBySubstring, centerX: centerX, topY: lastFrame.maxY + 4, attributes: dateAttributes)

            // 白天天气图标
            lastFrame = drawIcon(item.dayWeatherCode.serverWeatherDayImage() ?? UIImage(), centerX: centerX, topY: lastFrame.maxY + 7, size: iconSize)

            // 白天文字
            lastFrame = drawText(item.dayWeatherCode.serverWeather2Chinese(), centerX: centerX, topY: lastFrame.maxY + 4, attributes: dayWeatherAttributes)

            // 夜间天气图标（重新起点）
            var nightFrame = drawIcon(item.nightWeatherCode.serverWeatherNightImage() ?? UIImage(), centerX: centerX, topY: effectiveRect.maxY + 20, size: iconSize)

            // 夜间文字
            nightFrame = drawText(item.nightWeatherCode.serverWeather2Chinese(), centerX: centerX, topY: nightFrame.maxY + 6, attributes: nightWeatherAttributes)

            // 风向
            nightFrame = drawText(item.wd, centerX: centerX, topY: nightFrame.maxY + 7, attributes: wdAttributes)

            // 风力
            nightFrame = drawText(item.wf, centerX: centerX, topY: nightFrame.maxY, attributes: wfAttributes)

            // 空气质量
            _ = drawText(item.aqi.airQuality2Chinese ?? "", centerX: centerX, topY: nightFrame.maxY + 4, attributes: weekTextAttributes)
        }
        
    }
    
    func makeTextAttributes(fontSize: CGFloat, color: UIColor) -> [NSAttributedString.Key: Any] {
        return [.font: UIFont.systemFont(ofSize: fontSize, weight: .regular), .foregroundColor: color, .backgroundColor: UIColor.white]
    }
    
    
    @discardableResult
    func drawText(_ text: String, centerX: CGFloat, topY: CGFloat, attributes: [NSAttributedString.Key: Any]) -> CGRect {
        let size = text.size(withAttributes: attributes)
        let origin = CGPoint(x: centerX - size.width / 2, y: topY)
        text.draw(at: origin, withAttributes: attributes)
        return CGRect(origin: origin, size: size)
    }

    @discardableResult
    func drawIcon(_ image: UIImage, centerX: CGFloat, topY: CGFloat, size: CGFloat) -> CGRect {
        let rect = CGRect(x: centerX - size / 2, y: topY, width: size, height: size)
        image.draw(in: rect)
        return rect
    }
    
    /// 在一条曲线上绘制平滑曲线、圆点和对应文字标签
    ///
    /// - Parameters:
    ///   - context: 当前图形上下文，用于绘图
    ///   - values: 原始数据值（用于生成文字标签）
    ///   - rawPoints: 原始点坐标（x 正常，y 为原始值）
    ///   - effectiveRect: 可绘图区域，用于缩放点
    ///   - minValue: 全部数据中的最小值
    ///   - maxValue: 全部数据中的最大值
    ///   - curveColor: 曲线颜色
    ///   - pointFillColor: 数据点内部填充颜色
    ///   - pointStrokeColor: 数据点描边颜色
    ///   - pointLineWidth: 数据点描边线宽
    ///   - textAbove: 是否将文字绘制在点上方，false 表示绘制在下方
    private func drawCurveAndPointsAndLabels(
        context: CGContext,
        values: [CGFloat],
        rawPoints: [CGPoint],
        effectiveRect: CGRect,
        minValue: CGFloat,
        maxValue: CGFloat,
        curveColor: UIColor,
        pointFillColor: UIColor,
        pointStrokeColor: UIColor,
        pointLineWidth: CGFloat,
        textAbove: Bool
    ) {
        // 将原始点缩放到绘图区域内
        let points = scalePoints(rawPoints, toFit: effectiveRect, minValue: minValue, maxValue: maxValue)
        guard points.count > 1 else { return }

        // 绘制平滑曲线
        let path = monotoneCubicPath(from: points)
        curveColor.setStroke()
        path.lineWidth = lineWidth
        path.stroke()

        // 配置文字样式
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: UIColor.black
        ]

        // 绘制每个数据点及其对应文字
        for (index, point) in points.enumerated() {
            guard index < values.count else { continue }

            // 1. 绘制圆点
            let circleRect = CGRect(
                x: point.x - pointRadius,
                y: point.y - pointRadius,
                width: pointRadius * 2,
                height: pointRadius * 2
            )
            let circlePath = UIBezierPath(ovalIn: circleRect)
            pointFillColor.setFill()
            pointStrokeColor.setStroke()
            circlePath.lineWidth = pointLineWidth
            circlePath.fill()
            circlePath.stroke()

            // 2. 绘制温度文字
            let text = "\(values[index])°"
            let textSize = text.size(withAttributes: textAttributes)
            let textX = point.x - textSize.width / 2
            let textY = textAbove
                ? point.y - pointRadius - textSize.height - 2
                : point.y + pointRadius + 2
            let textPoint = CGPoint(x: textX, y: textY)
            text.draw(at: textPoint, withAttributes: textAttributes)
        }
    }
    
    
    // MARK: - 坐标缩放
    /// 将传入的点数组，按照给定全局最小和最大值，将 y 值等比缩放以适配传入 rect（有效绘图区域）的高度，x 值保持不变
    private func scalePoints(_ points: [CGPoint], toFit rect: CGRect, minValue: CGFloat, maxValue: CGFloat) -> [CGPoint] {
        guard maxValue > minValue else { return points }
        let yScaleFactor = rect.height / (maxValue - minValue)
        return points.map { point in
            let y = rect.origin.y + rect.height - (point.y - minValue) * yScaleFactor
            return CGPoint(x: point.x, y: y)
        }
    }
    
    // MARK: - 单调三次 Hermite 插值生成曲线路径
    private func monotoneCubicPath(from points: [CGPoint]) -> UIBezierPath {
        let path = UIBezierPath()
        if points.count < 2 { return path }
        
        path.move(to: points[0])
        let n = points.count
        var h = [CGFloat]()
        var delta = [CGFloat]()
        
        for i in 0..<n - 1 {
            let dx = points[i + 1].x - points[i].x
            let dy = points[i + 1].y - points[i].y
            h.append(dx)
            delta.append(dy / dx)
        }
        
        var m = [CGFloat](repeating: 0, count: n)
        m[0] = delta[0]
        m[n - 1] = delta[n - 2]
        
        for i in 1..<n - 1 {
            if delta[i - 1] * delta[i] <= 0 {
                m[i] = 0
            } else {
                let w1 = 2 * h[i] + h[i - 1]
                let w2 = h[i] + 2 * h[i - 1]
                m[i] = (w1 + w2) / ((w1 / delta[i - 1]) + (w2 / delta[i]))
            }
        }
        
        for i in 0..<n - 1 {
            let p0 = points[i]
            let p1 = points[i + 1]
            let dx = p1.x - p0.x
            let cp1 = CGPoint(x: p0.x + dx / 3, y: p0.y + m[i] * dx / 3)
            let cp2 = CGPoint(x: p1.x - dx / 3, y: p1.y - m[i + 1] * dx / 3)
            path.addCurve(to: p1, controlPoint1: cp1, controlPoint2: cp2)
        }
        return path
    }
}



