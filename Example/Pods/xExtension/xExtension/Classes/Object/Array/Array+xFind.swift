//
//  Array+xFind.swift
//  xExtension
//
//  Created by Mac on 2021/6/10.
//

import Foundation

extension Array {

    // MARK: - 根据数据编号查找对象
    /// 根据数据编号查找对象
    /// - Parameter idx: 数据编号
    /// - Returns: 查找结果
    public func xObject(at idx : Int) -> Element?
    {
        guard idx >= 0 else { return nil }
        guard idx < self.count else { return nil }
        let obj = self[idx]
        return obj
    }
    
    // MARK: - 根据数据对象查找编号
    /// 查找数据编号
    /// - Parameters:
    ///   - object: 其他对象数据
    /// - Returns: 查找结果
    public func xIndex(with object : AnyObject) -> Int?
    {
        for (i, element) in self.enumerated() {
            let obj = element as AnyObject
            guard obj.isEqual(object) else { continue }
            return i
        }
        return nil
    }
    
    /// 查找数据编号
    /// - Parameters:
    ///   - object: 整数对象数据
    /// - Returns: 查找结果
    public func xIndex(with object : Int) -> Int?
    {
        for (i, element) in self.enumerated() {
            guard let obj = element as? Int else { continue }
            guard obj == object else { continue }
            return i
        }
        return nil
    }
    
    /// 查找数据编号
    /// - Parameters:
    ///   - object: 浮点数对象数据
    /// - Returns: 查找结果
    public func xIndex(with object : Float) -> Int?
    {
        for (i, element) in self.enumerated() {
            guard let obj = element as? Float else { continue }
            guard obj == object else { continue }
            return i
        }
        return nil
    }
    
    /// 查找数据编号
    /// - Parameters:
    ///   - object: 浮点数对象数据
    /// - Returns: 查找结果
    public func xIndex(with object : Double) -> Int?
    {
        for (i, element) in self.enumerated() {
            guard let obj = element as? Double else { continue }
            guard obj == object else { continue }
            return i
        }
        return nil
    }
    
    /// 查找数据编号
    /// - Parameters:
    ///   - object: 字符串对象数据
    /// - Returns: 查找结果
    public func xIndex(with object : String) -> Int?
    {
        for (i, element) in self.enumerated() {
            guard let obj = element as? String else { continue }
            guard obj == object else { continue }
            return i
        }
        return nil
    }
    
}
