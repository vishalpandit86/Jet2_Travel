//
//  NetworkConfig.swift
//  Jet2TT
//
//  Created by Vishal Pandit on 26/07/20.
//  Copyright © 2020 Vishal. All rights reserved.
//

import Foundation

protocol APIProtocol {
    func httpMethodType() -> HTTPMethodType
    func apiEndPath() -> String
    func apiBasePath() -> String
}

public enum HTTPMethodType: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
}

protocol APIModelType {
    var api: APIProtocol { get set }
    var parameters: [String: Any]? { get set }
}

struct APIRequestModel: APIModelType {
    var api: APIProtocol
    var parameters: [String: Any]?

    init(api: APIProtocol, parameters: [String: Any]? = nil) {
        self.api = api
        self.parameters = parameters
    }
}

struct NetworkConfig {

    func generateHeader() -> [String: String] {
        var headerDict = [String: String]()
        headerDict["Content-Type"] = "application/json"

        return headerDict
    }
}
