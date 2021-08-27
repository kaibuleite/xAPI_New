//
//  Float+xToValue.swift
//  xExtension
//
//  Created by Mac on 2021/6/10.
//

import Foundation

extension Float {
    
    // MARK: - 转换成字符串类型
    /// 转换成字符串类型
    /// - Parameter precision: 最多保留小数点位数
    /// - Parameter clearMoreZero: 是否清除多余的0
    /// - Returns: 结果
    public func xToString(precision : Int,
                          isRemoveLastZero : Bool = false) -> String
    {
        let db = Double(self)
        let ret = db.xToString(precision: precision,
                               isRemoveLastZero: isRemoveLastZero)
        return ret
    }
    
}

extension CGFloat {
    
    // MARK: - Public Property
    /// 数据转换，对应设计图中宽度750的值
    public var xToDesign750Value : CGFloat
    {
        let screen = UIScreen.main
        let width = screen.bounds.width
        let ret = self / 750 * width
        return ret
    }
}
