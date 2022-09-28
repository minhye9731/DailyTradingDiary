//
//  CorpAnalysisViewController.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/28/22.
//

import UIKit
import RealmSwift

class CorpAnalysisViewController: BaseViewController {
    
    let mainView = CorpAnalysis()
    var addOrEditAction: PageMode = .write
    
    override func loadView() {
        self.view = mainView
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func configure() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        setNav()
        setNavItem()
        
        self.mainView.searchButton.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
    }
    
    func setNav() {
        self.navigationItem.title = "관심기업 등록"
        self.navigationController?.navigationBar.tintColor = .pointColor
        let navibarAppearance = UINavigationBarAppearance()
        navibarAppearance.backgroundColor = .backgroundColor
        navibarAppearance.titleTextAttributes = [.foregroundColor: UIColor.mainTextColor, .font: UIFont.systemFont(ofSize: 18, weight: .bold)]
        
        self.navigationItem.scrollEdgeAppearance = navibarAppearance
        self.navigationItem.standardAppearance = navibarAppearance
    }
    func setNavItem() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(doneButtonTapped))
        
        self.navigationItem.rightBarButtonItems = [doneButton]
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
}

// MARK: - tableview
extension CorpAnalysisViewController:  UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 13
        case 2: return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 160
        case 1: return 50
        case 2: return 300
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let summaryCell = tableView.dequeueReusableCell(withIdentifier: CorpSummaryTableViewCell.reuseIdentifier) as? CorpSummaryTableViewCell else { return UITableViewCell() }
        summaryCell.selectionStyle = .none
        
        guard let titleNameCell = tableView.dequeueReusableCell(withIdentifier: TitleNameTableViewCell.reuseIdentifier) as? TitleNameTableViewCell else { return UITableViewCell() }
        titleNameCell.selectionStyle = .none
        
        guard let finInfoCell = tableView.dequeueReusableCell(withIdentifier: FinanceInfoTableViewCell.reuseIdentifier) as? FinanceInfoTableViewCell else { return UITableViewCell() }
        finInfoCell.selectionStyle = .none
        
        
        switch indexPath.section {
        case 0: return summaryCell
        case 1:
            switch indexPath.row {
            case 0: return titleNameCell
            default: return finInfoCell
            }
        case 2: return summaryCell
        default: return summaryCell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let customHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomTableViewHeaderView.reuseIdentifier) as? CustomTableViewHeaderView else { return UIView() }
        switch section {
        case 0: customHeaderView.sectionTitleLabel.text = "종합"
        case 1: customHeaderView.sectionTitleLabel.text = "주요재무"
        case 1: customHeaderView.sectionTitleLabel.text = "My Opinion"
        default: customHeaderView.sectionTitleLabel.text = ""
        }
        return customHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
}

// MARK: - 기타 함수
extension CorpAnalysisViewController {
    
    @objc func doneButtonTapped() {
        print("저장 완료!")
    }
    
    @objc func searchButtonClicked() {
        print("검색 버튼이 눌렸다!")
    }
    
}
