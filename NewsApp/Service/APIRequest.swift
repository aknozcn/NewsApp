//
//  APIRequest.swift
//  NewsApp
//
//  Created by Akin O. on 1.06.2021.
//

import Foundation
import Moya

enum CategortyType: String, CaseIterable  {
    case general = "Genel"
    case business = "İş"
    case technology = "Teknoloji"
    case science = "Bilim"
    case entertainment = "Eğlence"
    case health = "Sağlık"
    case sports = "Spor"
}

enum LanguageType: String {
    case turkey = "tr"
    case germany = "de"
    case usa = "us"
}

enum APIRequest {
    case getNews(language: LanguageType, category: CategortyType)
}

extension APIRequest: TargetType {

    var baseURL: URL {
        guard let url = URL(string: "https://newsapi.org/v2/") else { fatalError() }
        return url
    }

    var path: String {
        switch self {
        case .getNews:
            return "top-headlines"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .getNews(let language, let category):
            let params = ["category": category,"country": language.rawValue, "apiKey": "cfcfcc868ebd41cbbe976e4b75b3fa3b"] as [String : Any]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
