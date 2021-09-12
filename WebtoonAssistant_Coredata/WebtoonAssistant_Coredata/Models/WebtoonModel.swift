//
//  WebtoonInformation.swift
//  WebtoonAssistant_Coredata
//
//  Created by 박규림 on 2021/02/23.
//

import SwiftUI
import CoreData

// in Webtoon_CoreDataProperties
// Extension class Webtoon
class WebtoonModel {
    static let instance = WebtoonModel() // Singleton pattern
    
    private init() {}
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment (\.presentationMode) var presentationMode
    
    @FetchRequest(entity : Webtoon.entity(), sortDescriptors: [])
    var Webtoons: FetchedResults<Webtoon>
    
    func add(webtoon : WebtoonNotStored) {

    }
}

// Core data 에 저장되지 않은 웹툰
struct WebtoonNotStored : Hashable {
    var name : String
    var uploadedDay : String
    var url : String
    var bookmarked : Bool
}

struct webtoonInfo {
    var imageSource : String // 이미지 소스 url
    var recentUpload : String // 최근 업로드 날짜
    var recentEpisode : String // 최근화 제목
}
