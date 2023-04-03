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
    
    // MARK: - 内存释放
    deinit {
        print("🏈 Upload:\(self.number)\t\(self)")
    }
    
}
