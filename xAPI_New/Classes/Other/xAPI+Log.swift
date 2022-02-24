//
//  xAPI+Log.swift
//  xAPI_New
//
//  Created by Mac on 2021/8/27.
//

import Alamofire

extension xAPI {
    
    // MARK: - 打印出错内容
    /// 打印出错内容
    public static func logRequestError(_ err : AFError)
    {
        print("⚠️ API 响应数据验证失败")
        print("**************************************")
        if let code = err.responseCode {
            print("Response Code = \(code)")
        } else {
            print("Response Code = unknown")
        }
        print("Error Content = \(err.localizedDescription)")
    }
    /// 打印请求信息
    public static func logRequestInfo(url : String,
                                      method : HTTPMethod,
                                      header : [String : String]?,
                                      parameter : [String : Any]?)
    {
        print("—————————————————")
        print("URL:\(url)")
        print("Method:\(method)")
        print("Header:\(self.formatterPostString(of: header))")
        print("GET Parameter:\(self.formatterGetString(of: parameter))")
        print("POST Parameter:\(self.formatterPostString(of: parameter))")
    }
    
}

extension Dictionary {
    
    // MARK: - 按顺序打印参数
    /// 按顺序打印参数
    public func xLogSortParameter()
    {
        guard let parameter = self as? [String : Any?] else {
            print("⚠️ 格式不符合")
            print(self)
            return
        }
        let keyArr = parameter.keys.sorted()
        for key in keyArr {
            guard let value = parameter[key] as? String else { continue }
            print(key, value)
        }
    }
}
