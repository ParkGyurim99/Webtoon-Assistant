//
//  ListView.swift
//  WebtoonAssistant_Coredata
//
//  Created by 박규림 on 2021/02/24.
//

import SwiftUI

struct ListView : View {
    @Binding var isPresented : Bool
    @FetchRequest(entity : Webtoon.entity(), sortDescriptors: [])
    var Webtoons: FetchedResults<Webtoon>
    
    init(isPresented : Binding<Bool>) {
        _isPresented = isPresented
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("북마크 모아보기")
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
            List {
                ForEach(Webtoons, id : \.self) { Webtoon in
                    webtoonCard(WebtoonName: Webtoon.name!, WebtoonUrl: Webtoon.url!)
                }
            }
        }
    }
}
