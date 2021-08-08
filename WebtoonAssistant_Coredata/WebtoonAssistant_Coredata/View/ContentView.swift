//
//  ContentView.swift
//  WebtoonAssistant_Coredata
//
//  Created by 박규림 on 2021/02/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var weekday = "mon" // default value == 월, monday
    @State var showAdd : Bool = false

    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity : Webtoon.entity(), sortDescriptors: [])
    var Webtoons: FetchedResults<Webtoon>
    
    var body: some View {
        NavigationView {
            ZStack (alignment : .bottomTrailing) {
                VStack {
                    DayPicker(selectedWeekday: $weekday)
                    List {
                        ForEach(Webtoons) { Webtoon in
                            if Webtoon.uploadedDay == weekday {
                                webtoonCard(WebtoonName: Webtoon.name!, WebtoonUrl: Webtoon.url!)
                            }
                        }
                        .onDelete { indexSet in // coredata 삭제하기
                            for index in indexSet {
                                viewContext.delete(Webtoons[index])
                            }
                            do {
                                try viewContext.save()
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }.listStyle(PlainListStyle())
                } // VStack
                
                // Add Bookmark Button on ZStack
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
                        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? 20 : 0) // 구형 아이폰에서 버튼에 패딩주기
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
                AddBookmarkView(isPresented: $showAdd, selectedWeekday: $weekday)
            })
        }
    }
}
