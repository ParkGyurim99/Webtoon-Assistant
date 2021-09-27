//
//  WebtoonCardView.swift
//  WebtoonAssistant_Coredata
//
//  Created by Park Gyurim on 2021/08/08.
//

import SwiftUI
import URLImage

struct webtoonCard : View {
    private let viewModel : CardViewModel

    // Injecting viewModel for each Webtoon
    init(viewModel : CardViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationLink(destination: WebView(urlToLoad : viewModel.url)) {
            HStack {
                URLImage(viewModel.imageUrl) { image in
                    image.resizable()
                }.frame(width : 100, height: 80)
                VStack (alignment : .leading) {
                    Text(viewModel.title)
                        .fontWeight(.bold)
                    Text(viewModel.subTitle1 + "\n" + viewModel.subTitle2)
                        .font(.system(size : 15))
                        .foregroundColor(.secondary)
                } // VStack
                Spacer()
                Image(systemName: "heart.fill").foregroundColor(Color.red)
            } // HStack
        }
    }
}
