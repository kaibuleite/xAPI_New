//
//  xAPI+Request.swift
//  xAPI_New
//
//  Created by Mac on 2021/8/27.
//

import Alamofire

extension xAPI {
    
    // MARK: - 请求操作
    /// API请求
    /// - Parameters:
    ///   - urlStr: 请求地址
    ///   - method: 请求方式
    ///   - headers: 头部
    ///   - parameters: 参数
    ///   - encoding: 参数编码类型，默认URL，或者可以切换为JSON
    ///   - queue: 消息队列
    ///   - completed: 完成回调
    public static func req(urlStr : String,
                           method : HTTPMethod,
                           headers : [String : String]?,
                           parameters : [String : Any]?,
                           encoding: ParameterEncoding = URLEncoding.default,
                           queue : DispatchQueue = .main,
                           completed : @escaping xHandlerRequestCompleted)
    {
        // 格式化请求数据
        var fm_url = self.formatterRequest(url: urlStr)
        var fm_parm = self.formatterRequest(parameters: parameters)
        let fm_head = self.formatterRequest(headers: headers)
        var ht_headers = HTTPHeaders()
        for key in fm_head.keys {
            guard let value = fm_head[key] else { continue }
            let header = HTTPHeader.init(name: key, value: value)
            ht_headers.add(header)
        }
        
        // GET请求拼接参数到URL中
        if method == .get, fm_parm.count > 0 {
            let getStr = self.formatterGetString(of: fm_parm)
            fm_url = fm_url + "?" + getStr
            // URL编码(先解码再编码，防止2次编码)
            fm_url = fm_url.xToUrlDecodedString() ?? fm_url
            fm_url = fm_url.xToUrlEncodedString() ?? fm_url
            fm_parm.removeAll() // 重置参数对象
        }
        
        // 创建请求体
        let request = AF.request(fm_url, method: method, parameters: fm_parm, encoding: encoding, headers: ht_headers) {
            (req) in
            req.timeoutInterval = xAPI.getRequestTimeoutDuration() // 配置超时时长
        }.validate()
        // 发起请求
        request.responseData(queue: queue) {
            (rep) in
            switch rep.result {
            case let .success(obj):
                let ret = self.analyzingResponse(data: obj)
                ret.repState = .success
                completed(ret)
                
            case let .failure(err):
                let ret = self.analyzingResponseFailure(code: err.responseCode,
                                                        data: rep.data)
                ret.repState = .failure
                completed(ret)
                // 打印请示求败日志
                self.logRequestError(err)
                self.logRequestInfo(url: fm_url,
                                    method: method,
                                    header: fm_head,
                                    parameter: fm_parm)
            }
        }
    }
    
    // MARK: - GET请求
    /// GET请求
    /// - Parameters:
    ///   - urlStr: 请求地址
    ///   - headers: 头部
    ///   - parameters: 参数
    ///   - encoding: 参数编码类型，默认URL，或者可以切换为JSON
    ///   - queue: 消息队列
    ///   - completed: 完成回调
    public static func get(urlStr : String,
                           headers : [String : String]?,
                           parameters : [String : Any]?,
                           encoding: ParameterEncoding = URLEncoding.default,
                           queue : DispatchQueue = .main,
                           completed : @escaping xHandlerRequestCompleted)
    {
        self.req(urlStr: urlStr,
                 method: .get,
                 headers: headers,
                 parameters: parameters,
                 encoding: encoding,
                 queue: queue,
                 completed: completed)
    }
    
    // MARK: - POS请求
    /// POS请求
    /// - Parameters:
    ///   - urlStr: 请求地址
    ///   - headers: 头部
    ///   - parameters: 参数
    ///   - encoding: 参数编码类型，默认URL，或者可以切换为JSON
    ///   - queue: 消息队列
    ///   - completed: 完成回调
    public static func post(urlStr : String,
                            headers : [String : String]?,
                            parameters : [String : Any]?,
                            encoding: ParameterEncoding = URLEncoding.default,
                            queue : DispatchQueue = .main,
                            completed : @escaping xHandlerRequestCompleted)
    {
        self.req(urlStr: urlStr,
                 method: .post,
                 headers: headers,
                 parameters: parameters,
                 encoding: encoding,
                 queue: queue,
                 completed: completed)
    }
    
    // MARK: - PUT请求
    /// PUT请求
    /// - Parameters:
    ///   - urlStr: 请求地址
    ///   - headers: 头部
    ///   - parameters: 参数
    ///   - encoding: 参数编码类型，默认URL，或者可以切换为JSON
    ///   - queue: 消息队列
    ///   - completed: 完成回调
    public static func put(urlStr : String,
                           headers : [String : String]?,
                           parameters : [String : Any]?,
                           encoding: ParameterEncoding = URLEncoding.default,
                           queue : DispatchQueue = .main,
                           completed : @escaping xHandlerRequestCompleted)
    {
        self.req(urlStr: urlStr,
              method: .put,
              headers: headers,
              parameters: parameters,
              encoding: encoding,
              queue: queue,
              completed: completed)
    }
    
    // MARK: - Delete请求
    /// Delete请求
    /// - Parameters:
    ///   - urlStr: 请求地址
    ///   - headers: 头部
    ///   - parameters: 参数
    ///   - encoding: 参数编码类型，默认URL，或者可以切换为JSON
    ///   - queue: 消息队列
    ///   - completed: 完成回调
    public static func delete(urlStr : String,
                              headers : [String : String]?,
                              parameters : [String : Any]?,
                              encoding: ParameterEncoding = URLEncoding.default,
                              queue : DispatchQueue = .main,
                              completed : @escaping xHandlerRequestCompleted)
    {
        self.req(urlStr: urlStr,
              method: .delete,
              headers: headers,
              parameters: parameters,
              encoding: encoding,
              queue: queue,
              completed: completed)
    }
}
