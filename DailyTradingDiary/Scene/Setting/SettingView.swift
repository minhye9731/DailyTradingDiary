//
//  SettingView.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 10/19/22.
//

import UIKit

final class SettingView: BaseView {
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        return collectionView
    }()
    
    override func configureUI() {
        self.addSubview(collectionView)
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
