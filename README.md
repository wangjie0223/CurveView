

# 🌤 DailyWeatherCurve

一个用于 iOS 的天气趋势曲线视图组件，支持白天/夜间温度、天气图标、风向风力、空气质量等要素展示，适用于天气类 App 的数据可视化。

## ✨ 特性 Highlights

- ✅ **纯 UIKit 实现**
  - 无第三方库依赖，完全基于 `UIView`、`UIScrollView`、`CGContext`、`UIBezierPath` 等系统组件绘制。

- 📊 **支持双曲线展示**
  - 白天与夜间温度分别绘制，支持定制颜色、线宽、圆点样式。

- 🧮 **温度自动缩放**
  - 自动计算数据中的最大值和最小值，动态适配绘图区域，避免坐标重叠。

- 🧵 **平滑曲线插值**
  - 使用 **单调三次 Hermite 插值算法**（Monotone Cubic Hermite Interpolation），生成自然平滑曲线，避免波动异常。

- 🌀 **可横向滚动**
  - `ScrollableCurveView` 支持任意长度数据，通过横向滚动自动适配。

- 🌈 **天气图标 & 中文描述自动映射**
  - 支持天气现象代码（如 "1"）转为图标和文字（如 "多云"），适配白天/夜间模式。

- 🗓 **日期扩展支持**
  - 日期字符串支持：
    - `"2025-04-15"` → `"周二"` / `"今天"` / `"明天"`
    - `"2025-04-15"` → `"04/15"`

- 🧾 **空气质量等级转换**
  - AQI 数值转等级文字（优 / 良 / 轻度污染 / …），方便展示。

## 📦 组件结构

| 类名                  | 功能说明                                 |
|-----------------------|------------------------------------------|
| `DailyCurveModel`     | 每日天气数据模型                         |
| `DailyCurveView`      | 核心视图，绘制白天/夜间曲线和图文内容   |
| `ScrollableCurveView` | 封装 `UIScrollView`，支持横向滚动       |

## 🛠 适用场景

- 天气类 App 的日趋势曲线展示
- 图文混合型自定义绘图需求
- iOS 绘图、坐标缩放、曲线插值教学项目

## 🖼 图标命名约定（可扩展）

- 白天图标资源命名：`.day00晴`, `.day01多云`, ...
- 夜间图标资源命名：`.night00晴`, `.night01多云`, ...

## 🔧 待扩展方向

- 支持长按/点击提示详情
- 动画绘制曲线
- 支持多种单位及样式切换

---
<img width="419" alt="image" src="https://github.com/user-attachments/assets/6698c34e-46bc-4e7c-8976-cf4c2b09447c" />


📌 欢迎 Star / Fork / Issues 提建议 🙌
