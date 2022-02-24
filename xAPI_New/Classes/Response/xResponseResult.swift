//
//  xResponseResult.swift
//  xAPI_New
//
//  Created by Mac on 2021/11/6.
//

import UIKit

public class xResponseResult: NSObject {
    
    // MARK: - Enum
    /// API响应结果
    public enum ResponseState {
        /// 成功
        case success
        /// 失败
        case failure
    }
    /// API响应数据解析
    public enum DataAnalyzingState {
        /// 成功
        case success
        /// 出错
        case failure
    }
    /// 服务器返回数据状态
    public enum ServerReturnDataState {
        /// 逻辑正常
        case normal
        /// 逻辑出错
        case error
    }
    
    // MARK: - Public Property
    /// API响应结果
    public var repState = ResponseState.success
    /// API响应数据解析(解析结果为 serverReturnDataState )
    public var repDataAnalyzingState = DataAnalyzingState.success
    /// 服务器返回数据状态
    public var serverReturnDataState = ServerReturnDataState.normal
    /// 服务器返回数据
    public var serverReturnData : Any?
    /// 提示信息
    public var tipMessage = ""
    /// 时间戳
    public var timestamp = ""
    
    // MARK: - Func 
    /// 打印内容
    public func log()
    {
        print(">>>>>> API响应")
        switch self.repState {
        case .success:  print("✅成功")
        case .failure:  print("❌失败")
        }
        print(">>> 响应数据解析")
        switch self.repDataAnalyzingState {
        case .success:  print("✅正常")
        case .failure:  print("❌错误")
        }
        print(">>> 解析结果(服务器返回数据)")
        if let obj = self.serverReturnData {
            print(obj)
        } else {
            print("NULL")
        }
    }
}
