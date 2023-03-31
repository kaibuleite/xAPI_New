//
//  xAPI.swift
//  xAPI_New
//
//  Created by Mac on 2021/8/27.
//

import Alamofire
import xExtension

// MARK: - xAPI
open class xAPI: NSObject {
    
    // MARK: - 上传文件类型枚举
    /// 上传文件类型枚举
    public enum xUploadFileType {
        // 图片
        case png
        case jpg, jpeg
        case gif
        // 多媒体
        case mp3
        case mp4, mpg4, m4vmp4v
        case mov
        // 文本
        case txt
        
        /// 文件模板
        public var mimeType : String {
            switch self {
            case .png:
                return "image/png"
            case .jpg, .jpeg:
                return "image/jpeg"
            case .gif:
                return "image/gif"
            case .mp3:
                return "audio/mp3"
            case .mp4, .mpg4, .m4vmp4v:
                return "video/mp4"
            case .mov:
                return "video/mov"
            case .txt:
                return "text/plain"
            }
        }
        /// 文件格式
        public var format : String {
            switch self {
            case .png:  return "png"
            case .jpg:  return "jpg"
            case .jpeg: return "jpeg"
            case .gif:  return "gif"
            case .mp3:  return "mp3"
            case .mp4:  return "mp4"
            case .mpg4: return "mp4"
            case .m4vmp4v:  return "mp4"
            case .mov:  return "mov"
            case .txt:  return "txt"
            }
        }
    }
    
    // MARK: - 请求回调
    /// 请求完成回调
    public typealias xHandlerRequestCompleted = (xResponse) -> Void
    
    // MARK: - 上传回调
    /// 上传进度回调(当前下载量，总数据量，下载进度)
    public typealias xHandlerUploadProgress = (Int64, Int64, Double) -> Void
    /// 上传取消回调(返回中断数据)
    public typealias xHandlerUploadCancel = (Data?) -> Void
    
    // MARK: - 下载回调
    /// 下载进度回调(当前下载量，总数据量，下载进度)
    public typealias xHandlerDownloadProgress = (Int64, Int64, Double) -> Void
    /// 下载取消回调(返回中断数据)
    public typealias xHandlerDownloadCancel = (Data?) -> Void
    
    // MARK: - 配置参数
    /// 请求编号
    static var xRequestNumber = 0
    /// 请求体列表
    public static var xApiRequstList = [String : xRequest]()
    /// 主机域名
    open class func getHostDomainName() -> String {
        return "主机域名，例如baidu.com"
    }
    /// 请求超时时长(默认60s)
    open class func getRequestTimeoutDuration() -> TimeInterval {
        return 60
    }
    /// 上传超时时长(默认60s)
    open class func getUploadTimeoutDuration() -> TimeInterval {
        return 60
    }
    /// 下载超时时长(默认60s)
    open class func getDownloadTimeoutDuration() -> TimeInterval {
        return 60
    }
    
    // MARK: - 格式化请求参数
    /// 格式化URL前缀
    open class func formatterUrlPrefix() -> String
    {
        return "API前缀"
    }
    /// 格式化Api请求URL
    open class func formatterRequest(url link : String) -> String
    {
        var url = link
        // 完整链接不用拼接
        if link.hasPrefix("http") == false {
            url = self.formatterUrlPrefix() + link
        }
        // URL编码(先解码再编码，防止2次编码)
        var ret = url.xToUrlDecodedString() ?? url
        ret = ret.xToUrlEncodedString() ?? url
        return ret
    }
    /// 格式化Api头部参数
    open class func formatterRequest(headers: [String : String]?) -> [String : String]
    {
        let head = headers ?? [String : String]()
        return head
    }
    /// 格式化Api请求参数
    open class func formatterRequest(parameters : [String : Any]?) -> [String : Any]
    {
        let parm = parameters ?? [String : Any]()
        return parm
    }
    /// 格式化Api数据摘要
    /// - Parameters:
    ///   - url: 请求url
    ///   - header: 头部参数
    ///   - parameter: 请求参数
    open class func formatterSign(url: String,
                                  header: [String : String],
                                  parameter: [String : Any]) -> String?
    {
        return nil
    }
    
    // MARK: - 响应数据
    // TODO: 数据校验
    /// 判断响应数据
    open class func checkResponse(_ afRep : AFDataResponse<Data>,
                                  at xReq : xRequest)
    {
        let xRep = xResponse.init(from: xReq)
        switch afRep.result {
        case let .success(obj):
            xRep.responseData = obj
            xRep.responseState = .success
            self.analyzingResponse(at: xRep)
            
        case let .failure(err):
            xRep.responseData = afRep.data
            xRep.responseState = .failure
            self.analyzingResponseFailure(at: xRep, error: err)
            // 打印请示求败日志
            self.logResponseError(err)
            self.logRequestInfo(xReq)
        }
        xReq.completed?(xRep)
        xApiRequstList.removeValue(forKey: "\(xReq.number)")
    }
    /// 判断上传数据
    open class func checkUploadResponse(_ afRep : AFDataResponse<Data>,
                                        at xReq : xUpload)
    {
        self.checkResponse(afRep, at: xReq)
    }
    /// 判断下载数据
    open class func checkDownloadResponse(_ afRep : AFDownloadResponse<Data>,
                                          at xReq : xDownload)
    {
        let xRep = xResponse.init(from: xReq)
        switch afRep.result {
        case let .success(obj):
            xRep.responseData = obj
            xRep.responseState = .success
            self.analyzingResponse(at: xRep)
            
        case let .failure(err):
            xRep.responseData = afRep.resumeData
            xRep.responseState = .failure
            self.analyzingResponseFailure(at: xRep, error: err)
            // 打印请示求败日志
            self.logResponseError(err)
            self.logRequestInfo(xReq)
        }
        xReq.completed?(xRep)
        xApiRequstList.removeValue(forKey: "\(xReq.number)")
    }
    // TODO: 数据解析
    /// 解析响应数据
    /// - Parameter data: 要解析的数据
    /// - Returns: 解析结果
    open class func analyzingResponse(at xRep: xResponse)
    {
        xRep.responseDataAnalyzing = .error
        // 尝试解析成JSON
        guard let data = xRep.responseData as? Data else { return }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else { return }
        xRep.responseDataAnalyzing = .success
        xRep.apiData = json
        // 尝试解析接口数据
        self.analyzingApiData(at: xRep)
    }
    /// 解析失败数据
    /// - Parameters:
    ///   - error: 错误内容
    ///   - data: 失败内容
    /// - Returns: 解析结果
    open class func analyzingResponseFailure(at xRep: xResponse,
                                             error : AFError)
    {
        xRep.responseDataAnalyzing = .error
        xRep.responseCode = error.responseCode ?? 200
        xRep.responseErrorReason = error.localizedDescription
        // 如果响应失败仍有数据返回，尝试解析
        guard xRep.responseData != nil else { return }
        self.analyzingResponse(at: xRep)
    }
    
