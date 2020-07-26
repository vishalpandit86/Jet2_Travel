//
//  CDUser+Extension.swift
//  Jet2TT
//
//  Created by Vishal Pandit on 26/07/20.
//  Copyright © 2020 Vishal. All rights reserved.
//

import Foundation

extension CDUser {
    func convertToUser() -> User {
        return User(id: self.id!, createdAt: self.createdAt!, name: self.name!, blogId: self.blogId ?? "", avatar: self.avatar ?? "", lastname: self.lastname ?? "", city: self.city ?? "", designation: self.designation!, about: self.about ?? "")
    }
}
