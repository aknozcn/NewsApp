//
//  AppCoordinator.swift
//  NewsApp
//
//  Created by Akin O. on 9.06.2021.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {

    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = MainViewController.instantiate(storyBoardName: .main)
        navigationController.pushViewController(vc, animated: false)
    }

    func startNews() {
        let newsViewController = NewsViewController.instantiate(storyBoardName: .main)
        newsViewController.coordinator = self
        newsViewController.tabBarItem = UITabBarItem(title: "Haberler", image: UIImage(named: "newspaper"), tag: 0)
        navigationController.pushViewController(newsViewController, animated: false)
    }
    
    func startFavorite() {
        let favoriteViewController = FavoriteViewController.instantiate(storyBoardName: .main)
        favoriteViewController.coordinator = self
        navigationController.pushViewController(favoriteViewController, animated: false)
    }
    
    func startWebView(webURL: String) {
        let webViewController = WebViewController.instantiate(storyBoardName: .main)
        webViewController.webURL = webURL
        navigationController.pushViewController(webViewController, animated: false)
    }
}
