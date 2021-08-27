//
//  API+Formatter.swift
//  xAPI_New
//
//  Created by Mac on 2021/8/27.
//

import Foundation

extension xAPI {
    
    // MARK: - 格式化GET参数为字符串
    /// 格式化GET参数为字符串
    public static func formatterGetString(of parameters : [String : Any]?) -> String
    {
        var ret = ""
        guard let param = parameters else { return ret }
        for (key, value) in param {
            if ret != "" {
                ret += "&"
            }
            ret += key + "=" + "\(value)"
        }
        return ret
    }
    
    // MARK: - 格式化POST参数为字符串
    /// 格式化POST参数为字符串
    public static func formatterPostString(of parameters : [String : Any]?) -> String
    {
        var ret = ""
        guard let param = parameters else { return ret  }
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted) else { return ret }
        ret = String.init(data: data, encoding: .utf8) ?? "JSON转换错误"
        return ret
    }
}
