//
//  DetailedWeatherConditionFirstCell.swift
//  Runvis
//
//  Created by 吳政緯 on 2017/5/23.
//  Copyright © 2017年 吳政緯. All rights reserved.
//

import UIKit

class DetailedWeatherConditionFirstCell: UITableViewCell {

    @IBOutlet weak var suggestionLabel: UILabel!
    @IBOutlet weak var aQIimageView: UIImageView!
}

extension DetailedWeatherConditionFirstCell {
    //設置所有View和Label的值
    
    func setValue(from data:AirQuality){
        
        if !data.aQI.isZero {
            
            let value = data.aQI
            let image:UIImage = AirPollutant.aQI(value).aQIImage!
            let suggestion:String = AirPollutant.aQI(value).runningSuggestion!
            self.suggestionLabel.text = suggestion
            self.aQIimageView.image = image
            
        } else {
            
            self.suggestionLabel.text = "AQI指數看來遺失了，還是在家裡下棋吧！"
            self.aQIimageView.image = #imageLiteral(resourceName: "chess")
        }
    }
}
