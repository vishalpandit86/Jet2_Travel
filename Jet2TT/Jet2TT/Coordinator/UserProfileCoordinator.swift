//
//  UserProfileCoordinator.swift
//  Jet2TT
//
//  Created by Vishal Pandit on 27/07/20.
//  Copyright © 2020 Vishal. All rights reserved.
//

import Foundation
import UIKit

final class UserProfileCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []

    private let navigationController: UINavigationController
    var parentCoordinator: ArticleListCoordinator?

    private let user: User!

    init(navigationController: UINavigationController, user: User) {
        self.navigationController = navigationController
        self.user = user
    }

    func start() {
        let userProfileVC: UserProfileController = .instantiate()
        let viewModel = UserProfileViewModel(user: user)
        viewModel.coordinator = self
        userProfileVC.viewModel = viewModel
        navigationController.pushViewController(userProfileVC, animated: true)
    }

    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }

    func childDidFinish(_ childCoordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { (coordinator) -> Bool in
            return childCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
}
