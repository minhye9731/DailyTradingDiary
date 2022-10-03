//
//  BaseViewController.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/14/22.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
    }
    
    
    func configure() {
        self.view.backgroundColor = .backgroundColor
    }
    
    func setConstraints() {}
    
    func showAlertMessage(title: String, button: String = "확인") {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: button, style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func showAlertMessageDetail(title: String, message: String, button: String = "확인") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: button, style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func deleteConfirmAlert(title: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "확인", style: .default, handler: handler)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    func giveColotString(label: UILabel, colorStr: String, color: UIColor) {
        
        let attributeLabelStr = NSMutableAttributedString(string: label.text!)
        attributeLabelStr.addAttribute(.foregroundColor, value: color, range: (label.text! as NSString).range(of: colorStr))
        label.attributedText = attributeLabelStr
    }
    
    func thousandSeparatorCommas(value: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(for: value) ?? "0"
    }
    
}
