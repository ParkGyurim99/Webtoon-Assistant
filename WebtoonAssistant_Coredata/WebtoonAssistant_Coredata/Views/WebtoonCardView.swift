//
//  WebtoonCardView.swift
//  WebtoonAssistant_Coredata
//
//  Created by Park Gyurim on 2021/08/08.
//

import SwiftUI

struct webtoonCard : View {
    var Webtoon : Webtoon
    var webtoonInformation : webtoonInfo // include image information
    
    // initializing variable
    init(Webtoon : Webtoon) {
        self.Webtoon = Webtoon
        webtoonInformation = getWebtoonInfo(urlAddress: Webtoon.url!)
    }
    
    var body: some View {
        NavigationLink(destination: WebView(urlToLoad : Webtoon.url!),
            label: {
                HStack {
                    Image(systemName : "person.fill")
                        .data(url: URL(string : webtoonInformation.imageSource)!)
                        .frame(width : 100, height: 80)
                    VStack (alignment : .leading) {
                        Text(Webtoon.name!)
                            .fontWeight(.bold)
                        Text(webtoonInformation.recentUpload + "\n" + webtoonInformation.recentEpisode)
                            .font(.system(size : 15))
                            .foregroundColor(.secondary)
                    } // VStack
                    Spacer()
                    Image(systemName: "heart.fill")
                        .foregroundColor(Color.red)
                } // HStack
            }
        ) // Navigation Link
    }
}

struct webtoonCardBookmark : View {
    @State var isClicked : Bool = false
    @State var alertMessage : String = "북마크에 추가되었습니다."
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment (\.presentationMode) var presentationMode
    @FetchRequest(entity : Webtoon.entity(), sortDescriptors: [])
    var Webtoons : FetchedResults<Webtoon>
    
    var SelectedWebtoon : WebtoonNotStored
    var webtoonInformation : webtoonInfo // include image information
    
    // initializing variable
    init(Webtoon : WebtoonNotStored) {
        self.SelectedWebtoon = Webtoon
        webtoonInformation = getWebtoonInfo(urlAddress: Webtoon.url)
    }
    
    var body: some View {
        HStack {
            Image(systemName : "person.fill")
                .data(url: URL(string : webtoonInformation.imageSource)!)
                .frame(width : 100, height: 80)
            
            Text(SelectedWebtoon.name)
                .fontWeight(.bold)
            Spacer()
            Button(action : {
                print("\(SelectedWebtoon.name) clicked")
                isClicked = true
                
                if !duplicateCheck(Webtoons: Webtoons, checkWebtoonName: SelectedWebtoon.name) {
                    let newWebtoon = Webtoon(context: viewContext)
                    newWebtoon.name = SelectedWebtoon.name
                    newWebtoon.uploadedDay = SelectedWebtoon.uploadedDay
                    newWebtoon.url = SelectedWebtoon.url
                    newWebtoon.isBookmarked = true
                    newWebtoon.id = UUID()
                    do {
                        try viewContext.save()
                        print("Order saved.")
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        print(error.localizedDescription)
                    }
                } else {
                    alertMessage = "이미 추가된 웹툰입니다."
                }
            }) {
                Image(systemName: "heart.fill")
                    .foregroundColor(duplicateCheck(Webtoons: Webtoons, checkWebtoonName: SelectedWebtoon.name) ? Color.red : Color.gray)
                    .font(.system(size : 30))
            }.alert(isPresented: $isClicked, content: {
                Alert(
                    title: Text("북마크에 추가"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("확인"))
                )
            })
        } // HStack
    }
}


struct CardView : View {
    // Coredata Webtoon Array
    @Environment(\.managedObjectContext) private var viewContext
    @Environment (\.presentationMode) var presentationMode
    @FetchRequest(entity : Webtoon.entity(), sortDescriptors: [])
    var Webtoons : FetchedResults<Webtoon>
    
    var webtoon : Webtoon
    
    init(webtoon : Webtoon) {
        self.webtoon = webtoon
    }
    
    var body : some View {
        NavigationLink(
            destination : WebView(urlToLoad: "https://m.naver.com"),
            isActive : .constant(false)
        ) {
            HStack {
                Image(systemName : "person.fill")
                    .frame(width : 100, height: 80)
                VStack (alignment : .leading) {
                    Text("Name Area")
                        .fontWeight(.bold)
                    Text("Last Uploaded Day\nLast Episode Title")
                        .font(.system(size : 15))
                        .foregroundColor(.secondary)
                } // VStack
                Spacer()
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .font(.system(size : 30))
            } // HStack
        } // NavigationLink
    }
}
