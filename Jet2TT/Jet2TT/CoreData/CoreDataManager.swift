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

    func saveDataInBackground() {
        persistentContainer.performBackgroundTask { (context) in

            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
    func get<T: NSManagedObject>(_ id: NSManagedObjectID) -> T? {
        do {
            return try moc.existingObject(with: id) as? T
        } catch {
            print(error)
        }
        return nil
    }

    func getAll<T: NSManagedObject>() -> [T] {
        do {
            let fetchReq = NSFetchRequest<T>(entityName: "\(T.self)")
            return try moc.fetch(fetchReq)
        } catch {
            print(error)
            return []
        }
    }

}
