//
//  PieChartView.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/21/22.
//

import UIKit

class PieChartView: UIView {

    let animation_duration: CGFloat = 2 // 전체 애니메이션 시간
    var slices: [Slice]? // 파이 그래프의 요소들(슬라이스들)
    var sliceIndex: Int = 0 // 현재 그리고 있는 슬라이스가 몇번째인지에 대한 정보
    var currentPercent: CGFloat = 0.0

    func animateChart() {
        // 첫 슬라이스로 index를 설정하고, 현재까지 그린 percent도 0으로 설정한다
        sliceIndex = 0
        currentPercent = 0.0
        // 새로 animateChart를 할 때는 뷰컨에 이미 그려져있는 기존의 layer들과 label들을 모두 지워야한다
        self.layer.sublayers = nil
        removeAllLabels()

        if slices != nil && slices!.count > 0 {
            let firstSlice = slices![0]
            addSlice(firstSlice)
            addLabel(firstSlice)
        }
    }

    func addSlice(_ slice: Slice) {
        // CABasicAnimation을 선언하여 from, to, duration 등을 설정한다
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = getDuration(slice)
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.delegate = self

        // 실제로 stroke를 그릴 path를 UIBezierPath으로 선언한다
        let canvasWidth = self.frame.width * 0.8
        let path = UIBezierPath(arcCenter: self.center,
                                radius: canvasWidth * 3 / 8,
                                startAngle: percentToRadian(currentPercent),
                                endAngle: percentToRadian(currentPercent + slice.percent),
                                clockwise: true)

        // CAShapeLayer에 위에서 정의한 BezierPath와 animation을 넘겨준다
        let sliceLayer = CAShapeLayer()
        sliceLayer.path = path.cgPath
        sliceLayer.fillColor = nil
        sliceLayer.strokeColor = slice.color.cgColor
        sliceLayer.lineWidth = canvasWidth * 2 / 8
        sliceLayer.strokeEnd = 1
        sliceLayer.add(animation, forKey: animation.keyPath)

        self.layer.addSublayer(sliceLayer)
    }

    // MARK: - 라벨더하기
    private func addLabel(_ slice: Slice) {
        let center = self.center
        // 현재 퍼센트와 그릴만큼의 퍼센트의 중간 위치를 찾고 거기에 레이블을 추가한다
        let labelCenter = getLabelCenter(currentPercent, currentPercent + slice.percent)

        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 12)
        addSubview(label)

        let status = slice.status
        label.text = "\(status)"

        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([label.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: labelCenter.x - center.x),
                                     label.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: labelCenter.y - center.y)])

        self.layoutIfNeeded()
    }

    private func getLabelCenter(_ fromPercent: CGFloat, _ toPercent: CGFloat) -> CGPoint {
        let canvasWidth = self.frame.width * 0.8
        let radius = canvasWidth * 3 / 8
        // 레이블이 위치해야할 곳을 계산하여 BezierPath로 나타낸다
        let labelAngle = percentToRadian((toPercent - fromPercent) / 2 + fromPercent)
        let path = UIBezierPath(arcCenter: self.center,
                                radius: radius,
                                startAngle: labelAngle,
                                endAngle: labelAngle,
                                clockwise: true)
        path.close()

        // BezierPath의 point를 반환
        return path.currentPoint
    }

    func removeAllLabels() {
        // 현재 pieChartView의 subview들 중 UILabel인 것들을 모두 삭제
        subviews.filter({ $0 is UILabel }).forEach({ $0.removeFromSuperview() })
    }

    func percentToRadian(_ percent: CGFloat) -> CGFloat {
        // 파이그래프의 시작이 270도 위치에서 시작하므로 각 슬라이스의 percent를 360도 좌표로 변환하여 각도를 계산한다
        var angle = 180 + percent * 360
        if angle >= 360 {
            angle -= 360
        }
        return angle * CGFloat.pi / 180.0
    }

    func getDuration(_ slice: Slice) -> CFTimeInterval {
        // 각 슬라이스의 퍼센티지에 따라 전체 애니메이션 시간에서 차지하는 시간의 비율도 다르게 계산하는 함수
        return CFTimeInterval(slice.percent / 1.0 * animation_duration)
    }
}

extension PieChartView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            // currentPercent는 현재까지 파이그래프를 그린 정도를 나타낸다
            // 여기에 현재 index번째의 slice percent만큼 그렸으므로 그 값만큼 더한다
            // "그렸으므로"인 이유는 현재 메소드가 불리는 시점이 index번째 슬라이스를 그리는 애니메이션이 didStop 된 이후이기 때문이다
            currentPercent += slices![sliceIndex].percent
            // 다음 슬라이스를 그려야하므로 sliceIndex를 한칸 옮겨준다
            sliceIndex += 1
            // 만약 다음 슬라이스가 남아있다면 addSlice를 반복한다
            if sliceIndex < slices!.count {
                let nextSlice = slices![sliceIndex]
                addSlice(nextSlice)
                addLabel(nextSlice)


            }
        }
    }
}
