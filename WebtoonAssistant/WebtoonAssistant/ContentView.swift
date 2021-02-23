//
//  ContentView.swift
//  WebtoonAssistant
//
//  Created by 박규림 on 2021/01/04.
//

import SwiftUI

struct ContentView : View {
    @State var weekday = "mon" // default value == 월, monday
    @State var showAdd : Bool = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
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
                    Divider()
                    List {
                        ForEach(myNaverWebtoon, id : \.self) { webtoon in
                            if webtoon.uploadedDay == weekday {
                                webtoonCard(Webtoon: webtoon)
                            }
                        }.padding()
                    }.listStyle(PlainListStyle())
                } // VStack
                
                // Add Bookmark
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
            } // ZStack
            .navigationTitle("내가 보는 웹툰")
            .navigationBarItems(trailing:
                NavigationLink(destination : SettingsView()) {
                    Image(systemName : "gearshape.2.fill")
                        .font(.system(size : 25))
                        .foregroundColor(.black)
                }
            )
            .sheet(isPresented: $showAdd, content: {
                addBookmarkView(isPresented: $showAdd)
            })
            
        } // NavigationView
    }
}
