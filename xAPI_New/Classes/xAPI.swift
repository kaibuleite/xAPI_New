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
    
    // MARK: - 响应结果解析类型
    /// 响应结果解析类型
    public enum ResponseDataSerializerType {
        /// 解析为Data
        case data
        /// 解析为String
        case string
        /// 解析为JSON
        case json
    }
    
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
    public typealias xHandlerApiReqCompleted = (xApiRequestResult) -> Void
    
    // MARK: - 上传回调
    /// 上传进度回调(当前下载量，总数据量，下载进度)
    public typealias xHandlerApiUploadProgress = (Int64, Int64, Double) -> Void
    /// 上传取消回调(返回中断数据)
    public typealias xHandlerApiUploadCancel = (Data?) -> Void
    /// 上传完成回调
    public typealias xHandlerApiUploadCompleted = (Bool, Any?) -> Void
    
    // MARK: - 下载回调
    /// 下载进度回调(当前下载量，总数据量，下载进度)
    public typealias xHandlerApiDownloadProgress = (Int64, Int64, Double) -> Void
    /// 下载取消回调(返回中断数据)
    public typealias xHandlerApiDownloadCancel = (Data?) -> Void
    /// 下载完成回调
    public typealias xHandlerApiDownloadCompleted = (Bool, Any?) -> Void
    
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
    open class func formatterRequest(header: [String : String]?) -> [String : String]
    {
        let head = header ?? [String : String]()
        return head
    }
    /// 格式化Api请求参数
    open class func formatterRequest(parameter : [String : Any]?) -> [String : Any]
    {
        let parm = parameter ?? [String : Any]()
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
    // 解析成功数据
    open class func serializerResponse(data: Data) -> xApiResponseDataSerializerResult {
        // 尝试解析成JSON
        let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        return .init(state: .success, data: json)
    }
    open class func serializerResponse(string: String) -> xApiResponseDataSerializerResult {
        return .init(state: .success, data: string)
    }
    open class func serializerResponse(json: Any) -> xApiResponseDataSerializerResult {
        return .init(state: .success, data: json)
    }
    // 解析失败数据
    open class func serializerResponseError(code : Int?, data: Data?) -> xApiResponseDataSerializerResult {
        // 尝试解析成JSON
        guard let obj = data else {
            return .init(state: .failure, data: data)
        }
        let json = try? JSONSerialization.jsonObject(with: obj, options: .mutableContainers)
        return .init(state: .success, data: json)
    }
}
