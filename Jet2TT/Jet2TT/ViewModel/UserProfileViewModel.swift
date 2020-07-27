//
//  UserProfileViewModel.swift
//  Jet2TT
//
//  Created by Vishal Pandit on 27/07/20.
//  Copyright © 2020 Vishal. All rights reserved.
//

import Foundation
import UIKit

final class UserProfileViewModel {

    let title = "User Profile"
    weak var coordinator: UserProfileCoordinator?

    private let user: User!

    init(user: User) {
        self.user = user
    }

    var userFullName: String {
        "\(user.name) \(user.lastname)"
    }

    var designation: String {
        user.designation
    }

    var city: String {
        user.city
    }

    var about: String {
        user.about
    }

    var imageUrl: String {
        user.avatar
    }

    func viewDidDisappear() {
        coordinator?.didFinish()
    }

    func loadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        ImageCacheManager.loadImage(urlString, completion: completion)
    }
}
