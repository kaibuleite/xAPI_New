//
//  xDownload.swift
//  xAPI_New
//
//  Created by Mac on 2023/3/30.
//

import UIKit
import Alamofire

public class xDownload: xRequest {
    
    /// 上传进度回调
    public var progress : xAPI.xHandlerDownloadProgress?
    /// 上传取消回调
    public var cancel : xAPI.xHandlerDownloadCancel?
    
    // MARK: - 内存释放
    deinit {
        self.progress = nil
        self.cancel = nil
        self.completed = nil
        print("🏉 Download:\(self.number)\t\(self)")
    }
    
    // MARK: - AF请求体
    /// AF请求体
    public lazy var afDownloadReques : DownloadRequest = {
        // 头部处理
        let headers = self.getAlamofireHeaders()
        // 创建AF请求
        let req = AF.download(self.url, method: self.method, parameters: self.parameters, encoding: self.encoding, headers: headers) {
            (req) in
            // 配置超时时长
            req.timeoutInterval = xAPI.getDownloadTimeoutDuration()
        }
        // 下载进度
        req.downloadProgress(queue: self.queue) {
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
    public override func start()
    {
        self.afDownloadReques.responseData(queue: self.queue) {
            [weak self] (rep) in
            guard let self = self else { return }
            xAPI.checkDownloadResponse(rep, at: self)
        }
    }
}
