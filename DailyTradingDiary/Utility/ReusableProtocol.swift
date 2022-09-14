//
//  ReusableProtocol.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/14/22.
//

import UIKit

protocol ReusableProtocol: AnyObject {
    static var reuseIdentifier: String { get }
}

extension UIViewController: ReusableProtocol {
    public static var reuseIdentifier: String {
        return String(describing: self) // description 메서드 활용방법으로 변경하자
    }
}

extension UICollectionViewCell: ReusableProtocol {
    public static var reuseIdentifier: String {
        return String(describing: self) // description 메서드 활용방법으로 변경하자
    }
}
extension UITableViewCell: ReusableProtocol {
    public static var reuseIdentifier: String {
        return String(describing: self) // description 메서드 활용방법으로 변경하자
    }
}
