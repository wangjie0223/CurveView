//
//  DailyCurveModel.swift
//  ZhongYangQiXiangTai
//
//  Created by 王杰 on 2025/4/14.
//
import UIKit

struct DailyCurveModel {
    /// 日期
    let date: String
    
    /// 白天的天气现象代码，比如用来表示“晴”、“多云”、“小雨”等的字符串编码。
    let dayWeatherCode: String
    
    /// 夜间的天气现象代码，比如用来表示“晴”、“多云”、“小雨”等的字符串编码。
    let nightWeatherCode: String
    
    /// 白天气温
    let dayTemp: CGFloat
    
    /// 夜间气温
    let nightTemp: CGFloat
    
    /// windDirection 风向，文字描述风从哪个方向吹来，例如“东北风”“西风”。
    let wd: String
    
    /// windForce 风力，表示风的等级，例如3级、5级，不是风速，常用于描述风的强度等级。
    let wf: String
    
    /// airQualityIndex 空气质量指数，是一个数值型指标，用来综合评估空气污染程度。一般范围为 0~500，数值越大，污染越严重。
    let aqi: Int
        
}


extension Int {
    /// 空气质量数值转汉字
    var airQuality2Chinese: String? {
        switch self {
        case ...50: return "优"
        case 51...100: return "良"
        case 101...150: return "轻度污染"
        case 151...200: return "中度污染"
        case 201...300: return "重度污染"
        case 301...: return "重度污染"
        default: return nil
        }
    }
    
}


extension String {
    
    /// 将 "yyyy-MM-dd" 格式的字符串转换为友好的星期描述：
    /// - 如果是今天，返回 "今天"
    /// - 如果是明天，返回 "明天"
    /// - 其他返回 "周一"、"周二" 等
    ///
    /// 示例：
    /// ```
    /// let dateString = "2025-04-15"
    /// print(dateString.friendlyWeekdayDescription ?? "无效日期")
    /// // 可能输出：周二
    /// ```
    var friendlyWeekdayDescription: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.timeZone = TimeZone.current

        guard let targetDate = formatter.date(from: self) else { return nil }

        let calendar = Calendar.current
        let today = Date()

        if calendar.isDate(targetDate, inSameDayAs: today) {
            return "今天"
        }

        if let tomorrow = calendar.date(byAdding: .day, value: 1, to: today),
           calendar.isDate(targetDate, inSameDayAs: tomorrow) {
            return "明天"
        }

        let weekday = calendar.component(.weekday, from: targetDate) // 星期日=1
        let weekdays = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
        return weekdays[weekday - 1]
    }
    
    
    
    /// 将 "yyyy-MM-dd" 字符串截取为 "MM/dd" 格式
    ///
    /// 示例：
    /// ```
    /// let dateString = "2025-04-14"
    /// print(dateString.toMonthDayBySubstring) // 输出: 04/14
    /// ```
    var toMonthDayBySubstring: String {
        guard self.count >= 10 else { return self } // 简单校验长度
        let start = self.index(self.startIndex, offsetBy: 5)
        let end = self.index(self.startIndex, offsetBy: 10)
        let monthDay = self[start..<end]
        return monthDay.replacingOccurrences(of: "-", with: "/")
    }
    
    /// 转UIImage 白天
    func serverWeatherDayImage() -> UIImage? {
        let code = Int(Double(self) ?? 0.0)
        
        let weatherImages: [Int: UIImage] = [
            0: .day00晴,
            1: .day01多云,
            2: .day02阴,
            3: .day03阵雨,
            4: .day04雷阵雨,
            5: .day05雨夹冰雹,
            6: .day06雨夹雪,
            7: .day07小雨,
            8: .day08中雨,
            9: .day09大雨,
            10: .day10暴雨,
            11: .day11大暴雨,
            12: .day11大暴雨,// ⚠️这里没找到图片,使用 大暴雨 的图
            13: .day13阵雪,
            14: .day14小雪,
            15: .day15中雪,
            16: .day16大雪,
            17: .day17暴雪,
            18: .day18雾,
            19: .day19冻雨,
            20: .day20沙尘暴,
            
            29: .day29浮尘,
            30: .day30扬沙,
            31: .day31强沙尘暴,
            
            53: .day53霾,
        ]
        
        return weatherImages[code]
    }
    
    /// 转UIImage 夜间
    func serverWeatherNightImage() -> UIImage? {
        let code = Int(Double(self) ?? 0.0)
        
        let weatherImages: [Int: UIImage] = [
            0: .night00晴,
            1: .night01多云,
            2: .day02阴,// ⚠️这里没找到图片,使用 day02阴 的图
            3: .night03阵雨,
            4: .day04雷阵雨,
            5: .day05雨夹冰雹,
            6: .day06雨夹雪,
            7: .day07小雨,
            8: .day08中雨,
            9: .day09大雨,
            10: .day10暴雨,
            11: .day11大暴雨,
            12: .day11大暴雨,// ⚠️这里没找到图片,使用 大暴雨 的图
            13: .night13阵雪,
            14: .day14小雪,
            15: .day15中雪,
            16: .day16大雪,
            17: .day17暴雪,
            18: .day18雾,
            19: .day19冻雨,
            20: .day20沙尘暴,
            
            29: .day29浮尘,
            30: .day30扬沙,
            31: .day31强沙尘暴,
            
            53: .day53霾,
        ]
        
        return weatherImages[code]
    }
    
    /// 服务器返回字段转汉字
    func serverWeather2Chinese() -> String {
        
        let doubleV = Double(self)
        
        switch doubleV {
        case 0.0: return "晴"
        case 1.0: return "多云"
        case 2.0: return "阴"
        case 3.0: return "阵雨"
        case 4.0: return "雷阵雨"
        case 5.0: return "雨夹冰雹"
        case 6.0: return "雨夹雪"
        case 7.0: return "小雨"
        case 8.0: return "中雨"
        case 9.0: return "大雨"
        case 10.0: return "暴雨"
        case 11.0: return "大暴雨"
        case 12.0: return "特大暴雨"
        case 13.0: return "阵雪"
        case 14.0: return "小雪"
        case 15.0: return "中雪"
        case 16.0: return "大雪"
        case 17.0: return "暴雪"
        case 18.0: return "雾"
        case 19.0: return "冻雨"
        case 20.0: return "沙尘暴"
        case 21.0: return "小雨-中雨"
        case 22.0: return "中雨-大雨"
        case 23.0: return "大雨-暴雨"
        case 24.0: return "暴雨-大暴雨"
        case 25.0: return "大暴雨-特大暴雨"
        case 26.0: return "小雪-中雪"
        case 27.0: return "中雪-大雪"
        case 28.0: return "大雪-暴雪"
        case 29.0: return "浮尘"
        case 30.0: return "扬沙"
        case 31.0: return "强沙尘暴"
        case 32.0: return "浓雾"
        case 33.0: return "雪"
        
        case 49.0: return "强浓雾"

        case 53.0: return "霾"
        case 54.0: return "中度霾"
        case 55.0: return "重度霾"
        case 56.0: return "严重霾"
        case 57.0: return "大雾"
        case 58.0: return "特强浓雾"
            
        case 1290.0: return "雷暴"

        default: return "晴"
        }
    }
    
}
