//
//  Color+xToValue.swift
//  xExtension
//
//  Created by Mac on 2021/6/10.
//

import Foundation

extension UIColor {
    
    // MARK: - 数据转换
    /// 转换成UIImage类型数据
    /// - Parameter size: 指定大小
    /// - Returns: 新图片
    public func xToImage(size : CGSize = .init(width: 1, height: 1)) -> UIImage?
    {
        let frame = CGRect.init(origin: .zero,
                                size: size)
        let view = UIView.init(frame: frame)
        view.backgroundColor = self
        // 绘画板
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        ctx.interpolationQuality = .none   // 高质量
        view.layer.render(in: ctx)
        let ret = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return ret
    }
}
