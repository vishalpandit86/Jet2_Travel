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
}

class ArticleListViewModel: NSObject {

    private let articleNetworkService: ArticleServiceRequestType!
    private let coreDataManager: CoreDataManager!
    private weak var uiUpdater: UIUpdaterProtocol!

    private var fetchSession: URLSessionDataTask?

    var title = "Articles"
    var coordinator: ArticleListCoordinator?

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

        let queryModel = CommonAPIQuery(page: 1, limit: 10)
        fetchSession = articleNetworkService.getAllArticles(apiQueryModel: queryModel, completion: { [weak self] (response) in

            self?.fetchSession = nil

            switch response {
            case .success(let articleList):
                print(articleList)
                DispatchQueue.main.async {
                    self?.coreDataManager.prepare(dataForSaving: articleList)
                    self?.uiUpdater?.updateUI()
                }

            case .failure(let error):
                print(error)
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
}

extension ArticleListViewModel: DataStoreProtocol{


    func sectionCount() ->Int{
        guard let sections = self.fetchedResultsController.sections else {
            return 0
        }
        return sections.count
    }

    func rowsCount(for section:Int) -> Int{

        guard let sections = self.fetchedResultsController.sections else {
            return 0
        }

        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }

    func titleForHeaderAt(section: Int) -> String{

        guard let sectionInfo = self.fetchedResultsController.sections?[section] else { return "" }
        return sectionInfo.name
    }

    func itemAt(indexPath: IndexPath) -> Article? {
        guard let item = self.fetchedResultsController.object(at: indexPath) as? CDArticle else{
            return nil
        }
        return createArticleViewModelWith(item)
    }

    private func createArticleViewModelWith(_ item: CDArticle) -> Article? {

        return Article(id: item.id!, createdAt: item.createdAt!, content: item.content!, comments: item.comments, likes: item.likes, media: item.convertToMediaList() ?? [], user: item.convertToUserList() ?? [])
       }
}
