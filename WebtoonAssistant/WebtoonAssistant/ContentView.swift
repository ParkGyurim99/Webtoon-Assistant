//
//  ContentView.swift
//  WebtoonAssistant
//
//  Created by 박규림 on 2021/01/04.
//

import SwiftUI

struct naverWebtoon : Hashable {
    var name : String
    var url : String
    /*
     var company : String
     var uploadDay : String or Int (1...7)
     */
}
// 나중에 '사이트'(네이버, 카카오 같은거)랑 '요일' 추가해서 구분 가능하도록 만들어야지

struct ContentView: View {
//    var myNaverWebtoons : [String: String] = //Dictionary
//    ["여신강림" : "https://comic.naver.com/webtoon/list.nhn?titleId=703846&weekday=tue",
//    "프리드로우 " : "https://comic.naver.com/webtoon/list.nhn?titleId=597447&weekday=sat"]
    
    var myNaveWebtoon : [naverWebtoon] =
        [naverWebtoon(name : "여신강림", url : "https://comic.naver.com/webtoon/list.nhn?titleId=703846&weekday=tue"),
         naverWebtoon(name : "프리드로우", url : "https://comic.naver.com/webtoon/list.nhn?titleId=597447&weekday=sat")]
    
    @State var weekday = ""
    
    var body: some View {
//        TabView 사용할 경우
//        NavigationView {
//            TabView {
//                homeView()
//                    .tabItem {
//                        Text("home")
//                        Image(systemName: "house.fill")
//                    }.tag(0)
//                bookmarkView()
//                    .tabItem {
//                        Text("bookmark")
//                        Image(systemName: "bookmark.circle.fill")
//                    }.tag(1)
//            }
//        }
        
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                // 리스트 자체를 Function or View로?
                VStack {
                    Picker("weekday", selection : $weekday) {
                        Text("월").tag("월")
                        Text("화").tag("화")
                        Text("수").tag("수")
                        Text("목").tag("목")
                        Text("금").tag("금")
                        Text("토").tag("토")
                        Text("일").tag("일")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    Text(weekday + "요웹툰")
                        .font(.headline)
//                        .foregroundColor(.white)
                        .fontWeight(.black)
                        .frame(width : 300, height: 30)
//                        .background(Color.green)
//                        .cornerRadius(20)
                    
                    List {
                        Section (header: Text("Naver Webtoon")) {
                            ForEach(myNaveWebtoon, id : \.self) { webtoon in
                                //Text(webtoon.name + webtoon.url)
                                NavigationLink(destination : myWebView(urlToLoad: webtoon.url))
                                {
                                    Text(webtoon.name)
                                }
                            }
                        }
                        Section (header: Text("Kakao Webtoon")) {
                            // Dummy
                            Text("kakao webtoon 1")
                            Text("kakao webtoon 2")
                            Text("kakao webtoon 3")
                        }
                    }
                } // VStack
                    
                // add webtoon that user want to subscribe
                Button(action: {
                    
                }, label: {
                    Image(systemName: "plus")
                        .font(.system(size : 30))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.yellow)
                        .clipShape(Circle())
                        .padding(.trailing, 20)
                })
                
            } // ZStack
            .navigationTitle("내가 보는 웹툰")
        } // NavigationView
    }
}
