//
//  ContentView.swift
//  WebtoonAssistant
//
//  Created by 박규림 on 2021/01/04.
//

import SwiftUI

enum Company {
    case naver, daum
}
struct Webtoon : Hashable {
    var company : Company //  = ["naver", "kakao", ... ]
    var name : String
    var uploadedDay : String
    var url : String
    var bookmarked : Bool
}

struct ContentView : View {
//    // example data
//    var myNaverWebtoon : [Webtoon] =
//        [Webtoon(company : .naver, name : "여신강림", uploadedDay : "tue", url : "https://comic.naver.com/webtoon/list.nhn?titleId=703846&weekday=tue", bookmarked: true),
//         Webtoon(company : .naver, name : "프리드로우", uploadedDay : "sat",url : "https://comic.naver.com/webtoon/list.nhn?titleId=597447&weekday=sat", bookmarked: true),
//         Webtoon(company : .naver, name : "민간인 통제구역", uploadedDay : "sat",url : "https://comic.naver.com/webtoon/list.nhn?titleId=737377&weekday=sat", bookmarked: true),
//         Webtoon(company : .naver, name : "복학왕", uploadedDay : "wed",url : "https://comic.naver.com/webtoon/list.nhn?titleId=626907&weekday=wed", bookmarked: true)]

    @State var weekday = "mon" // default value == 월, monday
    @State var showAdd : Bool = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                // 리스트 자체를 Function or View로?
                VStack {
                    Picker("weekday", selection : $weekday) {
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
                    
                    Text(weekdayToKor(weekday: weekday) + "요웹툰")
                        .font(.headline)
                        .fontWeight(.black)
                        .frame(width : 300, height: 30)
                    
                    List {
                        naverWebtoonList(weekday : weekday)
//                        Section (header: Text("Naver Webtoon")
//                                    .foregroundColor(.black)
//                                    .font(.system(size : 20))
//                        ) {
//                            ForEach(myNaverWebtoon, id : \.self) { webtoon in
//                                if webtoon.uploadedDay == weekday {
//                                    webtoonCard(Webtoon: webtoon)
//                                }
//                            }
//                        }
                        
                        Section (header: Text("Daum Webtoon")
                                    .foregroundColor(.black)
                                    .font(.system(size : 20))
                        ) {
                            // Dummy Data
                            Text("Daum webtoon 1")
                            Text("Daum webtoon 2")
                            Text("Daum webtoon 3")
                        }
                    }
                } // VStack
                
                // add webtoon to subscribe
                if showAdd == false {
                Button(action: {
                    withAnimation {
                        showAdd = true
                    }
                }, label: {
                    Image(systemName: "plus")
                        .font(.system(size : 30))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.yellow)
                        .clipShape(Circle())
                        .padding(.trailing, 20)
                        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? 20 : 0) // 구형 아이폰에서 바텀 패딩주기
                })
                }
                else {
                //if showAdd == true {
                    VStack (spacing : 20) {
                        Text("북마크 추가")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .padding(.top, 10)
                        Spacer()
                        HStack {
                            NavigationLink(destination : allNaverwebtoonList()) {
                            Text("네이버 웹툰")
                            Image(systemName : "greaterthan.circle")
                            }
                        }.font(.system(size : 20))
                        HStack {
                            Text("다음 웹툰")
                            Image(systemName : "greaterthan.circle")
                        }.font(.system(size : 20))
                        Spacer()
                        Button {
                            showAdd = false
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size : 30))
                        }.padding(.bottom, 10)
                    }
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.5)
                    .background(Color.yellow)
                    .cornerRadius(20)
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 3)
                }
            } // ZStack
            .navigationTitle("내가 보는 웹툰")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing, content: {
//                    Menu(content: {
//                        // 안에 들어갈 내용
//                    }, label: {
//                        // 버튼 모양, 생김새
//                        Image(systemName : "gearshape.2.fill")
//                            .font(.system(size : 30))
//                            .foregroundColor(.black)
//                    }) // Menu
                    NavigationLink(destination : settingsView()) {
                        Image(systemName : "gearshape.2.fill")
                            .font(.system(size : 30))
                            .foregroundColor(.black)
                    }
                    
                }) // ToolbarItem
                
            }) // toolbar
            
        } // NavigationView
    }
}
