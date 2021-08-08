//
//  WebtoonCardView.swift
//  WebtoonAssistant_Coredata
//
//  Created by Park Gyurim on 2021/08/08.
//

import SwiftUI


struct webtoonCard : View {
    var WebtoonName : String
    var WebtoonUrl : String
    var webtoonInformation : webtoonInfo // include image information
    
    // initializing variable
    init(WebtoonName : String, WebtoonUrl : String) {
        self.WebtoonName = WebtoonName
        self.WebtoonUrl = WebtoonUrl
        webtoonInformation = getWebtoonInfo(urlAddress: WebtoonUrl)
    }
    var body: some View {
        NavigationLink(destination: WebView(urlToLoad : WebtoonUrl),
            label: {
                HStack {
                    Image(systemName : "person.fill")
                        .data(url: URL(string : webtoonInformation.imageSource)!)
                        .frame(width : 100, height: 80)
                    VStack (alignment : .leading) {
                        Text(WebtoonName)
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
    @State var isBookmarked : Int = 0 // 0 : Clicked new Webtoon, 1 : Clicked existed Webtoon
    @Environment(\.managedObjectContext) private var viewContext
    @Environment (\.presentationMode) var presentationMode
    @FetchRequest(entity : Webtoon.entity(), sortDescriptors: [])
    var Webtoons : FetchedResults<Webtoon>
    
    var SelectedWebtoon : WebtoonNotStored
    var webtoonInformation : webtoonInfo // include image information
    @State var alertMessage : String = "북마크에 추가되었습니다."

    // initializing variable
    init(Webtoon : WebtoonNotStored) {
        self.SelectedWebtoon = Webtoon
        webtoonInformation = getWebtoonInfo(urlAddress: Webtoon.url)
    }

    var body: some View {
        HStack {
//            WebView(urlToLoad: webtoonInformation.imageSource)
//                .frame(width : 100, height: 80) // thumbnail
            Image(systemName : "person.fill")
                .data(url: URL(string : webtoonInformation.imageSource)!)
                .frame(width : 100, height: 80)
            Text(SelectedWebtoon.name)
                .fontWeight(.bold)
            Spacer()
            Button(action : {
                print("\(SelectedWebtoon.name) clicked")
                isClicked = true
                
                for i in 0..<Webtoons.count {
                    if SelectedWebtoon.name == Webtoons[i].name {
                        isBookmarked = 1
                        alertMessage = "이미 추가된 웹툰입니다."
                    }
                }
                
                if isBookmarked == 0 {
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
                }
            }) {
                Image(systemName: "heart.fill")
                    .foregroundColor(
                        duplicateCheck(Webtoons: Webtoons, checkWebtoonName: SelectedWebtoon.name) ? Color.red : Color.gray)
                    .font(.system(size : 30))
            }.alert(isPresented: $isClicked, content: {
                Alert(title: Text("북마크에 추가"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
            })
        } // HStack
        
    }
}
