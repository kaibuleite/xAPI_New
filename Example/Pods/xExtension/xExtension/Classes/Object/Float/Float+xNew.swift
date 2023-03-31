//
//  Float+xNew.swift
//  xExtension
//
//  Created by Mac on 2023/3/30.
//

import Foundation

extension CGFloat {
    
    /// 生产随机数
    public static func xNewRandom(max value : CGFloat = 100) -> CGFloat
    {
        let v1 = Int(arc4random()) % Int(value * 100)
        let v2 = CGFloat(v1) / 100
        return v2
    }
    /// 生产随机数组
    public static func xNewRandomList(count : Int,
                                      max value : CGFloat = 100) -> [CGFloat]
    {
        var list = [CGFloat]()
        for _ in 0 ..< count {
            let v = CGFloat.xNewRandom(max: value)
            list.append(v)
        }
        return list
    }
    
}
