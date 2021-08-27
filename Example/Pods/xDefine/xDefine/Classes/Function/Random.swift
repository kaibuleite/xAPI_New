//
//  Random.swift
//  xDefine
//
//  Created by Mac on 2021/6/10.
//

import Foundation

// MARK: - 随机返回某个区间范围内的值
/// 随机返回某个区间范围内的值
public func xRandomBetween(min : CGFloat,
                           max : CGFloat) -> CGFloat
{
    // 先取得他们之间的差值
    let sub = abs(max - min) + 1
    // 在差值间随机
    let mode = fmod(Double(arc4random()), Double(sub))
    //将随机的值加到较小的值上
    let ret = min + CGFloat(mode)
    return ret
}
