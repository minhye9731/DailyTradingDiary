//
//  HomeViewController.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/14/22.
//

import UIKit
import SnapKit

final class HomeViewController: BaseViewController {
    
    let mainView = HomeView()
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .backgroundColor

        
    }
    
    override func configure() {
        print(#function)
//        mainView.tableView.delegate = self
//        mainView.tableView.dataSource = self
        setNav()
        setSearchController()
    }

    func setNav() {
        // 아니면 아예 제목용 라벨 커스텀으로 저장해도 좋을 듯
        let titleLabel = UILabel()
        titleLabel.text = "Trading Diary"
        titleLabel.textAlignment = .left
        titleLabel.textColor = .pointColor
        titleLabel.font = .systemFont(ofSize: 27, weight: .bold)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        self.navigationController?.navigationBar.tintColor = .pointColor
        
        let navibarAppearance = UINavigationBarAppearance()
        navibarAppearance.backgroundColor = .backgroundColor
        
        self.navigationItem.scrollEdgeAppearance = navibarAppearance
        self.navigationItem.standardAppearance = navibarAppearance
    }
    
    func setSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "작성한 매매일지의 키워드를 검색해보세요! :)"
        searchController.searchBar.showsScopeBar = false
        self.navigationItem.searchController = searchController
        
        
    }
    
}
