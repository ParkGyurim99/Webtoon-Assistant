//
// main page의 리스트 하나하나에 들어가는 웹툰 카드를 담당하는 뷰
//
//  webtoonCard.swift
//  WebtoonAssistant
//
//  Created by 박규림 on 2021/01/08.
//

import SwiftUI
import SwiftSoup

struct webtoonInfo {
    var imageSource : String // 이미지 소스 url
    var recentUpload : String // 최근 업로드 날짜
    var recentEpisode : String // 최근화 제목
}

func webScrappingFunc(urlAddress : String)-> webtoonInfo {
    var information : webtoonInfo = webtoonInfo(imageSource: "", recentUpload: "", recentEpisode: "")
    
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

struct webtoonCard : View {
    var Webtoon : Webtoon
    var webtoonInformation : webtoonInfo // include image information    
    
    // initializing variable
    init(Webtoon : Webtoon) {
        self.Webtoon = Webtoon
        webtoonInformation = webScrappingFunc(urlAddress: Webtoon.url)
    }
    var body: some View {
    
        NavigationLink(destination: WebView(urlToLoad : Webtoon.url),
            label: {
                HStack {
                    WebView(urlToLoad: webtoonInformation.imageSource)
                        .frame(width : 100, height: 80) // thumbnail
                    VStack (alignment : .leading) {
                        Text(Webtoon.name)
                            .fontWeight(.bold)
                        Text(webtoonInformation.recentUpload + "\n" + webtoonInformation.recentEpisode)
                            .font(.system(size : 15))
                            .foregroundColor(.secondary)
                    } // VStack
                    
                    Spacer()
                    Image(systemName: "heart.fill")
                        .foregroundColor(Webtoon.bookmarked ? Color.red : Color.gray)
                } // HStack
            }
        ) // Navigation Link
        
    }
}


struct webtoonCardBookmark : View {
    var Webtoon : Webtoon
    var webtoonInformation : webtoonInfo // include image information
    
    // initializing variable
    init(Webtoon : Webtoon) {
        self.Webtoon = Webtoon
        webtoonInformation = webScrappingFunc(urlAddress: Webtoon.url)
    }
    var body: some View {
//        NavigationLink(destination: WebView(urlToLoad : Webtoon.url),
//            label: {
                HStack {
                    WebView(urlToLoad: webtoonInformation.imageSource)
                        .frame(width : 100, height: 80) // thumbnail
                    Text(Webtoon.name)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action : {
                        //Webtoon.bookmarked.toggle()
                    }) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(Webtoon.bookmarked ? Color.red : Color.gray)
                    }
                } // HStack
//            }
//        ) // Navigation Link
        
    }
}
