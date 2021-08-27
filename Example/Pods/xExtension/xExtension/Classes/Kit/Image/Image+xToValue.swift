//
//  Image+xToValue.swift
//  xExtension
//
//  Created by Mac on 2021/6/10.
//

import Foundation

extension UIImage {
    
    // MARK: - 数据转换
    /// 转换成 UIColor 类型数据
    /// - Returns: 转换结果
    public func xToColor() -> UIColor
    {
        let ret = UIColor.init(patternImage: self)
        return ret
    }
    
    /// 圆角图片
    /// - Parameter radius: 圆角半径
    /// - Returns: 新图片
    public func xToCornerImage(radius : CGFloat) -> UIImage?
    {
        let rect = CGRect.init(origin: .zero,
                               size: self.size)
        let path = UIBezierPath.init(roundedRect: rect,
                                     cornerRadius: radius)
        let ret = self.xDraw(rect: rect,
                             path: path)
        return ret
    }
    
    /// 圆形图片
    /// - Returns: 新图片
    public func xToCircleImage() -> UIImage?
    {
        let radius = fmin(self.size.width, self.size.height) / 2.0
        let rect = CGRect.init(x: self.size.width / 2.0 - radius,
                               y: self.size.height / 2.0 - radius,
                               width: 2.0 * radius,
                               height: 2.0 * radius)
        let path = UIBezierPath.init(roundedRect: rect,
                                     cornerRadius: radius)
        let ret = self.xDraw(rect: rect,
                             path: path)
        return ret
    }
    
    /// 转换成自适应方向图片
    /// - Returns: 新图片 
    public func xToFixOrientationImage() -> UIImage?
    {
        var transform = CGAffineTransform.identity
        let w = self.size.width
        let h = self.size.height
        // 根据图片方向调整方向——水平
        switch self.imageOrientation {
        case .up:
            return self
        case .down, .downMirrored:
            transform = transform.translatedBy(x: w, y: h)
            transform = transform.rotated(by: .pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: w, y: 0)
            transform = transform.rotated(by: .pi/2)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: h)
            transform = transform.rotated(by: -.pi/2)
            break
        default:
            break
        }
        // 根据图片方向调整方向——垂直
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: w, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: h, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
        default:
            break
        }
        // 重新渲染
        guard let cgImage = self.cgImage else { return nil }
        guard let colorSpace = cgImage.colorSpace else { return nil }
        let ctx = CGContext.init(data: nil,
                                 width: Int(w),
                                 height: Int(h),
                                 bitsPerComponent: cgImage.bitsPerComponent,
                                 bytesPerRow: cgImage.bytesPerRow,
                                 space: colorSpace,
                                 bitmapInfo: cgImage.bitmapInfo.rawValue,
                                 releaseCallback: nil,
                                 releaseInfo: nil)
        guard let context = ctx else { return nil }
        // 配置旋转样式
        context.concatenate(transform)
        switch (self.imageOrientation) {
        case .left, .leftMirrored, .right, .rightMirrored:
            context.draw(cgImage, in: CGRect.init(x: 0, y: 0, width: h, height: w))
        default:
            context.draw(cgImage, in: CGRect.init(x: 0, y: 0, width: w, height: h))
        }
        guard let retCGImage = context.makeImage() else { return nil }
        let ret = UIImage(cgImage: retCGImage)
        return ret
    }
    
}
