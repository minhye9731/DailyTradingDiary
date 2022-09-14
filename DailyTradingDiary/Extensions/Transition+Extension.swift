//
//  Transition+Extension.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/14/22.
//

import UIKit

extension UIViewController {
    
    enum TransitionStyle {
        case present
        case prsentNavigation
        case presentFullNavigation
        case push
    }
    
    func transition(_ vc: UIViewController, transitionStyle: TransitionStyle) {
        
        switch transitionStyle {
        case .present:
            self.present(vc, animated: true)
        case .prsentNavigation:
            let navi = UINavigationController(rootViewController: vc)
            self.present(navi, animated: true)
        case .presentFullNavigation:
            let navi = UINavigationController(rootViewController: vc)
            navi.modalPresentationStyle = .fullScreen
            self.present(navi, animated: true)
        case .push:
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


