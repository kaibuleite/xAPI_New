//
//  Dictionary+xLog.swift
//  xExtension
//
//  Created by Mac on 2023/3/30.
//

import Foundation

extension Dictionary {
    
    // MARK: - 按顺序打印参数
    /// 按顺序打印参数
    public func xLogSortKeyValue()
    {
        guard let dict = self as? [String : Any?] else {
            print("⚠️ 格式不符合")
            print(self)
            return
        } 
        let keyArr = dict.keys.sorted()
        for key in keyArr {
            guard let value = dict[key] else { continue }
            if let v = value {
                print("\(key) = \(v)")
            } else {
                print("\(key) = nil")
            }
        }
        print("===============")
    }
}
