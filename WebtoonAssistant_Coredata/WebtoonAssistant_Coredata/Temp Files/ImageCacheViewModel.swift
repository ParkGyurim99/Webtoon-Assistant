//
//  ImageCacheViewModel.swift
//  WebtoonAssistant_Coredata
//
//  Created by Park Gyurim on 2021/08/09.
//

import SwiftUI

class ImageCacheViewModel : ObservableObject {
    @Published var cachedImage : UIImage?
//    let tempImage = UIImage(named : "tempImg")
    
    let manager = ImageCacheModel.instance
    
    func getUIImageFromURL(url : URL) -> UIImage? {
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        return UIImage(data : data)
    }
    
    func saveImgToCache(url : URL, nameKey : String) {
        guard let image = getUIImageFromURL(url: url) else { return }
        manager.addCache(uiImage: image, nameKey: nameKey)
    }
    
    func getImgFromCache(nameKey : String) -> UIImage? {
        if let returnImage = manager.getCache(nameKey: nameKey) {
            cachedImage = returnImage
            return returnImage
        } else {
            // cachedImage = nil
            return nil
        }
    }
}
