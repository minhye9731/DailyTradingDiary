//
//  InfoViewController.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/14/22.
//

import UIKit
import Alamofire
import SwiftyJSON

final class InfoViewController: BaseViewController {
    
    let mainView = InfoView()
    var alphaNewsList: [MarketNewsModel] = []
    var fearGreedIndex: FearGreedModel = FearGreedModel(updateTime: "0000.00.00", now: FearGreed(indexValue: 0, indexStatus: ""), weekAgo: FearGreed(indexValue: 0, indexStatus: ""))

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = mainView
        
        connectAPI()
    }
    
    func connectAPI() {
        ALPHAAPIManager.shared.fetchAlphaNewsAPI(type: .alphaNews) { data in
            self.alphaNewsList = data
            
            DispatchQueue.main.async {
                self.mainView.tableView.reloadData()
            }
        }
        
        FEARGREEDAPIManager.shared.fetchFearGreedAPI() { data in
            self.fearGreedIndex = data
            
            DispatchQueue.main.async {
                self.mainView.tableView.reloadData()
            }
        }
    }
    
    
    
    override func configure() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        setNav()
    }
    
    func setNav() {
        let titleLabel = UILabel()
        titleLabel.text = "Market"
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
    

}


// MARK: - tableview 설정
extension InfoViewController:  UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0...3: return 1
        case 4: return 6
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let customHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: InfoTableViewHeaderView.reuseIdentifier) as? InfoTableViewHeaderView else { return UIView() }
        
        switch section {
        case 0: customHeaderView.sectionTitleLabel.text = "통화·암호화폐"
        case 1: customHeaderView.sectionTitleLabel.text = "채권·금리"
        case 2: customHeaderView.sectionTitleLabel.text = "경제 이벤트"
        case 3: customHeaderView.sectionTitleLabel.text = "시장 온도계"
        case 4: customHeaderView.sectionTitleLabel.text = "뉴스"
        default: customHeaderView.sectionTitleLabel.text = ""
        }
        
        return customHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let indexCell = tableView.dequeueReusableCell(withIdentifier: IndexTableViewCell.reuseIdentifier) as? IndexTableViewCell else { return UITableViewCell() }
        guard let fearGreedCell = tableView.dequeueReusableCell(withIdentifier: FearGreedGraphTableViewCell.reuseIdentifier) as? FearGreedGraphTableViewCell else { return UITableViewCell() }
        guard let newsCell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseIdentifier) as? NewsTableViewCell else { return UITableViewCell() }
        
        indexCell.collectionView.delegate = self
        indexCell.collectionView.dataSource = self
        indexCell.collectionView.tag = indexPath.section // 1~3섹션별 구분용
        
        switch indexPath.section {
        case 0: return indexCell
        case 1: return indexCell
        case 2: return indexCell
        case 3:
            fearGreedCell.setData(data: fearGreedIndex)
            return fearGreedCell
        case 4:
            
            DispatchQueue.main.async {
                newsCell.setData(data: self.alphaNewsList, indexPath: indexPath)
            }
            
//            newsCell.setData(data: alphaNewsList, indexPath: indexPath)
            return newsCell
        default: return indexCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let marketThermoHeight = self.view.frame.width
        
        switch indexPath.section {
        case 0...2: return 112
        case 3: return marketThermoHeight
        case 4: return 120
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 4 {
            let webVC = WebViewController()
            let row = alphaNewsList[indexPath.row]
            print("newsCell의 url연결 실행이다~!")
            webVC.destinationURL = row.url
            transition(webVC, transitionStyle: .present)
        }
        // 통신이 연결 error시 처리 필요
    }
    
}


// MARK: - collectionview 설정
extension InfoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
        // 빈배열을 만들어두고, 지수별 데이터가 들어와서 채워지는 수에 따라서
        //        switch collectionView.tag {
        //        case 0:
        //        case 1:
        //        case 2:
        //        default :
        //        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IndexCollectionViewCell.reuseIdentifier, for: indexPath) as? IndexCollectionViewCell else { return UICollectionViewCell() }
        
        // 테이블뷰의 섹션에 따라서 setdata 등 설정
//        switch collectionView.tag {
//        case 0:
//        case 1:
//        case 2:
//        default :
//        }
        
        return cell
    }
    
}






