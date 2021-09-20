//
//  CardViewModel.swift
//  WebtoonAssistant_Coredata
//
//  Created by Park Gyurim on 2021/09/20.
//

import Foundation
import SwiftSoup

final class CardViewModel : ObservableObject {
    let webtoon : Webtoon
    let webtoonInformation : webtoonInfo
    
    init(webtoon : Webtoon) {
        self.webtoon = webtoon
        self.webtoonInformation = getWebtoonInfo(urlAddress: webtoon.url!)
    }
    
    var title : String { return webtoon.name! }
    var imageSource : String { webtoonInformation.imageSource }
    var subTitle1 : String { webtoonInformation.recentUpload }
    var subTitle2 : String { webtoonInformation.recentEpisode }
    var url : String { webtoon.url! }
}

func getWebtoonInfo(urlAddress : String)-> webtoonInfo {
    var information : webtoonInfo
        = webtoonInfo(imageSource: "", recentUpload: "", recentEpisode: "")
    
    guard let url = URL(string : urlAddress)
        else { return webtoonInfo(imageSource: "blank", recentUpload: "", recentEpisode: "") }
    
    do {
        let html = try String(contentsOf: url, encoding: .utf8)
        let doc : Document = try SwiftSoup.parse(html)

//        // 제목
//        let titleName : Element = try doc.select("title").first()!
//        print(try titleName.text())
//
//        // 작가명
//        let writer : Element = try doc.select("div.comicinfo").select("div.detail").select("h2 span").first()!
//        print(try writer.text())
        
        
        // 최근 업로드 날짜
        let recentUpload : Element = try doc.select("td.num").first()!
        //print(try recentUpload.text())
        
        // 최신화 제목
        let recentTitle : Element = try doc.select("td.title a").first()!
        //print(try recentTitle.text())
        // 썸네일 이미지
        let img : Element = try doc.select("img").first()!

        information.imageSource = try img.attr("src") // 썸네일 이미지 소스 링크
        information.recentEpisode = try recentUpload.text() // 날짜
        information.recentUpload = try recentTitle.text() // 제목
        
    } catch Exception.Error(type: let type, Message: let message) {
        print(type)
        print(message)
    } catch {
        print("")
    }
    
    return information
}
