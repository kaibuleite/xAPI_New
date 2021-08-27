//
//  ViewController+xTabbar.swift
//  xExtension
//
//  Created by Mac on 2021/6/10.
//

import Foundation

extension UIViewController {
    
    // MARK: - 设置Tabbar标题颜色
    /// 设置Tabbar默认标题颜色
    /// - Parameter color: 指定颜色
    public func setTabbarItemNormalTitleColor(_ color : UIColor)
    {
        let attr = [NSAttributedString.Key.foregroundColor : color]
        self.tabBarItem.setTitleTextAttributes(attr, for: .normal)
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance.init()
            let normal = appearance.stackedLayoutAppearance.normal
            normal.titleTextAttributes = attr
            self.tabBarItem.standardAppearance = appearance
        }
    }
    
    /// 设置Tabbar选中标题颜色
    /// - Parameter color: 指定颜色
    public func setTabbarItemSelectedTitleColor(_ color : UIColor)
    {
        let attr = [NSAttributedString.Key.foregroundColor : color]
        self.tabBarItem.setTitleTextAttributes(attr, for: .selected)
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance.init()
            let selected = appearance.stackedLayoutAppearance.selected
            selected.titleTextAttributes = attr
            self.tabBarItem.standardAppearance = appearance
        }
    }
}
