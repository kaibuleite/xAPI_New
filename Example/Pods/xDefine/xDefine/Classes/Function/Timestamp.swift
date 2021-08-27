//
//  Timestamp.swift
//  xDefine
//
//  Created by Mac on 2021/6/10.
//

import Foundation

// MARK: - 时间戳
/// 秒级时间戳
public var xTimeStamp : Int
{
    let ts = Date().timeIntervalSince1970
    let ret = Int(ts)
    return ret
}

/// 毫秒级时间戳
public var xMillisecondTimeStamp : Int
{
    let ts = Date().timeIntervalSince1970
    let ret = Int(ts * 1000)
    return ret
}
