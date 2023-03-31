//
//  xResponse.swift
//  xAPI_New
//
//  Created by Mac on 2021/11/6.
//

import UIKit

public class xResponse: NSObject {
    
    // MARK: - Enum
    /// 响应状态
    public enum State {
        /// 成功
        case success
        /// 失败
        case failure
    }
    /// 响应数据解析
    public enum DataAnalyzingState {
        /// 成功
        case success
        /// 出错
        case error
    }
    
    // MARK: - Public Property
    // TODO: 请求体
    /// 请求体
    public var request : xRequest!
    /// 时间戳
    public var timestamp = ""
    /// 编号
    public var number = 0
    
    // TODO: 响应数据
    /// 响应状态
    public var responseState = xResponse.State.success
    /// 响应码
    public var responseCode = 200
    /// 出错原因
    public var responseErrorReason = ""
    /// 响应数据解析
    public var responseDataAnalyzing = DataAnalyzingState.success
    /// 响应数据
    public var responseData : Any?
    
    // TODO: 服务器数据
    /// 接口状态
    public var apiState = xResponse.State.success
    /// 接口状态码
    public var apiCode = -1
    /// 接口提示信息
    public var apiMessage = "NULL"
    /// 接口数据解析
    public var apiDataAnalyzing = DataAnalyzingState.success
    /// 接口数据
    public var apiData : Any?
    
    // MARK: - 内存释放
    deinit {
        print("⚽️ Response:\(self.number)\t\(self)")
    }
    
    // MARK: - 实例化对象
    required init(from request : xRequest) {
        self.request = request
        self.timestamp = "\(Int(Date().timeIntervalSince1970))"
        self.number = request.number
    }
    
    // MARK: - 打印内容
    /// 打印内容
    public func log()
    {
        print(">>> API响应")
        switch self.responseState {
        case .success:  print("✅成功")
        case .failure:  print("❌失败")
        }
        print(">>> 响应数据解析")
        switch self.responseDataAnalyzing {
        case .success:  print("✅正常")
        case .error:  print("❌错误")
        }
        print(">>> 接口数据解析")
        switch self.apiDataAnalyzing {
        case .success:  print("✅正常")
        case .error:  print("❌错误")
        }
    }
}
