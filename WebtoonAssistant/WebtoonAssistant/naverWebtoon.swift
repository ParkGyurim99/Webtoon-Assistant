//
//  naverWebtoonData.swift
//  WebtoonAssistant
//
//  Created by 박규림 on 2021/01/21.
//

import SwiftUI
import SwiftSoup

var myNaverWebtoon : [Webtoon] =
    [Webtoon(company : .naver, name : "여신강림", uploadedDay : "tue", url : "https://comic.naver.com/webtoon/list.nhn?titleId=703846&weekday=tue", bookmarked: true),
     Webtoon(company : .naver, name : "프리드로우", uploadedDay : "sat",url : "https://comic.naver.com/webtoon/list.nhn?titleId=597447&weekday=sat", bookmarked: true),
     Webtoon(company : .naver, name : "민간인 통제구역", uploadedDay : "sat",url : "https://comic.naver.com/webtoon/list.nhn?titleId=737377&weekday=sat", bookmarked: true),
     Webtoon(company : .naver, name : "복학왕", uploadedDay : "wed",url : "https://comic.naver.com/webtoon/list.nhn?titleId=626907&weekday=wed", bookmarked: true)]

func getNaverWebtoon(weekday : String) -> [Webtoon] {
    var returnWebtoon : [Webtoon] = []
    var temp : Webtoon = Webtoon(company: .naver, name: "", uploadedDay: "", url: "", bookmarked: false)
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
            var tempWebtoon = Webtoon(company: .naver, name: "", uploadedDay: weekdayString, url: "", bookmarked: false)
            
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

func addToNaverBookmark(webtoon : Webtoon) {
    var addedWebtoon : Webtoon
    var check = 0
    
    addedWebtoon = Webtoon(company: webtoon.company, name: webtoon.name, uploadedDay: webtoon.uploadedDay, url: webtoon.url, bookmarked: true)
    
    for i in 0..<myNaverWebtoon.count {
        if addedWebtoon.name == myNaverWebtoon[i].name {
            check = 1
        }
    }
    if check == 0 {
        myNaverWebtoon.append(addedWebtoon)
    }
}

struct naverWebtoonList : View {
    var weekday : String
    
    init(weekday : String) {
        self.weekday = weekday
    }
    
    var body : some View {
        
        Section (header: Text("Naver Webtoon")
                    .foregroundColor(.black)
                    .font(.system(size : 20))
        ) {
            ForEach(myNaverWebtoon, id : \.self) { webtoon in
                if webtoon.uploadedDay == weekday {
                    webtoonCard(Webtoon: webtoon)
                }
            }
        } // Section
        
    } // body
}

struct allNaverwebtoonList : View {
    
    @State var selectedWeekday : String = "mon"
    
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
                ForEach(getNaverWebtoon(weekday: selectedWeekday), id : \.self) { dayWebtoon in
                    webtoonCardBookmark(Webtoon: dayWebtoon)
                }
            }
            
        }.navigationBarTitle("네이버 웹툰 추가하기")
    }
}
