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
                                encoding : ParameterEncoding = URLEncoding.default,
                                queue : DispatchQueue = .main,
                                progress : @escaping xAPI.xHandlerDownloadProgress,
                                completed : @escaping xAPI.xHandlerRequestCompleted) -> (DownloadRequest, xDownload)
    {
        // 格式化请求数据并保存
        let xReq = xDownload()
        xReq.number = xRequestNumber
        xReq.type = .download
        xReq.method = method
        xReq.encoding = encoding
        xReq.queue = queue
        
        xReq.url = self.formatterRequest(url: urlStr)
        xReq.headers = self.formatterRequest(headers: headers)
        xReq.parameters = self.formatterRequest(parameters: parameters)
        
        xReq.validate()
        // 创建AF请求
        let headers = xReq.getAlamofireHeaders()
        let afReq = AF.download(xReq.url, method: xReq.method, parameters: xReq.parameters, encoding: xReq.encoding, headers: headers) {
            (req) in
            // 配置超时时长
            req.timeoutInterval = self.getDownloadTimeoutInterval()
        }
        // 下载进度
        afReq.downloadProgress(queue: xReq.queue) {
            (pro) in
            let cur = pro.completedUnitCount
            let tot = pro.totalUnitCount
            let fra = pro.fractionCompleted
            progress(cur, tot, fra)
        }
        // 开始下载
        self.downloadResuming(afReq, xReq: xReq, completed: completed)
        xRequestNumber += 1
        return (afReq, xReq)
    }
    
    // MARK: - 取消下载
    /// 取消下载
    /// - Parameter request: 下载对象
    /// - Returns: 下载对象
    @discardableResult
    public static func downloadCancel(_ afReq : DownloadRequest,
                                      completed : @escaping xAPI.xHandlerDownloadCancel) -> DownloadRequest
    {
        afReq.cancel {
            (data) in
            completed(data)
        }
        return afReq
    }
    
    // MARK: - 继续下载
    /// 继续下载
    /// - Parameters:
    ///   - afReq: AF下载请求体
    ///   - xReq: 自定义下载请求体
    ///   - queue: 消息队列
    ///   - completed: 完成回调
    /// - Returns: 下载对象
    public static func downloadResuming(_ afReq : DownloadRequest,
                                        xReq : xDownload,
                                        queue : DispatchQueue = .main,
                                        completed : @escaping xAPI.xHandlerRequestCompleted)
    {
        xReq.queue = queue
        // 继续下载
        afReq.validate()
        afReq.response(queue: xReq.queue) {
            (afRep) in
            switch afRep.result {
            case let .success(data):
                xReq.response.responseState = .success
                xReq.response.responseData = data
                
            case let .failure(error):
                xReq.response.responseState = .failure
                xReq.response.responseData = afRep.resumeData
                xReq.response.responseError = error
            }
            self.analyzingResponse(at: xReq)
            completed(xReq)
        }
    }
    
}
