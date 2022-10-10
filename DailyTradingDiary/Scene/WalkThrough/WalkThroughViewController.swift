//
//  WalkThroughViewController.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 10/10/22.
//

import UIKit

final class WalkThroughViewController: BaseViewController {
    
    let manualImage: UIImageView = {
       let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        return imageview
    }()
    
    let exitButton: UIButton = {
      let button = UIButton()
        button.tintColor = .white
        return button
    }()

    override func configure() {
        [manualImage, exitButton].forEach {
            self.view.addSubview($0)
        }
        
        manualImage.image = UIImage(named: "manualImage")
        exitButton.setImage(UIImage(systemName: Constants.ImageName.x.rawValue, withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .light)), for: .normal)
        exitButton.addTarget(self, action: #selector(exitButtonClicked), for: .touchUpInside)
    }
    
    override func setConstraints() {
        manualImage.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        exitButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
        }
    }

    @objc func exitButtonClicked() {
        UserDefaults.standard.set(true, forKey: "FirstRun")
        self.presentingViewController?.dismiss(animated: true)
    }
    

}
