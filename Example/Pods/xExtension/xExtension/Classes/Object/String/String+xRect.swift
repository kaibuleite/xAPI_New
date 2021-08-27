//
//  String+xRect.swift
//  xExtension
//
//  Created by Mac on 2021/6/10.
//

import Foundation

extension String {
    
    // MARK: - 内容尺寸
    /// 获取文本内容大小
    /// - Parameters:
    ///   - font: 字体信息
    ///   - rect: 限制区域大小
    ///   - lineBreakMode: 换行模式(内容显示不完全时的省略方式)
    /// - Returns: 内容尺寸
    public func xContentSize(for font : UIFont,
                             rect : CGSize,
                             lineBreakMode: NSLineBreakMode = .byCharWrapping) -> CGSize
    {
        /*
         换行模式说明 参考 https://www.jianshu.com/p/a794824d5513
         case byWordWrapping = 0    // 单词换行，每一行都末尾都显示完整的单词，显示不全换行，末尾不显示...
         case byCharWrapping = 1    // 字符换行，前几行不保证单词完整，最后一行显示不全直接省略，末尾不显示...
         case byClipping = 2        // 裁剪，前几行保证完整的单词，显示不全换行，最后一行末尾是按字符省略，末尾不显示...
         case byTruncatingHead = 3      // 头部省略，最后一行显示不全在前面加...
         case byTruncatingTail = 4      // 尾部省略，最后一行显示不全在后面加...
         case byTruncatingMiddle = 5    // 中间省略，最后一行显示不全在中间加...
         */
        let nsstr = self as NSString
        var attr = [NSAttributedString.Key : Any]()
        attr[.font] = font
        if lineBreakMode == .byWordWrapping {
            /*
             边框样式 参考 https://www.jianshu.com/p/c70dd08b90ac
             */
            let paragraphStyle = NSMutableParagraphStyle.init()
            paragraphStyle.lineBreakMode = lineBreakMode
            attr[.paragraphStyle] = paragraphStyle
        }
        /*
         附加选项 参考 https://www.jianshu.com/p/e3dde269adc7
         UsesLineFragmentOrigin     // 以组成的矩形为单位计算整个文本的尺寸
         TruncatesLastVisibleLine   //以每个字或字形为单位来计算
         UsesDeviceMetric   // 以每个字或字形为单位来计算
         UsesFontLeading    // 以字体间的行距（leading，行距：从一行文字的底部到另一行文字底部的间距。）来计算
         */
        let op1 = NSStringDrawingOptions.usesLineFragmentOrigin
        let op2 = NSStringDrawingOptions.usesFontLeading
        let options = NSStringDrawingOptions.init(rawValue: op1.rawValue | op2.rawValue)
        let rect = nsstr.boundingRect(with: rect,
                                      options: options,
                                      attributes: attr,
                                      context: nil)
        let ret = rect.size
        return ret;
    }
    
    /// 根据指定高度获取文本内容宽度(无限制)
    /// - Parameters:
    ///   - font: 字体信息
    ///   - height: 限制区域高度
    ///   - lineBreakMode: 换行模式(内容显示不完全时的省略方式)
    /// - Returns: 文本宽度
    public func xContentWidth(for font : UIFont,
                              height : CGFloat,
                              lineBreakMode: NSLineBreakMode = .byCharWrapping) -> CGFloat
    {
        let w = CGFloat(MAXFLOAT)
        let rect = CGSize.init(width: w, height: height)
        let size = self.xContentSize(for: font,
                                     rect: rect,
                                     lineBreakMode: lineBreakMode)
        return size.width
    }
    
    /// 根据指定宽度获取内容高度(无限制)
    /// - Parameters:
    ///   - font: 字体信息
    ///   - width: 限制区域宽度
    ///   - lineBreakMode: 换行模式(内容显示不完全时的省略方式)
    /// - Returns: 文本高度
    public func xContentHeight(for font : UIFont,
                               width : CGFloat,
                               lineBreakMode: NSLineBreakMode = .byCharWrapping) -> CGFloat
    {
        let h = CGFloat(MAXFLOAT)
        let rect = CGSize.init(width: width, height: h)
        let size = self.xContentSize(for: font,
                                     rect: rect,
                                     lineBreakMode: lineBreakMode)
        return size.height
    }
}
