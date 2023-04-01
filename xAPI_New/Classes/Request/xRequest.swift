//
//  xRequest.swift
//  xAPI_New
//
//  Created by Mac on 2023/3/30.
//

import UIKit
import Alamofire
import xExtension

public class xRequest: NSObject {
    
    // MARK: - Enum
    /// 请求提交类型
    public enum SubmitType {
        case normal
        case upload
        case download
    }
    
    // MARK: - Public Property
    /// 编号
    public var number = 0
    /// 请求类型
    public var type = xRequest.SubmitType.normal
    /// 链接
    public var url = ""
    /// 请求方式
    public var method = HTTPMethod.post
    /// 头部
    public var headers = [String : String]()
    /// 参数
    public var parameters = [String : Any]()
    /// 参数编码方式
    public var encoding : ParameterEncoding = URLEncoding.default
    /// 处理队列
    public var queue = DispatchQueue.main
    /// 时间戳
    public var timestamp = ""
    /// 完成回调
    public var completed : xAPI.xHandlerRequestCompleted?
    
    // MARK: - 内存释放
    deinit {
        self.completed = nil
        print("🏀 Request:\(self.number)\t\(self)")
    }
    
    // MARK: - AF请求体
    /// AF请求体
    public lazy var afRequest : DataRequest = {
        // 头部处理
        let headers = self.getAlamofireHeaders()
        // 创建AF请求
        let req = AF.request(self.url, method: self.method, parameters: self.parameters, encoding: self.encoding, headers: headers) {
            (req) in
            // 配置超时时长
            req.timeoutInterval = xAPI.getRequestTimeoutInterval()
        }
        return req.validate()
    }()
    
    // MARK: - 转换成AF头部
    /// 转换成AF头部
    func getAlamofireHeaders() -> HTTPHeaders
    {
        // 头部处理
        var headers = HTTPHeaders()
        for key in self.headers.keys {
            guard let value = self.headers[key] else { continue }
            let header = HTTPHeader.init(name: key, value: value)
            headers.add(header)
        }
        // 保存时间戳 
        self.timestamp = "\(Int(Date().timeIntervalSince1970))"
        return headers
    }
    
    // MARK: - 验证参数
    /// 验证参数
    @discardableResult
    func validate() -> xRequest
    {
        guard self.method == .get else { return self }
        if method == .get {
        }
        let getParameterStr = xAPI.formatterGetString(of: self.parameters)
        var getUrl = self.url + "?" + getParameterStr
        // URL编码(先解码再编码，防止2次编码)
        getUrl = getUrl.xToUrlDecodedString() ?? getUrl
        getUrl = getUrl.xToUrlEncodedString() ?? getUrl
        self.url = getUrl
        // 重置参数对象
        self.parameters.removeAll()
        return self
    }
    
    // MARK: - 发送请求
    /// 发送请求
    open func send()
    {
        self.afRequest.responseData(queue: self.queue) {
            [weak self] (rep) in
            guard let self = self else { return }
            xAPI.checkResponse(rep, at: self)
        }
    }
    
}

