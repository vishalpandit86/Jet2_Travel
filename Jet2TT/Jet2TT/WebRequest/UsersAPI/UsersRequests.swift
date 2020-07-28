//
//  UsersRequests.swift
//  Jet2TT
//
//  Created by Vishal Pandit on 27/07/20.
//  Copyright © 2020 Vishal. All rights reserved.
//

import Foundation

typealias GetUsersResponse = (Result<[User], Error>) -> Void

protocol UsersServiceRequestType {
    @discardableResult
    func getUsers(apiQueryModel: CommonAPIQuery, completion: @escaping GetUsersResponse) -> URLSessionDataTask?
}

struct UsersRequests: UsersServiceRequestType {
    func getUsers(apiQueryModel: CommonAPIQuery, completion: @escaping GetUsersResponse) -> URLSessionDataTask? {

        let usersRequestModel = APIRequestModel(api: UsersAPI.getUsers(apiQueryModel))

        return NetworkHelper.requestAPI(apiModel: usersRequestModel) { response in
            switch response {
            case .success(let serverData):
                JSONParserHelper.decodeFrom(serverData, returningModelType: [User].self) { (userList, error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    if let userList = userList {
                        completion(.success(userList))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
