//
//  UsersViewModel.swift
//  Jet2TT
//
//  Created by Vishal Pandit on 27/07/20.
//  Copyright © 2020 Vishal. All rights reserved.
//

import Foundation
import CoreData

final class UsersViewModel: NSObject {
    let title = "Users"

    weak var coordinator: UsersCoordinator?

    private let usersNetworkService: UsersServiceRequestType!
    private let coreDataManager: CoreDataManager!
    private weak var uiUpdater: UIUpdaterProtocol!

    private var fetchSession: URLSessionDataTask?

    var currentPage: Int = 0

    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDUser")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "blogId == %@", "")
        let fetchRequestController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coreDataManager.moc, sectionNameKeyPath: #keyPath(CDArticle.id), cacheName: nil)
        return fetchRequestController
    }()

    init(with usersNetworkService: UsersServiceRequestType,
         coreDataManager: CoreDataManager = CoreDataManager.shared,
         uiUpdater: UIUpdaterProtocol) {

        self.usersNetworkService = usersNetworkService
        self.coreDataManager = coreDataManager
        self.uiUpdater = uiUpdater

        super.init()
    }

    var isLoading: Bool {
        !(fetchSession?.progress.isFinished ?? true)
    }

    func viewDidLoad() {
        fetchUsers()
    }

    func fetchUsers() {
           if !(fetchSession?.progress.isFinished ?? true) {
               return
           }

        let count = allObjectCount()
        currentPage = (count / 10)

        let queryModel = CommonAPIQuery(page: currentPage + 1, limit: 10)
        fetchSession = usersNetworkService.getUsers(apiQueryModel: queryModel, completion: { [weak self] (response) in

            self?.fetchSession = nil
            DispatchQueue.main.async {
                switch response {
                case .success(let userList):
                    self?.coreDataManager.prepare(dataForSaving: userList)
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
}

extension UsersViewModel: DataStoreProtocol {

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

    func itemAt(indexPath: IndexPath) -> UserCellViewModel? {
        guard let item = self.fetchedResultsController.object(at: IndexPath(row: 0, section: indexPath.row)) as? CDUser, let coordinator = coordinator else {
            return nil
        }

        var cellViewModel = UserCellViewModel(item.convertToUser())
        cellViewModel.onUserSelect = coordinator.onUserSelect
        return cellViewModel
    }
}
