//
//  Storyboarded .swift
//  NewsApp
//
//  Created by Akin O. on 9.06.2021.
//

import Foundation
import UIKit

enum StoryboardName: String{
    case main = "Main"
}

protocol Storyboarded {
    static func instantiate(storyBoardName: StoryboardName) -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(storyBoardName: StoryboardName) -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: storyBoardName.rawValue, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}
