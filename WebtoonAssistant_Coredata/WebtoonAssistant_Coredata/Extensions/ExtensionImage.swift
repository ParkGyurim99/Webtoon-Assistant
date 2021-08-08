//
//  ExtensionImage.swift
//  WebtoonAssistant_Coredata
//
//  Created by Park Gyurim on 2021/08/08.
//

import SwiftUI

// url to Image
extension Image {
    func data(url:URL) -> Self {
        if let data = try? Data(contentsOf: url) {
            return Image(uiImage: UIImage(data: data)!).resizable()
        }
    return self.resizable()
    }
}
