//
//  FavoriteViewModel.swift
//  NewsApp
//
//  Created by Akin O. on 4.06.2021.
//

import Foundation

class FavoriteViewModel {


    var allNews: [Article]?
    var delegate: FavoriteViewModelDelegate?
    private let manager: CoreDataManager = CoreDataManager()

    func handleDeleteFavorite(title: String) {
        if manager.deleteNews(title: title) {
            getAllFavoriteNews()
        }
    }

    func getAllFavoriteNews() {
        allNews = manager.fetchNews()
        delegate?.reloadTableView()
    }
}
