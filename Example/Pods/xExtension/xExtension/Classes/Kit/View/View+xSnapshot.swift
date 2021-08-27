//
//  View+xSnapshot.swift
//  xExtension
//
//  Created by Mac on 2021/6/10.
//

import Foundation

extension UIView {
    
    // MARK: - 截图
    /// 截图
    public func xSnapshotImage() -> UIImage?
    {
        let ret = self.layer.xSnapshotImage()
        return ret
    }
    /// 截图并创建PDF
    public func xSnapshotPDF() -> Data?
    {
        let ret = self.layer.xSnapshotPDF()
        return ret
    }
}
