//
//  CDNews+CoreDataProperties.swift
//
//
//  Created by Akin O. on 2.06.2021.
//
//

import Foundation
import CoreData


extension CDNews {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDNews> {
        return NSFetchRequest<CDNews>(entityName: "CDNews")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var newsTitle: String?
    @NSManaged public var newsDescription: String?
    @NSManaged public var newsAuthor: String?
    @NSManaged public var newsUrl: String?
    @NSManaged public var newsUrlToImage: String?
    @NSManaged public var newsPublishedAt: String?
    @NSManaged public var newsContent: String?

    func convertToArticle() -> Article {
        return Article(author: self.newsAuthor, title: self.newsTitle, articleDescription: self.newsDescription, url: self.newsUrl, urlToImage: self.newsUrlToImage, publishedAt: self.newsPublishedAt, content: self.newsContent)
    }
}
