//
//  UIColor+Extension.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/14/22.
//

import UIKit

extension UIColor {
    
    static var backgroundColor: UIColor {
        
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .light {
                return UIColor(red: 242/255, green: 241/255, blue: 245/255, alpha: 1)
            } else {
                return .black
            }
        }
    }
    
    static var subBackgroundColor: UIColor {
        
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .light {
                return UIColor(red: 242/255, green: 241/255, blue: 245/255, alpha: 1)
            } else {
                return UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
            }
        }
    }
    
    static var cellBackgroundColor: UIColor {
        
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .light {
                return .white
            } else {
                return UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
            }
        }
    }
    
    static var popupBackgroundColor: UIColor {
        
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 0.9)
        }
    }
    
    static var tabBarColor: UIColor {
        
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .light {
                return UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
            } else {
                return UIColor(red: 21/255, green: 21/255, blue: 21/255, alpha: 1)
            }
        }
    }
    
    static var mainTextColor: UIColor {
        
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .light {
                return .black
            } else {
                return .white
            }
        }
    }
    
    static var subTextColor: UIColor {
        
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .light {
                return .lightGray
            } else {
                return .lightGray
            }
        }
    }
    
    static var pointColor: UIColor {
        
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return UIColor.systemPurple
        }
    }
    
    static var deleteColor: UIColor {
        
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return UIColor.red
        }
    }

    
}

