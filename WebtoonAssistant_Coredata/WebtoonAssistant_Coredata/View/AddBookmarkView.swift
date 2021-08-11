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
        print("add clicked")
    }
    
    var body: some View {
        VStack {
            // Title
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
            
            DayPicker(selectedWeekday: $selectedWeekday)
            List {
                ForEach(getWebtoons(weekday: selectedWeekday), id : \.self) { dayWebtoon in
                    webtoonCardBookmark(Webtoon: dayWebtoon)
                }
            }
        }
    }
}
