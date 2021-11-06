//
//  xRequestResult.swift
//  xAPI_New
//
//  Created by Mac on 2021/11/6.
//

import UIKit

public class xApiRequestResult: NSObject {
    
    // MARK: - Enum
    /// API请求状态
    public enum xApiRequestState {
        /// 成功
        case success
        /// 失败
        case failure
    }
    
    // MARK: - Public Property
    /// API请求状态
    public var state = xApiRequestState.success
    /// 解析结果
    public var responseDataSerializerResult : xApiResponseDataSerializerResult?
    
    // MARK: - Func
    /// 实例化
    public init(state : xApiRequestState,
                responseDataSerializerResult : xApiResponseDataSerializerResult? = nil)
    {
        self.state = state
        self.responseDataSerializerResult = responseDataSerializerResult
    }
    
    /// 打印内容
    public func log()
    {
        print("========== API请求 ")
        switch self.state {
        case .success:  print("✅成功")
        case .failure:  print("❌失败")
        }
        self.responseDataSerializerResult?.log()
    }
}
