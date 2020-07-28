//
//  CoreDataManager.swift
//  Jet2TT
//
//  Created by Vishal Pandit on 26/07/20.
//  Copyright © 2020 Vishal. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() { }

    lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "Jet2TT")
        persistentContainer.loadPersistentStores { _, error in
            print(error?.localizedDescription ??
            "")
        }
        return persistentContainer
    }()

    var moc: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func prepare(dataForSaving: [User]) {
        _ = dataForSaving.map({createEntityFrom(data: $0)})
        save()
    }

    private func createEntityFrom(data: User) -> CDUser? {
        let user = CDUser(context: moc)
        user.id = data.id
        user.blogId = data.blogId ?? ""
        user.createdAt = data.createdAt
        user.name = data.name
        user.avatar = data.avatar
        user.lastname = data.lastname
        user.designation = data.designation
        user.about = data.about
        user.city = data.city

        return user
    }

    func prepare(dataForSaving: [Article]) {
        _ = dataForSaving.map({createEntityFrom(data: $0)})
        save()
    }

    private func createEntityFrom(data: Article) -> CDArticle? {
            let article = CDArticle(context: moc)

            article.id = Int32(data.id)!
            article.comments = data.comments
            article.likes = data.likes
            article.content = data.content
            article.createdAt = data.createdAt

            var mediaSet: Set<CDMedia> = []
            for mediaItem in data.media {
                let media = CDMedia(context: moc)
                media.id = mediaItem.id
                media.blogId = mediaItem.blogId
                media.createdAt = mediaItem.createdAt
                media.image = mediaItem.image
                media.title = mediaItem.title
                media.url = mediaItem.url
                mediaSet.update(with: media)
            }
            article.addToToMedia(mediaSet)

            var userSet: Set<CDUser> = []
            for userItem in data.user {
                let user = CDUser(context: moc)
                user.id = userItem.id
                user.blogId = userItem.blogId
                user.createdAt = userItem.createdAt
                user.name = userItem.name
                user.avatar = userItem.avatar
                user.lastname = userItem.lastname
                user.designation = userItem.designation
                user.about = userItem.about
                user.city = userItem.city
                userSet.update(with: user)
            }
            article.addToToUser(userSet)

        return article
    }

    func save() {
        do {
            try moc.save()
        } catch {
            print(error)
        }
    }
}
