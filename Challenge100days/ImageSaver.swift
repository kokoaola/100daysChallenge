//
//  ImageSaver.swift
//  Instafilter
//
//  Created by koala panda on 2022/12/12.
//

import UIKit


///targetからinfo 「privacy ー　PhotoLibrary Additions Usage Description」選んで許可の理由を書く
///これしないとクラッシュするよ

class ImageSaver: NSObject {
    //Save成功判定のためのプロパティ
    var successHandler: (() -> Void)?
    var errorHandler: ((Error) -> Void)?
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            errorHandler?(error)
        } else {
            successHandler?()
        }
    }
}

///べつばーじょん
//class ImageSaver: NSObject {
//    func writeToPhotoAlbum(image: UIImage) {
//        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
//    }
//
//    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
//        print("Save finished!")
//    }
//}


///これをビューに書く
//func save() {
//    
//    let imageSaver = ImageSaver()
//    
//    imageSaver.successHandler = {
//        print("Success!")
//    }
//    
//    imageSaver.errorHandler = {
//        print("Oops: \($0.localizedDescription)")
//    }
//    
//    imageSaver.writeToPhotoAlbum(image: uiImage)
//}
