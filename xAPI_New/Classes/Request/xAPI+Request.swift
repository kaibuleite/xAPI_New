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
                           headers : [String : String]? = nil,
                           parameters : [String : Any]?,
                           encoding : ParameterEncoding = URLEncoding.default,
                           queue : DispatchQueue = .main,
                           completed : @escaping xAPI.xHandlerRequestCompleted)
    {
        // 格式化请求数据并保存
        let xReq = xRequest()
        xReq.number = xRequestNumber
        xReq.type = .normal
        xReq.method = method
        xReq.encoding = encoding
        xReq.queue = queue
        
        xReq.url = self.formatterRequest(url: urlStr)
        xReq.headers = self.formatterRequest(headers: headers)
        xReq.parameters = self.formatterRequest(parameters: parameters)
        
        xReq.validate()
        // 创建AF请求
        let headers = xReq.getAlamofireHeaders()
        let afReq = AF.request(xReq.url, method: xReq.method, parameters: xReq.parameters, encoding: xReq.encoding, headers: headers) {
            (req) in
            // 配置超时时长
            req.timeoutInterval = self.getRequestTimeoutInterval()
        }
        // 发起请求
        afReq.validate()
        afReq.response(queue: xReq.queue) { 
            (afRep) in
            switch afRep.result {
            case let .success(data):
                xReq.response.responseState = .success
                xReq.response.responseData = data
                
            case let .failure(error):
                xReq.response.responseState = .failure
                xReq.response.responseData = afRep.data
                xReq.response.responseError = error
            }
            self.analyzingResponse(at: xReq)
            completed(xReq)
        }
        xRequestNumber += 1
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
                           headers : [String : String]? = nil,
                           parameters : [String : Any]?,
                           encoding : ParameterEncoding = URLEncoding.default,
                           queue : DispatchQueue = .main,
                           completed : @escaping xAPI.xHandlerRequestCompleted)
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
                            headers : [String : String]? = nil,
                            parameters : [String : Any]?,
                            encoding : ParameterEncoding = URLEncoding.default,
                            queue : DispatchQueue = .main,
                            completed : @escaping xAPI.xHandlerRequestCompleted)
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
                           headers : [String : String]? = nil,
                           parameters : [String : Any]?,
                           encoding : ParameterEncoding = URLEncoding.default,
                           queue : DispatchQueue = .main,
                           completed : @escaping xAPI.xHandlerRequestCompleted)
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
                              headers : [String : String]? = nil,
                              parameters : [String : Any]?,
                              encoding : ParameterEncoding = URLEncoding.default,
                              queue : DispatchQueue = .main,
                              completed : @escaping xAPI.xHandlerRequestCompleted)
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
