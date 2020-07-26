//
//  CDMedia+Extension.swift
//  Jet2TT
//
//  Created by Vishal Pandit on 26/07/20.
//  Copyright © 2020 Vishal. All rights reserved.
//

import Foundation

extension CDMedia {
    func convertToMedia() -> Media {
        return Media(id: self.id!, blogId: self.blogId!, createdAt: self.createdAt!, image: self.image!, title: self.title!, url: self.url!)
    }
}
