//
//  UIView+Shadow.swift
//  NewsApp
//
//  Created by Akin O. on 4.06.2021.
//

import Foundation
import UIKit

extension UIView {
    
    func addShadow() {
        self.backgroundColor = #colorLiteral(red: 0.9957031608, green: 0.9966481328, blue: 0.9997710586, alpha: 1)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.35
        self.layer.shadowPath = UIBezierPath(roundedRect: self.layer.bounds, cornerRadius: self.layer.cornerRadius).cgPath
    }
}
