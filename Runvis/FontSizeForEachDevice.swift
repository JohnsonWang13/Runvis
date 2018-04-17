//
//  FontSizeForEachDevice.swift
//  Runvis
//
//  Created by 吳政緯 on 2017/5/23.
//  Copyright © 2017年 吳政緯. All rights reserved.
//

import UIKit


//enum FontSizeForEachDevice{
//   
//    case title1
//    case title2
//    case title3
//    case
//    case
//    
//    
//    
//
//}


class FontSizeForEachDevice {

    class func overrideFontSize(fontSize:CGFloat) -> CGFloat {

        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        switch height {
        case 480.0: //Iphone 3,4,SE => 3.5 inch
            return fontSize * 0.7
           
        case 568.0: //iphone 5, 5s => 4 inch
           return fontSize * 0.8
        case 667.0: //iphone 6, 6s => 4.7 inch
           return fontSize * 0.9
        case 736.0: //iphone 6s+ 6+ => 5.5 inch
           return fontSize
        default:
            print("not an iPhone or have a BUG")
            return 0
        }
    }
}
