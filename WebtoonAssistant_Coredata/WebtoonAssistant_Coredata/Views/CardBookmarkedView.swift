//
//  WebtoonCardBookmarkedView.swift
//  WebtoonAssistant_Coredata
//
//  Created by Park Gyurim on 2021/09/27.
//

import SwiftUI
import URLImage

struct BookmarkedCard : View {
    @State var isClicked : Bool = false

    private let viewModel : CardBookmarkedViewModel
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment (\.presentationMode) var presentationMode
    @FetchRequest(entity : Webtoon.entity(), sortDescriptors: [])
    var Webtoons : FetchedResults<Webtoon>
    
    init(viewModel : CardBookmarkedViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack {
            URLImage(viewModel.imageUrl) {image in
                image.resizable()
            }.frame(width : 100, height: 80)
            Text(viewModel.title)
                .fontWeight(.bold)
            Spacer()
            Button {
                isClicked = true
                if !viewModel.isExist(Webtoons) {
                    let newWebtoon = Webtoon(context: viewContext)
                    newWebtoon.name = viewModel.webtoon.name
                    newWebtoon.uploadedDay = viewModel.webtoon.uploadedDay
                    newWebtoon.url = viewModel.webtoon.url
                    newWebtoon.isBookmarked = true
                    newWebtoon.id = UUID()
                    do {
                        try viewContext.save()
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        print(error.localizedDescription)
                    }
                } else {
                    viewModel.alertMessage = "이미 추가된 웹툰입니다."
                }
            } label : {
                Image(systemName: "heart.fill")
                    .foregroundColor(viewModel.isExist(Webtoons) ? .red : .gray)
            }.alert(isPresented: $isClicked) {
                Alert(title: Text(viewModel.alertTitle),
                      message: Text(viewModel.alertMessage))
            }
        }
    }
}
