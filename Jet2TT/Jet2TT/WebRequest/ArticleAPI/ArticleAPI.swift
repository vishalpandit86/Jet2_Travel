//
//  ArticleAPI.swift
//  Jet2TT
//
//  Created by Vishal Pandit on 26/07/20.
//  Copyright © 2020 Vishal. All rights reserved.
//

import Foundation

struct CommonAPIQuery {
    let page: Int
    let limit: Int
}

enum ArticleAPI {
    case getArticleList(CommonAPIQuery)
}

extension ArticleAPI: APIProtocol {

    func apiBasePath() -> String {
        switch self {
        case .getArticleList(_):
            return NetworkConstant.baseURL
        }
    }

    func httpMethodType() -> HTTPMethodType {
        var methodType = HTTPMethodType.get
        switch self {
        case .getArticleList(_):
            methodType = .get
        }
        return methodType
    }

    func apiEndPath() -> String {
        var apiEndPath = ""
        switch self {
        case .getArticleList(let queryModel):
            apiEndPath += NetworkConstant.blogs + "page=\(queryModel.page)&limit=\(queryModel.limit)"
        }
        return apiEndPath
    }
}
