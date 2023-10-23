//
//  xResponse.swift
//  xAPI_New
//
//  Created by Mac on 2021/11/6.
//

import UIKit
import Alamofire

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
    /// 编号
    public var number = 0
    /// 时间戳
    public let timestamp = "\(Int(Date().timeIntervalSince1970))"
    
    // TODO: 响应数据
    /// 响应状态
    public var responseState = xResponse.State.success
    /// 响应码
    public var responseError : AFError?
    /// 响应数据
    public var responseData : Any?
    /// 响应数据解析
    public var responseDataAnalyzing = DataAnalyzingState.success
    
    // TODO: 接口数据
    /// 接口状态
    public var apiState = xResponse.State.success
    /// 接口状态码
    public var apiCode = -1
    /// 接口提示信息
    public var apiMessage = "NULL"
    /// 接口数据
    public var apiData : Any?
    /// 接口数据解析
    public var apiDataAnalyzing = DataAnalyzingState.success
    
    // MARK: - 内存释放
    deinit {
        guard xAPI.isShowResponseDeinitTipMsg else { return }
        print("⚽️ Rep:\(self.number)\t\(self)")
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
        case .error:    print("❌错误")
        }
        print(">>> 接口数据解析")
        switch self.apiDataAnalyzing {
        case .success:  print("✅正常")
        case .error:    print("❌错误")
        }
        guard let data = self.apiData else { return }
        print(data)
    }
}
