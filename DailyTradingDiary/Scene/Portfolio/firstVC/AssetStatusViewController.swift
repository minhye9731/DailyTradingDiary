//
//  AssetStatusViewController.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/22/22.
//

import UIKit
import SnapKit
import RealmSwift

final class AssetStatusViewController: BaseViewController {
    
    // MARK: - property
    private let mainView = AssetStatusView()
    var totalAmount = CorpRegisterRepository.standard.getTotalInvest()
    var slideArr = CorpRegisterRepository.standard.getPercentagePerStock()
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.totalAmount = CorpRegisterRepository.standard.getTotalInvest()
        self.slideArr = CorpRegisterRepository.standard.getPercentagePerStock()
        mainView.tableView.reloadData()
    }

}

// MARK: - tableview 설정 관련
extension AssetStatusViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return slideArr.count == 0 ? 2 : 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return slideArr.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 120
        case 1: return mainView.frame.width
        case 2: return 86
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let customHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomTableViewHeaderView.reuseIdentifier) as? CustomTableViewHeaderView else { return UIView() }
        
        switch section {
        case 0: customHeaderView.sectionTitleLabel.text = "투자원금"
        case 1: customHeaderView.sectionTitleLabel.text = "자산구성"
        default: customHeaderView.sectionTitleLabel.text = "List"
        }
        return customHeaderView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AssetSummaryTableViewCell.reuseIdentifier) as? AssetSummaryTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            
            cell.getData(total: thousandSeparatorCommas(value: totalAmount))
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AssetChartTableViewCell.reuseIdentifier) as? AssetChartTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            
            if totalAmount == 0 {
                cell.ratioChart.isHidden = true
                cell.emptyView.isHidden = false
            } else {
                cell.ratioChart.isHidden = false
                cell.emptyView.isHidden = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                cell.ratioChart.slices = self.slideArr.sorted(by: { $0.percent > $1.percent })
                cell.ratioChart.animateChart()
            }
        
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AssetListTableViewCell.reuseIdentifier) as? AssetListTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            
            cell.setData(data: slideArr.sorted(by: { $0.percent > $1.percent }), indexPath: indexPath)
            
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AssetListTableViewCell.reuseIdentifier) as? AssetListTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            return cell
        }
    }
    
}
