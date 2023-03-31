//
//  Double+xNew.swift
//  xExtension
//
//  Created by Mac on 2023/3/30.
//

import Foundation

extension Double {
    
    /// 生产随机数
    public static func xNewRandom(max value : Double = 100) -> Double
    {
        let v1 = Int(arc4random()) % Int(value * 100)
        let v2 = Double(v1) / 100
        return v2
    }
    
    /// 生产随机数组
    public static func xNewRandomList(count : Int,
                                      max value : Double = 100) -> [Double]
    {
        var list = [Double]()
        for _ in 0 ..< count {
            let v = Double.xNewRandom(max: value)
            list.append(v)
        }
        return list
    }
    
}
