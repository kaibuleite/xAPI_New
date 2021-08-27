//
//  String+xSub.swift
//  xExtension
//
//  Created by Mac on 2021/6/10.
//

import Foundation

extension String {
    
    // MARK: - 截取指定范围字符串
    /// 截取指定范围字符串
    /// - Parameter range: 截取范围
    /// - Returns: 截取结果
    public func xSub(range : NSRange) -> String?
    {
        let loc = range.location
        let len = range.length
        guard loc + len <= self.count else {
            print("⚠️⚠️⚠️ 截取的长度超出字符串范围")
            return nil
        }
        guard loc >= 0, len >= 0 else {
            print("⚠️⚠️⚠️ 截取参数不能为负数")
            return nil
        }
        let nsStr = self as NSString
        let ret = nsStr.substring(with: range)
        return ret
    }
    
    // MARK: - 截取前几位字符串
    /// 截取前几位字符串(截取失败返回空字符串)
    /// - Parameter length: 截取长度
    /// - Returns: 截取结果
    public func xSubPrefix(length : Int) -> String?
    {
        let range = NSMakeRange(0, length)
        let ret = self.xSub(range: range)
        return ret
    }
    
    // MARK: - 截取后几位字符串
    /// 截取后几位字符串(截取失败返回空字符串)
    /// - Parameter length: 截取长度
    /// - Returns: 截取结果
    public func xSubSuffix(length : Int) -> String?
    {
        let loc = self.count - length
        let range = NSMakeRange(loc, length)
        let ret = self.xSub(range: range)
        return ret
    }
    
    // MARK: - 字符串包含
    /// 判断字符串是否包含另外一个字符串
    /// - Parameters:
    ///   - subStr: 另外一个字符串
    ///   - isIgnoringCase: 是否忽视大小写
    /// - Returns: 判断结果
    public func xContains(subStr : String,
                          isIgnoringCase : Bool = false) -> Bool
    {
        if isIgnoringCase {
            return self.range(of: subStr, options: .caseInsensitive) != nil
        }
        else {
            return self.range(of: subStr) != nil
        }
    }
    
}
