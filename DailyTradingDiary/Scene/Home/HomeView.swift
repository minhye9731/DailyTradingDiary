//
//  HomeView.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/14/22.
//

import UIKit
import SnapKit
import FSCalendar

final class HomeView: BaseView {
    
    lazy var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.backgroundColor = .backgroundColor
        return calendar
    }()
    
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .plain)
        tableview.backgroundColor = .backgroundColor
        tableview.rowHeight = 86
        tableview.register(TradeTableViewCell.self, forCellReuseIdentifier: TradeTableViewCell.reuseIdentifier)
        tableview.separatorStyle = .none
        return tableview
    }()
    
    let floatingButton: UIButton = {
       let button = UIButton()
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.backgroundColor = .pointColor
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        return button
    }()
    
    let firstFloatingButton: UIButton = {
       let button = UIButton()
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .pointColor //.subBackgroundColor
        configuration.baseForegroundColor = .white //.mainTextColor
        configuration.image = UIImage(systemName: Constants.ImageName.diary.rawValue)
        configuration.imagePlacement = .leading
        configuration.imagePadding = 12
        configuration.cornerStyle = .large
        
        var title = AttributedString.init("매매일지")
        title.font = .boldSystemFont(ofSize: 13)
        configuration.attributedTitle = title
        
        button.configuration = configuration

        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        return button
    }()
    
    let secondFloatingButton: UIButton = {
       let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .pointColor //.subBackgroundColor
        configuration.baseForegroundColor = .white // .mainTextColor
        configuration.image = UIImage(systemName: Constants.ImageName.corporation.rawValue)
        configuration.imagePlacement = .leading
        configuration.imagePadding = 12
        configuration.cornerStyle = .large
        
        var title = AttributedString.init("기업등록")
        title.font = .boldSystemFont(ofSize: 13)
        configuration.attributedTitle = title
        
        button.configuration = configuration
        
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        return button
    }()
    
    let floatingStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.alignment = .trailing
        stackview.distribution = .equalSpacing
        stackview.spacing = 12
        return stackview
    }()
    
    // empty view
    let emptyView: EmptyView = {
       let view = EmptyView()
        view.setDataAtEmptyView(image: "accountingBook.png", main: "아직 생성된 매매일지가 없어요.", sub: "+ 버튼으로 매매일지를 작성해\n일자별 거래내역을 확인해보세요.")
        return view
    }()

    override func configureUI() {
        [calendar, tableView, emptyView, floatingStackView].forEach {
            self.addSubview($0)
        }
        
        [secondFloatingButton, firstFloatingButton, floatingButton].forEach {
            floatingStackView.addArrangedSubview($0)
        }
        
        let image = UIImage(systemName: Constants.ImageName.plus.rawValue, withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .light))
        
        floatingButton.setImage(image, for: .normal)
        floatingButton.setTitleColor(.backgroundColor, for: .normal)
    }
    
    override func setConstraints() {
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.centerX.equalTo(self)
            make.width.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(300)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom)
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        floatingButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.width.equalTo(60)
        }
        
        firstFloatingButton.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.width.equalTo(120)
        }
        
        secondFloatingButton.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.width.equalTo(120)
        }
        
        floatingStackView.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-36)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-28)
        }
        
        // emptyview
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom)
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }

}









