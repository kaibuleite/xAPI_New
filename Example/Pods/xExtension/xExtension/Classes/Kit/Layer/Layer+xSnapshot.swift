//
//  Layer+xSnapshot.swift
//  xExtension
//
//  Created by Mac on 2021/6/10.
//

import Foundation

extension CALayer {

    // MARK: - 截图
    /// 截图
    public func xSnapshotImage() -> UIImage?
    {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        self.render(in: ctx)
        let ret = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return ret
    }
    /// 截图并创建PDF
    public func xSnapshotPDF() -> Data?
    {
        let data = NSMutableData.init()
        UIGraphicsBeginPDFContextToData(data, self.bounds, nil)
        UIGraphicsBeginPDFPage()
        guard let cxt = UIGraphicsGetCurrentContext() else { return nil }
        self.render(in: cxt)
        UIGraphicsEndPDFContext()
        return data as Data
    }
}
