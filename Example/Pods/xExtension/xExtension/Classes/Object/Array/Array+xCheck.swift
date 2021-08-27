//
//  Array+xCheck.swift
//  xExtension
//
//  Created by Mac on 2021/6/10.
//

import Foundation

extension Array {

    // MARK: - 判断数组是否包含编号
    /// 判断数组是否包含编号
    /// - Parameter idx: 编号
    /// - Returns: 结果
    public func xContains(idx : Int) -> Bool
    {
        guard idx >= 0 else { return false }
        guard idx < self.count else { return false }
        return true
    }
    
}
