//
//  MainViewController.swift
//  NewsApp
//
//  Created by Akin O. on 9.06.2021.
//

import UIKit

class MainViewController: UITabBarController, Storyboarded {

    let newsCoordinator = AppCoordinator(navigationController: UINavigationController())
    let favoriteCoordinator = AppCoordinator(navigationController: UINavigationController())

    override func viewDidLoad() {
        navigationController?.isNavigationBarHidden = true
        super.viewDidLoad()

        newsCoordinator.startNews()
        favoriteCoordinator.startFavorite()

        viewControllers = [newsCoordinator.navigationController, favoriteCoordinator.navigationController]

        newsCoordinator.navigationController.tabBarItem = UITabBarItem(title: "Haberler", image: UIImage(systemName: "newspaper"), tag: 0)
        newsCoordinator.navigationController.tabBarItem.selectedImage = UIImage(systemName: "newspaper.fill")
        favoriteCoordinator.navigationController.tabBarItem = UITabBarItem(title: "Favori", image: UIImage(systemName: "star"), tag: 1)
        favoriteCoordinator.navigationController.tabBarItem.selectedImage = UIImage(systemName: "star.fill")
    }
}
