//
//  Article.swift
//  Jet2TT
//
//  Created by Vishal Pandit on 26/07/20.
//  Copyright © 2020 Vishal. All rights reserved.
//

import Foundation

// MARK: - Article
struct Article: Codable {
    let id, createdAt, content: String
    let comments, likes: Int32
    let media: [Media]
    let user: [User]
}

// MARK: - Media
struct Media: Codable {
    let id, blogId, createdAt: String
    let image: String
    let title: String
    let url: String
}

// MARK: - User
struct User: Codable {
    let id, createdAt, name: String
    let blogId: String?
    let avatar: String
    let lastname, city, designation, about: String
}
