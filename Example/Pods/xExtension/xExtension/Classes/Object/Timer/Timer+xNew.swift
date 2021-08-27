//
//  Timer+xNew.swift
//  xExtension
//
//  Created by Mac on 2021/6/10.
//

import Foundation

extension Timer {
    
    // MARK: - Handler
    /// 定时器触发回调
    public typealias xHandlerTimerInvoke = (Timer) -> Void
    
    // MARK: - Public Func
    /// 创建定时器
    /// - Parameters:
    ///   - timeInterval: 间隔
    ///   - repeats: 是否重复
    ///   - block: 回调
    public static func xNew(timeInterval : TimeInterval,
                            repeats : Bool,
                            handler : @escaping xHandlerTimerInvoke) -> Timer
    {
        let timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                         target: self,
                                         selector: #selector(timerInvoke(_:)),
                                         userInfo: handler,
                                         repeats: repeats)
        return timer
    }
    
    // MARK: - Private Func
    /// 触发回调
    @objc private static func timerInvoke(_ timer : Timer)
    {
        let block = timer.userInfo as? xHandlerTimerInvoke
        block?(timer)
    }
}
