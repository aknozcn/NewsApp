//
//  APIManager.swift
//  NewsApp
//
//  Created by Akin O. on 1.06.2021.
//

import Foundation
import Moya

protocol Networkable {

    var provider: MoyaProvider<APIRequest> { get }

    func fetchNews(category: CategortyType, type: LanguageType, completion: @escaping(Result<NewsResult, Error>) -> ())
}

class APIManager: Networkable {

    var provider = MoyaProvider<APIRequest>(plugins: [NetworkLoggerPlugin()])

    func fetchNews(category: CategortyType, type: LanguageType, completion: @escaping (Result<NewsResult, Error>) -> ()) {
        request(target: .getNews(language: LanguageType(rawValue: type.rawValue)! as LanguageType, category: CategortyType(rawValue: category.rawValue)!), completion: completion)
    }
}

private extension APIManager {

    private func request<T: Decodable>(target: APIRequest, completion: @escaping(Result<T, Error>) -> ()) {

        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
