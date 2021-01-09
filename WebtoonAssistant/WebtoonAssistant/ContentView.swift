//
//  ContentView.swift
//  WebtoonAssistant
//
//  Created by 박규림 on 2021/01/04.
//

import SwiftUI

enum Company {
    case naver, kakao
}

struct Webtoon : Hashable {
    var company : Company //  = ["naver", "kakao", ... ]
    var name : String
    var uploadedDay : String
    var url : String
}
// 나중에 '사이트'(네이버, 카카오 같은거)랑 '요일' 추가해서 구분 가능하도록 만들어야지 // 끝
// enum으로 회사 정보 추가... 회사별로 html 코드가 다른데 어떤식으로 처리할지?

struct ContentView: View {
    // example data
    var myNaveWebtoon : [Webtoon] =
        [Webtoon(company : .naver, name : "여신강림", uploadedDay : "화", url : "https://comic.naver.com/webtoon/list.nhn?titleId=703846&weekday=tue"),
         Webtoon(company : .naver, name : "프리드로우", uploadedDay : "토",url : "https://comic.naver.com/webtoon/list.nhn?titleId=597447&weekday=sat"),
         Webtoon(company : .naver, name : "민간인 통제구역", uploadedDay : "토",url : "https://comic.naver.com/webtoon/list.nhn?titleId=737377&weekday=sat"),
         Webtoon(company : .naver, name : "복학왕", uploadedDay : "수",url : "https://comic.naver.com/webtoon/list.nhn?titleId=626907&weekday=wed")]
    
    @State var weekday = "월" // default value == 월
    
    var body: some View {
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
                        .fontWeight(.black)
                        .frame(width : 300, height: 30)
                    
                    List {
                        Section (header: Text("Naver Webtoon")
                                    .foregroundColor(.black)
                                    .font(.system(size : 20))
                        ) {
                            ForEach(myNaveWebtoon, id : \.self) { webtoon in
                                if webtoon.uploadedDay == weekday {
                                    webtoonCard(titleName: webtoon.name, urlAddress: webtoon.url)
                                }
                            }
                        }
                        Section (header: Text("Kakao Webtoon")
                                    .foregroundColor(.black)
                                    .font(.system(size : 20))
                        ) {
                            // Dummy Data
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
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Menu(content: {
                        // 안에 들어갈 내용
                    }, label: {
                        // 버튼 모양, 생김새
                        Image(systemName : "person.crop.circle.fill")
                            .font(.system(size : 30))
                            .foregroundColor(.black)
                    }) // Menu
                    
                }) // ToolbarItem
                
            }) // toolbar
            
        } // NavigationView
    }
}
