//
//  UsersViewController.swift
//  Jet2TT
//
//  Created by Vishal Pandit on 27/07/20.
//  Copyright © 2020 Vishal. All rights reserved.
//


import UIKit
import CoreData

final class UsersViewController: UIViewController, UIUpdaterProtocol {
    var viewModel: UsersViewModel!
    @IBOutlet weak var userTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        updateUI()
        viewModel.viewDidLoad()
    }

    private func setupViews() {
        navigationItem.title = viewModel.title

        userTableView.dataSource = self
        userTableView.delegate = self

        userTableView.rowHeight = UITableView.automaticDimension
        userTableView.estimatedRowHeight = 60

        viewModel.fetchedResultsController.delegate = self

        userTableView.register(UserCell.self, forCellReuseIdentifier: "UserCellID")
        userTableView.register(LoadingCell.self, forCellReuseIdentifier: "LoadingCellID")

    }

    func updateUI() {
        viewModel.getDataFromDB()
        userTableView.reloadData()
    }

    func updateOfflineUI(error: Error) {
        viewModel.getDataFromDB()
        userTableView.reloadData()

        showMessage(title: "Offline", message: error.localizedDescription, actionTitle: NSLocalizedString("OK", comment: ""))
    }

}

extension UsersViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        userTableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch (type) {
        case .update:
            if let newIndexPath = newIndexPath {
                if userTableView.indexPathsForVisibleRows?.firstIndex(of: newIndexPath) != nil {
                    if let cell = userTableView.cellForRow(at: newIndexPath) as? UserCell, let cellVM = viewModel.itemAt(indexPath: newIndexPath) {
                        cell.update(with: cellVM)
                    }
                }
            }
        case .insert:
            if let newIndexPath = newIndexPath {
                userTableView.insertRows(at: [IndexPath(row: newIndexPath.section, section: 0)], with: .none)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                if indexPath == newIndexPath {
                    if let cell = userTableView.cellForRow(at: newIndexPath) as? UserCell, let cellVM = viewModel.itemAt(indexPath: newIndexPath) {
                        cell.update(with: cellVM)
                    }
                } else {
                    userTableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
                    userTableView.insertRows(at: [IndexPath(row: newIndexPath.row, section: 0)], with: .none)
                }
            }
        default:
            break
        }

    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        userTableView.endUpdates()
    }
}

extension UsersViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.allObjectCount()
        } else if section == 1 {
            return 1
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCellID", for: indexPath) as! UserCell

            guard let cellVM = viewModel.itemAt(indexPath: indexPath) else {
                return cell
            }

            cell.update(with: cellVM)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCellID", for: indexPath) as! LoadingCell
            cell.spinner.startAnimating()
            return cell
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if (offsetY > contentHeight - scrollView.frame.height * 4) && !viewModel.isLoading {
            viewModel.fetchUsers()
        }
    }
}

extension UsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let cellVM = viewModel.itemAt(indexPath: indexPath) else {
            return
        }

        cellVM.onUserSelect(cellVM.user)
    }
}
