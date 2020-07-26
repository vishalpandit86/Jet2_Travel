//
//  CDArticle+Extension.swift
//  Jet2TT
//
//  Created by Vishal Pandit on 26/07/20.
//  Copyright © 2020 Vishal. All rights reserved.
//

import Foundation

extension CDArticle {

    func convertToArticle() -> Article {
        return Article(id: "\(self.id)", createdAt: self.createdAt!, content: self.content!, comments: self.comments, likes: self.likes, media: self.convertToMediaList() ?? [], user: self.convertToUserList() ?? [])
    }

    func convertToMediaList() -> [Media]? {
        guard self.toMedia != nil && self.toMedia?.count != 0 else { return nil }

        var mediaList: [Media] = []

        self.toMedia?.forEach({ (cdMedia) in
            mediaList.append(cdMedia.convertToMedia())
        })

        return mediaList
    }

    func convertToUserList() -> [User]? {
        guard self.toUser != nil && self.toUser?.count != 0 else { return nil }

        var userList: [User] = []

        self.toUser?.forEach({ (cdUser) in
            userList.append(cdUser.convertToUser())
        })

        return userList


    }
}
