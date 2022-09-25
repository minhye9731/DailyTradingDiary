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
    var eventsArr = [Date]()
    
    // MARK: - Lifecycle
    override func loadView() {
//        print("HomeViewController - \(#function)")
        TradingDiaryRepository.standard.sortByRegDate()
        self.mainView.tableView.reloadData()
    }

    override func configure() {
//        print("HomeViewController - \(#function)")
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
        
        // 이벤트 점 추가하기
        eventsArr = TradingDiaryRepository.standard.tasks.map {
            guard let result = $0.tradingDate.toStringinKR().toDateinKR() else { return Date() }
            return result
        }
        
        // 스와이프시 캘린더 방향처리 - 적용 안된다ㅠㅠ
        setCalendarSwipe()
        
//        isEmptyCheck()
    }
    
    func setCalendarSwipe() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        swipeUp.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    @objc func swipeEvent(_ swipe: UISwipeGestureRecognizer) {
        if swipe.direction == .up {
            self.mainView.calendar.scope = .week
        } else if swipe.direction == .down {
            self.mainView.calendar.scope = .month
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//        print("HomeViewController - \(#function)")
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        print("HomeViewController - \(#function)")
        isEmptyCheck()
//        guard let date = self.mainView.calendar.selectedDate else { return }
        TradingDiaryRepository.standard.filteredByTradingDate(selectedDate: self.mainView.calendar.selectedDate!)
        
        // 이벤트 점 추가하기 - 아래처럼 추가해도 바로 표기가 안됨
//        self.eventsArr = TradingDiaryRepository.standard.tasks.map {
//            guard let result = $0.tradingDate.toStringinKR().toDateinKR() else { return Date() }
//            return result
//        }
        
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
        TradingDiaryRepository.standard.filteredByTradingDate(selectedDate: self.mainView.calendar.selectedDate!)
        
        return TradingDiaryRepository.standard.tasks.count
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
                
                self.isEmptyCheck() // 에러는 안나지만 적용안됨
                
                self.eventsArr = TradingDiaryRepository.standard.tasks.map {
                    guard let result = $0.tradingDate.toStringinKR().toDateinKR() else { return Date() }
                    return result
                } // 에러는 안나지만 적용안됨
                
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
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.mainView.calendar.snp.updateConstraints { make in
            make.height.equalTo(bounds.height)
        }
        self.view.layoutIfNeeded()
    }
    
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
        
        // 일자
        self.mainView.calendar.appearance.titleFont = .systemFont(ofSize: 14, weight: .regular)
        self.mainView.calendar.appearance.titlePlaceholderColor = .subTextColor
        self.mainView.calendar.appearance.titleDefaultColor = .mainTextColor
//        self.mainView.calendar.appearance.titleWeekendColor = .systemRed
        
        self.mainView.calendar.appearance.headerDateFormat = "YYYY MM월"
        self.mainView.calendar.appearance.headerTitleFont = .systemFont(ofSize: 16, weight: .regular)
        self.mainView.calendar.appearance.headerTitleColor = .mainTextColor
        self.mainView.calendar.appearance.headerTitleAlignment = .center
        self.mainView.calendar.appearance.headerMinimumDissolvedAlpha = 0.5
        
        // today
        self.mainView.calendar.appearance.titleTodayColor = .mainTextColor
        self.mainView.calendar.appearance.todayColor = .subTextColor
        
        // 선택일
        self.mainView.calendar.select(selectedDate)
        self.mainView.calendar.appearance.selectionColor = .pointColor
        self.mainView.calendar.appearance.titleSelectionColor = .mainTextColor
        
        // 이벤트 색상
        self.mainView.calendar.appearance.eventDefaultColor = .pointColor
        self.mainView.calendar.appearance.eventSelectionColor = .pointColor
    }
    
    // 토요일, 일요일 색상구분
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let day = Calendar.current.component(.weekday, from: date) - 1
        
        if Calendar.current.shortWeekdaySymbols[day] == "Sun" || Calendar.current.shortWeekdaySymbols[day] == "일" {
            return .systemRed
        } else if Calendar.current.shortWeekdaySymbols[day] == "Sat" || Calendar.current.shortWeekdaySymbols[day] == "토" {
            return .systemBlue
        } else {
            return .label
        }
    }
    
    // 선택된 날짜의 채워진 색상 지정
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return appearance.selectionColor
    }
    
    // 날짜 선택시 발생하는 일
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("\(self.mainView.calendar.selectedDate?.toString())")
        
        TradingDiaryRepository.standard.filteredByTradingDate(selectedDate: date)
        
        
        isEmptyCheck()
        self.mainView.tableView.reloadData()
    }
   
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        if self.eventsArr.contains(date) {
            return 1
        } else {
            return 0
        }
    }
    
    
    
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
    
    func isEmptyCheck() {
        if TradingDiaryRepository.standard.tasks.count == 0 {
            self.mainView.tableView.isHidden = true
            self.mainView.emptyView.isHidden = false
        } else {
            self.mainView.tableView.isHidden = false
            self.mainView.emptyView.isHidden = true
        }
    }

    
}

