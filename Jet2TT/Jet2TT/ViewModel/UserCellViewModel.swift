//
//  UserCellViewModel.swift
//  Jet2TT
//
//  Created by Vishal Pandit on 27/07/20.
//  Copyright © 2020 Vishal. All rights reserved.
//

import Foundation
import UIKit

struct UserCellViewModel {
    private(set) var user: User!
    var onUserSelect: (User) -> Void = { _ in }

    init(_ user: User) {
        self.user = user
    }

    var userFullname: String? {
        "\(user.name) \(user.lastname)"
    }

    var designation: String {
        user.designation
    }

    var city: String {
        user.city
    }

    var imageUrl: String? {
        user.avatar
    }

    func loadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        ImageCacheManager.loadImage(urlString, completion: completion)
    }
}
