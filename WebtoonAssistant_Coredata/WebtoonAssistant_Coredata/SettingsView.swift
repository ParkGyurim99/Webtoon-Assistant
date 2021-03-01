//
//  SettingsView.swift
//  WebtoonAssistant_Coredata
//
//  Created by 박규림 on 2021/02/23.
//

import SwiftUI

struct SettingsView : View {
    var body: some View {
        VStack {
//            Spacer()
//                .frame(height : 20)
            List {
                NavigationLink(destination: ListView(), label: {
                    Image(systemName : "list.dash")
                    Text("북마크 모아보기")
                        .bold()
                })
            }
        }.navigationTitle(Text("설정"))
    }
}
