//
//  ContentViewModel.swift
//  WebtoonAssistant_Coredata
//
//  Created by Park Gyurim on 2021/09/12.
//

import Foundation

final class ContentViewModel : ObservableObject {
    let title = "북마크 모아보기"
    
    @Published var weekday = "mon" // default value == 월, monday
    @Published var showAdd : Bool = false
}
