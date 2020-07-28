//
//  DataStore.swift
//  Jet2TT
//
//  Created by Vishal Pandit on 26/07/20.
//  Copyright © 2020 Vishal. All rights reserved.
//

import Foundation
import CoreData

protocol UIUpdaterProtocol: class {
    func updateUI()
    func updateOfflineUI(error: Error)
}

class ArticleListViewModel: NSObject {

    private let articleNetworkService: ArticleServiceRequestType!
    private let coreDataManager: CoreDataManager!
    private weak var uiUpdater: UIUpdaterProtocol!

    private var fetchSession: URLSessionDataTask?

    let title = "Articles"
    weak var coordinator: ArticleListCoordinator?

    var currentPage: Int = 0

    var isLoading: Bool {
        !(fetchSession?.progress.isFinished ?? true)
    }

    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDArticle")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        let fetchRequestController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coreDataManager.moc, sectionNameKeyPath: #keyPath(CDArticle.id), cacheName: nil)
        return fetchRequestController
    }()

    init(with articleNetworkService: ArticleServiceRequestType,
         coreDataManager: CoreDataManager = CoreDataManager.shared,
         uiUpdater: UIUpdaterProtocol) {

        self.articleNetworkService = articleNetworkService
        self.coreDataManager = coreDataManager
        self.uiUpdater = uiUpdater

        super.init()
    }
    
    func viewDidLoad() {
        fetchArticles()
    }

    func fetchArticles() {
        if !(fetchSession?.progress.isFinished ?? true) {
            return
        }

        let count = allObjectCount()
        currentPage = (count / 10)

        let queryModel = CommonAPIQuery(page: currentPage + 1, limit: 10)
        fetchSession = articleNetworkService.getAllArticles(apiQueryModel: queryModel, completion: { [weak self] (response) in

            self?.fetchSession = nil
            DispatchQueue.main.async {
                switch response {
                case .success(let articleList):
                    self?.coreDataManager.prepare(dataForSaving: articleList)
                    self?.uiUpdater?.updateUI()

                case .failure(let error):
                    self?.uiUpdater?.updateOfflineUI(error: error)
                    print(error)
                }
            }
        })

    }

    func getDataFromDB() {
        do {
            try fetchedResultsController.performFetch()
        } catch(let ex) {
            print(ex.localizedDescription)
        }
    }

    func showAllUsers() {
        coordinator?.onShowAllUsers()
    }
}

extension ArticleListViewModel: DataStoreProtocol {

    func allObjectCount() -> Int {
        guard let allObjects = fetchedResultsController.fetchedObjects else { return 0 }
        return allObjects.count
    }

    func sectionCount() -> Int {
        guard let sections = self.fetchedResultsController.sections else {
            return 0
        }
        return sections.count
    }

    func titleForHeaderAt(section: Int) -> String {

        guard let sectionInfo = self.fetchedResultsController.sections?[section] else { return "" }
        return sectionInfo.name
    }

    func itemAt(indexPath: IndexPath) -> ArticleCellViewModel? {
        guard let item = self.fetchedResultsController.object(at: IndexPath(row: 0, section: indexPath.row)) as? CDArticle else {
            return nil
        }
        if let article = createArticleViewModelWith(item),
            let coordinator = coordinator {
            var cellModel = ArticleCellViewModel(article)
            cellModel.onUserSelect = coordinator.onUserSelect
            return cellModel
        }
        return nil
    }

    private func createArticleViewModelWith(_ item: CDArticle) -> Article? {

        return Article(id: "\(item.id)", createdAt: item.createdAt!, content: item.content!, comments: item.comments, likes: item.likes, media: item.convertToMediaList() ?? [], user: item.convertToUserList() ?? [])
    }
}
