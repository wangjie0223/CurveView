以下是从你提供的完整代码中提炼出的技术点，可作为 GitHub 项目的技术介绍部分：

⸻

🌤 Daily Weather Curve View

一个支持横向滚动、带天气图标和多维指标展示的天气趋势曲线图组件，适用于 iOS 天气类 App，基于 UIKit 和 CoreGraphics 实现。

⸻

📌 技术亮点
	•	🧱 纯 UIKit 实现
	•	无任何第三方依赖，全面使用 UIView、UIScrollView、CGContext 和 UIBezierPath 构建。
	•	📐 高度可定制的可视化组件
	•	支持白天/夜间两条温度曲线独立绘制，颜色、线宽、点样式均可配置。
	•	温度值、星期、日期、天气图标、天气文字、风向、风力、AQI 全部布局绘制。
	•	📊 自定义坐标缩放逻辑
	•	自动计算温度最大值和最小值，Y 轴坐标自适应缩放，高度适配不同数据集。
	•	📈 曲线平滑插值
	•	使用单调三次 Hermite 插值算法（Monotone Cubic Hermite Interpolation）生成平滑曲线路径，避免曲线反转或异常波动。
	•	🌀 支持滑动容器组件
	•	ScrollableCurveView 支持动态点数量和横向滚动，自动扩展内容宽度，适配任意数量的天气数据。
	•	🖼 天气图标自动映射
	•	内建天气代码转文字描述方法（如 “1” ➝ “多云”）；
	•	自动匹配白天与夜间 UIImage 资源，支持 .dayXX 与 .nightXX 命名风格。
	•	📆 日期处理扩展
	•	字符串扩展支持：
	•	"yyyy-MM-dd" → "周一" / "今天" / "明天" 友好格式。
	•	"yyyy-MM-dd" → "MM/dd" 简洁显示格式。
	•	🌫 空气质量指数展示
	•	支持 AQI 数值转文字等级（优 / 良 / 轻度污染…），便于 UI 展示。

⸻

🧩 模块组成
	•	DailyCurveModel：用于承载每一日天气数据的模型。
	•	DailyCurveView：核心绘图组件，负责温度曲线、图标与标签绘制。
	•	ScrollableCurveView：带 UIScrollView 的封装组件，支持任意长度数据横向滚动。

⸻

🛠️ 适合场景
	•	天气类 App 的日常天气趋势可视化
	•	自定义曲线图需求的 UI 自绘组件
	•	学习 Core Graphics 和曲线插值算法的示例项目

⸻

如果你还想补充项目功能、使用方法、资源命名约定等，也可以继续加上，我可以帮你整理出更完整的 GitHub README。要不要我顺手帮你起个项目名？
