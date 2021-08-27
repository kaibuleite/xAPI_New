//
//  Color+xNew.swift
//  xExtension
//
//  Created by Mac on 2021/6/10.
//

import Foundation

extension UIColor {
    
    // MARK: - 创建16进制色
    /// 创建16进制色
    /// - Parameters:
    ///   - hex: 16进制内容
    ///   - alpha: 透明度
    /// - Returns: 新颜色
    public static func xNew(hex : String,
                            alpha : CGFloat = 1) -> UIColor
    {
        var str = hex
        // 去掉16进制中开头的无用字符
        str = str.replacingOccurrences(of: "0X", with: "")
        str = str.replacingOccurrences(of: "0x", with: "")
        str = str.replacingOccurrences(of: "#", with: "")
        if str.count == 3 {
            let rStr = str.xSub(range: NSMakeRange(0, 1)) ?? "0"
            let gStr = str.xSub(range: NSMakeRange(1, 1)) ?? "0"
            let bStr = str.xSub(range: NSMakeRange(2, 1)) ?? "0"
            str = rStr + rStr + gStr + gStr + bStr + bStr
        }
        else
        if str.count != 6 {
            print("⚠️⚠️⚠️ 要转换的16进制字符串有问题：\(hex)")
            return UIColor.clear
        }
        let rStr = str.xSub(range: NSMakeRange(0, 2)) ?? "00"
        let gStr = str.xSub(range: NSMakeRange(2, 2)) ?? "00"
        let bStr = str.xSub(range: NSMakeRange(4, 2)) ?? "00"
        
        var r = UInt32(0)
        var g = r
        var b = r
        Scanner(string: rStr).scanHexInt32(&r)
        Scanner(string: gStr).scanHexInt32(&g)
        Scanner(string: bStr).scanHexInt32(&b)
        
        let color = UIColor.init(red: CGFloat(r) / 255,
                                 green: CGFloat(g) / 255,
                                 blue: CGFloat(b) / 255,
                                 alpha: alpha)
        return color
    }
    
    // MARK: - 随机色
    /// 随机色
    /// - Parameter alpha: 透明度
    /// - Returns: 新颜色
    public static func xNewRandom(alpha : CGFloat = 1) -> UIColor
    {
        let r = CGFloat(arc4random() % 255) / 255.0
        let g = CGFloat(arc4random() % 255) / 255.0
        let b = CGFloat(arc4random() % 255) / 255.0
        let color = UIColor.init(red: r,
                                 green: g,
                                 blue: b,
                                 alpha: alpha)
        return color
    }
}
