//
//  String+xEdit.swift
//  xExtension
//
//  Created by Mac on 2021/6/10.
//

import Foundation

extension String {
    
    // MARK: 读取输入框内容
    /// 读取输入框内容
    /// - Parameter input: 输入框
    /// - Returns: 读取成功
    @discardableResult
    public mutating func xRead(input : UITextField) -> Bool
    {
        self = input.text ?? ""
        if self.count == 0 {
            let msg = input.placeholder ?? ""
            if msg.count > 0 {
                msg.xAlertTip()
            }
        }
        return self.count > 0
    }
    
    /// 读取输入框内容
    /// - Parameter input: 输入框
    /// - Returns: 读取成功
    @discardableResult
    public mutating func xRead(input : UITextView) -> Bool
    {
        self = input.text ?? ""
        return self.count > 0
    }
}
