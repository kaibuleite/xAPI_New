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
                              method : HTTPMethod,
                              headers : [String : String]?,
                              parameters : [String : Any]?,
                              encoding: ParameterEncoding = URLEncoding.default,
                              queue : DispatchQueue = .main,
                              progress : @escaping xHandlerUploadProgress,
                              completed : @escaping xHandlerUploadCompleted) -> UploadRequest
    {
        // 格式化请求数据
        var fm_url = self.formatterRequest(url: urlStr)
        var fm_parm = self.formatterRequest(parameters: parameters)
        let fm_head = self.formatterRequest(headers: headers)
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
        let request = AF.upload(multipartFormData: {
            (multipartFormData) in
            // 把参数塞到表单里(仅限字符串)
            for (key, value) in fm_parm {
                guard let obj = value as? String else { continue }
                guard let data = obj.data(using: .utf8) else { continue }
                multipartFormData.append(data, withName: key)
            }
            // 把文件塞到表单里
            multipartFormData.append(fileData,
                                     withName: fileKey,
                                     fileName: fileName,
                                     mimeType: fileType.mimeType)
            
        }, to: fm_url, method: method, headers: ht_headers) {
            (req) in
            req.timeoutInterval = xAPI.getUploadTimeoutDuration() // 配置超时时长
        }.validate()
        // 上传进度
        request.uploadProgress(queue: queue, closure: {
            (pro) in 
            let cur = pro.completedUnitCount
            let tot = pro.totalUnitCount
            let fra = pro.fractionCompleted
            progress(cur, tot, fra) 
        })
        // 发起请求
        request.responseData(queue: queue) {
            (rep) in
            switch rep.result {
            case let .success(obj):
                let ret = self.analyzingResponse(data: obj)
                ret.repState = .success
                completed(ret)
                
            case let .failure(err):
                let ret = self.analyzingResponseFailure(code: err.responseCode,
                                                        data: rep.data)
                ret.repState = .failure
                completed(ret)
                // 打印请示求败日志
                self.logRequestError(err)
                self.logRequestInfo(url: fm_url,
                                    method: method,
                                    header: fm_head,
                                    parameter: fm_parm)
            }
        }
        return request
    }
}
