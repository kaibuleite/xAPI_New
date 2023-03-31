//
//  View+xEdit.swift
//  xExtension
//
//  Created by Mac on 2021/6/10.
//

import Foundation

extension UIView {
    
    // MARK: - 子控件
    /// 移除所有子控件
    public func xRemoveAllSubViews()
    {
        for obj in self.subviews {
            obj.removeFromSuperview()
        }
    }
    
    // MARK: - 设置阴影
    /// 设置阴影
    public func xSetShadow(color : UIColor,
                           offset : CGSize,
                           radius : CGFloat)
    {
        self.layer.xSetShadow(color: color, offset: offset, radius: radius)
    }
    
    // MARK: - 设置锚点
    /// 重置锚点
    /// - Parameter anchorPoint: 新锚点
    public func xSetAnchor(point : CGPoint)
    {
        let origin_old = self.frame.origin
        self.layer.anchorPoint = point
        let origin_new = self.frame.origin
        
        var center = self.center
        center.x -= (origin_new.x - origin_old.x)
        center.y -= (origin_new.y - origin_old.y)
        
        self.center = center
    }
    

}
