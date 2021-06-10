//
//  CoreDataRepository.swift
//  NewsApp
//
//  Created by Akin O. on 2.06.2021.
//

import Foundation
import CoreData

struct CoreDataRepository: Repository {

    func create(news: Article) -> Bool {

        if !checkExistsNews(byTitle: news.title!) {
            let cdNews = CDNews(context: PersistentStorage.shared.context)
            cdNews.id = UUID()
            cdNews.newsAuthor = news.author
            cdNews.newsContent = news.content
            cdNews.newsDescription = news.articleDescription
            cdNews.newsPublishedAt = news.publishedAt
            cdNews.newsTitle = news.title
            cdNews.newsUrl = news.url
            cdNews.newsUrlToImage = news.urlToImage
            PersistentStorage.shared.saveContext()
            return true
        }
        return false
    }

    func getAll() -> [Article]? {

        let result = PersistentStorage.shared.fetchManagedObject(managedObject: CDNews.self)

        var newss: [Article] = []
        result?.forEach({ (cdNews) in
            newss.append(cdNews.convertToArticle())
        })

        return newss
    }

    func delete(title: String) -> Bool {
        let cdNews = getCDNews(byTitle: title)
        guard cdNews != nil else { return false }

        PersistentStorage.shared.context.delete(cdNews!)
        PersistentStorage.shared.saveContext()
        return true
    }

    private func checkExistsNews(byTitle title: String) -> Bool {
        let fetchRequest = NSFetchRequest<CDNews>(entityName: "CDNews")
        let predicate = NSPredicate(format: "newsTitle==%@", title as CVarArg)

        fetchRequest.predicate = predicate
        do {
            let result = try PersistentStorage.shared.context.fetch(fetchRequest).first

            guard result != nil else { return false }
            return true

        } catch let error {
            debugPrint(error)
        }
        return false

    }

    private func getCDNews(byTitle title: String) -> CDNews? {
        let fetchRequest = NSFetchRequest<CDNews>(entityName: "CDNews")
        let predicate = NSPredicate(format: "newsTitle==%@", title as CVarArg)

        fetchRequest.predicate = predicate
        do {
            let result = try PersistentStorage.shared.context.fetch(fetchRequest).first

            guard result != nil else { return nil }
            return result

        } catch let error {
            debugPrint(error)
        }
        return nil
    }
}

