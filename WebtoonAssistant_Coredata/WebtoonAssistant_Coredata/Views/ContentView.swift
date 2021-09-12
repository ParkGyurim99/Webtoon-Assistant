//
//  ContentView.swift
//  WebtoonAssistant_Coredata
//
//  Created by 박규림 on 2021/02/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity : Webtoon.entity(), sortDescriptors: [])
    var Webtoons: FetchedResults<Webtoon>
    
    var addButton : some View {
        Button(action: {
            withAnimation {
                viewModel.showAdd = true
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
    }
    
    var body: some View {
        ZStack (alignment : .bottomTrailing) {
            VStack {
                DayPicker(selectedWeekday: $viewModel.weekday)
                List {
                    ForEach(Webtoons) { Webtoon in
                        if Webtoon.uploadedDay == viewModel.weekday {
                            webtoonCard(Webtoon: Webtoon)
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
                }.listStyle(InsetGroupedListStyle())
            } // VStack
            
            // Add Bookmark Button on ZStack
            addButton
        } // ZStack
        .navigationTitle(viewModel.title)
        .sheet(isPresented: $viewModel.showAdd, content: {
            AddBookmarkView(isPresented: $viewModel.showAdd, selectedWeekday: $viewModel.weekday)
        })
    }
}
