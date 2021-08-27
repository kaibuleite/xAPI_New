//
//  Image+xEdit.swift
//  xExtension
//
//  Created by Mac on 2021/6/10.
//

import Foundation

extension UIImage {
    
    // MARK: - 图片缩放
    /// 缩放图片(等比例)
    /// - Parameter size: 缩放大小
    /// - Returns: 新图片
    public func xScaleTo(size : CGSize) -> UIImage?
    {
        let factor_w = size.width / self.size.width
        let factor_h = size.height / self.size.height
        let factor = fmin(factor_w, factor_h)
        // 计算等比数据
        let w = self.size.width * factor
        let h = self.size.height * factor
        let size = CGSize.init(width: w,
                               height: h)
        let rect = CGRect.init(origin: .zero,
                               size: size)
        let path = UIBezierPath.init(rect: rect)
        let ret = self.xDraw(rect: rect,
                             path: path)
        return ret
    }
    
    /// 根据宽度等比例缩放图片
    /// - Parameter width: 宽度
    /// - Returns: 新图片
    public func xAutoScaleTo(width : CGFloat) -> UIImage?
    {
        let w = width
        // 计算等比数据
        let h = w * self.size.height / self.size.width
        let size = CGSize.init(width: w,
                               height: h)
        let rect = CGRect.init(origin: .zero,
                               size: size)
        let path = UIBezierPath.init(rect: rect)
        let ret = self.xDraw(rect: rect,
                             path: path)
        return ret
    }
    
    /// 根据高度等比例缩放图片
    /// - Parameter height: 高度
    /// - Returns: 新图片
    public func xAutoScaleTo(height : CGFloat) -> UIImage?
    {
        let h = height
        // 计算等比数据
        // 计算等比数据
        let w = h * self.size.width / self.size.height
        let size = CGSize.init(width: w,
                               height: h)
        let rect = CGRect.init(origin: .zero,
                               size: size)
        let path = UIBezierPath.init(rect: rect)
        let ret = self.xDraw(rect: rect,
                             path: path)
        return ret
    }
    
    // MARK: - 重新绘制图片
    /// 重新绘制图片
    /// - Parameters:
    ///   - rect: 绘制范围
    ///   - path: 绘制路径（裁剪路径）
    /// - Returns: 新图片
    func xDraw(rect : CGRect,
               path : UIBezierPath) -> UIImage?
    {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        ctx.interpolationQuality = .none   // 高质量
        ctx.addPath(path.cgPath)
        ctx.clip()
        self.draw(in: rect)
        let ret = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return ret
    }
    
    // MARK: - 图片压缩
    /// 压缩图片
    /// - Parameter size: 指定尺寸(kb)
    /// - Returns: 新图片
    public func xCompressTo(size : CGFloat) -> Data?
    {
        // 原始大小
        var data = self.jpegData(compressionQuality: 1)
        guard size > 0 else { return data }
        
        var kb = CGFloat(data?.count ?? 0) / 1024
        var quality = CGFloat(1)
        var sub = CGFloat(0.05) // 每次递减
        while kb > size {
            if quality < sub { sub /= 2 }
            quality -= sub
            data = self.jpegData(compressionQuality: quality)
            kb = CGFloat(data?.count ?? 0) / 1024
        }
        return data
    }
    
    // MARK: - 图片裁剪
    /// 裁剪图片
    /// - Parameter rect: 剪范围裁
    /// - Returns: 新图片
    public func xCut(rect : CGRect) -> UIImage?
    {
        let path = UIBezierPath.init(rect: rect)
        let ret = self.xDraw(rect: rect,
                             path: path)
        return ret
    }
    
    // MARK: - 图片拼接
    /// 拼接图片
    /// - Parameters:
    ///   - image: 要拼接的图片
    ///   - spacing: 是两张图片的间距,默认为0
    /// - Returns: 新图片
    public func xAppend(image : UIImage,
                        spacing : Double = 0) -> UIImage?
    {
        let w = self.size.width + image.size.width + CGFloat(spacing)
        let h = fmax(self.size.height, image.size.height)
        // 自身图片
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: w, height: h), false, 0)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        ctx.interpolationQuality = .none   // 高质量
        var rect = CGRect.init()
        rect.origin.y = (h - self.size.height) / 2.0
        rect.size = self.size
        self.draw(in: rect)
        // 要拼接的图片
        rect.origin.x = self.size.width + CGFloat(spacing)
        rect.origin.y = (h - image.size.height) / 2.0
        rect.size = image.size
        image.draw(in: rect)
        // 拼接
        let ret = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return ret
    }
    
    // MARK: - 图片覆盖
    /// 覆盖图片
    /// - Parameters:
    ///   - image: 要覆盖的图片
    ///   - frame: 覆盖位置、大小
    /// - Returns: 新图片
    public func xCover(image : UIImage,
                       frame : CGRect) -> UIImage?
    {
        // 自身图片
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        ctx.interpolationQuality = .none   // 高质量
        self.draw(in: CGRect.init(origin: CGPoint.zero, size: self.size))
        image.draw(in: frame)
        // 要覆盖的图片
        let ret = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return ret
    }
    
    /// 覆盖图片到自己中心
    /// - Parameter image: 要覆盖的图片
    /// - Returns: 新图片
    public func xCoverCenter(image : UIImage) -> UIImage?
    {
        let x = (self.size.width - image.size.width) / 2.0
        let y = (self.size.height - image.size.height) / 2.0
        let center = CGPoint.init(x: x,
                                  y: y)
        let frame = CGRect.init(origin: center,
                                size: image.size)
        let ret = self.xCover(image: image,
                              frame: frame)
        return ret
    }
}
