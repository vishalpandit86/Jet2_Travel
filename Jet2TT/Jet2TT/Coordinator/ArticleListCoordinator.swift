//
//  ArticleListCoordinator.swift
//  Jet2TT
//
//  Created by Vishal Pandit on 26/07/20.
//  Copyright © 2020 Vishal. All rights reserved.
//

import Foundation
import UIKit

final class ArticleListCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []

    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let articleListVC : ArticleListViewController = .instantiate()
        articleListVC.viewModel = ArticleListViewModel(with: ArticleRequests(), uiUpdater: articleListVC)
        // set VM and then navigate
        navigationController.setViewControllers([articleListVC], animated: false)
    }

    func startShowUserProfile() {

    }

    func childDidFinish(_ childCoordinator: Coordinator) {

        if let index = childCoordinators.firstIndex(where: { (coordinator) -> Bool in
            return childCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
}
