//
//  ImageCacheModel.swift
//  WebtoonAssistant_Coredata
//
//  Created by Park Gyurim on 2021/08/09.
//

import SwiftUI

class ImageCacheModel {
    static let instance = ImageCacheModel() // Singleton patter
    
    private init() {}
    
    var imageCache = NSCache<NSString, UIImage>()
    
    func addCache(uiImage : UIImage, nameKey : String) {
        imageCache.setObject(uiImage, forKey: nameKey as NSString)
    }
    
    func removeCache(nameKey : String) {
        imageCache.removeObject(forKey: nameKey as NSString)
    }
    
    func getCache(nameKey : String) -> UIImage? {
        return imageCache.object(forKey: nameKey as NSString)
    }
}
