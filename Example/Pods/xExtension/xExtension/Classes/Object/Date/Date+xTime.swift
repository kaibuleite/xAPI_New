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
    public func xYear() -> Int
    {
        let ret = NSCalendar.current.component(.year, from: self)
        return ret
    }
    
    // MARK: - 月
    /// 获取当前月份
    /// - Returns: 月份
    public func xMonth() -> Int
    {
        let ret = NSCalendar.current.component(.month, from: self)
        return ret
    }
    
    // MARK: - 日
    /// 获取当前日期
    /// - Returns: 日期
    public func xDay() -> Int
    {
        let ret = NSCalendar.current.component(.day, from: self)
        return ret
    }
    
    // MARK: - 时
    /// 获取当前小时
    /// - Returns: 小时
    public func xHour() -> Int
    {
        let ret = NSCalendar.current.component(.hour, from: self)
        return ret
    }
    
    // MARK: - 分
    /// 获取当前分钟
    /// - Returns: 分钟
    public func xMinute() -> Int
    {
        let ret = NSCalendar.current.component(.minute, from: self)
        return ret
    }
    
    // MARK: - 秒
    /// 获取当前秒数
    /// - Returns: 秒数
    public func xSecond() -> Int
    {
        let ret = NSCalendar.current.component(.second, from: self)
        return ret
    }
    
    // MARK: - 其他
    /// 获取当前时间其他信息
    /// - Returns: 其他信息
    public func xData(with component : Calendar.Component) -> Int
    {
        let ret = NSCalendar.current.component(component, from: self)
        return ret
    }

    // MARK: - 创建日期对象
    /// 根据年月日创建日期对象
    /// - Parameters:
    ///   - year: 年
    ///   - month: 月
    ///   - day: 日
    /// - Returns: 日期对象
    public static func xNew(year : Int,
                            month : Int,
                            day : Int) -> Date?
    {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        
        let calendar = Calendar.current
        let date = calendar.date(from: components)
        return date
    }
    
    /// 根据时间戳创建日期对象
    /// - Parameters:
    ///   - timestamp: 时间戳
    ///   - isMillisecond: 是否毫秒级
    /// - Returns: 日期对象
    public static func xNew(timestamp : TimeInterval,
                            isMillisecond : Bool = false) -> Date?
    {
        var ts = timestamp
        if isMillisecond {
            ts /= 1000
        }
        let date = Date.init(timeIntervalSince1970: ts)
        return date
    }
    /// 根据时间戳创建日期对象
    /// - Parameters:
    ///   - timestamp: 时间戳
    ///   - isMillisecond: 是否毫秒级
    /// - Returns: 日期对象
    public static func xNew(timestamp : String,
                            isMillisecond : Bool = false) -> Date?
    {
        let ts = timestamp.xToDouble()
        return self.xNew(timestamp: ts, isMillisecond: isMillisecond)
    }
    
    
    // MARK: - 获取当前月份有多少天
    /// 获取当前月份有多少天
    /// - Returns: 天数
    public func xGetDaysInMonth() -> Int 
    {
        var components = DateComponents()
        components.year = self.xYear()
        components.month = self.xMonth()
        components.day = 0
        
        let calendar = Calendar.current
        guard let date = calendar.date(from: components) else { return 0 }
        guard let range = calendar.range(of: .day, in: .month, for: date) else { return 0 }
        let daysCount = range.count
        return daysCount
    }
    
}
