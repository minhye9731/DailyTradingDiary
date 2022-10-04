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
                return .white
            } else {
                return .black
            }
        }
    }
    
    static var subBackgroundColor: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .light {
                return .white
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
    
    static var mainTextColor: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .light {
                return .black
            } else {
                return .white
            }
        }
    }
    
    static var mainTextColorReverse: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .light {
                return .white
            } else {
                return .black
            }
        }
    }
    
    static var subTextColor: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .light {
                return .lightGray
            } else {
                return .darkGray
            }
        }
    }
    
    static var subTextColorReverse: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .light {
                return .darkGray
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
            return UIColor.systemRed
        }
    }
    
    static var tradeDiaryTagColor: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return UIColor.systemGreen
        }
    }

    
}

