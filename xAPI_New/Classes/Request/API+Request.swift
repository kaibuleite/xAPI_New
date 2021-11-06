//
//  API+Request.swift
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
    ///   - header: 头部
    ///   - parameter: 参数
    ///   - queue: 消息队列
    ///   - repDataSerializer: 响应结果解析类型，默认解析为JSON格式
    ///   - completed: 完成回调
    public static func req(urlStr : String,
                           method : HTTPMethod,
                           header : [String : String]?,
                           parameter : [String : Any]?,
                           queue : DispatchQueue = .main,
                           repDataSerializer : ResponseDataSerializerType = .json,
                           completed : @escaping xHandlerApiReqCompleted)
    {
        // 格式化请求数据
        var fm_url = self.formatterRequest(url: urlStr)
        var fm_parm = self.formatterRequest(parameter: parameter)
        let fm_head = self.formatterRequest(header: header)
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
        let request = AF.request(fm_url, method: method, parameters: fm_parm, headers: ht_headers)
        // 发起请求
        switch repDataSerializer {
        case .data:
            request.responseData(queue: queue) {
                (rep) in
                switch rep.result {
                case let .success(obj):
                    let result = self.serializerResponse(data: obj)
                    completed(.init(state: .success, responseDataSerializerResult: result))
                    
                case let .failure(err):
                    self.logRequestError(err)
                    self.logRequestInfo(url: fm_url, method: method, header: fm_head, parameter: fm_parm)
                    let result = self.serializerResponseError(code: err.responseCode, data: rep.data)
                    completed(.init(state: .failure, responseDataSerializerResult: result))
                } 
            }
        case .string:
            request.responseString(queue: queue) {
                (rep) in
                switch rep.result {
                case let .success(obj):
                    let result = self.serializerResponse(string: obj)
                    completed(.init(state: .failure, responseDataSerializerResult: result))
                    
                case let .failure(err):
                    self.logRequestError(err)
                    self.logRequestInfo(url: fm_url, method: method, header: fm_head, parameter: fm_parm)
                    let result = self.serializerResponseError(code: err.responseCode, data: rep.data)
                    completed(.init(state: .failure, responseDataSerializerResult: result))
                }
            }
        case .json:
            request.responseJSON(queue: queue) {
                (rep) in
                switch rep.result {
                case let .success(obj):
                    let result = self.serializerResponse(json: obj)
                    completed(.init(state: .success, responseDataSerializerResult: result))
                    
                case let .failure(err):
                    self.logRequestError(err)
                    self.logRequestInfo(url: fm_url, method: method, header: fm_head, parameter: fm_parm)
                    let result = self.serializerResponseError(code: err.responseCode, data: rep.data)
                    completed(.init(state: .failure, responseDataSerializerResult: result))
                }
            }
        }
    }
    
    // MARK: - GET请求
    /// GET请求
    /// - Parameters:
    ///   - urlStr: 请求地址
    ///   - header: 头部
    ///   - parameter: 参数
    ///   - queue: 消息队列
    ///   - repDataSerializer: 响应结果解析类型，默认解析为JSON格式
    ///   - completed: 完成回调
    public static func get(urlStr : String,
                           header : [String : String]?,
                           parameter : [String : Any]?,
                           queue : DispatchQueue = .main,
                           repDataSerializer : ResponseDataSerializerType = .json,
                           completed : @escaping xHandlerApiReqCompleted)
    {
        self.req(urlStr: urlStr, method: .get, header: header, parameter: parameter, queue: queue, repDataSerializer: repDataSerializer, completed: completed)
    }
    
    // MARK: - POS请求
    /// POS请求
    /// - Parameters:
    ///   - urlStr: 请求地址
    ///   - header: 头部
    ///   - parameter: 参数
    ///   - queue: 消息队列
    ///   - repDataSerializer: 响应结果解析类型，默认解析为JSON格式
    ///   - completed: 完成回调
    public static func post(urlStr : String,
                            header : [String : String]?,
                            parameter : [String : Any]?,
                            queue : DispatchQueue = .main,
                            repDataSerializer : ResponseDataSerializerType = .json,
                            completed : @escaping xHandlerApiReqCompleted)
    {
        self.req(urlStr: urlStr, method: .post, header: header, parameter: parameter, queue: queue, repDataSerializer: repDataSerializer, completed: completed)
    }
    
    // MARK: - PUT请求
    /// PUT请求
    /// - Parameters:
    ///   - urlStr: 请求地址
    ///   - header: 头部
    ///   - parameter: 参数
    ///   - queue: 消息队列
    ///   - repDataSerializer: 响应结果解析类型，默认解析为JSON格式
    ///   - completed: 完成回调
    public static func put(urlStr : String,
                           header : [String : String]?,
                           parameter : [String : Any]?,
                           queue : DispatchQueue = .main,
                           repDataSerializer : ResponseDataSerializerType = .json,
                           completed : @escaping xHandlerApiReqCompleted)
    {
        self.req(urlStr: urlStr, method: .put, header: header, parameter: parameter, queue: queue, repDataSerializer: repDataSerializer, completed: completed)
    }
    
    // MARK: - Delete请求
    /// Delete请求
    /// - Parameters:
    ///   - urlStr: 请求地址
    ///   - header: 头部
    ///   - parameter: 参数
    ///   - queue: 消息队列
    ///   - repDataSerializer: 响应结果解析类型，默认解析为JSON格式
    ///   - completed: 完成回调
    public static func delete(urlStr : String,
                              header : [String : String]?,
                              parameter : [String : Any]?,
                              repDataSerializer : ResponseDataSerializerType = .json,
                              queue : DispatchQueue = .main,
                              completed : @escaping xHandlerApiReqCompleted)
    {
        self.req(urlStr: urlStr, method: .delete, header: header, parameter: parameter, queue: queue, repDataSerializer: repDataSerializer, completed: completed)
    }
}
