//
//  Colors.swift
//  Runvis
//
//  Created by 王富生 on 2017/5/22.
//  Copyright © 2017年 吳政緯. All rights reserved.
//

import UIKit

extension UIColor {
    
    class var darkishBlue: UIColor {
        return UIColor(red: 13/255, green: 66/255, blue: 141/255, alpha: 1)
    }
    
    class var oceanBlue: UIColor {
        return UIColor(red: 0/255, green: 95/255, blue: 175/255, alpha: 1)
    }
    
    //良好
    class var airQualityLevelGreen: UIColor {
        return UIColor(red: 39/255, green: 189/255, blue: 4/255, alpha: 1)
    }
    //不錯
    class var airQualityLevelYellow: UIColor {
        return UIColor(red: 254/255, green: 221/255, blue: 26/255, alpha: 1)
    }
    //普通
    class var airQualityLevelOrange: UIColor {
        return UIColor(red: 246/255, green: 139/255, blue: 7/255, alpha: 1)
    }
    //差
    class var airQualityLevelRed: UIColor {
        return UIColor(red: 215/255, green: 4/255, blue: 4/255, alpha: 1)
    }
    //很差
    class var airQualityLevelPurple: UIColor {
        return UIColor(red: 127/255, green: 3/255, blue: 164/255, alpha: 1)
    }
    //危害
    class var airQualityLevelCrimson: UIColor {
        return UIColor(red: 129/255, green: 1/255, blue: 17/255, alpha: 1)
    }
    
    class var darkishBlueWithOpacity15: UIColor {
        return UIColor(red: 13/255.0, green: 66/255.0, blue: 141/255.0, alpha: 0.17)
    }
    
    class var whiteWithOpacity70: UIColor {
        return UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.7)
    }

    class var purpleyGrey: UIColor {
        return UIColor(red: 155/255.0, green: 155/255.0, blue: 155/255.0, alpha: 1)
    }
    
    class var runPageBackground: UIColor {
        return UIColor(red: 17/255, green: 59/255, blue: 120/255, alpha: 1)
    }
    
    class var countdownBackground: UIColor {
        return UIColor(red: 143/255, green: 163/255, blue: 192/255, alpha: 1)
    }
    class var detailWeatherBackBround: UIColor {
        return UIColor(red: 206/255, green: 216/255, blue: 231/255, alpha: 1)
    }

}
