//
//  AddBookmarkView.swift
//  WebtoonAssistant_Coredata
//
//  Created by 박규림 on 2021/02/23.
//

import SwiftUI

struct AddBookmarkView : View {
    //@State var selectedWeekday : String = "mon"
    @Binding var selectedWeekday : String
    @Binding var isPresented : Bool

    init(isPresented : Binding<Bool>, selectedWeekday : Binding<String>) {
        _isPresented = isPresented
        _selectedWeekday = selectedWeekday
    }
    
    var body: some View {
        VStack {
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
            
            Picker("weekday", selection : $selectedWeekday) {
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
            
            Text(weekdayToKor(weekday : selectedWeekday) + "요웹툰")
                .font(.headline)
                .fontWeight(.black)
                .frame(width : 300, height: 30)
            //Spacer()
            Divider()
            List {
                ForEach(getWebtoons(weekday: selectedWeekday), id : \.self) { dayWebtoon in
                    webtoonCardBookmark(Webtoon: dayWebtoon)
                }
            }
        }
    }
}
