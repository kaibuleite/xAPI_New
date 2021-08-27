//
//  View+xFrame.swift
//  xExtension
//
//  Created by Mac on 2021/6/10.
//

import Foundation

extension UIView {
    
    // MARK: - 坐标
    /* 为了防止跟其他的框架命名冲突，这边不直接取名 x、y、w、h */
    /// 坐标
    public var xOrigin : CGPoint {
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin
        }
    }
    /// x坐标
    public var xOriginX : CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.x
        }
    }
    /// y坐标
    public var xOriginY : CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.y
        }
    }
    
    // MARK: - 尺寸
    /// 长宽
    public var xSize : CGSize {
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
        get {
            return self.frame.size
        }
    }
    /// 长
    public var xSizeH : CGFloat {
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
        get {
            return self.frame.size.height
        }
    }
    /// 宽
    public var xSizeW : CGFloat {
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
        get {
            return self.frame.size.width
        }
    }
    
    // MARK: - 容器
    /// 所在的ViewController
    public var xContainerViewController : UIViewController?
    {
        var view : UIView? = self
        while view != nil {
            let resp = view?.next
            if let vc = resp as? UIViewController {
                return vc
            }
            view = view?.superview
        }
        return nil
    }
}
