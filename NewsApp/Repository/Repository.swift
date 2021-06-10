//
//  Repository.swift
//  NewsApp
//
//  Created by Akin O. on 2.06.2021.
//

import Foundation

protocol Repository {
    func create(news: Article) -> Bool
    func getAll() -> [Article]?
    func delete(title: String) -> Bool
}
