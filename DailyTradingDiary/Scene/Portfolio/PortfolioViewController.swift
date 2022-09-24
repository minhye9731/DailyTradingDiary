//
//  CalendarViewController.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/14/22.
//

import UIKit
import SnapKit
import Tabman
import Pageboy
import RealmSwift

class PortfolioViewController: TabmanViewController {
    
    var viewControllers: Array<UIViewController> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
//        setNavItem()
        
        let firstVC = AssetStatusViewController()
        let secondVC = TradeRecordViewController()
        
        viewControllers.append(firstVC)
        viewControllers.append(secondVC)
        
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        settingTabBar(ctBar: bar)
        addBar(bar, dataSource: self, at: .top)
    }
    
    func setNav() {
        let titleLabel = UILabel()
        titleLabel.text = "PortFolio"
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
    
//    func setNavItem() {
//        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
//        self.navigationItem.backBarButtonItem = backBarButtonItem
//    }
}

// MARK: - 화면구성 설정
extension PortfolioViewController: PageboyViewControllerDataSource, TMBarDataSource {
        
        func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
            
            switch index {
            case 0: return TMBarItem(title: "자산현황")
            case 1: return TMBarItem(title: "매매내역")
            default:
                let title = "Page \(index)"
                return TMBarItem(title: title)
            }
        }
        
        func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
            return viewControllers.count
        }
        
        func viewController(for pageboyViewController: PageboyViewController,
                            at index: PageboyViewController.PageIndex) -> UIViewController? {
            return viewControllers[index]
        }
        
        func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
            return nil
        }
}

// MARK: - 기타 함수
extension PortfolioViewController {
    
    func settingTabBar (ctBar : TMBar.ButtonBar) {
        ctBar.backgroundView.style = .clear
        ctBar.backgroundColor = .backgroundColor
        
        ctBar.layout.transitionStyle = .snap
        ctBar.layout.alignment = .centerDistributed
        ctBar.layout.contentMode = .fit
        ctBar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        ctBar.buttons.customize { (button) in
            button.tintColor = .mainTextColor
            button.selectedTintColor = .pointColor
            button.font = UIFont.systemFont(ofSize: 14)
            button.selectedFont = UIFont.systemFont(ofSize: 14, weight: .bold)
        }
        
        ctBar.indicator.weight = .custom(value: 2)
        ctBar.indicator.tintColor = .pointColor
        ctBar.indicator.overscrollBehavior = .compress
    }
}
