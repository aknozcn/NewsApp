//
//  NewsResult.swift
//  NewsApp
//
//  Created by Akin O. on 1.06.2021.
//


import Foundation

struct NewsResult: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let author: String?
    let title: String?
    let articleDescription: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
}
