//
//  Date+xTime.swift
//  xExtension
//
//  Created by Mac on 2021/6/10.
//

import Foundation

extension Date {
    
    // MARK: - 年
    /// 获取当前年份
    /// - Returns: 年份
    public func year() -> Int
    {
        let ret = NSCalendar.current.component(.year, from: self)
        return ret
    }
    
    // MARK: - 月
    /// 获取当前月份
    /// - Returns: 月份
    public func month() -> Int
    {
        let ret = NSCalendar.current.component(.month, from: self)
        return ret
    }
    
    // MARK: - 日
    /// 获取当前日期
    /// - Returns: 日期
    public func day() -> Int
    {
        let ret = NSCalendar.current.component(.day, from: self)
        return ret
    }
    
    // MARK: - 时
    /// 获取当前小时
    /// - Returns: 小时
    public func hour() -> Int
    {
        let ret = NSCalendar.current.component(.hour, from: self)
        return ret
    }
    
    // MARK: - 分
    /// 获取当前分钟
    /// - Returns: 分钟
    public func minute() -> Int
    {
        let ret = NSCalendar.current.component(.minute, from: self)
        return ret
    }
    
    // MARK: - 秒
    /// 获取当前秒数
    /// - Returns: 秒数
    public func second() -> Int
    {
        let ret = NSCalendar.current.component(.second, from: self)
        return ret
    }
    
    // MARK: - 毫秒
    /// 获取当前毫秒
    /// - Returns: 毫秒
    public func nanosecond() -> Int
    {
        let ret = NSCalendar.current.component(.nanosecond, from: self)
        return ret
    }
    
    // MARK: - 其他
    /// 获取当前时间其他信息
    /// - Returns: 其他信息
    public func other(component : Calendar.Component) -> Int
    {
        let ret = NSCalendar.current.component(component, from: self)
        return ret
    }
    
}
