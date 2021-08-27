//
//  Image+xAlbum.swift
//  xExtension
//
//  Created by Mac on 2021/6/19.
//

import Foundation
import Photos

extension UIImage {
    
    // MARK: - Handler
    /// 图片保存回调
    public typealias xHandlerSaveImage = (Bool, String) -> Void
    
    // MARK: - 保存图片到相册
    /// 保存图片到相册
    /// - Parameters:
    ///   - img: 图片
    ///   - handler: 完成回调
    public func xSavePNGToAlbum(completed : @escaping xHandlerSaveImage)
    {
        let data = self.pngData()
        self.xSaveImageToAlbum(data, completed: completed)
    }
    
    /// 保存图片到相册
    /// - Parameters:
    ///   - quality: 质量
    ///   - handler: 完成回调
    public func xSaveJPGToAlbum(quality : CGFloat = 1,
                                completed : @escaping xHandlerSaveImage)
    {
        let data = self.jpegData(compressionQuality: quality)
        self.xSaveImageToAlbum(data, completed: completed)
    }
    
    /// 保存图片到相册
    /// - Parameters:
    ///   - img: 图片数据
    ///   - handler: 完成回调
    public func xSaveImageToAlbum(_ imgData : Data?,
                                  completed : @escaping xHandlerSaveImage)
    {
        let status = PHPhotoLibrary.authorizationStatus()
        guard status == .authorized else {
            completed(false, "未取得相册权限")
            return
        }
        guard let data = imgData else {
            completed(false, "图片数据获取失败")
            return
        }
        PHPhotoLibrary.shared().performChanges {
            print(">>>>>>>>>> 开始保存图片")
            // let req = PHAssetChangeRequest.creationRequestForAsset(from: ret) // 无法保存gif，用子类来
            let req = PHAssetCreationRequest.forAsset()
            req.addResource(with: .photo, data: data, options: nil)
            if let ident = req.placeholderForCreatedAsset?.localIdentifier {
                print(">>>>>>>>>> 图片保存成功，唯一标识 = " + ident)
            }
        } completionHandler: {
            (isSuccess, error) in
            let msg = error?.localizedDescription ?? ""
            completed(isSuccess, msg)
        }
    }
    
    // MARK: - 方法过时，用上面的替换
    /*
    /// 保存GIF图片到相册 需要导入 AssetsLibrary
    /// - Parameter data: GIF图片数据
    public static func saveGifDataToPhotosAlbum(_ data : NSData,
                                                completed handler: @escaping (Bool) -> Void)
    {
        guard self.isAuthorized() else { return }
        let metadata = ["UTI": kCMMetadataBaseDataType_GIF]
        // 开始写数据
        let library = ALAssetsLibrary.init()
        library.writeImageData(toSavedPhotosAlbum: data as Data, metadata: metadata) {
            (assetURL, error) in
            if let err = error {
                xMessageAlert.display(message: "保存失败")
                print(err.localizedDescription)
            }
            else {
                xMessageAlert.display(message: "保存成功")
            }
        }
    }
     */
    
    /*
     旧方法，不推荐
    /// 保存图片到相册
    /// - Parameter img: 图片
    public static func saveImageToPhotosAlbum(_ img: UIImage,
                                              completed handler: @escaping (Bool) -> Void)
    {
        guard self.isAuthorized() else { return }
        UIImageWriteToSavedPhotosAlbum(img, shared, #selector(saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
    }
     
    /// 保存图片到相册回调
    /// - Parameters:
    ///   - image: 图片
    ///   - error: 错误
    ///   - contextInfo: 上下文信息
    @objc private func saveImage(image: UIImage,
                                 didFinishSavingWithError error: NSError?,
                                 contextInfo: AnyObject)
    {
        if let err = error {
            xMessageAlert.display(message: "保存失败")
            print(err.localizedDescription)
        }
        else {
            xMessageAlert.display(message: "保存成功")
        }
    }
     
     */
}
