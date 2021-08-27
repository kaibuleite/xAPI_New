//
//  View+xLayout.swift
//  xExtension
//
//  Created by Mac on 2021/6/10.
//

import Foundation

extension UIView {
    
    /// 检测系统自动布局是否关闭
    /// - Returns: 关闭结果
    func xCheckAddLayoutRequirements() -> Bool
    {
        // 系统默认会给autoresizing 约束
        // 关闭autoresizing 不关闭否则程序崩溃
        self.translatesAutoresizingMaskIntoConstraints = false
        return true
    }
    
    // MARK: - 约束布局
    /// 添加自身布局
    /// - Parameters:
    ///   - attr1: 描述1
    ///   - relation: 关系
    ///   - multiplier: 系数
    ///   - constant: 变量
    public func xAddLayout(attribute attr1: NSLayoutConstraint.Attribute,
                           relatedBy relation: NSLayoutConstraint.Relation,
                           multiplier: CGFloat = 1,
                           constant: CGFloat = 0)
    {
        guard self.xCheckAddLayoutRequirements() else { return }
        let layout = NSLayoutConstraint.init(item: self,
                                             attribute: attr1,
                                             relatedBy: relation,
                                             toItem: nil,
                                             attribute: .notAnAttribute,
                                             multiplier: multiplier,
                                             constant: constant)
        self.addConstraint(layout)
    }
    
    /// 添加相对布局
    /// - Parameters:
    ///   - attr1: 描述1
    ///   - relation: 关系
    ///   - view2: 相对视图
    ///   - attr2: 描述2
    ///   - multiplier: 系数
    ///   - constant: 变量
    public func xAddLayout(attribute attr1: NSLayoutConstraint.Attribute,
                           relatedBy relation: NSLayoutConstraint.Relation,
                           toItem view2: UIView,
                           attribute attr2: NSLayoutConstraint.Attribute,
                           multiplier: CGFloat = 1,
                           constant: CGFloat = 0)
    {
        guard self.xCheckAddLayoutRequirements() else { return }
        let layout = NSLayoutConstraint.init(item: self,
                                             attribute: attr1,
                                             relatedBy: relation,
                                             toItem: view2,
                                             attribute: attr2,
                                             multiplier: multiplier,
                                             constant: constant)
        self.addConstraint(layout)
    }
    
    // MARK: - 对齐
    /// 添加上对齐
    /// - Parameters:
    ///   - view2: 相对视图
    ///   - constant: 变量
    public func xAddTopLayout(toItem view2: UIView,
                              constant: CGFloat = 0)
    {
        self.xAddLayout(attribute: .top, relatedBy: .equal, toItem: view2,
                        attribute: .top, multiplier: 1, constant: constant)
    }
    
    /// 添加下对齐
    /// - Parameters:
    ///   - view2: 相对视图
    ///   - constant: 变量
    public func xAddBottomLayout(toItem view2: UIView,
                                 constant: CGFloat = 0)
    {
        self.xAddLayout(attribute: .bottom, relatedBy: .equal, toItem: view2,
                        attribute: .bottom, multiplier: 1, constant: constant)
    }
    
    /// 添加左对齐
    /// - Parameters:
    ///   - view2: 相对视图
    ///   - constant: 变量
    public func xAddLeadingLayout(toItem view2: UIView,
                                  constant: CGFloat = 0)
    {
        self.xAddLayout(attribute: .leading, relatedBy: .equal, toItem: view2,
                        attribute: .leading, multiplier: 1, constant: constant)
    }
    
    /// 添加右对齐
    /// - Parameters:
    ///   - view2: 相对视图
    ///   - constant: 变量
    public func xAddTrailingLayout(toItem view2: UIView,
                                   constant: CGFloat = 0)
    {
        self.xAddLayout(attribute: .trailing, relatedBy: .equal, toItem: view2,
                        attribute: .trailing, multiplier: 1, constant: constant)
    }
    
    /// 添加全对齐
    /// - Parameters:
    ///   - view2: 相对视图
    ///   - constant: 变量   
    public func xAddFullLayout(toItem view2: UIView,
                               constant: CGFloat = 0)
    {
        self.xAddTopLayout(toItem: view2)
        self.xAddBottomLayout(toItem: view2)
        self.xAddLeadingLayout(toItem: view2)
        self.xAddTrailingLayout(toItem: view2)
    }
    
    // MARK: - 宽高
    /// 添加宽度约束
    /// - Parameters:
    ///   - constant: 变量
    ///   - relation: 关系
    public func xAddWidthLayout(constant: CGFloat,
                                relatedBy relation: NSLayoutConstraint.Relation = .equal)
    {
        self.xAddLayout(attribute: .width,
                        relatedBy: relation,
                        multiplier: 1,
                        constant: constant)
    }
    
    /// 添加高度约束
    /// - Parameters:
    ///   - constant: 变量
    ///   - relation: 关系
    public func xAddHeightLayout(constant: CGFloat,
                                 relatedBy relation: NSLayoutConstraint.Relation = .equal)
    {
        self.xAddLayout(attribute: .height,
                        relatedBy: relation,
                        multiplier: 1,
                        constant: constant)
    }
}
