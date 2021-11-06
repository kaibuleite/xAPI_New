//
//  xApiResponseDataSerializerResult.swift
//  xAPI_New
//
//  Created by Mac on 2021/11/6.
//

import UIKit

public class xApiResponseDataSerializerResult: NSObject {
    
    /// API响应数据解析状态
    public enum xApiResponseDataSerializerState {
        /// 成功
        case success
        /// 失败
        case failure
    }
    
    /// API请求状态
    public var state = xApiResponseDataSerializerState.success
    /// 解析结果
    public var data : Any? 

    /// 实例化
    public init(state : xApiResponseDataSerializerState,
                data : Any? = nil)
    {
        self.state = state
        self.data = data
    }
    
    /// 打印内容
    public func log()
    {
        switch self.state {
        case .success:  print("API响应数据解析 ✅成功\n")
        case .failure:  print("API响应数据解析 ❌失败\n")
        }
        print("API响应数据解析结果:")
        if let obj = self.data {
            print(obj)
        } else {
            print("NULL")
        }
    }
}
