//
//  WebtoonViewModel.swift
//  WebtoonAssistant_Coredata
//
//  Created by Park Gyurim on 2021/08/08.
//

import SwiftUI
import SwiftSoup
import CoreData

class WebtoonViewModel : ObservableObject {
    let manager = WebtoonModel.instance
    
    init() {
    
    }
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

// 요일별 웹툰 받아오기
func getWebtoons(weekday : String) -> [WebtoonNotStored] {
    var returnWebtoon : [WebtoonNotStored] = []
    var temp : WebtoonNotStored = WebtoonNotStored(name: "", uploadedDay: "", url: "", bookmarked: false)
    var weekdayInt : Int {
        switch weekday {
            case "mon" :
                return 0
            case "tue" :
                return 1
            case "wed" :
                return 2
            case "thu" :
                return 3
            case "fri" :
                return 4
            case "sat" :
                return 5
            case "sun" :
                return 6
            default:
                return -1
        }
    }
    
    guard let url = URL(string : "https://comic.naver.com/webtoon/weekday.nhn") else { return returnWebtoon }
    do {
        let html = try String(contentsOf: url, encoding: .utf8)
        let doc : Document = try SwiftSoup.parse(html)

        // 요일
        let weekdayWebtoon : Elements = try doc.select("div.col_inner")
        let weekdayString : String = try weekdayWebtoon[weekdayInt].select("h4")[0].className()
        print(weekdayString)
        temp.uploadedDay = weekdayString
        
        let targetDayWebtoon : Elements = try weekdayWebtoon[weekdayInt].select("div.thumb a") // target 웹툰 배열
        
//        temp.name = try targetDayWebtoon[num].select("img").attr("alt")
//        temp.url = try targetDayWebtoon[num].attr("href")
//
//        print(targetDayWebtoon.count) // 해당요일별 웹툰 갯수
//
//        print(temp.name)
//        print("https://comic.naver.com" + temp.url)
//        print(temp)

        for i in 0..<targetDayWebtoon.count {
            var tempWebtoon = WebtoonNotStored(name: "", uploadedDay: weekdayString, url: "", bookmarked: false)
            
            temp.name = try targetDayWebtoon[i].select("img").attr("alt")
            temp.url = try targetDayWebtoon[i].attr("href")
            
            tempWebtoon.name = temp.name
            tempWebtoon.url = "https://comic.naver.com" + temp.url
            
            returnWebtoon.append(tempWebtoon)
        }
    }
    catch Exception.Error(type: let type, Message: let message) {
        print(type)
        print(message)
    }
    catch {
        print("")
    }
    
    return returnWebtoon
}

func duplicateCheck(Webtoons : FetchedResults<Webtoon>, checkWebtoonName : String) -> Bool {
    for i in 0..<Webtoons.count {
        if checkWebtoonName == Webtoons[i].name {
            return true
        }
    }
    return false
}
