//
//  IntroViewController.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 10/5/22.
//

import UIKit
import SnapKit
import RealmSwift

final class IntroViewController: BaseViewController {
    
    let logoImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override func configure() {
        self.view.backgroundColor = .white
        logoImageView.image = UIImage(named: "TradyIntro")
        
        self.view.addSubview(logoImageView)
        
        // 통신
//        let startTime = CFAbsoluteTimeGetCurrent()
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
//        DARTAPIManager.shared.downloadCorpCode(type: .dartCorpCode)
//        print("downloadCorpCode 작업 소요시간 🤔: \(CFAbsoluteTimeGetCurrent() - startTime)")
        
        // 화면전환
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let vc = TabBarController()
            let navigationController = UINavigationController(rootViewController: vc)
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            sceneDelegate?.window?.rootViewController = navigationController
            
            vc.checkFirstRun()
        }
        
    }
    
    
    override func setConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self.view)
            make.width.height.equalTo(200)
        }
        
    }
    
}
