//
//  TimeDisplay.swift
//  Runvis
//
//  Created by 王富生 on 2017/5/27.
//  Copyright © 2017年 吳政緯. All rights reserved.
//

import UIKit


extension Int {
    
    func timeDisplay() -> String {
        
        let hour = self / 3600
        let min = self % 3600 / 60
        let sec = self % 60
        
        if hour != 0 {
            return "\(hour):\(min.timeFillZero()):\(sec.timeFillZero())"
        } else {
            return "\(min):\(sec.timeFillZero())"
        }
    }
    
    func timeFillZero() -> String {
        if self < 10 {
            return "0\(self)"
        } else {
            return "\(self)"
        }
    }
}

extension Double {
    
    func timePerKmDisplay() -> String {
        if self.isNaN {
            return "0'00\""
        }
        if self != 0 {
            let speedMin = Int((1 / self * 3600) / 60)
            let speedSec = Int((1 / self * 3600).truncatingRemainder(dividingBy: 60))
            return "\(speedMin)'\(speedSec.timeFillZero())\""
        } else {
            return "0'00\""
        }
    }
    
    func toKmDisplay() -> String {
        if self.isNaN {
            return "0.00"
        }
        if self >= 100000 {
            let km = Int(self/1000)
            return "\(km)"
        } else if self >= 10000 {
            let km = floor(self / 100) / 10
            return "\(km)"
        } else if self < 10 {
            let km = 0.0
            return "\(km)0"
        } else {
            let km = floor(self / 10)
            if (km.truncatingRemainder(dividingBy: 10)) != 0 {
                return "\(km/100)"
            } else {
                return "\(km/100)0"
            }
        }
    }
}
