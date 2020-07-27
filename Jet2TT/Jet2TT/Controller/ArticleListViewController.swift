//
//  ArticleListViewController.swift
//  Jet2TT
//
//  Created by Vishal Pandit on 26/07/20.
//  Copyright © 2020 Vishal. All rights reserved.
//

import UIKit
import CoreData

class ArticleListViewController: UIViewController, UIUpdaterProtocol {
    var viewModel: ArticleListViewModel!
    @IBOutlet weak var articleTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        updateUI()
        viewModel.viewDidLoad()
    }

    private func setupViews() {
        navigationItem.title = viewModel.title

        articleTableView.dataSource = self
        articleTableView.delegate = self

        articleTableView.rowHeight = UITableView.automaticDimension
        articleTableView.estimatedRowHeight = 600

        viewModel.fetchedResultsController.delegate = self
        articleTableView.register(ArticleCell.self, forCellReuseIdentifier: "ArticleCellID")
        articleTableView.register(LoadingCell.self, forCellReuseIdentifier: "LoadingCellID")
    }

    func updateUI() {
        viewModel.getDataFromDB()
        articleTableView.reloadData()
    }

    func updateOfflineUI(error: Error) {
        viewModel.getDataFromDB()
        articleTableView.reloadData()

        showMessage(title: "Offline", message: error.localizedDescription, actionTitle: NSLocalizedString("OK", comment: ""))
    }
}

extension ArticleListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        articleTableView.beginUpdates()
    }

//    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//        switch type {
//        case .insert:
//            articleTableView.insertSections(IndexSet(integer: 0), with: .none)
//        case .delete:
//            articleTableView.deleteSections(IndexSet(integer: 0), with: .none)
//        case .move, .update:
//            articleTableView.reloadSections(IndexSet(integer: 0), with: .none)
//        @unknown default:
//            fatalError("Unknown NSFetchedResultsChangeType not implemented")
//        }
//    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch (type) {
        case .update:
            if let newIndexPath = newIndexPath {
                if articleTableView.indexPathsForVisibleRows?.firstIndex(of: newIndexPath) != nil {
                    if let cell = articleTableView.cellForRow(at: newIndexPath) as? ArticleCell, let articleCellVM = viewModel.itemAt(indexPath: newIndexPath) {
                        cell.update(with: articleCellVM)
                    }
                }
            }
        case .insert:
            if let newIndexPath = newIndexPath {
                articleTableView.insertRows(at: [IndexPath(row: newIndexPath.section, section: 0)], with: .none)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                if indexPath == newIndexPath {
                    if let cell = articleTableView.cellForRow(at: newIndexPath) as? ArticleCell, let articleCellVM = viewModel.itemAt(indexPath: newIndexPath) {
                        cell.update(with: articleCellVM)
                    }
                } else {
                    articleTableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
                    articleTableView.insertRows(at: [IndexPath(row: newIndexPath.row, section: 0)], with: .none)
                }
            }
        default:
            break
        }

    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        articleTableView.endUpdates()
    }
}

extension ArticleListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.allObjectCount()
        } else if section == 1 {
            //Return the Loading cell
            return 1
        } else {
            //Return nothing
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCellID", for: indexPath) as! ArticleCell

            guard let articleCellVM = viewModel.itemAt(indexPath: indexPath) else {
                return cell
            }

            cell.update(with: articleCellVM)
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
            viewModel.fetchArticles()
        }
    }
}

extension ArticleListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
