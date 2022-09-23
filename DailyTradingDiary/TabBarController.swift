//
//  TabBarController.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/14/22.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupTabBarAppearance()
    }
    
    func configure() {
        let firstVC = HomeViewController()
        firstVC.tabBarItem = UITabBarItem(title: Constants.MenuName.home,
                                          image: UIImage(systemName: Constants.ImageName.home.rawValue),
                                          selectedImage: UIImage(systemName: Constants.ImageName.homeClicked.rawValue))
        let firstNav = UINavigationController(rootViewController: firstVC)
        
        let secondVC = InfoViewController()
        secondVC.tabBarItem = UITabBarItem(title: Constants.MenuName.info,
                                           image: UIImage(systemName: Constants.ImageName.info.rawValue),
                                           selectedImage: UIImage(systemName: Constants.ImageName.infoClicked.rawValue))
        let secondNav = UINavigationController(rootViewController: secondVC)
        
        let thirdVC = PortfolioViewController()
        thirdVC.tabBarItem = UITabBarItem(title: Constants.MenuName.portfolio,
                                          image: UIImage(systemName: Constants.ImageName.portfolifo.rawValue),
                                           selectedImage: UIImage(systemName: Constants.ImageName.portfolifoClicked.rawValue))
        let thirdNav = UINavigationController(rootViewController: thirdVC)
        
        setViewControllers([firstNav, secondNav, thirdNav], animated: true)
    }
    
    func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .backgroundColor
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.unselectedItemTintColor = .white
        tabBar.tintColor = .pointColor
    }

}

