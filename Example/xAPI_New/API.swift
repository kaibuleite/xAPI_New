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
    // 主机域名
    override class func getHostDomainName() -> String {
        return "devmall.fudouzhongkang.com"
    }
    // 接口通用前缀
    override class func formatterUrlPrefix() -> String {
        return "https://devmall.fudouzhongkang.com/appapi.php?"
    }
    // 添加公共头部（如时间戳，数据摘要）
    override class func formatterRequest(headers: [String : String]?) -> [String : String] {
        let obj = super.formatterRequest(headers: headers)
        return obj
    }
    // 添加公共参数（如用户Token，数据摘要）
    override class func formatterRequest(parameters: [String : Any]?) -> [String : Any] {
        let obj = super.formatterRequest(parameters: parameters)
        return obj
    }
    // 签名、数据摘要
    override class func formatterSign(url: String,
                                      header: [String : String],
                                      parameter: [String : Any]) -> String?
    {
        let obj = super.formatterSign(url: url, header: header, parameter: parameter)
        return obj
    }
    
    // MARK: - 重写响应配置
    /* 一般都会解析成JSON,在解析结果里面做进一步处理 */
    /* 考虑一些其他接口类型（Restful）下失败用 ResponseCode 导致无法按照正常流程解析, 可以调用 xReq.response.responseError?.responseCode 查看响应失败码 */
    override class func analyzingResponse(at xReq: xRequest) {
        super.analyzingResponse(at: xReq)
    }
    /* 一般都是解析成字典*/
    override class func analyzingApiDictionaryData(_ dict: [String : Any], at xReq: xRequest) {
        super.analyzingApiDictionaryData(dict, at: xReq)
    }
    /* 常用字典类型接口数据处理*/
    override class func getApiCode(in dict: [String : Any]) -> Int {
        var code = 0
        if let obj = dict["errorCode"] as? Int      { code = obj } else
        if let obj = dict["errorCode"] as? String   { code = obj.xToInt() }
        return code
    }
    override class func getApiMessage(in dict: [String : Any]) -> String {
        var msg = ""
        if let obj = dict["errorMsg"] as? String    { msg = obj }
        return msg
    }
    override class func getApiData(in dict: [String : Any]) -> Any? {
        var data : Any?
        if let obj = dict["result"] { data = obj }
        return data
    }
    override class func validateApiState(at xReq: xRequest) {
        super.validateApiState(at: xReq)
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
