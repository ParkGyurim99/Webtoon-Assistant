//
//  Webtoon+CoreDataProperties.swift
//  WebtoonAssistant_Coredata
//
//  Created by 박규림 on 2021/02/23.
//
//

import Foundation
import CoreData


extension Webtoon {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Webtoon> {
        return NSFetchRequest<Webtoon>(entityName: "Webtoon")
    }

    @NSManaged public var name: String?
    @NSManaged public var uploadedDay: String?
    @NSManaged public var url: String?
    @NSManaged public var isBookmarked: Bool
    @NSManaged public var id: UUID?

}

extension Webtoon : Identifiable {

}
