//
//  Label+xRect.swift
//  xExtension
//
//  Created by Mac on 2021/6/10.
//

import Foundation

extension UILabel {
    
    // MARK: - 内容大小
    /// 计算内容大小
    /// - Parameters:
    ///   - margin: 边缘留空
    /// - Returns: 内容大小
    public func xContentSize(margin : UIEdgeInsets = .zero) -> CGSize
    {
        guard let str = self.text else { return self.bounds.size }
        guard str.count > 0 else { return self.bounds.size }
        var w = self.bounds.width
        var h = self.bounds.height
        if w <= 0 { w = UIScreen.main.bounds.width }
        if h <= 0 { h = UIScreen.main.bounds.height }
        let rect = CGSize.init(width: w, height: h)
        var size = str.xContentSize(for: self.font,
                                    rect: rect)
        size.width += (margin.left + margin.right)
        size.height += (margin.top + margin.bottom)
        return size
    }

    // MARK: - 设置文本渐变色
    /// 设置文本渐变色
    /// - Parameters:
    ///   - colors: 渐变色
    ///   - start: 开始位置
    ///   - end: 结束位置
    ///   - options: 渐变配置
    public func xSetTextGradient(colors : [UIColor],
                                 start : CGPoint = .init(x: 0, y: 0.5),
                                 end : CGPoint = .init(x: 1, y: 0.5),
                                 options : CGGradientDrawingOptions = .drawsBeforeStartLocation)
    {
        let size = self.bounds.size
        guard let gradientImage = UIImage.xNewGradient(colors: colors, start: start, end: end, size: size, options: options) else {
            print("⚠️ 渐变图片创建失败")
            return
        }
        // 根据图片创建颜色
        let textGradientColor = UIColor.init(patternImage: gradientImage)
        self.textColor = textGradientColor
    }
}
