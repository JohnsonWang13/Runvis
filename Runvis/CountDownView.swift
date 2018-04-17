//
//  CountDownView.swift
//  Runvis
//
//  Created by 王富生 on 2017/5/24.
//  Copyright © 2017年 吳政緯. All rights reserved.
//

import UIKit

class CountDownView: UIView {

    let π = CGFloat.pi
    let circleLayer = CAShapeLayer()
    let circleBackground = CAShapeLayer()
    
    override func draw(_ rect: CGRect) {
        
        let arcCenter = CGPoint(x: rect.maxX / 2, y: rect.maxY / 2)
        let radius: CGFloat = (min(rect.height, rect.width) - 11) / 2
        let startAngle: CGFloat = 6 * π / 4
        let endAngle: CGFloat = -2 * π / 4
        
        
        let outCircle = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        circleBackground.path = outCircle.cgPath
        circleBackground.strokeColor = UIColor.countdownBackground.cgColor
        circleBackground.fillColor = UIColor.clear.cgColor
        circleBackground.lineWidth = 10
        
        circleLayer.path = outCircle.cgPath
        circleLayer.strokeColor = UIColor.white.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = 10
        
        layer.addSublayer(circleBackground)
        layer.addSublayer(circleLayer)
    }
    
    func animateCircleTo(duration: TimeInterval, fromValue: CGFloat, toValue: CGFloat){
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        animation.duration = duration
        
        animation.fromValue = fromValue
        animation.toValue = toValue
        
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        circleLayer.strokeEnd = toValue
        
        circleLayer.add(animation, forKey: "animateCircle")
    }
}
