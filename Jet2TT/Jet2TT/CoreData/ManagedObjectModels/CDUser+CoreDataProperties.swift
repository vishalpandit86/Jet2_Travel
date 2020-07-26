//
//  CDUser+CoreDataProperties.swift
//  Jet2TT
//
//  Created by Vishal Pandit on 26/07/20.
//  Copyright © 2020 Vishal. All rights reserved.
//
//

import Foundation
import CoreData


extension CDUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDUser> {
        return NSFetchRequest<CDUser>(entityName: "CDUser")
    }

    @NSManaged public var id: String?
    @NSManaged public var blogId: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var name: String?
    @NSManaged public var avatar: String?
    @NSManaged public var lastname: String?
    @NSManaged public var city: String?
    @NSManaged public var designation: String?
    @NSManaged public var about: String?
    @NSManaged public var toArticle: Set<CDArticle>?

}

// MARK: Generated accessors for toArticle
extension CDUser {

    @objc(addToArticleObject:)
    @NSManaged public func addToToArticle(_ value: CDArticle)

    @objc(removeToArticleObject:)
    @NSManaged public func removeFromToArticle(_ value: CDArticle)

    @objc(addToArticle:)
    @NSManaged public func addToToArticle(_ values: Set<CDArticle>)

    @objc(removeToArticle:)
    @NSManaged public func removeFromToArticle(_ values: Set<CDArticle>)

}
