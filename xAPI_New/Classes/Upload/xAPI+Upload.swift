//
//  xAPI+Upload.swift
//  xAPI_New
//
//  Created by Mac on 2021/8/27.
//

import Alamofire

extension xAPI {
    
    // MARK: - 上传文件
    /// 上传文件
    /// - Parameters:
    ///   - urlStr: 请求地址
    ///   - fileData: 文件
    ///   - fileKey: 文件标识
    ///   - fileName: 文件名称
    ///   - fileType: 文件类型
    ///   - method: 请求方式
    ///   - headers: 头部
    ///   - parameters: 参数
    ///   - encoding: 参数编码类型，默认URL，或者可以切换为JSON
    ///   - queue: 消息队列
    ///   - progress: 下载进度(已完成，总量)
    ///   - completed: 完成回调
    /// - Returns: 上传对象
    @discardableResult
    public static func upload(urlStr : String,
                              fileData : Data,
                              fileKey : String,
                              fileName : String,
                              fileType : xUploadFileType,
                              method : HTTPMethod = .post,
                              headers : [String : String]? = nil,
                              parameters : [String : Any]?,
                              encoding : ParameterEncoding = URLEncoding.default,
                              queue : DispatchQueue = .main,
                              progress : @escaping xAPI.xHandlerUploadProgress,
                              completed : @escaping xAPI.xHandlerRequestCompleted) -> (UploadRequest, xUpload)
    {
        // 格式化请求数据并保存
        let xReq = xUpload()
        xReq.number = xRequestNumber
        xReq.type = .upload
        xReq.method = method
        xReq.encoding = encoding
        xReq.queue = queue
        
        xReq.url = self.formatterRequest(url: urlStr)
        xReq.headers = self.formatterRequest(headers: headers)
        xReq.parameters = self.formatterRequest(parameters: parameters)
        
        xReq.fileData = fileData
        xReq.fileKey = fileKey
        xReq.fileName = fileName
        xReq.fileType = fileType
        
        xReq.validate()
        // 创建AF请求
        let headers = xReq.getAlamofireHeaders()
        let afReq = AF.upload(multipartFormData: {
            (formData) in
            // 把参数塞到表单里(仅限字符串)
            for (key, value) in xReq.parameters {
                guard let obj = value as? String else { continue }
                guard let data = obj.data(using: .utf8) else { continue }
                formData.append(data, withName: key)
            }
            // 把文件塞到表单里
            formData.append(xReq.fileData,
                            withName: xReq.fileKey,
                            fileName: xReq.fileName,
                            mimeType: xReq.fileType.mimeType)
            
        }, to: xReq.url, method: xReq.method, headers: headers) {
            (req) in
            // 配置超时时长
            req.timeoutInterval = self.getUploadTimeoutInterval()
        }
        // 上传进度
        afReq.uploadProgress(queue: xReq.queue) {
            (pro) in
            let cur = pro.completedUnitCount
            let tot = pro.totalUnitCount
            let fra = pro.fractionCompleted
            progress(cur, tot, fra)
        }
        // 开始上传
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
        return (afReq, xReq)
    }
}
