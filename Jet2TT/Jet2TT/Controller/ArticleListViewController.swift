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
        viewModel.viewDidLoad()
    }

    private func setupViews() {
        navigationItem.title = viewModel.title

        articleTableView.dataSource = self
        articleTableView.delegate = self
        viewModel.fetchedResultsController.delegate = self
        articleTableView.register(ArticleCell.self, forCellReuseIdentifier: "ArticleCellID")
    }

    func updateUI() {
        viewModel.getDataFromDB()
        articleTableView.reloadData()
    }
}

extension ArticleListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        articleTableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                articleTableView.insertRows(at: [indexPath], with: .middle)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                articleTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        default:
            break
        }

    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {

        switch type {
        case .insert:
            articleTableView.insertSections(IndexSet(integer: sectionIndex), with: .middle)
        case .delete:
            articleTableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            break;
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        articleTableView.endUpdates()
    }
}

extension ArticleListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //viewModel.sectionCount()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowsCount(for: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCellID", for: indexPath) as! ArticleCell

        guard let article = viewModel.itemAt(indexPath: indexPath) else{
            return cell
        }
        cell.titleLabel.text = article.content
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return viewModel.titleForHeaderAt(section: section)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
    }

}

extension ArticleListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
