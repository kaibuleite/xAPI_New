//
//  Log.swift
//  xDefine
//
//  Created by Mac on 2021/6/10.
//

import Foundation

// MARK: - 自定义控制台打印方法
/// 自定义控制台打印方法
public func xLog(_ items: Any...,
                 showFuncInfo : Bool = false,
                 file: String = #file,
                 line: Int = #line,
                 method: String = #function)
{
    if showFuncInfo {
        print("\((file as NSString).lastPathComponent)\t [\(line)]\t \(method)")
    }
    var i = 0
    let j = items.count
    let separator = " "    // 分隔符
    let terminator = "\n"  // 终止符
    for a in items {
        i += 1
        print(a, terminator:i == j ? terminator: separator)
    }
}

// MARK: - 打印警告信息到控制台
/// 打印警告信息到控制台
public func xWarning(_ items: Any...,
                     showFuncInfo : Bool = false,
                     file: String = #file,
                     line: Int = #line,
                     method: String = #function) -> Void
{
    if showFuncInfo {
        print("\((file as NSString).lastPathComponent)\t [\(line)]\t \(method)")
    }
    var i = 0
    let j = items.count
    let separator = " "    // 分隔符
    let terminator = "\n"  // 终止符
    for a in items {
        if i == 0 {
            print("⚠️⚠️⚠️⚠️⚠️ ", terminator: separator)
        }
        print(a, terminator: separator)
        i += 1
        if i == j {
            print(" ⚠️⚠️⚠️⚠️⚠️", terminator: terminator)
        }
    }
}
