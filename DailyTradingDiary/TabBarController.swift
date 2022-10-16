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
        
        NotificationCenter.default.addObserver(self, selector: #selector(showInfoPage(_:)), name: Notification.Name("showInfoPage"), object: nil)
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

    // 첫실행 여부 확인함수
    func checkFirstRun() {
        if UserDefaults.standard.bool(forKey: "FirstRun") == false {
            let vc = WalkThroughViewController()
            transition(vc, transitionStyle: .presentFull)
        }
    }
    
    // local 알림 클릭시 화면이동 함수
    @objc func showInfoPage(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let index = userInfo["index"] as? Int {
                self.selectedIndex = index
                print("index 1 탭으로 화면이동~")
            }
        }
    }
}

