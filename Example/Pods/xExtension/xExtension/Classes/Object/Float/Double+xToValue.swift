//
//  Double+xToValue.swift
//  xExtension
//
//  Created by Mac on 2021/6/11.
//

import Foundation

extension Double {
    
    // MARK: - 转换成字符串类型
    /// 转换成字符串类型
    /// - Parameter precision: 最多保留小数点位数
    /// - Parameter clearMoreZero: 是否清除多余的0
    /// - Returns: 结果
    public func xToString(precision : Int,
                          isRemoveLastZero : Bool = false) -> String
    {
        let str = String.init(format: "%.\(precision)f", self)
        var ret = str
        if ret.count == 0 {
            ret = "0"
        }
        // 包含小数点才执行之后的操作
        guard isRemoveLastZero else { return ret }
        // 带有小数，开始剔除
        let count = ret.count
        for _ in 0 ..< count {
            // 判断结尾是否为0
            if ret.hasSuffix("0") {
                ret.removeLast()
            } else {
                break
            }
        }
        // 判断是否是整数
        if ret.hasSuffix(".") {
            ret.removeLast()
        }
        return ret
    }
    
}
