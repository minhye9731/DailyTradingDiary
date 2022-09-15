//
//  TradingDiaryViewController.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/15/22.
//

import UIKit
import SnapKit

final class TradingDiaryViewController: BaseViewController {

    let mainView = TradingDiaryView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = mainView
        
    }
    
    override func configure() {
        print(#function)
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        setNav()
        setNavItem()
    }
    
    override func setConstraints() {
        
    }

    func setNav() {
        self.navigationItem.title = "매매일지 작성"
        self.navigationController?.navigationBar.tintColor = .pointColor
        let navibarAppearance = UINavigationBarAppearance()
        navibarAppearance.backgroundColor = .subBackgroundColor
        navibarAppearance.titleTextAttributes = [.foregroundColor: UIColor.mainTextColor, .font: UIFont.systemFont(ofSize: 18, weight: .bold)]
        
        self.navigationItem.scrollEdgeAppearance = navibarAppearance
        self.navigationItem.standardAppearance = navibarAppearance
    }
    
    func setNavItem() {
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(doneButtonTapped))
        
        navigationItem.rightBarButtonItems = [doneButton]
    }
    
    

}

// MARK: - tableview 설정 관련
extension TradingDiaryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return 1
        case 1: return 3
        case 2: return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CorpNameTableViewCell.reuseIdentifier) as? CorpNameTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.backgroundColor = .subBackgroundColor
            return cell
        case 1:
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TradeDateTableViewCell.reuseIdentifier) as? TradeDateTableViewCell else { return UITableViewCell() }
                cell.selectionStyle = .none
                cell.backgroundColor = .subBackgroundColor
                return cell
            } else if indexPath.row == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: BuySellTableViewCell.reuseIdentifier) as? BuySellTableViewCell else { return UITableViewCell() }
                cell.selectionStyle = .none
                cell.backgroundColor = .subBackgroundColor
                return cell
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NumPriceTableViewCell.reuseIdentifier) as? NumPriceTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.backgroundColor = .subBackgroundColor
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TradingMemoTableViewCell.reuseIdentifier) as? TradingMemoTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.backgroundColor = .subBackgroundColor
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TradingMemoTableViewCell.reuseIdentifier) as? TradingMemoTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.backgroundColor = .subBackgroundColor
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0: return 40
        case 1: return 40
        case 2: return 300
        default: return 0
        }
        
    }
    
}


// MARK: - 기타 함수들
extension TradingDiaryViewController {
    
    @objc func doneButtonTapped() {
        print("TradingDiaryView - \(#function)")
        // realdm에 데이터 저장
        // 이전 페이지인 홈화면으로 이동
    }
    
    
    
}








