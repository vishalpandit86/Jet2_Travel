//
//  ArticleRequests.swift
//  Jet2TT
//
//  Created by Vishal Pandit on 26/07/20.
//  Copyright © 2020 Vishal. All rights reserved.
//

import Foundation

typealias GetArticleResponse = (Result<[Article], Error>) -> Void

protocol ArticleServiceRequestType {
    @discardableResult
    func getAllArticles(apiQueryModel: CommonAPIQuery, completion: @escaping GetArticleResponse) -> URLSessionDataTask?
}

struct ArticleRequests: ArticleServiceRequestType {
    func getAllArticles(apiQueryModel: CommonAPIQuery, completion: @escaping GetArticleResponse) -> URLSessionDataTask? {

        let articleRequestModel = APIRequestModel(api: ArticleAPI.getArticleList(apiQueryModel))

        return NetworkHelper.requestAPI(apiModel: articleRequestModel) { response in
            switch response {
            case .success(let serverData):
                JSONParserHelper.decodeFrom(serverData, returningModelType: [Article].self) { (articleList, error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    if let articleList = articleList {
                        completion(.success(articleList))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
