//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by Akin O. on 1.06.2021.
//

import Foundation
import UIKit

class NewsViewModel {

    var allNews: NewsResult?
    var delegate: APIFetching?

    private let apiManager = APIManager()
    private let manager: CoreDataManager = CoreDataManager()


    func getNews(categoryType: CategortyType, languageType: LanguageType) {
        apiManager.fetchNews(category: categoryType, type: languageType) { result in
            switch result {
            case .success(let news):
                print("getNews Success: \(news)")
                self.allNews = news
                self.delegate?.didFetched()
            case .failure(let error):
                print("getNews Error: \(error.localizedDescription)")
            }
        }
    }

    func handleMarkAsFavourite(indexPath: IndexPath) -> Bool {

        let data = Article(author: allNews?.articles[indexPath.row].author, title: allNews?.articles[indexPath.row].title, articleDescription: allNews?.articles[indexPath.row].articleDescription, url: allNews?.articles[indexPath.row].url, urlToImage: allNews?.articles[indexPath.row].urlToImage, publishedAt: allNews?.articles[indexPath.row].publishedAt, content: allNews?.articles[indexPath.row].content)

        if manager.createNews(news: data) {
            return true
        }
        return false
    }
}
