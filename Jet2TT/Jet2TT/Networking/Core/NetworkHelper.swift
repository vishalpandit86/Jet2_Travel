//
//  NetworkHelper.swift
//  Jet2TT
//
//  Created by Vishal Pandit on 26/07/20.
//  Copyright © 2020 Vishal. All rights reserved.
//

import Foundation

//APPError enum which shows all possible errors
public enum NetworkError: Error {
    case networkError(Error)
    case dataNotFound
    case jsonParsingError(Error)
    case invalidStatusCode(Int)
    case invalidURL
    case incorrectData(Data)
    case unknown
}

typealias NetworkCompletionBlock = (Result<Data, Error>) -> Void

struct NetworkHelper {

    @discardableResult
    public static func requestAPI(apiModel: APIModelType, completion: @escaping NetworkCompletionBlock) -> URLSessionDataTask? {
        let escapedAddress = (apiModel.api.apiBasePath()+apiModel.api.apiEndPath()).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        var request = URLRequest(url: URL(string: escapedAddress!)!)
        request.httpMethod = apiModel.api.httpMethodType().rawValue
        request.allHTTPHeaderFields = NetworkConfig().generateHeader()

        if let params = apiModel.parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params as Any, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? NetworkError.unknown))
                return
            }
            if let httpStatus = response as? HTTPURLResponse,  ![200, 201].contains(httpStatus.statusCode) {
                completion(.failure(NetworkError.incorrectData(data)))
            }
            completion(.success(data))
        }
        task.resume()
        return task
    }
}
