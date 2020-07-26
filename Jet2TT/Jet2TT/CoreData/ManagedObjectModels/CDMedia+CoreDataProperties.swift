//
//  CDMedia+CoreDataProperties.swift
//  Jet2TT
//
//  Created by Vishal Pandit on 26/07/20.
//  Copyright © 2020 Vishal. All rights reserved.
//
//

import Foundation
import CoreData


extension CDMedia {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDMedia> {
        return NSFetchRequest<CDMedia>(entityName: "CDMedia")
    }

    @NSManaged public var id: String?
    @NSManaged public var blogId: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var image: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var toArticle: CDArticle?

}
