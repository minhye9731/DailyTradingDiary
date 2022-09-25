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
    var alphaNewsList: [MarketNewsData] = []
    var fearGreedIndex: FearGreedData = FearGreedData(updateTime: "0000.00.00", now: FearGreed(indexValue: 0, indexStatus: ""), weekAgo: FearGreed(indexValue: 0, indexStatus: ""))
    var fxList: [IndexData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = mainView
        
        connectAPI()
    }
    
    func connectAPI() {
        
//        ALPHAAPIManager.shared.fetchAlphaFXAPI(type: .alpnaFX, from: "USD", to: "KRW") { dDayValue, xDayValue in
//
//            let name = "달러/원"
//            let value = "\(Constants.CurrencySign.won) \(String(dDayValue.prefix(4)))"
//
//            let numberFormatter = NumberFormatter()
//            numberFormatter.maximumFractionDigits = 2
//
//            let gapValueRaw = Double(dDayValue)! - Double(xDayValue)!
//            let gapValue = numberFormatter.string(for: gapValueRaw) ?? "0.00"
//
//            let gapPercentRaw = gapValueRaw / Double(xDayValue)! * 100
//            let gapPercent = numberFormatter.string(for: gapPercentRaw) ?? "0.00"
//
//            let wonDollar = IndexDataModel(name: name, value: value, gap: gapValue, changeRate: gapPercent)
//
//            self.fxList.append(wonDollar)
//
//            DispatchQueue.main.async {
//                self.mainView.tableView.reloadData()
//            }
//        }
        
//        ALPHAAPIManager.shared.fetchAlphaTYAPI(type: .alphaTreasury)
        
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
                    
                    let newsDataArray: [MarketNewsData] = data.map { news -> MarketNewsData in
                        
                        let title = news.title
                        let url = news.url
                        let date = news.timePublished
                        let imageUrl = news.bannerImage
                        let source = news.source
                        let topic = news.topics
                        let relatedCorp = news.tickerSentiment
                        
                        return MarketNewsData(title: title, url: url, publishedDate: date, profileImageUrl: imageUrl ?? "", source: source, topic: topic, relatedTicker: relatedCorp)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 //5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        switch section {
//        case 0...3: return 1
//        case 4: return 6
//        default: return 1
//        }
        
        switch section {
        case 0: return 1
        case 1: return alphaNewsList.count
        default : return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let customHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: InfoTableViewHeaderView.reuseIdentifier) as? InfoTableViewHeaderView else { return UIView() }
        
        switch section {
        case 0: customHeaderView.sectionTitleLabel.text = "시장 온도계"
        case 1: customHeaderView.sectionTitleLabel.text = "뉴스"
//        case 2: customHeaderView.sectionTitleLabel.text = "경제 이벤트"
//        case 3: customHeaderView.sectionTitleLabel.text = "시장 온도계"
//        case 4: customHeaderView.sectionTitleLabel.text = "뉴스"
        default: customHeaderView.sectionTitleLabel.text = ""
        }
        
        return customHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        guard let indexCell = tableView.dequeueReusableCell(withIdentifier: IndexTableViewCell.reuseIdentifier) as? IndexTableViewCell else { return UITableViewCell() }
        guard let fearGreedCell = tableView.dequeueReusableCell(withIdentifier: FearGreedGraphTableViewCell.reuseIdentifier) as? FearGreedGraphTableViewCell else { return UITableViewCell() }
        guard let newsCell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseIdentifier) as? NewsTableViewCell else { return UITableViewCell() }
        
//        indexCell.collectionView.delegate = self
//        indexCell.collectionView.dataSource = self
//        indexCell.collectionView.tag = indexPath.section // 1~3섹션별 구분용
        
        switch indexPath.section {
        case 0:
            fearGreedCell.setData(data: fearGreedIndex)
            return fearGreedCell
        case 1:
            DispatchQueue.main.async {
                newsCell.setData(data: self.alphaNewsList, indexPath: indexPath)
            }
            return newsCell
//        case 2: return indexCell
//        case 3:
//        case 4:
        default: return fearGreedCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let marketThermoHeight = self.view.frame.width
        
//        switch indexPath.section {
//        case 0...2: return 112
//        case 3: return marketThermoHeight
//        case 4: return 120
//        default: return 1
//        }
        
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
        // 통신이 연결 error시 처리 필요
    }
    
}


// MARK: - collectionview 설정
//extension InfoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        // 빈배열을 만들어두고, 지수별 데이터가 들어와서 채워지는 수에 따라서
//                switch collectionView.tag {
//                case 0: return fxList.count
//                case 1: return 4
//                case 2: return 4
//                default : return 4
//                }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IndexCollectionViewCell.reuseIdentifier, for: indexPath) as? IndexCollectionViewCell else { return UICollectionViewCell() }
//
//        // 테이블뷰의 섹션에 따라서 setdata 등 설정
//        switch collectionView.tag {
//        case 0:
//            cell.setData(arr: fxList, indexPath: indexPath)
//
//            return cell
//        case 1: return cell
//        case 2: return cell
//        default : return cell
//        }
//
//    }
//
//}






