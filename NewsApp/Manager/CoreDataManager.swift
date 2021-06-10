
//  CoreDataManager.swift
//  NewsApp
//
//  Created by Akin O. on 2.06.2021.
//

import Foundation

struct CoreDataManager {

    private let _coreDataRepository = CoreDataRepository()

    func createNews(news: Article) -> Bool {

        return _coreDataRepository.create(news: news)
    }

    func fetchNews() -> [Article]? {

        return _coreDataRepository.getAll()
    }

    func deleteNews(title: String) -> Bool {

        return _coreDataRepository.delete(title: title)
    }
}
