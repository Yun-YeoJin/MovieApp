//
//  TabViewController.swift
//  MovieApp
//
//  Created by 윤여진 on 2022/12/27.
//

import UIKit

final class TabViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
        setupTabBarAppearence()
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
    }
    
    private func setupTabBar(viewController: UIViewController, title: String, image: String) -> UINavigationController {
        
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = UIImage(named: image)
        
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
    
    private func configureTabBar() {
        
        let searchMovieVC = setupTabBar(viewController: SearchMovieVC(), title: "검색", image: HomeTabImage.search)
        let bookmarkMovieVC = setupTabBar(viewController: BookmarkMovieVC(), title: "즐겨찾기", image: HomeTabImage.favorite)
        
        setViewControllers([searchMovieVC, bookmarkMovieVC], animated: true)
    }
    
    private func setupTabBarAppearence() {
        
        if #available(iOS 13.0, *) {
            let tabBarAppearance = UITabBarItemAppearance()
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = .white
            tabBarAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemGreen]
            appearance.stackedLayoutAppearance = tabBarAppearance
            tabBar.standardAppearance = appearance
            tabBar.backgroundColor = .systemBackground
            tabBar.tintColor = .systemGreen
        } else {
           
        }
        
    }
    
    
    
}

