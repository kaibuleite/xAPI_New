//
//  xAPI+Download.swift
//  xAPI_New
//
//  Created by Mac on 2021/8/27.
//

import Alamofire

extension xAPI { 
    
    // MARK: - 下载文件
    /// 下载文件
    /// - Parameters:
    ///   - urlStr: 请求地址
    ///   - method: 请求方式
    ///   - headers: 头部
    ///   - parameters: 参数
    ///   - encoding: 参数编码类型，默认URL，或者可以切换为JSON
    ///   - queue: 消息队列
    ///   - progress: 下载进度
    ///   - completed: 完成回调
    /// - Returns: 下载对象
    @discardableResult
    public static func download(urlStr : String,
                                method : HTTPMethod,
                                headers : [String : String]?,
                                parameters : [String : Any]?,
                                encoding: ParameterEncoding = URLEncoding.default,
                                queue : DispatchQueue = .main,
                                progress : @escaping xAPI.xHandlerDownloadProgress,
                                completed : @escaping xAPI.xHandlerRequestCompleted) -> xDownload
    {
        // 格式化请求数据并保存
        let xReq = xDownload()
        xReq.number = xRequestNumber
        xReq.type = .download
        xReq.url = self.formatterRequest(url: urlStr)
        xReq.method = method
        xReq.headers = self.formatterRequest(headers: headers)
        xReq.parameters = self.formatterRequest(parameters: parameters)
        xReq.encoding = encoding
        xReq.queue = queue
        xReq.completed = completed
        
        xReq.progress = progress
        // 发起请求
        xRequestNumber += 1
        xApiRequstList["\(xReq.number)"] = xReq
        xReq.validate()
        xReq.send()
        return xReq
    }
    
    // MARK: - 取消下载
    /// 取消下载
    /// - Parameter request: 下载对象
    /// - Returns: 下载对象
    @discardableResult
    public static func downloadCancel(request : DownloadRequest,
                                      completed : @escaping xAPI.xHandlerDownloadCancel) -> DownloadRequest
    {
        request.cancel {
            (data) in
            completed(data)
        }
        return request
    }
    
    // MARK: - 继续下载
    /// 继续下载
    /// - Parameters:
    ///   - request: 下载对象
    ///   - resumeData: 下载到一半的数据
    ///   - queue: 消息队列
    ///   - progress: 下载进度
    ///   - completed: 完成回调
    /// - Returns: 下载对象
    @discardableResult
    public static func downloadResuming(request : xDownload,
                                        resumeData : Data?,
                                        queue : DispatchQueue = .main,
                                        progress : @escaping xAPI.xHandlerDownloadProgress,
                                        completed : @escaping xAPI.xHandlerRequestCompleted) -> xDownload
    {
        // 发起请求
        if let data = resumeData {
            // 继续下载
            request.afDownloadReques = AF.download(resumingWith: data)
        }
        // 继续下载
        xApiRequstList["\(request.number)"] = request
        request.send()
        return request
    }
}
