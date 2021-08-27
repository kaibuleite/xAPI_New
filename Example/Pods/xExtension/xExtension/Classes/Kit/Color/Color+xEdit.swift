//
//  Color+xEdit.swift
//  xExtension
//
//  Created by Mac on 2021/6/10.
//

import Foundation

extension UIColor {
    
    // MARK: - 修改透明度
    /// 修改透明度
    /// - Parameter alpha: 透明度
    /// - Returns: 新颜色
    public func xEdit(alpha : CGFloat) -> UIColor
    {
        let ret = self.withAlphaComponent(alpha)
        return ret
    }
    
    // MARK: - 混合两种颜色
    /// 混合两种颜色（取平均值）
    /// - Parameters:
    ///   - color: 要混合的颜色
    ///   - ratio: 要混合的颜色占比
    ///   - alpha: 混合结果的透明度
    /// - Returns: 新颜色
    public func xMix(color: UIColor,
                     ratio: CGFloat,
                     alpha: CGFloat = 1.0) -> UIColor
    {
        // 计算两种混合颜色的占比
        guard ratio > 0 else { return self }
        guard ratio < 1 else { return color }
        let ratio1 = 1 - ratio
        let ratio2 = ratio
        // 获取颜色的颜色空间
        guard let comp1 = self.cgColor.components,
              let comp2 = color.cgColor.components else {
            return self
        }
        // 根据颜色空间设置rgb值
        var r1 = CGFloat(0), g1 = CGFloat(0), b1 = CGFloat(0)
        var r2 = CGFloat(0), g2 = CGFloat(0), b2 = CGFloat(0)
        if comp1.count > 3 {
            // 3色通道(彩色)
            r1 = comp1[0]
            g1 = comp1[1]
            b1 = comp1[2]
        } else {
            // 单色通道(黑白灰)
            r1 = comp1[0]
            g1 = comp1[0]
            b1 = comp1[0]
        }
        if comp2.count > 3 {
            // 3色通道(彩色)
            r2 = comp2[0]
            g2 = comp2[1]
            b2 = comp2[2]
        } else {
            // 单色通道(黑白灰)
            r2 = comp2[0]
            g2 = comp2[0]
            b2 = comp2[0]
        }
        // 混合操作
        let r = r1 * ratio1 + r2 * ratio2
        let g = g1 * ratio1 + g2 * ratio2
        let b = b1 * ratio1 + b2 * ratio2
        let ret = UIColor.init(red: r, green: g, blue: b, alpha: alpha)
        return ret
    }
    
}
