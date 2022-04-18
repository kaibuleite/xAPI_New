//
//  Image+xNew.swift
//  xExtension
//
//  Created by Mac on 2022/3/2.
//

import Foundation

extension UIImage {
    
    // MARK: - 创建渐变色图片
    /// 创建渐变色图片
    /// - Parameters:
    ///   - colors: 渐变色
    ///   - start: 开始位置
    ///   - end: 结束位置
    ///   - size: 图片大小
    ///   - options: 渐变配置
    /// - Returns: 渐变色图片
    public static func xNewGradient(colors : [UIColor],
                                    start : CGPoint,
                                    end : CGPoint,
                                    size : CGSize,
                                    options : CGGradientDrawingOptions = .drawsBeforeStartLocation) -> UIImage?
    {
        guard colors.count > 0 else { return nil }
        let cgcolors = colors.map { return $0.cgColor }
        // 生成渐变图片
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        var colorSpace = cgcolors.last!.colorSpace
        var gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: cgcolors as CFArray,
                                  locations: nil)
        let startPoint = CGPoint(x: start.x * size.width,
                                 y: start.y * size.height)
        let endPoint = CGPoint(x: end.x * size.width,
                               y: end.y * size.height)
        context?.drawLinearGradient(gradient!,
                                    start: startPoint,
                                    end: endPoint,
                                    options: options)
        //取到渐变图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        //释放资源
        gradient = nil
        colorSpace = nil
        context?.restoreGState()
        UIGraphicsEndImageContext()
        return image
    }
}
