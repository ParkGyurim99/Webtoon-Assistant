//
//  myWebtoon.swift
//  WebtoonAssistant
//
//  Created by 박규림 on 2021/01/21.
//

import SwiftUI
import SwiftSoup

//struct Webtoon : Hashable {
//    var name : String
//    var uploadedDay : String
//    var url : String
//    var bookmarked : Bool
//}

struct webtoonInfo {
    var imageSource : String // 이미지 소스 url
    var recentUpload : String // 최근 업로드 날짜
    var recentEpisode : String // 최근화 제목
}

var myNaverWebtoon : [Webtoon] =
    [Webtoon(name : "여신강림", uploadedDay : "tue", url : "https://comic.naver.com/webtoon/list.nhn?titleId=703846&weekday=tue", bookmarked: true),
     Webtoon(name : "프리드로우", uploadedDay : "sat", url : "https://comic.naver.com/webtoon/list.nhn?titleId=597447&weekday=sat", bookmarked: true),
     Webtoon(name : "민간인 통제구역", uploadedDay : "sat", url : "https://comic.naver.com/webtoon/list.nhn?titleId=737377&weekday=sat", bookmarked: true),
     Webtoon(name : "복학왕", uploadedDay : "wed", url : "https://comic.naver.com/webtoon/list.nhn?titleId=626907&weekday=wed", bookmarked: true)]

func getWebtoonInfo(urlAddress : String)-> webtoonInfo {
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


func getWebtoons(weekday : String) -> [Webtoon] {
    var returnWebtoon : [Webtoon] = []
    var temp : Webtoon = Webtoon(name: "", uploadedDay: "", url: "", bookmarked: false)
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
            var tempWebtoon = Webtoon(name: "", uploadedDay: weekdayString, url: "", bookmarked: false)
            
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

func isBookmarked(name : String) -> Bool {
    for i in 0..<myNaverWebtoon.count {
        if name == myNaverWebtoon[i].name {
            return true
        }
    }
    return false
}

func addToNaverBookmark(webtoon : Webtoon) {
    var addedWebtoon : Webtoon
    var check = 0 // 중복 확인
    
    addedWebtoon = Webtoon(name: webtoon.name, uploadedDay: webtoon.uploadedDay, url: webtoon.url, bookmarked: true)
    
    for i in 0..<myNaverWebtoon.count {
        if addedWebtoon.name == myNaverWebtoon[i].name {
            check = 1
        }
    }
    if check == 0 {
        myNaverWebtoon.append(addedWebtoon)
    }
}

struct addBookmarkView : View {
    @State var selectedWeekday : String = "mon"
    @Binding var isPresented : Bool

    init(isPresented : Binding<Bool>) {
        _isPresented = isPresented
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("북마크에 추가하기")
                    .font(.largeTitle)
                    .bold()
                Spacer()
                Button {
                    isPresented.toggle()
                } label : {
                    Image(systemName : "xmark")
                        .foregroundColor(.black)
                        .font(.system(size : 25))
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
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
            //Spacer()
            Divider()
            List {
                ForEach(getWebtoons(weekday: selectedWeekday), id : \.self) { dayWebtoon in
                    webtoonCardBookmark(Webtoon: dayWebtoon)
                }
            }
        }
    }
}

struct webtoonCard : View {
    var Webtoon : Webtoon
    var webtoonInformation : webtoonInfo // include image information
    
    // initializing variable
    init(Webtoon : Webtoon) {
        self.Webtoon = Webtoon
        webtoonInformation = getWebtoonInfo(urlAddress: Webtoon.url)
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
    @State var isClicked : Bool = false
    var Webtoon : Webtoon
    var webtoonInformation : webtoonInfo // include image information
    
    // initializing variable
    init(Webtoon : Webtoon) {
        self.Webtoon = Webtoon
        webtoonInformation = getWebtoonInfo(urlAddress: Webtoon.url)
    }
    
    var body: some View {
        HStack {
            WebView(urlToLoad: webtoonInformation.imageSource)
                .frame(width : 100, height: 80) // thumbnail
            Text(Webtoon.name)
                .fontWeight(.bold)
            Spacer()
            Button(action : {
                print("\(Webtoon.name) clicked")
                addToNaverBookmark(webtoon: Webtoon)
                isClicked = true
            }) {
                Image(systemName: "heart.fill")
                    //.foregroundColor(isClicked ? Color.red : Color.gray)
                    .foregroundColor(isBookmarked(name: Webtoon.name) ? Color.red : Color.gray)
                    .font(.system(size : 30))
            }.alert(isPresented: $isClicked, content: {
                Alert(title: Text("북마크에 추가"), message: Text("북마크에 추가되었습니다."), dismissButton: .default(Text("확인")))
            })
        } // HStack
        
    }
}
