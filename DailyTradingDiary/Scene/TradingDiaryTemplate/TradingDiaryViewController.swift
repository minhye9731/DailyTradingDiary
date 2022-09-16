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
    var data: KRXModel = KRXModel(itemName: "-", corpName: "-", marketName: "-", srtnCode: "-", isinCode: "-")
    
    // MARK: - lifecycle
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
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return 1
        case 3: return 1
        case 4: return 1
        case 5: return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CorpNameTableViewCell.reuseIdentifier) as? CorpNameTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none // 삭제예정
            cell.backgroundColor = .subBackgroundColor
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NumPriceTableViewCell.reuseIdentifier) as? NumPriceTableViewCell else { return UITableViewCell() }
            cell.nameLabel.text = "매매단가"
            cell.selectionStyle = .none
            cell.backgroundColor = .subBackgroundColor
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NumPriceTableViewCell.reuseIdentifier) as? NumPriceTableViewCell else { return UITableViewCell() }
            cell.nameLabel.text = "수량"
            cell.selectionStyle = .none
            cell.backgroundColor = .subBackgroundColor
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BuySellTableViewCell.reuseIdentifier) as? BuySellTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.backgroundColor = .subBackgroundColor
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TradeDateTableViewCell.reuseIdentifier) as? TradeDateTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.backgroundColor = .subBackgroundColor
            return cell
        case 5:
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
        case 0...4: return 50
        case 5: return 300
        default: return 0
        }
        
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 0 {
//            let vc = TradingSearchViewController()
//            vc.delegate = self
//            self.transition(vc, transitionStyle: .push)
//        }
//    }
    
}



// MARK: - 기타 함수들
extension TradingDiaryViewController {
    
    func sendData(data: KRXModel) {
        self.data = data
    }
    
    @objc func doneButtonTapped() {
        print("TradingDiaryView - \(#function)")
        // realdm에 데이터 저장
        // 이전 페이지인 홈화면으로 이동
    }
    
    func setBackButtonName(name: String) {
        let backBarButtonItem = UIBarButtonItem(title: name, style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
}








