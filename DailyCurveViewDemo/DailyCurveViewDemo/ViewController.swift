//
//  ViewController.swift
//  DailyCurveViewDemo
//
//  Created by 王杰 on 2025/4/14.
//
let SCREEN_WIDTH = UIScreen.main.bounds.size.width

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let sampleData: [DailyCurveModel] = [
            .init(date: "2025-04-01", dayWeatherCode: "00", nightWeatherCode: "01", dayTemp: 22, nightTemp: 12, wd: "东北风", wf: "3级", aqi: 48),
            .init(date: "2025-04-02", dayWeatherCode: "01", nightWeatherCode: "02", dayTemp: 24, nightTemp: 14, wd: "东风", wf: "2级", aqi: 52),
            .init(date: "2025-04-03", dayWeatherCode: "03", nightWeatherCode: "03", dayTemp: 19, nightTemp: 11, wd: "东南风", wf: "4级", aqi: 66),
            .init(date: "2025-04-04", dayWeatherCode: "02", nightWeatherCode: "00", dayTemp: 26, nightTemp: 15, wd: "南风", wf: "3级", aqi: 71),
            .init(date: "2025-04-05", dayWeatherCode: "04", nightWeatherCode: "07", dayTemp: 21, nightTemp: 16, wd: "西南风", wf: "5级", aqi: 95),
            .init(date: "2025-04-06", dayWeatherCode: "08", nightWeatherCode: "09", dayTemp: 18, nightTemp: 13, wd: "西风", wf: "2级", aqi: 88),
            .init(date: "2025-04-07", dayWeatherCode: "10", nightWeatherCode: "10", dayTemp: 20, nightTemp: 17, wd: "西北风", wf: "4级", aqi: 123),
            .init(date: "2025-04-08", dayWeatherCode: "00", nightWeatherCode: "01", dayTemp: 27, nightTemp: 19, wd: "北风", wf: "2级", aqi: 39),
            .init(date: "2025-04-09", dayWeatherCode: "01", nightWeatherCode: "02", dayTemp: 25, nightTemp: 16, wd: "东北风", wf: "3级", aqi: 58),
            .init(date: "2025-04-10", dayWeatherCode: "05", nightWeatherCode: "05", dayTemp: 22, nightTemp: 12, wd: "东风", wf: "4级", aqi: 104),
            .init(date: "2025-04-11", dayWeatherCode: "06", nightWeatherCode: "06", dayTemp: 17, nightTemp: 9, wd: "东南风", wf: "5级", aqi: 140),
            .init(date: "2025-04-12", dayWeatherCode: "07", nightWeatherCode: "08", dayTemp: 16, nightTemp: 8, wd: "南风", wf: "3级", aqi: 78),
            .init(date: "2025-04-13", dayWeatherCode: "00", nightWeatherCode: "00", dayTemp: 28, nightTemp: 20, wd: "西南风", wf: "1级", aqi: 32),
            .init(date: "2025-04-14", dayWeatherCode: "01", nightWeatherCode: "01", dayTemp: 26, nightTemp: 18, wd: "西风", wf: "2级", aqi: 42),
            .init(date: "2025-04-15", dayWeatherCode: "02", nightWeatherCode: "02", dayTemp: 23, nightTemp: 15, wd: "西北风", wf: "3级", aqi: 67),
            .init(date: "2025-04-16", dayWeatherCode: "03", nightWeatherCode: "04", dayTemp: 19, nightTemp: 13, wd: "北风", wf: "4级", aqi: 80),
            .init(date: "2025-04-17", dayWeatherCode: "04", nightWeatherCode: "07", dayTemp: 20, nightTemp: 14, wd: "东北风", wf: "2级", aqi: 98),
            .init(date: "2025-04-18", dayWeatherCode: "09", nightWeatherCode: "10", dayTemp: 18, nightTemp: 12, wd: "东风", wf: "3级", aqi: 109),
            .init(date: "2025-04-19", dayWeatherCode: "11", nightWeatherCode: "11", dayTemp: 16, nightTemp: 10, wd: "东南风", wf: "4级", aqi: 122),
            .init(date: "2025-04-20", dayWeatherCode: "00", nightWeatherCode: "00", dayTemp: 29, nightTemp: 21, wd: "南风", wf: "2级", aqi: 45),
            .init(date: "2025-04-21", dayWeatherCode: "01", nightWeatherCode: "01", dayTemp: 26, nightTemp: 18, wd: "西南风", wf: "1级", aqi: 50),
            .init(date: "2025-04-22", dayWeatherCode: "06", nightWeatherCode: "06", dayTemp: 15, nightTemp: 7, wd: "西风", wf: "5级", aqi: 130),
            .init(date: "2025-04-23", dayWeatherCode: "05", nightWeatherCode: "05", dayTemp: 20, nightTemp: 12, wd: "西北风", wf: "4级", aqi: 118),
            .init(date: "2025-04-24", dayWeatherCode: "07", nightWeatherCode: "08", dayTemp: 18, nightTemp: 10, wd: "北风", wf: "3级", aqi: 93),
            .init(date: "2025-04-25", dayWeatherCode: "02", nightWeatherCode: "01", dayTemp: 24, nightTemp: 16, wd: "东北风", wf: "2级", aqi: 60),
            .init(date: "2025-04-26", dayWeatherCode: "01", nightWeatherCode: "02", dayTemp: 25, nightTemp: 17, wd: "东风", wf: "3级", aqi: 54),
            .init(date: "2025-04-27", dayWeatherCode: "00", nightWeatherCode: "00", dayTemp: 27, nightTemp: 20, wd: "东南风", wf: "2级", aqi: 41),
            .init(date: "2025-04-28", dayWeatherCode: "03", nightWeatherCode: "03", dayTemp: 22, nightTemp: 13, wd: "南风", wf: "4级", aqi: 82),
            .init(date: "2025-04-29", dayWeatherCode: "10", nightWeatherCode: "10", dayTemp: 19, nightTemp: 11, wd: "西南风", wf: "5级", aqi: 137),
            .init(date: "2025-04-30", dayWeatherCode: "11", nightWeatherCode: "11", dayTemp: 17, nightTemp: 10, wd: "西风", wf: "3级", aqi: 111)
        ]
        
        
        view.addSubview(curveView)
        curveView.dailyWeatherList = sampleData
    }

    let curveView: ScrollableCurveView = {
        let customV = ScrollableCurveView(frame: CGRect(x: 20, y: 100, width: SCREEN_WIDTH - 40, height: 400))
        customV.backgroundColor = .lightGray
        // 可调整点间距
        customV.xSpacing = 60.0
        return customV
    }()
    
    
    
}

