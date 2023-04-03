//
//  xDownload.swift
//  xAPI_New
//
//  Created by Mac on 2023/3/30.
//

import UIKit
import Alamofire

public class xDownload: xRequest {
    
    // MARK: - 内存释放
    deinit {
        print("🏉 Download:\(self.number)\t\(self)")
    }
    
}
