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
                              encoding: ParameterEncoding = URLEncoding.default,
                              queue : DispatchQueue = .main,
                              progress : @escaping xAPI.xHandlerUploadProgress,
                              completed : @escaping xAPI.xHandlerRequestCompleted) -> xUpload
    {
        // 格式化请求数据并保存
        let xReq = xUpload()
        xReq.number = xRequestNumber
        xReq.type = .upload
        xReq.url = self.formatterRequest(url: urlStr)
        xReq.method = method
        xReq.headers = self.formatterRequest(headers: headers)
        xReq.parameters = self.formatterRequest(parameters: parameters)
        xReq.encoding = encoding
        xReq.queue = queue
        xReq.completed = completed
        
        xReq.fileData = fileData
        xReq.fileKey = fileKey
        xReq.fileName = fileName
        xReq.fileType = fileType
        xReq.progress = progress
        // 发起请求
        xRequestNumber += 1
        xApiRequstList["\(xReq.number)"] = xReq
        xReq.validate()
        xReq.start()
        return xReq
    }
}
