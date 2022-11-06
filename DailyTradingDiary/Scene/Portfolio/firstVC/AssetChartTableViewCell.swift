//
//  AssetChartTableViewCell.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 11/6/22.
//

import UIKit

final class AssetChartTableViewCell: BaseTableViewCell {
    
    // MARK: - property
    lazy var ratioChart: PortfolioChartView = {
        let pieChartView = PortfolioChartView()
        return pieChartView
    }()
    
    let emptyView: EmptyView = {
       let view = EmptyView()
        view.setDataAtEmptyView(image: "pieChart.png", main: "현재 보유하고 있는 자산이 없어요.", sub: "홈화면의 + 버튼으로 매매일지를 작성해\n자산구성을 확인해보세요.")
        return view
    }()
    
    // MARK: - functions
    override func configure() {
        [ratioChart, emptyView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        ratioChart.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        emptyView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
}
