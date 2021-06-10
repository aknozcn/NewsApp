//
//  Coordinator.swift
//  NewsApp
//
//  Created by Akin O. on 9.06.2021.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController {get set}
    func start()
}
