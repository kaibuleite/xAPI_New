//
//  Label+xRect.swift
//  xExtension
//
//  Created by Mac on 2021/6/10.
//

import Foundation

extension UILabel {
    
    // MARK: - 内容大小
    /// 计算内容大小
    /// - Parameters:
    ///   - margin: 边缘留空
    /// - Returns: 内容大小
    public func xContentSize(margin : UIEdgeInsets = .zero) -> CGSize
    {
        guard let str = self.text else { return self.bounds.size }
        guard str.count > 0 else { return self.bounds.size }
        var w = self.bounds.width
        var h = self.bounds.height
        if w <= 0 { w = UIScreen.main.bounds.width }
        if h <= 0 { h = UIScreen.main.bounds.height }
        let rect = CGSize.init(width: w, height: h)
        var size = str.xContentSize(for: self.font,
                                    rect: rect)
        size.width += (margin.left + margin.right)
        size.height += (margin.top + margin.bottom)
        return size
    }

}
