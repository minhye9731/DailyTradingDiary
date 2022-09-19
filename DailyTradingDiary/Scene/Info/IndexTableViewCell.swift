//
//  IndexTableViewCell.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/19/22.
//

import UIKit

final class IndexTableViewCell: BaseTableViewCell {
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 100)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.register(IndexCollectionViewCell.self, forCellWithReuseIdentifier: IndexCollectionViewCell.reuseIdentifier)
        
        return collectionview
    }()
    
    override func configure() {
        self.backgroundColor = .yellow // test용, 추후에 mainbackgroundcolor로 변경
        contentView.addSubview(collectionView)
        
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
}






