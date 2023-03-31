//
//  xUpload.swift
//  xAPI_New
//
//  Created by Mac on 2023/3/30.
//

import UIKit
import Alamofire

public class xUpload: xRequest {
    
    /// 文件
    public var fileData = Data()
    /// 文件名称
    public var fileName = ""
    /// 文件上传Key
    public var fileKey = ""
    /// 文件类型
    public var fileType = xAPI.xUploadFileType.jpg
    /// 上传进度回调
    public var progress : xAPI.xHandlerUploadProgress?
    /// 上传取消回调
    public var cancel : xAPI.xHandlerUploadCancel?
    
    // MARK: - 内存释放
    deinit {
        self.progress = nil
        self.cancel = nil
        self.completed = nil
        print("🏈 Upload:\(self.number)\t\(self)")
    }
    
    // MARK: - AF请求体
    /// AF请求体
    public lazy var afUploadReques : UploadRequest = {
        // 头部处理
        let headers = self.getAlamofireHeaders()
        // 创建AF请求
        let req = AF.upload(multipartFormData: {
            (formData) in
            // 把参数塞到表单里(仅限字符串)
            for (key, value) in self.parameters {
                guard let obj = value as? String else { continue }
                guard let data = obj.data(using: .utf8) else { continue }
                formData.append(data, withName: key)
            }
            // 把文件塞到表单里
            formData.append(self.fileData,
                            withName: self.fileKey,
                            fileName: self.fileName,
                            mimeType: self.fileType.mimeType)
            
        }, to: self.url, method: self.method, headers: headers) {
            (req) in
            // 配置超时时长
            req.timeoutInterval = xAPI.getUploadTimeoutDuration()
        }
        // 上传进度
        req.uploadProgress(queue: self.queue) {
            (pro) in
            let cur = pro.completedUnitCount
            let tot = pro.totalUnitCount
            let fra = pro.fractionCompleted
            self.progress?(cur, tot, fra)
        }
        return req.validate()
    }()
    
    // MARK: - 发送请求
    /// 发送请求
    public override func start() {
        self.afUploadReques.responseData(queue: self.queue) {
            [weak self] (rep) in
            guard let self = self else { return }
            xAPI.checkUploadResponse(rep, at: self)
        }
    }
}
