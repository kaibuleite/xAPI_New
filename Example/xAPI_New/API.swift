//
//  API.swift
//  xAPI_New_Example
//
//  Created by Mac on 2021/8/27.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Alamofire
import xAPI_New

class API: xAPI_New.xAPI {

    // MARK: - 重写请求配置
    // 接口通用前缀
    override class func formatterUrlPrefix() -> String {
        return "https://devmall.fudouzhongkang.com/appapi.php?"
    }
    // 添加公共头部（如时间戳）
    override class func formatterRequest(headers: [String : String]?) -> [String : String]
    {
        let obj = super.formatterRequest(headers: headers)
        return obj
    }
    // 添加公共参数（如用户Token）
    override class func formatterRequest(parameters: [String : Any]?) -> [String : Any]
    {
        let obj = super.formatterRequest(parameters: parameters)
        return obj
    }
    // 签名
    override class func formatterSign(url: String,
                                      header: [String : String],
                                      parameter: [String : Any]) -> String?
    {
        let obj = super.formatterSign(url: url, header: header, parameter: parameter)
        return obj
    }
    
    // MARK: - 重写响应配置
    /* 一般都会解析成JSON,在解析结果里面做进一步处理 */
    override class func analyzingResponse(data: Data) -> xResponseResult
    {
        let ret = super.analyzingResponse(data: data)
        // print(ret.serverReturnData)
        guard let info = ret.serverReturnData as? [String : Any] else {
            ret.serverReturnDataState = .error
            return ret
        }
        print(info)
        let code = info["errorCode"] as? Int ?? 0
        if code == 1 {
            ret.serverReturnDataState = .normal
        } else {
            ret.serverReturnDataState = .error
        }
        if let obj = info["errorMsg"] as? String {
            ret.tipMessage = obj
            obj.xAlertTip()
        }
        let data = info["result"]
        ret.serverReturnData = data
        return ret
    }
    
    /* 考虑一些奇葩风格（Restful）下失败用 ResponseCode 导致无法按照正常流程解析 */
    override class func analyzingResponseFailure(code: Int?,
                                                 data: Data?) -> xResponseResult
    {
        let obj = super.analyzingResponseFailure(code: code, data: data)
        // 可以判断是否网页崩溃，直接显示网页
        return obj
    }
    
    // MARK: - 测试接口
    public static func testReq(completed : @escaping (Bool, [String : Any]) -> Void)
    {
        var parameter = [String : String]()
        parameter["page"] = "1"
        self.post(urlStr: "c=Merchantapp&a=cityList", headers: nil, parameters: parameter) {
            (result) in
            // 响应失败不一定没数据，推荐用服务器实际返回的Data来判断接口是否成功
            if let info = result.serverReturnData as? [String : Any] {
                completed(true, info)
            } else {
                completed(false, .init())
            }
        }
    }
}

// MARK: - 响应数据的另一种写法(参考)
// 响应结果
struct ResponseResult: Codable {
    let state: Bool?
    let body: Body?
}
// 响应内容
struct Body: Codable {
    let retCode: String?
    let retMsg: String?
    let timestamp: String?
    let repData: ResponseData?
    // 映射表
    enum CodingKeys: String, CodingKey {
        case retCode = "ret_code"
        case retMsg = "ret_msg"
        case timestamp = "timestamp"
        case repData = "response_data"
    }
}
// 响应数据
struct ResponseData: Codable {
    let token: String?
//    let oter: Any?
    // 映射表
    enum CodingKeys: String, CodingKey {
        case token = "token"
    }
}
