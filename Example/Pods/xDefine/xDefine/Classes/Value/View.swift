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
    }
    else {
        win = UIApplication.shared.keyWindow
    }
    return win
}
