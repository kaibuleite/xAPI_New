//
//  String+xReplace.swift
//  xExtension
//
//  Created by Mac on 2021/6/10.
//

import Foundation

extension String {
    
    // MARK: 字符串替换
    /// 替换指定范围字符串
    /// - Parameters:
    ///   - range: 范围
    ///   - str: 要替换的字符串
    /// - Returns: 结果
    public func xReplace(range : NSRange,
                         with str : String) -> String?
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
        let ret = nsStr.replacingCharacters(in: range, with: str)
        return ret
    }
    
    // MARK: 字符串替换(正则)
    /// 用正则表达式替换字符串
    /// - Parameters:
    ///   - pattern: 规则
    ///   - options: 附加选项
    ///   - str: 要替换的字符串
    /// - Returns: 结果
    public func xReplaceRegex(pattern : String,
                              options : NSRegularExpression.Options = .caseInsensitive,
                              with str : String) -> String?
    {
        guard let regex = try? NSRegularExpression.init(pattern: pattern, options: options) else { return nil }
        let range = NSMakeRange(0, self.count)
        let ret = regex.stringByReplacingMatches(in: self, options: .reportProgress, range: range, withTemplate: str)
        return ret
    }
}
