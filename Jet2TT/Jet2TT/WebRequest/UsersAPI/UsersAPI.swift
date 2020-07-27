//
//  UsersAPI.swift
//  Jet2TT
//
//  Created by Vishal Pandit on 27/07/20.
//  Copyright © 2020 Vishal. All rights reserved.
//

import Foundation

enum UsersAPI {
    case getUsers(CommonAPIQuery)
}

extension UsersAPI: APIProtocol {

    func apiBasePath() -> String {
        switch self {
        case .getUsers(_):
            return NetworkConstant.baseURL
        }
    }

    func httpMethodType() -> HTTPMethodType {
        var methodType = HTTPMethodType.get
        switch self {
        case .getUsers(_):
            methodType = .get
        }
        return methodType
    }

    func apiEndPath() -> String {
        var apiEndPath = ""
        switch self {
        case .getUsers(let queryModel):
            apiEndPath += NetworkConstant.users + "page=\(queryModel.page)&limit=\(queryModel.limit)"
        }
        return apiEndPath
    }
}
