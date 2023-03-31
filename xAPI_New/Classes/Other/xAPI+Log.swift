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
    public static func logResponseError(_ err : AFError)
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
    public static func logRequestInfo(_ req : xRequest)
    {
        print("—————————————————")
        print("Number:\(req.number)")
        print("URL:\(req.url)")
        print("Method:\(req.method)")
        print("Header:\(self.formatterPostString(of: req.headers))")
        print("GET Parameter:\(self.formatterGetString(of: req.parameters))")
        print("POST Parameter:\(self.formatterPostString(of: req.parameters))")
    }
    
}
