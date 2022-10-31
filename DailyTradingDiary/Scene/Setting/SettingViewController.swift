//
//  SettingViewController.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 10/19/22.
//

import UIKit
import MessageUI

struct SettingList: Hashable {
    let id = UUID().uuidString
    let title: String
    let subTitle: String
}


class SettingViewController: BaseViewController {
    
    let mainView = SettingView()
    
    var contents = [
        SettingList(title: "문의하기", subTitle: ""),
        SettingList(title: "리뷰쓰기", subTitle: ""),
        SettingList(title: "오픈소스 라이선스", subTitle: ""),
        SettingList(title: "버전", subTitle: "x.x.x")
    ]
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, SettingList>!
    
    override func loadView() {
        self.view = mainView
        mainView.collectionView.collectionViewLayout = createLayout()
        configureDataSource()
    }
    
    override func configure() {
        self.tabBarController?.tabBar.isHidden = true
        setNav()
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
    
    func sendEmailTapped() {
        
        if MFMailComposeViewController.canSendMail() {
            
        }
        else {
            
        }
        
    }
    
    func writeReviewTapped() {
        
        if let appstoreUrl = URL(string: "https://apps.apple.com/app/id{앱스토어ID}") {
            var urlComp = URLComponents(url: appstoreUrl, resolvingAgainstBaseURL: false)
            urlComp?.queryItems = [
                URLQueryItem(name: "action", value: "write-review")
            ]
            guard let reviewUrl = urlComp?.url else {
                return
            }
            UIApplication.shared.open(reviewUrl, options: [:], completionHandler: nil)
        }
        
    }
}

// MARK: - compositional
extension SettingViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
    
    private func configureDataSource() {
        
        let cellRegisteration = UICollectionView.CellRegistration<UICollectionViewListCell, SettingList> { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.title
            content.secondaryText = itemIdentifier.subTitle
            content.textProperties.color = .mainTextColor
            cell.contentConfiguration = content
            
            var background = UIBackgroundConfiguration.listPlainCell()
            background.backgroundColor = .backgroundColor
            cell.backgroundConfiguration = background
            
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: mainView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, SettingList>()
        snapshot.appendSections([0])
        snapshot.appendItems(contents)
        dataSource.apply(snapshot)
    }
    
}
