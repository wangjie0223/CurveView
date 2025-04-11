//
//  CurveView.swift
//  ZhongYangQiXiangTai
//
//  Created by 王杰 on 2025/4/10.
//

class CurveView: UIView {
    var xSpacing: CGFloat = 60.0  // 固定的 x 轴间距

    // MARK: - 数据属性

    /// 白天温度数据（或其他指标），代表 y 轴值
    var temperatureValues: [CGFloat] = [] {
        didSet { setNeedsDisplay() }
    }
    
    /// 夜间温度数据
    var nightTemperatureValues: [CGFloat] = [] {
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
    override func draw(_ rect: CGRect) {
        // 两组数据都可能为空，此处只需当两者都为空时才不绘制
        if temperatureValues.isEmpty && nightTemperatureValues.isEmpty { return }
        
        // 1. 根据温度数据生成原始点数组，x 值按固定间距计算
        let dayRawPoints = temperatureValues.enumerated().map { (index, value) -> CGPoint in
            CGPoint(x: CGFloat(index) * xSpacing, y: value)
        }
        let nightRawPoints = nightTemperatureValues.enumerated().map { (index, value) -> CGPoint in
            CGPoint(x: CGFloat(index) * xSpacing, y: value)
        }
        
        // 2. 计算全局（白天和夜间）最低温和最高温
        var globalMin: CGFloat = .greatestFiniteMagnitude
        var globalMax: CGFloat = -.greatestFiniteMagnitude
        
        if let minDay = temperatureValues.min() {
            globalMin = min(globalMin, minDay)
        }
        if let maxDay = temperatureValues.max() {
            globalMax = max(globalMax, maxDay)
        }
        if let minNight = nightTemperatureValues.min() {
            globalMin = min(globalMin, minNight)
        }
        if let maxNight = nightTemperatureValues.max() {
            globalMax = max(globalMax, maxNight)
        }
        // 如果所有数据都相等，为避免除 0，可对 max 做一个微小偏移
        if globalMin == globalMax {
            globalMax += 1
        }
        
        // 3. 缩放点数组（y 值统一映射到视图高度，x 值依旧固定间距）
        let dayScaledPoints = scalePoints(dayRawPoints, toFit: rect, minValue: globalMin, maxValue: globalMax)
        let nightScaledPoints = scalePoints(nightRawPoints, toFit: rect, minValue: globalMin, maxValue: globalMax)
        
        // 4. 使用单调三次 Hermite 插值生成平滑曲线路径，并绘制各自曲线与数据点
        
        // 绘制白天曲线
        if dayScaledPoints.count > 1 {
            let dayPath = monotoneCubicPath(from: dayScaledPoints)
            curveColor.setStroke()
            dayPath.lineWidth = lineWidth
            dayPath.stroke()
            
            // 绘制白天数据点
            for point in dayScaledPoints {
                let circleRect = CGRect(x: point.x - pointRadius,
                                        y: point.y - pointRadius,
                                        width: pointRadius * 2,
                                        height: pointRadius * 2)
                let circlePath = UIBezierPath(ovalIn: circleRect)
                pointFillColor.setFill()
                pointStrokeColor.setStroke()
                circlePath.lineWidth = pointLineWidth
                circlePath.fill()
                circlePath.stroke()
            }
        }
        
        // 绘制夜间曲线
        if nightScaledPoints.count > 1 {
            let nightPath = monotoneCubicPath(from: nightScaledPoints)
            nightCurveColor.setStroke()
            nightPath.lineWidth = lineWidth
            nightPath.stroke()
            
            // 绘制夜间数据点
            for point in nightScaledPoints {
                let circleRect = CGRect(x: point.x - pointRadius,
                                        y: point.y - pointRadius,
                                        width: pointRadius * 2,
                                        height: pointRadius * 2)
                let circlePath = UIBezierPath(ovalIn: circleRect)
                nightPointFillColor.setFill()
                nightPointStrokeColor.setStroke()
                circlePath.lineWidth = nightPointLineWidth
                circlePath.fill()
                circlePath.stroke()
            }
        }
    }
    
    // MARK: - 坐标缩放
    /// 将传入的点数组，按照给定的全局最小值和最大值，将 y 值等比缩放以适配 rect 高度，x 值保持固定
    private func scalePoints(_ points: [CGPoint], toFit rect: CGRect, minValue: CGFloat, maxValue: CGFloat) -> [CGPoint] {
        guard maxValue > minValue else { return points }
        let yScaleFactor = rect.height / (maxValue - minValue)
        return points.map { point in
            // 保持 x 值不变
            let y = rect.height - (point.y - minValue) * yScaleFactor
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
        
        // 计算每段区间长度及其斜率
        for i in 0..<n - 1 {
            let dx = points[i + 1].x - points[i].x
            let dy = points[i + 1].y - points[i].y
            h.append(dx)
            delta.append(dy / dx)
        }
        
        var m = [CGFloat](repeating: 0, count: n)
        m[0] = delta[0]
        m[n - 1] = delta[n - 2]
        
        // 计算各数据点处的导数
        for i in 1..<n - 1 {
            if delta[i - 1] * delta[i] <= 0 {
                m[i] = 0
            } else {
                let w1 = 2 * h[i] + h[i - 1]
                let w2 = h[i] + 2 * h[i - 1]
                m[i] = (w1 + w2) / ((w1 / delta[i - 1]) + (w2 / delta[i]))
            }
        }
        
        // 根据导数计算贝塞尔曲线的控制点，并添加曲线段
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
