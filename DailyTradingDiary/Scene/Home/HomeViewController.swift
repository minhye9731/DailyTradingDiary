//
//  HomeViewController.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/14/22.
//

import UIKit
import SnapKit
import FSCalendar
import RealmSwift

final class HomeViewController: BaseViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    let mainView = HomeView()
    var selectedDate: Date = Date()
    
    // MARK: - Lifecycle
    override func loadView() {
        print("HomeViewController - \(#function)")
        TradingDiaryRepository.standard.sortByRegDate()
        self.mainView.tableView.reloadData()
    }

    override func configure() {
        print("HomeViewController - \(#function)")
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        setNav()
        setNavItem()
        setCalendarUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HomeViewController - \(#function)")
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        self.view = mainView
        TradingDiaryRepository.standard.sortByRegDate()
        mainView.floatingButton.addTarget(self, action: #selector(floatingBtnTapped), for: .touchUpInside)
        
        dump(TradingDiaryRepository.standard.tasks)
        dump("선택된 시작 날짜 : \(mainView.calendar.selectedDate)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("HomeViewController - \(#function)")
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("HomeViewController - \(#function)")

        guard let date = self.mainView.calendar.selectedDate else { return }
        TradingDiaryRepository.standard.filteredByTradingDate(selectedDate: date)
        TradingDiaryRepository.standard.sortByRegDate()
        self.mainView.tableView.reloadData()
    }
    
    func setNav() {
        let titleLabel = UILabel()
        titleLabel.text = "Trading Diary"
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
    
    func setNavItem() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        let settingButton = UIBarButtonItem(image: UIImage(systemName: Constants.ImageName.setting.rawValue), style: .plain, target: self, action: #selector(settingButtonTapped))
        let todayButton = UIBarButtonItem(title: "Today", style: .plain, target: self, action: #selector(todayButtonClicked))
        
        self.navigationItem.rightBarButtonItems = [settingButton, todayButton]
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
}

// MARK: - tableview 설정
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let result = TradingDiaryRepository.standard.tasks.filter { $0.tradingDate.toString() == self.mainView.calendar.selectedDate?.toString() }.count
        
        return result
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let tradeCell = tableView.dequeueReusableCell(withIdentifier: TradeTableViewCell.reuseIdentifier) as? TradeTableViewCell else { return UITableViewCell() }

        tradeCell.setData(arr: Array(TradingDiaryRepository.standard.tasks), indexPath: indexPath)
                
        return tradeCell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)번 째 셀을 클릭했습니다. 해당 생성파일의 보기으로 넘어감")
        
        let tradeDiaryVC = TradingDiaryViewController()
        let row = Array(TradingDiaryRepository.standard.tasks)[indexPath.row]
        
        tradeDiaryVC.diaryData = row
        tradeDiaryVC.addOrEditAction = .edit
        
        transition(tradeDiaryVC, transitionStyle: .push)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        print(#function)

        let row = Array(TradingDiaryRepository.standard.tasks)[indexPath.row]
        
        let delete = UIContextualAction(style: .normal, title: nil) { action, view, completion in
            
            self.deleteConfirmAlert(title: "해당 메모를 삭제하시겠습니까?") { _ in
                
                TradingDiaryRepository.standard.deleteDiary(item: row)
                TradingDiaryRepository.standard.sortByRegDate()
                self.mainView.tableView.reloadData()
            }
        }
        
        delete.image = UIImage(systemName: Constants.ImageName.trash.rawValue)
        delete.backgroundColor = .deleteColor

        return UISwipeActionsConfiguration(actions: [delete])
    }
}

// MARK: - FSCalendar 설정
extension HomeViewController: FSCalendarDelegateAppearance {
    
    // 변경이 필요할 때 별도설정 해야함
//    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
//        calendar.snp.updateConstraints { (make) in
//            make.height.equalTo(bounds.height)
//            // Do other updates
//        }
//        self.view.layoutIfNeeded()
//    }
    
    func setCalendarUI() {
        
        self.mainView.calendar.dataSource = self
        self.mainView.calendar.delegate = self
        
        self.mainView.calendar.locale = Locale(identifier: "ko_KR")
        
        self.mainView.calendar.placeholderType = .fillHeadTail
        
        self.mainView.calendar.calendarWeekdayView.weekdayLabels[0].text = "일"
        self.mainView.calendar.calendarWeekdayView.weekdayLabels[1].text = "월"
        self.mainView.calendar.calendarWeekdayView.weekdayLabels[2].text = "화"
        self.mainView.calendar.calendarWeekdayView.weekdayLabels[3].text = "수"
        self.mainView.calendar.calendarWeekdayView.weekdayLabels[4].text = "목"
        self.mainView.calendar.calendarWeekdayView.weekdayLabels[5].text = "금"
        self.mainView.calendar.calendarWeekdayView.weekdayLabels[6].text = "토"
        
        self.mainView.calendar.scrollEnabled = true
        self.mainView.calendar.scrollDirection = .horizontal
        
        // 요일
        self.mainView.calendar.appearance.weekdayFont = .systemFont(ofSize: 14, weight: .regular)
        self.mainView.calendar.appearance.weekdayTextColor = .mainTextColor
        self.mainView.calendar.calendarWeekdayView.weekdayLabels[0].textColor = .systemRed // 적용안됨
        self.mainView.calendar.calendarWeekdayView.weekdayLabels[6].textColor = .systemBlue // 적용안됨
        
        // 일자
        self.mainView.calendar.appearance.titleFont = .systemFont(ofSize: 14, weight: .regular)
        self.mainView.calendar.appearance.titlePlaceholderColor = .subTextColor
        self.mainView.calendar.appearance.titleDefaultColor = .mainTextColor
//        self.mainView.calendar.appearance.title // 일요일은 빨간색
        // 토요일은 파란색
        
        self.mainView.calendar.appearance.headerDateFormat = "YYYY MM월"
        self.mainView.calendar.appearance.headerTitleFont = .systemFont(ofSize: 16, weight: .regular)
        self.mainView.calendar.appearance.headerTitleColor = .mainTextColor
        self.mainView.calendar.appearance.headerTitleAlignment = .center
        
        // today
        self.mainView.calendar.appearance.titleTodayColor = .mainTextColor
        self.mainView.calendar.appearance.todayColor = .subTextColor
        
        // 선택일
        self.mainView.calendar.select(selectedDate)
        self.mainView.calendar.appearance.selectionColor = .pointColor
        self.mainView.calendar.appearance.titleSelectionColor = .mainTextColor
    }
    
    // 선택된 날짜의 채워진 색상 지정
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return appearance.selectionColor
    }
    
    // 날짜 선택시 발생하는 일
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
//        self.tasks.filter { $0.tradingDate.toString() == date.toString() }
        
//        TradingDiaryRepository.standard.tasks.filter { $0.tradingDate.toString() == date.toString() }
        
//        TradingDiaryRepository.standard.tasks.where {
//            checkDay(realmDate: $0.tradingDate, calendarDate: self.mainView.calendar.selectedDate)
//        }
//
//        TradingDiaryRepository.standard.tasks.where { $0.tradingDate }
        
//        dump("\(TradingDiaryRepository.standard.tasks.)")
        print("\(self.mainView.calendar.selectedDate?.toString())")
        
        TradingDiaryRepository.standard.filteredByTradingDate(selectedDate: date)
        
        self.mainView.tableView.reloadData()
    }
    
    // event 설정
    
    
}

// MARK: - 기타함수들
extension HomeViewController {
    
    @objc func floatingBtnTapped() {
        let vc = TradingDiaryViewController()
        vc.addOrEditAction = .write
        transition(vc, transitionStyle: .push)
    }
    
    @objc func settingButtonTapped() {
        let vc = SettingViewController()
        transition(vc, transitionStyle: .push)
    }
    
    @objc func todayButtonClicked() {
        self.mainView.calendar.select(Date())
    }
    
//    func checkDay(realmDate: Query<Date>, calendarDate: Date) -> Bool {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        dateFormatter.timeZone = TimeZone.current
////        dateFormatter.string(from: self)
//
//        let result = dateFormatter.string(from: realmDate) == dateFormatter.string(from: calendarDate)
//
//        return result
//    }
    
}

