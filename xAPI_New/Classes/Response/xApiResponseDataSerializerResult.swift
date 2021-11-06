//
//  xApiResponseDataSerializerResult.swift
//  xAPI_New
//
//  Created by Mac on 2021/11/6.
//

import UIKit

public class xApiResponseDataSerializerResult: NSObject {
    
    // MARK: - Enum
    /// API响应数据解析状态
    public enum xApiResponseDataSerializerState {
        /// 成功
        case success
        /// 失败
        case failure
    }
    
    /// API响应数据解析结果
    public enum xApiResponseDataCodeState {
        /// 正常
        case normal
        /// 出错
        case error
    }
    
    // MARK: - Public Property
    /// API响应数据解析状态
    public var state = xApiResponseDataSerializerState.success
    /// API响应状态码
    public var code = xApiResponseDataCodeState.normal
    /// 提示信息
    public var msg = ""
    /// 时间戳
    public var timestamp = ""
    /// 解析结果
    public var data : Any? 
    
    // MARK: - Func
    /// 实例化
    public init(state : xApiResponseDataSerializerState,
                code : xApiResponseDataCodeState = .normal,
                data : Any? = nil)
    {
        self.state = state
        self.data = data
    }
    
    /// 打印内容
    public func log()
    {
        print("===== API响应数据解析")
        switch self.state {
        case .success:  print("✅成功")
        case .failure:  print("❌失败")
        }
        print("===== 响应数据逻辑")
        switch self.code {
        case .normal:   print("✅正常")
        case .error:    print("❌错误")
        }
        print("===== 响应数据解析结果")
        if let obj = self.data {
            print(obj)
        } else {
            print("NULL")
        }
    }
}
