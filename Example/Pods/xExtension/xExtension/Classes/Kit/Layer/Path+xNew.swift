//
//  Path+xNew.swift
//  xExtension
//
//  Created by Mac on 2021/6/10.
//

import Foundation

extension UIBezierPath {
    
    // MARK: - 创建圆角路径
    /// 创建圆角路径
    /// - Parameters:
    ///   - rect: 大小
    ///   - tlRadius: 左上角圆角半径(Top Left)
    ///   - trRadius: 右上角圆角半径(Top Right)
    ///   - blRadius: 左下角圆角半径(Bottom Left)
    ///   - brRadius: 右下角圆角半径(Bottom Right)
    /// - Returns: 新路径
    public class func xNew(rect : CGRect,
                           tlRadius : CGFloat,
                           trRadius : CGFloat,
                           blRadius : CGFloat,
                           brRadius : CGFloat) -> UIBezierPath
    {
        // 声明参数
        let w = rect.width
        let h = rect.height
        var radius = CGFloat.zero   // 半径
        var center = CGPoint.zero   // 圆心
        var toPos = CGPoint.zero    // 下一个点
        // 开始绘制
        let path = UIBezierPath.init()
        // 左上
        radius = tlRadius
        center = CGPoint.init(x: radius, y: radius)
        path.addArc(withCenter: center, radius: radius,
                    startAngle: CGFloat.pi * 180 / 180,
                    endAngle:   CGFloat.pi * 270 / 180,
                    clockwise: true)
        toPos = CGPoint.init(x: w - trRadius, y: 0)
        path.addLine(to: toPos)
        // 右上
        radius = trRadius
        center = CGPoint.init(x: w - radius, y: radius)
        path.addArc(withCenter: center, radius: radius,
                    startAngle: CGFloat.pi * 270 / 180,
                    endAngle:   CGFloat.pi * 360 / 180,
                    clockwise: true)
        toPos = CGPoint.init(x: w, y: h - blRadius)
        path.addLine(to: toPos)
        // 右下
        radius = brRadius
        center = CGPoint.init(x: w - radius, y: h - radius)
        path.addArc(withCenter: center, radius: radius,
                    startAngle: CGFloat.pi * 0 / 180,
                    endAngle:   CGFloat.pi * 90 / 180,
                    clockwise: true)
        toPos = CGPoint.init(x: brRadius, y: h)
        path.addLine(to: toPos)
        // 左下
        radius = blRadius
        center = CGPoint.init(x: radius, y: h - radius)
        path.addArc(withCenter: center, radius: radius,
                    startAngle: CGFloat.pi * 90 / 180,
                    endAngle:   CGFloat.pi * 180 / 180,
                    clockwise: true)
        toPos = CGPoint.init(x: 0, y: tlRadius)
        path.addLine(to: toPos)
        
        return path
    }
}
