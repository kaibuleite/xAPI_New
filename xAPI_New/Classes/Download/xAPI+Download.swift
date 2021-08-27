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
    ///   - header: 头部
    ///   - parameter: 参数
    ///   - queue: 消息队列
    ///   - progress: 下载进度
    ///   - completed: 完成回调
    /// - Returns: 下载对象
    @discardableResult
    public static func download(urlStr : String,
                                method : HTTPMethod,
                                header : [String : String]?,
                                parameter : [String : Any]?,
                                queue : DispatchQueue = .main,
                                progress : @escaping xHandlerApiDownloadProgress,
                                completed : @escaping xHandlerApiDownloadCompleted) -> DownloadRequest
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
        let request = AF.download(fm_url, method: method, parameters: fm_parm, headers: ht_headers) 
        // 开始下载
        request.downloadProgress(queue: queue) {
            (pro) in
            let cur = pro.completedUnitCount
            let tot = pro.totalUnitCount
            let fra = pro.fractionCompleted
            progress(cur, tot, fra)
            
        }.responseData(queue: queue) {
            (rep) in
            switch rep.result {
            case let .success(obj):
                completed(true, obj)
                
            case let .failure(err):
                self.logRequestError(err)
                self.logRequestInfo(url: fm_url, method: method, header: fm_head, parameter: fm_parm)
                completed(false, nil)
            }
        }
        return request
    }
    
    // MARK: - 取消下载
    /// 取消下载
    /// - Parameter request: 下载对象
    /// - Returns: 下载对象
    @discardableResult
    public static func downloadCancel(request : DownloadRequest,
                                      completed : @escaping xHandlerApiDownloadCancel) -> DownloadRequest
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
    public static func downloadResuming(request : DownloadRequest,
                                        resumeData : Data?,
                                        queue : DispatchQueue = .main,
                                        progress : @escaping xHandlerApiDownloadProgress,
                                        completed : @escaping xHandlerApiDownloadCompleted) -> DownloadRequest
    {
        var req = request
        if let data = resumeData {
            // 继续下载
            req = AF.download(resumingWith: data)
        }
        req.downloadProgress(queue: queue) {
            (pro) in
            let cur = pro.completedUnitCount
            let tot = pro.totalUnitCount
            let fra = pro.fractionCompleted
            progress(cur, tot, fra)
            
        }.responseData(queue: queue) {
            (rep) in
            switch rep.result {
            case let .success(obj):
                completed(true, obj)
                
            case let .failure(err):
                self.logRequestError(err)
                completed(false, nil)
            }
        }
        return req
    }
}
