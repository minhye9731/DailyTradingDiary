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
import UserNotifications

final class HomeViewController: BaseViewController, FSCalendarDelegate, FSCalendarDataSource, UIGestureRecognizerDelegate {
    
    let mainView = HomeView()
    var selectedDate: Date = Date()
    var eventsArr = [Date]()
    let notificationCenter = UNUserNotificationCenter.current()
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    lazy var scopeGesture: UIPanGestureRecognizer = { [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.mainView.calendar, action: #selector(self.mainView.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    lazy var fltyButtons: [UIButton] = [self.mainView.firstFloatingButton, self.mainView.secondFloatingButton]
    var isShowFloating: Bool = false
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = mainView
        print("HomeViewController - \(#function)")
        self.mainView.tableView.reloadData()
    }
    
    override func configure() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        setNav()
        setNavItem()
        setCalendarUI()
        setGesture()
        requestAuthorization()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 90000 row 데이터 받기
        print(Realm.Configuration.defaultConfiguration.fileURL!)
//        DARTAPIManager.shared.downloadCorpCode(type: .dartCorpCode)
        
        TradingDiaryRepository.standard.sortByRegDate()
        
        mainView.floatingButton.addTarget(self, action: #selector(floatingBtnTapped), for: .touchUpInside)
        mainView.firstFloatingButton.addTarget(self, action: #selector(firstFloatinBtnTapped), for: .touchUpInside)
        mainView.secondFloatingButton.addTarget(self, action: #selector(secondFloatingBtnTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
        isShowFloating = false
        self.mainView.firstFloatingButton.isHidden = true
        self.mainView.secondFloatingButton.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        TradingDiaryRepository.standard.filteredByTradingDate(selectedDate: self.mainView.calendar.selectedDate!)
        isEmptyCheck()
        self.eventsArr = TradingDiaryRepository.standard.localRealm.objects(TradingDiaryRealmModel.self).map {
            guard let result = $0.tradingDate.toStringinKR().toDateinKR() else { return Date() }
            return result
        }
        self.mainView.tableView.reloadData()
        self.mainView.calendar.reloadData()
    }
    
    
}

// MARK: - tableview 설정
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        TradingDiaryRepository.standard.filteredByTradingDate(selectedDate: self.mainView.calendar.selectedDate!)
        return  TradingDiaryRepository.standard.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tradeCell = tableView.dequeueReusableCell(withIdentifier: TradeTableViewCell.reuseIdentifier) as? TradeTableViewCell else { return UITableViewCell() }
        tradeCell.setData(arr: Array(TradingDiaryRepository.standard.tasks), indexPath: indexPath)
        tradeCell.selectionStyle = .none
        return tradeCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tradeDiaryVC = TradingDiaryViewController()
        
        let row = Array(TradingDiaryRepository.standard.tasks)[indexPath.row]
        
        tradeDiaryVC.diaryData = row
        tradeDiaryVC.addOrEditAction = .edit
        
        transition(tradeDiaryVC, transitionStyle: .push)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let row = Array(TradingDiaryRepository.standard.tasks)[indexPath.row]
        
        let delete = UIContextualAction(style: .normal, title: nil) { action, view, completion in
            self.deleteConfirmAlert(title: "해당 메모를 삭제하시겠습니까?") { _ in
                
                CorpRegisterRepository.standard.deleteDiaryatList(item: row)
                self.isEmptyCheck()
                TradingDiaryRepository.standard.sortByRegDate()
                self.eventsArr = TradingDiaryRepository.standard.localRealm.objects(TradingDiaryRealmModel.self).map {
                    guard let result = $0.tradingDate.toStringinKR().toDateinKR() else { return Date() }
                    return result
                }
                self.mainView.tableView.reloadData()
                self.mainView.calendar.reloadData()
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
        UIView.animate(withDuration: 0.5) {
            self.mainView.layoutIfNeeded()
        }
    }
    
    func setCalendarUI() {
        
        self.mainView.calendar.dataSource = self
        self.mainView.calendar.delegate = self
        
        self.mainView.calendar.locale = Locale(identifier: "ko_KR")
        
        self.mainView.calendar.placeholderType = .none
        
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
        self.mainView.calendar.appearance.titleDefaultColor = .mainTextColor
        
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
        
        TradingDiaryRepository.standard.filteredByTradingDate(selectedDate: date)
        isEmptyCheck()
        self.mainView.tableView.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        self.eventsArr = TradingDiaryRepository.standard.localRealm.objects(TradingDiaryRealmModel.self).map {
            guard let result = $0.tradingDate.toStringinKR().toDateinKR() else { return Date() }
            return result
        }
        
        if self.eventsArr.contains(date) {
            return 1
        } else {
            return 0
        }
    }
    
}

// MARK: - 기타함수들
extension HomeViewController {
    
    func setGesture() {
        self.mainView.addGestureRecognizer(self.scopeGesture)
        self.mainView.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.mainView.calendar.scope = .month
    }
    func setNav() {
        let titleLabel = UILabel()
        titleLabel.text = "Trady"
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
        let todayButton = UIBarButtonItem(title: "Today", style: .plain, target: self, action: #selector(todayButtonClicked))
        let settingButton = UIBarButtonItem(image: UIImage(systemName: Constants.ImageName.setting.rawValue), style: .plain, target: self, action: #selector(settingButtonTapped))
        
        self.navigationItem.rightBarButtonItems = [settingButton, todayButton]
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.mainView.tableView.contentOffset.y >= self.mainView.tableView.contentInset.top
        
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.mainView)
            switch self.mainView.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            default : break
            }
        }
        return shouldBegin
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
    
    // 플로팅 버튼
    @objc func floatingBtnTapped() {
        // 표기, 숨기기기 기능
        if isShowFloating {
            fltyButtons.reversed().forEach { button in
                UIView.animate(withDuration: 0.3) {
                    button.isHidden = true
                    self.mainView.layoutIfNeeded()
                }
            }
        } else {
            fltyButtons.forEach { [weak self] button in
                button.isHidden = false
                button.alpha = 0
                
                UIView.animate(withDuration: 0.3) {
                    button.alpha = 1
                    self?.mainView.layoutIfNeeded()
                }
            }
        }
        isShowFloating = !isShowFloating
    }
    
    @objc func firstFloatinBtnTapped() {
        let vc = TradingDiaryViewController()
        vc.addOrEditAction = .write
        transition(vc, transitionStyle: .push)
    }
    
    @objc func secondFloatingBtnTapped() {
        let vc = CorpAnalysisViewController()
        vc.addOrEditAction = .write
        transition(vc, transitionStyle: .push)
    }
    
    @objc func todayButtonClicked() {
        self.mainView.calendar.select(Date())
        isEmptyCheck()
    }
    
    @objc func settingButtonTapped() {
        let vc = SettingViewController()
        transition(vc, transitionStyle: .push)
    }
    
}

// MARK: - 아침 local 알림 설정
extension HomeViewController {
    
    func requestAuthorization() {
        
        let authorizationOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        
        notificationCenter.requestAuthorization(options: authorizationOptions) { success, error in
            if success {
                self.sendNotification()
            }
        }
    }
    
    func sendNotification() {
        
        let morningNotification = UNMutableNotificationContent()
        morningNotification.title = "🗞 Time to be Trady 🗞"
        morningNotification.body = "오늘의 시장 상황을 확인하며 하루를 시작해보세요 :)"
        morningNotification.badge = 1
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.hour = 8
        dateComponents.minute = 40
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                                            content: morningNotification,
                                            trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
    }
    
}


