//
//  String+xToValue.swift
//  xExtension
//
//  Created by Mac on 2021/6/10.
//

import Foundation

extension String {
    
    // MARK: - 编码|解码
    /// Base64编码
    /// - Parameter options: 编码选项
    /// - Returns: 编码结果
    public func xToBase64EncodedString(options : Data.Base64EncodingOptions = .init(rawValue: 0)) -> String?
    {
        let data = self.data(using: .utf8)
        let ret = data?.base64EncodedString(options: options)
        return ret
    }
    
    /// Base64解码
    /// - Parameter options: 解码选项
    /// - Returns: 解码结果
    public func xToBase64DecodedString(options : Data.Base64DecodingOptions = .init(rawValue: 0)) -> String?
    {
        let data = Data(base64Encoded: self, options: options)
        let ret = String(data: data!, encoding: .utf8)
        return ret
    }
    
    /// URL编码
    /// - Returns: 编码结果
    public func xToUrlEncodedString() -> String?
    {
        let set = CharacterSet.urlQueryAllowed
        let ret = self.addingPercentEncoding(withAllowedCharacters: set)
        return ret
    }
    
    /// URL解码
    /// - Returns: 解码结果
    public func xToUrlDecodedString() -> String?
    {
        let ret = self.removingPercentEncoding
        return ret
    }
    
    /// UTF-8编码
    /// - Returns: 解码结果
    public func xToUTF8String() -> String?
    {
        guard let data = self.data(using: .utf8) else { return nil }
        let ret = String.init(data: data, encoding: .utf8)
        return ret
    }
    
    // MARK: - 类型转换
    /// 转换成Int类型数据
    /// - Returns: 转换结果
    public func xToInt() -> Int
    {
        guard let ret = Int(self) else { return 0 }
        return ret
    }
    
    /// 转换成Float类型数据
    /// - Returns: 转换结果
    public func xToFloat() -> Float
    {
        guard let ret = Float(self) else { return 0 }
        return ret
    }
    
    /// 转换成Double类型数据
    /// - Returns: 转换结果
    public func xToDouble() -> Double
    {
        guard let ret = Double(self) else { return 0 }
        return ret
    }
    
    /// 转换成bool类型数据
    /// - Returns: 转换结果
    public func xToBool() -> Bool
    {
        let arr = ["", "0", "No", "NO", "False", "FALSE"]
        for str in arr {
            if str == self {
                return false
            }
        }
        return true
    }
    
    /// 转换成UIImage类型数据
    /// - Parameter bundle: 图片所在的包
    /// - Returns: 转换结果
    public func xToImage(in bundle : Bundle? = nil) -> UIImage?
    {
        var img : UIImage? = nil
        if bundle == nil {
            img = UIImage.init(named: self)
        }
        else {
            img = UIImage.init(named: self, in: bundle, compatibleWith: nil)
        }
        return img
    }
    
    /// 转换成URL
    /// - Parameter isUsingUrlEncode: 是否使用URL编码（处理汉字）
    /// - Returns: 转换结果
    public func xToURL(isUsingUrlEncode: Bool = false) -> URL?
    {
        // 做url编码
        if isUsingUrlEncode {
            if let str = self.xToUrlEncodedString() {
                let url = URL.init(string: str)
                return url
            }
        }
        let url = URL.init(string: self)
        return url
    }
    
    // MARK: - 格式转换
    /// 转换成国际计数（三位分节法，每3位加一个","）
    /// - Returns: 转换结果
    public func xToInternationalNumberString() -> String?
    {
        // 0没啥好转换的
        let str = self.replacingOccurrences(of: ",", with: "")
        guard str.xToDouble() != 0 else { return "0" }
        // 获取整数和小数位
        let arr = str.components(separatedBy: ".")
        var intStr = "\(arr.first!.xToInt())"
        // 整数长度
        var len = intStr.count
        var ret : String = ""
        while (len > 3) {
            len -= 3
            let loc = intStr.count - 3
            let range1 = NSMakeRange(loc, 3)
            if let sub = intStr.xSub(range: range1) {
                ret = "," + sub + ret
            }
            let range2 = NSMakeRange(0, loc)
            if let sub = intStr.xSub(range: range2) {
                intStr = sub
            }
        }
        ret = intStr + ret
        // 补充小数
        if arr.count == 2 {
            let decimal = arr.last!
            ret += "." + decimal
        }
        return ret
    }
    
    /// 时间戳转日期1
    /// - Parameters:
    ///   - format: 日期格式（yyyy-MM-dd)
    ///   - isMillisecond: 是否毫秒级
    /// - Returns: 转换结果
    public func xToDateString(format : String,
                              isMillisecond : Bool = false) -> String
    {
        let fm = DateFormatter()
        fm.dateFormat = format
        let ret = self.xToDateString(format: fm)
        return ret
    }
    
    /// 时间戳转日期
    /// - Parameters:
    ///   - format: 日期格式（建议不要频繁创建format造成性能浪费)
    ///   - isMillisecond: 是否毫秒级
    /// - Returns: 转换结果
    public func xToDateString(format : DateFormatter,
                              isMillisecond : Bool = false) -> String
    {
        var time = self.xToDouble()
        if isMillisecond {
            time /= 1000
        }
        let date = Date.init(timeIntervalSince1970: time)
        let ret = format.string(from: date)
        return ret
    }
    
    /// 字符串划线
    /// - Parameter color: 划线颜色
    /// - Returns: 转换结果富文本
    public func xToLineString(color : UIColor = .lightGray) -> NSAttributedString
    {
        var dic = [NSAttributedString.Key : Any]()
        dic[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
        dic[.strikethroughColor] = color
        dic[.baselineOffset] = 0
        let atr = NSAttributedString.init(string: self,
                                          attributes: dic)
        return atr
    }
}
