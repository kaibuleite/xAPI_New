//
//  View+xToValue.swift
//  xExtension
//
//  Created by Mac on 2021/6/10.
//

import Foundation

extension UIView {
    
    // MARK: - 数据转换
    /// 将当前视图转为UIImage
    /// - Parameter quality: 图片质量（默认无损）
    /// - Returns: 转换结果
    public func xToImage(quality : CGInterpolationQuality = .none) -> UIImage?
    {
        let frame = self.bounds
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        ctx.interpolationQuality = quality  // 高质量
        self.layer.render(in: ctx)
        let ret = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return ret
    }
}
