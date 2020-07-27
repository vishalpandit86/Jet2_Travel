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

    enum CacheKey {
        case avatar
        case media
    }

    var onUserSelect: (User) -> Void = { _ in }

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
        "\(article.comments.formatUsingAbbreviation()) Comments"
    }

    var likes: String {
        "\(article.likes.formatUsingAbbreviation()) Likes"
    }

    var userName: String? {
        if let fName = article.user.first?.name, let lName = article.user.first?.lastname {
            return "\(fName) \(lName)"
        }
        return nil
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

    var user: User? {
        if let user = article.user.first {
            return user
        }
        return nil
    }

    func loadImage(cacheKey: CacheKey, completion: @escaping (UIImage?) -> Void) {
        let urlString = cacheKey == .media ? self.article.media.first!.image :  self.article.user.first!.avatar
        ImageCacheManager.loadImage(urlString, completion: completion)
    }
}
