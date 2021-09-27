//
//  BookmarkedCardViewModel.swift
//  WebtoonAssistant_Coredata
//
//  Created by Park Gyurim on 2021/09/27.
//

import SwiftUI
import SwiftSoup

final class CardBookmarkedViewModel : ObservableObject {
    let webtoon : WebtoonNotStored
    let webtoonInformation : webtoonInfo
    let alertTitle : String = "북마크에 추가"
    var alertMessage : String = "북마크에 추가되었습니다."
    
    init(webtoon : WebtoonNotStored) {
        self.webtoon = webtoon
        self.webtoonInformation = WebtoonViewModel.getWebtoonInfo(urlAddress: webtoon.url)
    }
    
    var title : String { webtoon.name }
    var imageUrl : URL { URL(string : webtoonInformation.imageSource)! }
    
    func isExist(_ Webtoons : FetchedResults<Webtoon>) -> Bool {
        for i in 0..<Webtoons.count {
            if webtoon.name == Webtoons[i].name { return true } 
        }
        return false
    }
}
