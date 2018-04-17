//
//  darkishBlueLabel.swift
//  Runvis
//
//  Created by 吳政緯 on 2017/5/21.
//  Copyright © 2017年 吳政緯. All rights reserved.
//

import UIKit


//字體為PingFangTC-Regular
class DarkishBlueLabel:UILabel{
    
    override func awakeFromNib() {
        
            self.font = UIFont(name: "PingFangTC-Regular", size: self.font.pointSize)
            self.textColor = UIColor.darkishBlue
        
    }
    @IBInspectable var iPhoneFontSize:CGFloat = 0 {
        didSet {
            overrideFontSize(fontSize: iPhoneFontSize)
        }
    }
    
    func overrideFontSize(fontSize:CGFloat){
        
        let currentFontName = self.font.fontName
        var calculatedFont: UIFont?
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        
        switch height {
        case 480.0: //Iphone 3,4,SE => 3.5 inch
            calculatedFont = UIFont(name: currentFontName, size: fontSize * 0.6)
            self.font = calculatedFont
            break
        case 568.0: //iphone 5, 5s => 4 inch
            calculatedFont = UIFont(name: currentFontName, size: fontSize * 0.7)
            self.font = calculatedFont
            break
        case 667.0: //iphone 6, 6s => 4.7 inch
            calculatedFont = UIFont(name: currentFontName, size: fontSize * 0.9)
            self.font = calculatedFont
            break
        case 736.0: //iphone 6s+ 6+ => 5.5 inch
            calculatedFont = UIFont(name: currentFontName, size: fontSize)
            self.font = calculatedFont
            break
        default:
            print("not an iPhone")
            break
        }
    }
}
