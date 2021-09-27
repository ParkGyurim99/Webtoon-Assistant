//
//  AddBookmarkView.swift
//  WebtoonAssistant_Coredata
//
//  Created by 박규림 on 2021/02/23.
//

import SwiftUI

struct AddBookmarkView : View {    
    @Binding var selectedWeekday : String
    @Binding var isPresented : Bool

    init(isPresented : Binding<Bool>, selectedWeekday : Binding<String>) {
        _isPresented = isPresented
        _selectedWeekday = selectedWeekday
    }
    
    var title : some View {
        HStack {
            Text("북마크 추가하기")
                .font(.largeTitle)
                .bold()
            Spacer()
            Button {
                isPresented.toggle()
            } label : {
                Image(systemName : "xmark")
                    .font(.system(size : 25))
                    .foregroundColor(.white)
            }
        }
        .padding(20)
    }
    
    var body: some View {
        VStack {
            title
            DayPicker(selectedWeekday: $selectedWeekday)
            List {
                ForEach(WebtoonViewModel.getWebtoons(weekday: selectedWeekday), id : \.self) { dayWebtoon in
                    BookmarkedCard(viewModel: CardBookmarkedViewModel(webtoon: dayWebtoon))
                }
            }.listStyle(PlainListStyle())
        }
    }
}
