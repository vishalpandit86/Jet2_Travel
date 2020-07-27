//
//  UsersCoordinator.swift
//  Jet2TT
//
//  Created by Vishal Pandit on 27/07/20.
//  Copyright © 2020 Vishal. All rights reserved.
//

import Foundation
import UIKit

final class UsersCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []

    private let navigationController: UINavigationController
    var parentCoordinator: ArticleListCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let usersVC : UsersViewController = .instantiate()
        let viewModel = UsersViewModel(with: UsersRequests(), coreDataManager: CoreDataManager.shared, uiUpdater: usersVC)
        viewModel.coordinator = self
        usersVC.viewModel = viewModel

        navigationController.pushViewController(usersVC, animated: true)
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

    func onUserSelect(_ user: User) {
        let coordinator = UserProfileCoordinator(navigationController: navigationController, user: user)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
