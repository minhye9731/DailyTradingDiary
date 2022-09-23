//
//  SettingViewController.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/17/22.
//

import UIKit

class SettingViewController: BaseViewController {
    
    let mainView = SettingView()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        setNav()
    }
    
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

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.reuseIdentifier) as? SettingTableViewCell else { return UITableViewCell() }
        
        switch indexPath.row {
        case 0:
            cell.nameLabel.text = "문의하기"
        case 1:
            cell.nameLabel.text = "리뷰쓰기"
        case 2:
            cell.nameLabel.text = "오픈소스 라이선스"
        case 3:
            cell.nameLabel.text = "버전"
            cell.subLabel.text = "0.0.0" // 버전정보 받아와서 보여주기
        default : break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)번째 셀이 클릭되었습니다.")
    }
    
    
}
