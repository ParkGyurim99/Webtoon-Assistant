//
//  webtoonData.swift
//  WebtoonAssistant
//
//  Created by 박규림 on 2021/01/13.
//

import SwiftUI
import SwiftSoup

enum Company {
    case naver, daum
}
// enum으로 회사 정보 추가... 회사별로 html 코드가 다른데 어떤식으로 처리할지?

struct Webtoon : Hashable {
    var company : Company //  = ["naver", "kakao", ... ]
    var name : String
    var uploadedDay : String
    var url : String
    var bookmarked : Bool = false
}

func getNaverWebtoon(weekday : String) -> [Webtoon] {
    var returnWebtoon : [Webtoon] = []
    var temp : Webtoon = Webtoon(company: .naver, name: "", uploadedDay: "", url: "")
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
            var tempWebtoon = Webtoon(company: .naver, name: "", uploadedDay: weekdayString, url: "")
            
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

func weekdayToKor(weekday : String) -> String {
    switch weekday {
    case "mon":
        return "월"
    case "tue":
        return "화"
    case "wed":
        return "수"
    case "thu":
        return "목"
    case "fri":
        return "금"
    case "sat":
        return "토"
    case "sun":
        return "일"
    default:
        return "월"
    }
}

struct addNaverwebtoon : View {
    @State var selectedWeekday : String = "mon"
    var todayWebtoon : [String: [Webtoon]] {
        ["mon" : getNaverWebtoon(weekday: "mon"),
        "tue" : getNaverWebtoon(weekday: "tue"),
        "wed" : getNaverWebtoon(weekday: "wed"),
        "thu" : getNaverWebtoon(weekday: "thu"),
        "fri" : getNaverWebtoon(weekday: "fri"),
        "sat" : getNaverWebtoon(weekday: "sat"),
        "sun" : getNaverWebtoon(weekday: "sun")]
    }
    
    var body: some View {
        VStack {
            Picker("weekday", selection : $selectedWeekday) {
                Text("월").tag("mon")
                Text("화").tag("tue")
                Text("수").tag("wed")
                Text("목").tag("thu")
                Text("금").tag("fri")
                Text("토").tag("sat")
                Text("일").tag("sun")
            }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
            Text(weekdayToKor(weekday : selectedWeekday) + "요웹툰")
                .font(.headline)
                .fontWeight(.black)
                .frame(width : 300, height: 30)
           
            
            List {
                ForEach(todayWebtoon[selectedWeekday]!, id : \.self) { dayWebtoon in
                    webtoonCardBookmark(Webtoon: dayWebtoon)
                }
            }
            
        }.navigationBarTitle("네이버 웹툰 추가하기")
    }
}
