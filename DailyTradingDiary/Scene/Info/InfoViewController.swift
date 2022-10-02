//
//  InfoViewController.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/14/22.
//

import UIKit
import Alamofire
import SwiftyJSON
import SkeletonView

final class InfoViewController: BaseViewController {
    
    let mainView = InfoView()
    var alphaNewsList: [MarketNewsDTO] = []
    var fearGreedIndex: FearGreedDTO = FearGreedDTO(updateTime: "0000.00.00", now: FearGreed(indexValue: 0, indexStatus: ""), weekAgo: FearGreed(indexValue: 0, indexStatus: ""))
    var fxList: [IndexData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = mainView
        
        let skeletonAnimation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        self.view.showAnimatedGradientSkeleton(usingGradient: .init(colors: [.lightGray, .pointColor]), animation: skeletonAnimation, transition: .none)
          self.fetchDataSource()
        }
    
    private func fetchDataSource() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.connectAPI()
            self.mainView.tableView.reloadData()
            self.mainView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
        }
    }
    
    func connectAPI() {
        FEARGREEDAPIManager.shared.fetchFearGreedAPI() { data in
            self.fearGreedIndex = data
            DispatchQueue.main.async {
                self.mainView.tableView.reloadData()
            }
        }
        
        ALPHAAPIManager.shared.fetchAlphaNewsAPI(type: .alphaNews) { (response) in
            
            switch(response) {
            case .success(let AlphaMarketNewsModel):
                
                if let data = AlphaMarketNewsModel as? [Feed] {
                    
                    let newsDataArray: [MarketNewsDTO] = data.map { news -> MarketNewsDTO in
                        
                        let title = news.title
                        let url = news.url
                        let date = news.timePublished
                        let imageUrl = news.bannerImage
                        let source = news.source
                        let topic = news.topics
                        let relatedCorp = news.tickerSentiment
                        
                        return MarketNewsDTO(title: title, url: url, publishedDate: date, profileImageUrl: imageUrl ?? "", source: source, topic: topic, relatedTicker: relatedCorp)
                    }
                    
                    self.alphaNewsList.append(contentsOf: newsDataArray)
                    DispatchQueue.main.async {
                        self.mainView.tableView.reloadData()
                    }
                }

            case .requestErr(let message) :
                print("requestErr")
                self.showAlertMessageDetail(title: "요청 에러가 발생했습니다.", message: "\(message)")
            case .pathErr :
                self.showAlertMessageDetail(title: "<알림>", message: "요청 경로가 잘못되었습니다. 잠시 후 재시도해 주세요 :)")
            case .serverErr :
                self.showAlertMessageDetail(title: "<알림>", message: "서버 에러가 발생했습니다. 잠시 후 재시도해 주세요 :)")
            case .networkFail :
                self.showAlertMessageDetail(title: "<알림>", message: "네트워크 통신 에러가 발생했습니다. 인터넷 환경을 확인 후 재시도해 주세요 :)")
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let marketThermoHeight = self.view.frame.width
        
        switch indexPath.section {
        case 0: return marketThermoHeight
        case 1: return 120
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            let webVC = WebViewController()
            let row = alphaNewsList[indexPath.row]
            webVC.destinationURL = row.url
            transition(webVC, transitionStyle: .present)
        }
    }
    
}

// MARK: - skeleton view 적용한 tableview
extension InfoViewController: SkeletonTableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return alphaNewsList.count
        default : return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let fearGreedCell = tableView.dequeueReusableCell(withIdentifier: FearGreedGraphTableViewCell.reuseIdentifier) as? FearGreedGraphTableViewCell else { return UITableViewCell() }
        guard let newsCell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseIdentifier) as? NewsTableViewCell else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            fearGreedCell.setData(data: fearGreedIndex)
            return fearGreedCell
        case 1:
            newsCell.setData(data: self.alphaNewsList, indexPath: indexPath)
            return newsCell
        default: return fearGreedCell
        }
    }
    
    // skeletonView
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        switch indexPath.section {
        case 0: return "fearGreedCell"
        case 1: return "newsCell"
        default: return "fearGreedCell"
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        guard let fearGreedCell = skeletonView.dequeueReusableCell(withIdentifier: FearGreedGraphTableViewCell.reuseIdentifier) as? FearGreedGraphTableViewCell else { return UITableViewCell() }
        guard let newsCell = skeletonView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseIdentifier) as? NewsTableViewCell else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            return fearGreedCell
        case 1:
            return newsCell
        default: return fearGreedCell
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        UITableView.automaticNumberOfSkeletonRows
    }
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 2
    }
    
}

extension InfoViewController: SkeletonTableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let customHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomTableViewHeaderView.reuseIdentifier) as? CustomTableViewHeaderView else { return UIView() }
        switch section {
        case 0: customHeaderView.sectionTitleLabel.text = "시장 온도계"
        case 1: customHeaderView.sectionTitleLabel.text = "뉴스"
        default: customHeaderView.sectionTitleLabel.text = ""
        }
        return customHeaderView
    }
    
}
