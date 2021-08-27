//
//  String+xAlert.swift
//  xExtension
//
//  Created by Mac on 2021/6/19.
//

import Foundation
import xDefine

extension String {
    
    // MARK: - 显示提示标签
    /// 显示提示标签
    public func xAlertTip(duration : Double = 2)
    {
        DispatchQueue.main.async {
            guard self.count > 0 else { return }
            // 移除旧控件
            guard let win = xKeyWindow else { return }
            let tag = 930421    // 固定tag
            win.viewWithTag(tag)?.removeFromSuperview()
            // 创建提示标签
            let lbl = UILabel.init()
            lbl.tag = tag
            lbl.text = self
            lbl.numberOfLines = 0
            lbl.preferredMaxLayoutWidth = xScreenWidth - 100
            lbl.textAlignment = .center
            lbl.textColor = .white
            lbl.backgroundColor = .init(white: 0, alpha: 0.8)
            lbl.layer.cornerRadius = 5
            lbl.layer.masksToBounds = true
            // 修改坐标
            let margin = UIEdgeInsets.init(top: 5, left: 8, bottom: 5, right: 8)
            let size = lbl.xContentSize(margin: margin)
            let frame = CGRect.init(origin: .zero,
                                    size: size)
            lbl.frame = frame
            lbl.center = CGPoint.init(x: win.bounds.size.width / 2.0,
                                      y: win.bounds.size.height / 2.0)
            win.addSubview(lbl)
            // 设置动画
            var time = duration
            if duration == 0 {
                time = 2.0 + 0.05 * Double(self.count)
            }
            lbl.alpha = 1
            UIView.animate(withDuration: time, animations: {
                lbl.alpha = 0
            }, completion: {
                (finish) in
                lbl.removeFromSuperview()
            })
        }
    }
    
}

