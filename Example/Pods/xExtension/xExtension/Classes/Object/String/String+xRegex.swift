//
//  String+xRegex.swift
//  xExtension
//
//  Created by Mac on 2021/6/10.
//

import Foundation

extension String {
    
    // MARK: - 是否满足正则
    /// 判断是否满足正则表达式
    /// - Parameters:
    ///   - pattern: 规则
    ///   - options: 附加选项（默认不区分大小写）
    /// - Returns: 结果
    public func xCheckRegex(pattern : String,
                            options : NSRegularExpression.Options = .caseInsensitive) -> Bool
    {
        /*
         附加选项 参考 https://www.jianshu.com/p/ec6339cc33ad
         NSRegularExpressionCaseInsensitive            // 不区分字母大小写的模式，aBc 会匹配到abc.
         NSRegularExpressionAllowCommentsAndWhitespace // 忽略掉正则表达式中的空格和#号之后的字符，表达式[a-z]，会匹配到[a-z]
         NSRegularExpressionIgnoreMetacharacters       // 将正则表达式整体作为字符串处理。表达式 a b c 会匹配到abc，ab#c会匹配到ab。
         NSRegularExpressionDotMatchesLineSeparators   // 允许.匹配任何字符，包括换行符
         NSRegularExpressionAnchorsMatchLines          // 允许^和$符号匹配行的开头和结尾
         NSRegularExpressionUseUnixLineSeparators      // 设置\n为唯一的行分隔符，否则所有的都有效。
         NSRegularExpressionUseUnicodeWordBoundaries   // 使用Unicode TR#29标准作为词的边界，否则所有传统正则表达式的词边界都有效

         NSMatchingReportProgress           // 找到最长的匹配字符串后调用block回调
         NSMatchingReportCompletion         // 找到任何一个匹配串后都回调一次block
         NSMatchingAnchored                 // 从匹配范围的开始出进行极限匹配
         NSMatchingWithTransparentBounds    // 允许匹配的范围超出设置的范围
         NSMatchingWithoutAnchoringBounds   // 禁止^和$自动匹配行还是和结束
         */
        // 创建正则表达式对象
        guard let regex = try? NSRegularExpression.init(pattern: pattern, options: options) else { return false }
        // 开始匹配
        let range = NSMakeRange(0, self.count)
        let ret = regex.numberOfMatches(in: self, options: .reportProgress, range: range)
        return ret > 0
    }
    
    // MARK: - 枚举正则结果
    /// 枚举正则结果
    /// - Parameters:
    ///   - pattern: 规则
    ///   - options: 附加选项
    ///   - handler: 匹配回调
    public func xEnumerateRegexMatches(pattern : String,
                                       options : NSRegularExpression.Options = .caseInsensitive,
                                       handler : @escaping (String, NSRange) -> Void)
    {
        guard let regex = try? NSRegularExpression.init(pattern: pattern, options: options) else { return }
        let range = NSMakeRange(0, self.count)
        regex.enumerateMatches(in: self, options: .reportProgress, range: range) {
            (result, flags, stop) in
            let range = result?.range ?? .init(location: 0, length: 0)
            let str = self.xSub(range: range) ?? ""
            handler(str, range)
        }
    }
    
}
