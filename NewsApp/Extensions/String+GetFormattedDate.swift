//
//  String+GetFormattedDate.swift
//  NewsApp
//
//  Created by Akin O. on 2.06.2021.
//

import Foundation

extension String {
    static func getFormattedDate(formatter: String) -> String {

        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.locale = Locale(identifier: "tr_TR")
        dateFormatterPrint.dateFormat = "dd-MM-yyyy/HH:mm"
        dateFormatterPrint.timeZone = TimeZone(identifier: "GMT")

        let date: Date? = dateFormatterGet.date(from: formatter)

        if let dateFormat = date {
            return dateFormatterPrint.string(from: dateFormat)
        }
        return ""
    }
}
