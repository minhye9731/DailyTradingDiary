//
//  PortfolioChartView.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/22/22.
//

import UIKit

class PortfolioChartView: UIView {
    
    let animation_duration: CGFloat = 2
    var slices: [newVersionSlice]?
    var sliceIndex: Int = 0
    var currentPercent: CGFloat = 0.0
    
    // MARK: - slice, label 모두를 순차적으로 보여주는 함수
    func animateChart() {
            sliceIndex = 0
            currentPercent = 0.0
        
            self.layer.sublayers = nil
            removeAllLabels()
        
            if slices != nil && slices!.count > 0 {
                let firstSlice = slices![0]
                addSlice(firstSlice)
                addLabel(firstSlice)
            }
        }
    
    // MARK: - slice 더해주는 함수
    func addSlice(_ slice: newVersionSlice) {
        let canvasWidth = self.frame.width * 0.65 //여기
        let path = UIBezierPath(arcCenter: self.center,
                                    radius: canvasWidth * 3 / 8, //여기
                                    startAngle: percentToRadian(currentPercent),
                                    endAngle: percentToRadian(currentPercent + slice.percent),
                                    clockwise: true)
        
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = getDuration(slice) // 전체 animation 시간을 각 slice 비율만큼 할당
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear) // 이건뭘까
            animation.delegate = self
            
//        let canvasWidth = self.frame.width * 0.8
        
//        let path = UIBezierPath(arcCenter: self.center, // portfolio > 자산현황 > 자산구성 의 중앙으로 수정
//                                    radius: canvasWidth * 3 / 8,
//                                    startAngle: percentToRadian(currentPercent),
//                                    endAngle: percentToRadian(currentPercent + slice.percent),
//                                    clockwise: true)
            
            let sliceLayer = CAShapeLayer()
            sliceLayer.path = path.cgPath
            sliceLayer.fillColor = nil
            sliceLayer.strokeColor = slice.color.cgColor
            sliceLayer.lineWidth = canvasWidth * 2 / 8 // 여기
            sliceLayer.strokeEnd = 1
            sliceLayer.add(animation, forKey: animation.keyPath)
            
            self.layer.addSublayer(sliceLayer)
        }
    
    // MARK: - label 더해주는 함수
    private func addLabel(_ slice: newVersionSlice) {
            let center = self.center // 라벨 또한 'portfolio > 자산현황 > 자산구성'의 중앙으로 수정
        let labelCenter = getLabelCenter(currentPercent, currentPercent + slice.percent) // 라벨 위치잡기
            
            // 종목명 라벨
            let label = UILabel()
            label.textColor = .black
            label.numberOfLines = 0
            label.textAlignment = .center
            addSubview(label)
            
            // 구성비율 라벨
            let roundedPercentage = round(slice.percent * 1000) / 10
            label.text = "\(roundedPercentage)%"
            
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([label.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: labelCenter.x - center.x),
                                         label.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: labelCenter.y - center.y)])
            
            self.layoutIfNeeded()
        }
    
    // MARK: - 기타 함수들
    // 라벨 위치 잡기
    private func getLabelCenter(_ fromPercent: CGFloat, _ toPercent: CGFloat) -> CGPoint {
            let canvasWidth = self.frame.width * 0.65 // 여기
            let radius = canvasWidth * 3 / 8 // 여기
            let labelAngle = percentToRadian((toPercent - fromPercent) / 2 + fromPercent)
            let path = UIBezierPath(arcCenter: self.center,
                                    radius: radius,
                                    startAngle: labelAngle,
                                    endAngle: labelAngle,
                                    clockwise: true)
            path.close()
            
            return path.currentPoint
        }
    
    // 각 slice의 퍼센트를 각도로 변환
    func percentToRadian(_ percent: CGFloat) -> CGFloat {
        var angle = 270 + percent * 360
        if angle >= 360 {
            angle -= 360
        }
        return angle * CGFloat.pi / 180.0
    }
    
    // 전체 animation 시간을 각 slice 비율만큼 할당
    func getDuration(_ slice: newVersionSlice) -> CFTimeInterval {
        return CFTimeInterval(slice.percent / 1.0 * animation_duration)
    }
    
    // 현 pieChartView의 subview 중 UILabel 모두 삭제
    func removeAllLabels() {
        subviews.filter({ $0 is UILabel }).forEach({ $0.removeFromSuperview() })
    }
}

// MARK: - addslice 고스톱 여부 결정하는 함수. delegate로 연결되어 addslice 작동할때마다 실행됨
extension PortfolioChartView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            currentPercent += slices![sliceIndex].percent
            sliceIndex += 1
            
            if sliceIndex < slices!.count {
                let nextSlice = slices![sliceIndex]
                addSlice(nextSlice)
                addLabel(nextSlice)
            }
        }
    }
    
    
}
