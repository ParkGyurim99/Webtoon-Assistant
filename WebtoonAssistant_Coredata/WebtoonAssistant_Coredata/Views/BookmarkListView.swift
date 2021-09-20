//
//  ListView.swift
//  WebtoonAssistant_Coredata
//
//  Created by 박규림 on 2021/02/24.
//

import SwiftUI

struct BookmarkListView : View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity : Webtoon.entity(), sortDescriptors: [])
    var Webtoons: FetchedResults<Webtoon>
    
    var body: some View {
        List {
            ForEach(Webtoons, id : \.self) { Webtoon in
                webtoonCard(viewModel : CardViewModel(webtoon: Webtoon))
            }
            .onDelete { indexSet in
                for index in indexSet {
                    viewContext.delete(Webtoons[index])
                }
                do {
                    try viewContext.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.navigationTitle("북마크 모아보기")
    }
}
