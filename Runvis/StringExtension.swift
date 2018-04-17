//
//  StringExtension.swift
//  Runvis
//
//  Created by 吳政緯 on 2017/5/29.
//  Copyright © 2017年 吳政緯. All rights reserved.
//

import Foundation



extension String {
    
    var length: Int {
        return self.characters.count
    }
    
    subscript (i: Int) -> String {
        return self[Range(i ..< i + 1)]
    }
    
    func substring(from: Int) -> String {
        return self[Range(min(from, length) ..< length)]
    }
    
    func substring(to: Int) -> String {
        return self[Range(0 ..< max(0, to))]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return self[Range(start ..< end)]
    }
    
}


////使用範例
//
//let str = "abcdef"
//str[1 ..< 3] // returns "bc"
//str[5] // returns "f"
//str[80] // returns ""
//str.substring(from: 3) // returns "def"
//str.substring(to: str.length - 2) // returns "abcd"



extension String {
    
    func transformWeatherString()->WeatherConditionDescription{
        switch self {
        case "多雲短暫陣雨":
            return .sunnyRain
        case "陰短暫陣雨或雷雨":
            return .sunnyRain
        case "陰陣雨或雷雨":
            return .thunderRain
        case "多雲時陰陣雨或雷雨":
            return .thunderRain
        case "陰時多雲":
            return .mostlyClear
        case "陰天":
            return .mostlyClear
        case "多雲時陰":
            return .mostlyClear
        case "多雲":
            return .mostlyClear
        case "陰時多雲短暫陣雨":
            return .sunnyRain
        default:
            return .mostlyClear
        }
    }
    
    
}
