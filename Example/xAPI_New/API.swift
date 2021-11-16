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
        return "https://mingdev.fudouzhongkang.com/api/"
    }
    // 添加公共头部（如时间戳）
    override class func formatterRequest(headers: [String : String]?) -> [String : String] {
        let obj = super.formatterRequest(headers: headers)
        return obj
    }
    // 添加公共参数（如用户Token）
    override class func formatterRequest(parameters: [String : Any]?) -> [String : Any] {
        let obj = super.formatterRequest(parameters: parameters)
        return obj
    }
    // 签名
    override class func formatterSign(url: String, header: [String : String], parameter: [String : Any]) -> String? {
        let obj = super.formatterSign(url: url, header: header, parameter: parameter)
        return obj
    }
    
    // MARK: - 重写响应配置
    /* 一般都会解析成JSON,在解析结果里面做进一步处理 */
    override class func serializerResponse(json: Any) -> xApiResponseDataSerializerResult {
        guard let info = json as? [String : Any] else {
            return .init(state: .failure, data: json)
        }
        // print(info)
        let code = info["code"] as! Int
        let msg = info["msg"] as! String
        msg.xAlertTip()
        let data = info["data"]
        return .init(state: .success, data: data)
    }
    /* 考虑一些奇葩风格（Restful）下失败用 ResponseCode 导致无法按照正常流程解析 */
    override class func serializerResponseError(code: Int?, data: Data?) -> xApiResponseDataSerializerResult {
        let obj = super.serializerResponseError(code: code, data: data)
        // 可以判断是否网页崩溃，直接显示网页
        return obj
    }
    
    // MARK: - 测试接口
    public static func testReq(completed : @escaping (Bool, [String : Any]) -> Void)
    {
        var parameter = [String : String]()
        parameter["page"] = "1"
        self.post(urlStr: "goods/category_list", headers: nil, parameters: parameter) {
            (result) in
            // isSuccess表示接口响应结果，失败不一定没数据，推荐用实际的Data来判断接口是否成功
            if let info = result.responseDataSerializerResult?.data as? [String : Any] {
                completed(true, info)
            } else {
                completed(false, .init())
            }
        }
    }
}
