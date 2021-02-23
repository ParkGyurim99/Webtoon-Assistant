//
//  ContentView.swift
//  WebtoonAssistant_Coredata
//
//  Created by 박규림 on 2021/02/23.
//

import SwiftUI
import CoreData

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

struct ContentView: View {
    @State var weekday = "mon" // default value == 월, monday
    @State var showAdd : Bool = false
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity : Webtoon.entity(), sortDescriptors: [])
//    @FetchRequest(entity: Webtoon.entity(), sortDescriptors: [], predicate: NSPredicate(format: "status != %@", Status.completed.rawValue))
    public var Webtoons: FetchedResults<Webtoon>
    
    var body: some View {
        NavigationView {
            ZStack (alignment : .bottomTrailing) {
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
                        ForEach(Webtoons) { Webtoon in
                            if Webtoon.uploadedDay == weekday {
                                //webtoonCard(Webtoon: )
                                Text("\(Webtoon.name!)")
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
                AddBookmarkView(isPresented: $showAdd)
            })
        }
    }
}
