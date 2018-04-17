//
//  DetailedWeatherConditionCell.swift
//  Runvis
//
//  Created by 吳政緯 on 2017/5/16.
//  Copyright © 2017年 吳政緯. All rights reserved.
//

import UIKit

class DetailedWeatherConditionCell: UITableViewCell {

    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var aQILabel: UILabel!
    @IBOutlet weak var aQIColorView: AriLevelColorSmall!
    @IBOutlet weak var airQualityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        aQIColorView.layer.cornerRadius = 5
        aQIColorView.clipsToBounds = true
        self.backgroundColor  = .detailWeatherBackBround
    }
}


extension DetailedWeatherConditionCell {
    
    //設置所有View和Label的值
    func setValue(from data:AirQuality) {
        
        if !data.aQI.isZero {
            let aQI = data.aQI
            self.aQILabel.text = "AQI \(aQI)"
            self.aQIColorView.backgroundColor = AirPollutant.aQI(aQI).correspodingColor
            self.airQualityLabel.text = "空氣品質 \(AirPollutant.aQI(aQI).airQuality)"
        }
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:  #selector(self.showCurrentTime), userInfo: nil, repeats: true)
    }

    func showCurrentTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd EEE hh:mm:ss"
        let date = Date()
        let dateString = formatter.string(from: date)
        currentTimeLabel.text = dateString
    }
}
