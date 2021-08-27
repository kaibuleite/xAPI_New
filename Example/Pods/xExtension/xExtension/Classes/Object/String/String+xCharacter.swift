//
//  String+xCharacter.swift
//  xExtension
//
//  Created by Mac on 2021/6/10.
//

import Foundation

extension String {
    
    // MARK: - 字母操作
    /// 首字母（适用汉字）
    public var xFirstCharacter : String
    {
        // 转变成可变字符串
        let mStr = NSMutableString.init(string: self)
        // 将中文转换成带声调的拼音
        CFStringTransform(mStr as CFMutableString, nil, kCFStringTransformToLatin, false)
        // 去掉声调(变音不敏感)
        var pinyinStr = mStr.folding(options: .diacriticInsensitive, locale: .current)
        // 将拼音首字母换成大写
        pinyinStr = pinyinStr.uppercased()
        // 截取大写首字母
        let firstStr = String(pinyinStr.prefix(1))
        // 判断首字母是否为大写
        let regexA = "^[A-Z]$"
        let predA = NSPredicate.init(format: "SELF MATCHES %@", regexA)
        let ret = predA.evaluate(with: firstStr) ? firstStr : "#"
        return ret
    }
    
    /// 大写转小写
    public var xLowercaseString : String {
        let ret = self.lowercased()
        return ret
    }
    /// 小写转大写
    public var xUppercaseString : String {
        let ret = self.uppercased()
        return ret
    }
    
}