    // MARK: - 接口数据
    // TODO: 数据解析
    /// 解析接口数据
    /// - Parameter xRep: 请求体
    open class func analyzingApiData(at xRep: xResponse)
    {
        xRep.apiDataAnalyzing = .error
        guard let apiData = xRep.apiData else { return }
        if let data = apiData as? Data {
            // 接口数据为字符串
            let str = String(data: data, encoding: .utf8) ?? ""
            self.analyzingApiStringData(str, at: xRep)
        } else
        if let dict = apiData as? [String : Any] {
            // 接口数据为字典
            self.analyzingApiDictionaryData(dict, at: xRep)
        } else
        if let array = apiData as? [Any] {
            // 接口数据为数组
            self.analyzingApiArrayData(array, at: xRep)
        } else {
            // 接口数据未定义的类型
            self.analyzingApiUnknownData(apiData, at: xRep)
        }
    }
    /// 解析接口数据——字符串
    /// - Parameters:
    ///   - str: 要解析的字符串
    ///   - xRep: 响应结果
    open class func analyzingApiStringData(_ str : String,
                                           at xRep : xResponse)
    {
        print("\(#function) in \(type(of: self))")
        print("❗️ 接口返回字符串")
    }
    /// 解析接口数据——字典
    /// - Parameters:
    ///   - str: 要解析的字典
    ///   - xRep: 响应结果
    open class func analyzingApiDictionaryData(_ dict : [String : Any],
                                               at xRep : xResponse)
    {
        xRep.apiDataAnalyzing = .success
        // 错误码
        xRep.apiCode = self.getApiCode(in: dict)
        // 提示信息
        xRep.apiMessage = self.getApiMessage(in: dict)
        // 接口数据
        xRep.apiData = self.getApiData(in: dict)
        // 校验
        self.validateApiState(at: xRep)
    }
    /// 解析接口数据——数组
    /// - Parameters:
    ///   - str: 要解析的数组
    ///   - xRep: 响应结果
    open class func analyzingApiArrayData(_ array : [Any],
                                          at xRep : xResponse)
    {
        print("\(#function) in \(type(of: self))")
        print("❗️ 接口返回数组")
    }
    /// 解析接口数据——其他
    /// - Parameters:
    ///   - str: 要解析的数据
    ///   - xRep: 响应结果
    open class func analyzingApiUnknownData(_ obj : Any,
                                            at xRep : xResponse)
    {
        print("\(#function) in \(type(of: self))")
        print("❗️ 接口返回未知类型\n\(obj)")
    }
    // TODO: 数据提取
    /// 接口状态码
    open class func getApiCode(in dict : [String : Any]) -> Int
    {
        var code = 0
        if let obj = dict["errorCode"] as? Int      { code = obj } else
        if let obj = dict["errorCode"] as? String   { code = obj.xToInt() }
        if let obj = dict["status"] as? Int     { code = obj } else
        if let obj = dict["status"] as? String  { code = obj.xToInt() }
        return code
    }
    /// 接口提示信息
    open class func getApiMessage(in dict : [String : Any]) -> String
    {
        var msg = ""
        if let obj = dict["msg"] as? String         { msg = obj }
        if let obj = dict["errorMsg"] as? String    { msg = obj }
        return msg
    }
    /// 接口数据
    open class func getApiData(in dict : [String : Any]) -> Any?
    {
        var data : Any?
        if let obj = dict["result"] { data = obj }
        if let obj = dict["data"]   { data = obj }
        return data
    }
    /// 校验接口状态
    open class func validateApiState(at xRep : xResponse)
    {
        // 接口重写，下边是参考
        xRep.apiState = .success
        if xRep.apiCode != 0, xRep.apiCode != 1000 {
            xRep.apiState = .failure
        }
        print("\(xRep.apiState == .success ? "⭕️" : "❌") CODE =【\(xRep.apiCode)】\tMSG =【\(xRep.apiMessage)】")
        // 重新登录提示
        let reLoginMsgList = ["重新登录提示1",
                              "重新登录提示2",
                              "重新登录提示3"]
        for obj in reLoginMsgList {
            guard obj == xRep.apiMessage else { continue }
            // 发送重新登录信息
            return
        }
        // 错误提示过滤
        let unshowMsgList = ["过滤提示1",
                             "过滤提示2",
                             "过滤提示3"]
        for obj in unshowMsgList {
            guard obj == xRep.apiMessage else { continue }
            return
        }
        xRep.apiMessage.xAlertTip()
    }
    
}
