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
    public typealias xHandlerRequestCompleted = (xResponseResult) -> Void
    
    // MARK: - 上传回调
    /// 上传进度回调(当前下载量，总数据量，下载进度)
    public typealias xHandlerUploadProgress = (Int64, Int64, Double) -> Void
    /// 上传取消回调(返回中断数据)
    public typealias xHandlerUploadCancel = (Data?) -> Void
    /// 上传完成回调
    public typealias xHandlerUploadCompleted = (xResponseResult) -> Void
    
    // MARK: - 下载回调
    /// 下载进度回调(当前下载量，总数据量，下载进度)
    public typealias xHandlerDownloadProgress = (Int64, Int64, Double) -> Void
    /// 下载取消回调(返回中断数据)
    public typealias xHandlerDownloadCancel = (Data?) -> Void
    /// 下载完成回调
    public typealias xHandlerDownloadCompleted = (xResponseResult) -> Void
    
    // MARK: - 超时时长（可重写）
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
    
    // MARK: - 格式化请求参数（可重写）
    /// 格式化URL前缀
    open class func formatterUrlPrefix() -> String
    {
        return "API前缀"
    }
    /// 格式化Api请求URL
    open class func formatterRequest(url link : String) -> String
    {
        var url = link
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
     
    
    // MARK: - 解析响应数据（可重写）
    /// 解析响应数据
    /// - Parameter data: 要解析的数据
    /// - Returns: 解析结果
    open class func analyzingResponse(data: Data) -> xResponseResult
    {
        let ret = xResponseResult()
        // 尝试解析成JSON
        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
            ret.repDataAnalyzingState = .success
            ret.serverReturnData = json
        } else {
            ret.repDataAnalyzingState = .failure
            ret.serverReturnData = nil
        }
        // 服务器返回的数据状态在子类里判断
        ret.serverReturnDataState = .normal
//        ret.timestamp = ""
//        ret.tipMessage = ""
        return ret
    }
    /// 解析失败数据
    /// - Parameters:
    ///   - code: 错误码
    ///   - data: 失败内容
    /// - Returns: 解析结果
    open class func analyzingResponseFailure(code : Int?,
                                             data: Data?) -> xResponseResult
    {
        let ret = xResponseResult()
        guard let obj = data else {
            ret.repDataAnalyzingState = .failure
            ret.serverReturnData = nil
            return ret
        }
        // 尝试解析成JSON
        return self.analyzingResponse(data: obj) 
    }
}
