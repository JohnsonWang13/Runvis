//
//  CustomWhiteView.swift
//  Runvis
//
//  Created by 吳政緯 on 2017/5/21.
//  Copyright © 2017年 吳政緯. All rights reserved.
//

import UIKit


//給DetailedWeatherConditionSecondCell的一些View使用
class CustomWhiteView:UIView{
    
    override func awakeFromNib() {
        
        self.backgroundColor = UIColor.whiteWithOpacity70
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
}
