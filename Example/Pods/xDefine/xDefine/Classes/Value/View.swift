//
//  View.swift
//  xDefine
//
//  Created by Mac on 2021/6/10.
//

import UIKit

/// 当前窗口
public var xKeyWindow : UIWindow?
{
    var win : UIWindow?
    if #available(iOS 13.0, *) {
        let sceneList = UIApplication.shared.connectedScenes
        if let scene = sceneList.first {
            if let delegate = scene.delegate as? UIWindowSceneDelegate {
                win = delegate.window as? UIWindow
            }
        }
        if win == nil {
            win = UIApplication.shared.windows.last
        }
    } else {
        win = UIApplication.shared.keyWindow
    }
    return win
}

// MARK: - 当前ViewController
/// 当前ViewController
public var xCurrentViewController : UIViewController? {
    let root = xKeyWindow?.rootViewController
    let vc = xGetCurrentViewController(from: root)
    return vc
}
/// 获取当前的ViewController
public func xGetCurrentViewController(from rootVC : UIViewController?) -> UIViewController?
{
    var currentVC = rootVC
    while currentVC?.presentedViewController != nil {
        currentVC = currentVC?.presentedViewController!
    }
    if let tbc = currentVC as? UITabBarController {
        currentVC = xGetCurrentViewController(from: tbc.selectedViewController!)
    } else
    if let nvc = currentVC as? UINavigationController {
        currentVC = xGetCurrentViewController(from: nvc.visibleViewController!)
    }
    return currentVC
}
