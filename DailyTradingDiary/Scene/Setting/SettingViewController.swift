//
//  SettingViewController.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 10/19/22.
//

import UIKit

class SettingViewController: BaseViewController {
    
    let mainView = SettingView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func configure() {
        self.tabBarController?.tabBar.isHidden = true
        setNav()
    }
    
    override func setConstraints() {
        
    }
    
}

// MARK: - 기타함수
extension SettingViewController {
    
    func setNav() {
        self.navigationItem.title = "설정"
        self.navigationController?.navigationBar.tintColor = .pointColor
        let navibarAppearance = UINavigationBarAppearance()
        navibarAppearance.backgroundColor = .backgroundColor
        navibarAppearance.titleTextAttributes = [.foregroundColor: UIColor.mainTextColor, .font: UIFont.systemFont(ofSize: 18, weight: .bold)]
        
        self.navigationItem.scrollEdgeAppearance = navibarAppearance
        self.navigationItem.standardAppearance = navibarAppearance
    }
}
