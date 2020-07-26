//
//  ArticleCellViewModel.swift
//  Jet2TT
//
//  Created by Vishal Pandit on 26/07/20.
//  Copyright © 2020 Vishal. All rights reserved.
//

import Foundation
import UIKit

struct ArticleCellViewModel {
    private let article: Article

    static let imageCache = NSCache<NSString, UIImage>()

    private var avatarCacheKey: String {
        article.user.first!.avatar
    }

    private var mediaCacheKey: String {
        if let key = article.media.first?.id {
            return key
        }
        return UUID().uuidString
    }

    enum CacheKey {
        case avatar
        case media
    }

    private let imageQueue = DispatchQueue(label: "imageQueue", qos: .background)

    static var formatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter
    }()

    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" //2020-04-17T09:46:47.375Z
        return formatter
    }()

    init(_ article: Article) {
        self.article = article
    }

    var createAtString: String {
        if let createDate = Self.dateFormatter.date(from: article.createdAt) {
            return Self.formatter.localizedString(for: createDate, relativeTo: Date())
        }
        return ""
    }

    var content: String? {
        article.content
    }

    var comments: String {
        "\(article.comments) Comments"
    }

    var likes: String {
        "\(article.likes) Likes"
    }

    var userName: String? {
        article.user.first?.name
    }

    var designation: String? {
        article.user.first?.designation
    }

    var isMediaAvailable: Bool {
        if let _ = article.media.first?.image {
            return true
        }
        return false
    }
    func loadImage(cacheKey: CacheKey, completion: @escaping (UIImage?) -> Void) {
        // check cache 1st
        let key = cacheKey == .media ? mediaCacheKey : avatarCacheKey

        if let image = Self.imageCache.object(forKey: key as NSString) {
            DispatchQueue.main.async {
                completion(image)
            }
        } else {
            imageQueue.async {
                let url = cacheKey == .media ? URL(string: self.article.media.first!.image) : URL(string: self.article.user.first!.avatar)
                URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) -> Void in

                    if error != nil {
                        print(error ?? "error")
                        completion(nil)
                        return
                    }
                    DispatchQueue.main.async(execute: { () -> Void in
                        if let image = UIImage(data: data!) {
                            Self.imageCache.setObject(image, forKey: key as NSString)
                            DispatchQueue.main.async {
                                completion(image)
                            }
                        }
                    })

                }).resume()

            }

        }
    }
}
