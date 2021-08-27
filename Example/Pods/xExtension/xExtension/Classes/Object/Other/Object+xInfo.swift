//
//  Object+xInfo.swift
//  xExtension
//
//  Created by Mac on 2021/6/10.
//

import Foundation

extension NSObject {
    
    /// 数据信息结构
    public struct xObjectInfoStruct {
        /// 命名空间
        public var space : String = ""
        /// 名称
        public var name : String = ""
        
        /// 初始化数据信息结构对象
        /// - Parameters:
        ///   - aClass: 类型
        /// - Returns: 结果
        public static func new(aClass : AnyClass) -> xObjectInfoStruct
        {
            let classStr = NSStringFromClass(aClass)
            // 直接转换类结构，格式为一般为 命名空间.类名
            let arr = classStr.components(separatedBy: ".")
            var ret = xObjectInfoStruct()
            if arr.count == 2 {
                // 直接拆分数组
                ret.space = arr[0]
                ret.name = arr[1]
            }
            else {
                // 从info.plist读取类结构
                let bundle = Bundle.init(for: aClass)
                if let info = bundle.infoDictionary {
                    if let name = info["CFBundleExecutable"] as? String {
                        ret.space = name
                    }
                }
                ret.name = classStr
            }
            return ret
        }
    }
    
    // MARK: - 类的信息结构
    /// 类的信息结构
    public class var xClassInfoStruct : xObjectInfoStruct
    {
        let ret = xObjectInfoStruct.new(aClass: self.classForCoder())
        return ret
    }
    
    // MARK: - 对象的信息结构
    /// 对象的信息结构
    public var xClassInfoStruct : xObjectInfoStruct
    {
        let ret = xObjectInfoStruct.new(aClass: self.classForCoder)
        return ret
    }
    
}
