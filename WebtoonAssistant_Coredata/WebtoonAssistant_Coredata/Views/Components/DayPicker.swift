//
//  DayPicker.swift
//  WebtoonAssistant_Coredata
//
//  Created by Park Gyurim on 2021/08/08.
//

import SwiftUI

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

struct DayPicker : View {
    @Binding var selectedWeekday : String
    
    var body : some View {
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
    }
}
