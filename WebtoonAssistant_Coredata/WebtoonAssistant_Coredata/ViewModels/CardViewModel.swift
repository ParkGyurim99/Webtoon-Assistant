//
//  CardViewModel.swift
//  WebtoonAssistant_Coredata
//
//  Created by Park Gyurim on 2021/09/20.
//

import SwiftUI
import SwiftSoup

final class CardViewModel : ObservableObject {
    let webtoon : Webtoon
    let webtoonInformation : webtoonInfo
    
    init(webtoon : Webtoon) {
        self.webtoon = webtoon
        self.webtoonInformation = WebtoonViewModel.getWebtoonInfo(urlAddress: webtoon.url!)
    }
    
    var title : String { return webtoon.name! }
    var imageUrl : URL { URL(string : webtoonInformation.imageSource)! }
    var subTitle1 : String { webtoonInformation.recentUpload }
    var subTitle2 : String { webtoonInformation.recentEpisode }
    var url : String { webtoon.url! }
}
