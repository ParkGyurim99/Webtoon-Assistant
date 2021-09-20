//
//  ContentViewModel.swift
//  WebtoonAssistant_Coredata
//
//  Created by Park Gyurim on 2021/09/12.
//

import SwiftUI
import CoreData

final class ContentViewModel : ObservableObject {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity : Webtoon.entity(), sortDescriptors: [])
    var Webtoons: FetchedResults<Webtoon>

    let title = "북마크 모아보기"

    @Published var weekday = "mon" // default value == 월, monday
    @Published var showAdd : Bool = false
    @Published private(set) var  itemViewModels : [CardViewModel] = []
    
    init() {
        itemViewModels = Webtoons.map { webtoon in
            .init(webtoon: webtoon)
        }
    }
}
