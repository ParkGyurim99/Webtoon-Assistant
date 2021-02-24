//
//  WebtoonInformation.swift
//  WebtoonAssistant_Coredata
//
//  Created by 박규림 on 2021/02/23.
//

import SwiftUI
import SwiftSoup

// Core data 에 저장되지 않은 웹툰
struct WebtoonNotStored : Hashable {
    var name : String
    var uploadedDay : String
    var url : String
    var bookmarked : Bool
}

struct webtoonInfo {
    var imageSource : String // 이미지 소스 url
    var recentUpload : String // 최근 업로드 날짜
    var recentEpisode : String // 최근화 제목
}

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

// url to Image
extension Image {
    func data(url:URL) -> Self {
        if let data = try? Data(contentsOf: url) {
            return Image(uiImage: UIImage(data: data)!).resizable()
        }
    return self.resizable()
    }
}

struct webtoonCard : View {
    var WebtoonName : String
    var WebtoonUrl : String
    var webtoonInformation : webtoonInfo // include image information
    
    // initializing variable
    init(WebtoonName : String, WebtoonUrl : String) {
        self.WebtoonName = WebtoonName
        self.WebtoonUrl = WebtoonUrl
        webtoonInformation = getWebtoonInfo(urlAddress: WebtoonUrl)
    }
    var body: some View {
        NavigationLink(destination: WebView(urlToLoad : WebtoonUrl),
            label: {
                HStack {
//                    WebView(urlToLoad: webtoonInformation.imageSource)
//                        .frame(width : 100, height: 80) // thumbnail
                    Image(systemName : "person.fill")
                        .data(url: URL(string : webtoonInformation.imageSource)!)
                        .frame(width : 100, height: 80)
                    VStack (alignment : .leading) {
                        Text(WebtoonName)
                            .fontWeight(.bold)
                        Text(webtoonInformation.recentUpload + "\n" + webtoonInformation.recentEpisode)
                            .font(.system(size : 15))
                            .foregroundColor(.secondary)
                    } // VStack
                    Spacer()
                    Image(systemName: "heart.fill")
                        .foregroundColor(Color.red)
                } // HStack
            }
        ) // Navigation Link
       
    }
}

func duplicateCheck(Webtoons : FetchedResults<Webtoon>, checkWebtoonName : String) -> Bool {
    for i in 0..<Webtoons.count {
        if checkWebtoonName == Webtoons[i].name {
            return true
        }
    }
    return false
}

struct webtoonCardBookmark : View {
    @State var isClicked : Bool = false
    @State var isBookmarked : Int = 0 // 0 : Clicked new Webtoon, 1 : Clicked existed Webtoon
    @Environment(\.managedObjectContext) private var viewContext
    @Environment (\.presentationMode) var presentationMode
    @FetchRequest(entity : Webtoon.entity(), sortDescriptors: [])
    var Webtoons : FetchedResults<Webtoon>
    
    var SelectedWebtoon : WebtoonNotStored
    var webtoonInformation : webtoonInfo // include image information
    @State var alertMessage : String = "북마크에 추가되었습니다."

    // initializing variable
    init(Webtoon : WebtoonNotStored) {
        self.SelectedWebtoon = Webtoon
        webtoonInformation = getWebtoonInfo(urlAddress: Webtoon.url)
    }

    var body: some View {
        HStack {
//            WebView(urlToLoad: webtoonInformation.imageSource)
//                .frame(width : 100, height: 80) // thumbnail
            Image(systemName : "person.fill")
                .data(url: URL(string : webtoonInformation.imageSource)!)
                .frame(width : 100, height: 80)
            Text(SelectedWebtoon.name)
                .fontWeight(.bold)
            Spacer()
            Button(action : {
                print("\(SelectedWebtoon.name) clicked")
                isClicked = true
                
                for i in 0..<Webtoons.count {
                    if SelectedWebtoon.name == Webtoons[i].name {
                        isBookmarked = 1
                        alertMessage = "이미 추가된 웹툰입니다."
                    }
                }
                
                if isBookmarked == 0 {
                    let newOrder = Webtoon(context: viewContext)
                    newOrder.name = SelectedWebtoon.name
                    newOrder.uploadedDay = SelectedWebtoon.uploadedDay
                    newOrder.url = SelectedWebtoon.url
                    newOrder.isBookmarked = true
                    newOrder.id = UUID()
                    do {
                        try viewContext.save()
                        print("Order saved.")
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }) {
                Image(systemName: "heart.fill")
                    .foregroundColor(duplicateCheck(Webtoons: Webtoons, checkWebtoonName: SelectedWebtoon.name) ? Color.red : Color.gray)
                    .font(.system(size : 30))
            }.alert(isPresented: $isClicked, content: {
                Alert(title: Text("북마크에 추가"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
            })
        } // HStack
        
    }
}
