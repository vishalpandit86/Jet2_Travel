//
//  CDArticle+CoreDataProperties.swift
//  Jet2TT
//
//  Created by Vishal Pandit on 26/07/20.
//  Copyright © 2020 Vishal. All rights reserved.
//
//

import Foundation
import CoreData


extension CDArticle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDArticle> {
        return NSFetchRequest<CDArticle>(entityName: "CDArticle")
    }

    @NSManaged public var id: Int32
    @NSManaged public var createdAt: String?
    @NSManaged public var content: String?
    @NSManaged public var comments: Int32
    @NSManaged public var likes: Int32
    @NSManaged public var toMedia: Set<CDMedia>?
    @NSManaged public var toUser: Set<CDUser>?

}

// MARK: Generated accessors for toMedia
extension CDArticle {

    @objc(addToMediaObject:)
    @NSManaged public func addToToMedia(_ value: CDMedia)

    @objc(removeToMediaObject:)
    @NSManaged public func removeFromToMedia(_ value: CDMedia)

    @objc(addToMedia:)
    @NSManaged public func addToToMedia(_ values: Set<CDMedia>)

    @objc(removeToMedia:)
    @NSManaged public func removeFromToMedia(_ values: Set<CDMedia>)

}

// MARK: Generated accessors for toUser
extension CDArticle {

    @objc(addToUserObject:)
    @NSManaged public func addToToUser(_ value: CDUser)

    @objc(removeToUserObject:)
    @NSManaged public func removeFromToUser(_ value: CDUser)

    @objc(addToUser:)
    @NSManaged public func addToToUser(_ values: Set<CDUser>)

    @objc(removeToUser:)
    @NSManaged public func removeFromToUser(_ values: Set<CDUser>)

}
