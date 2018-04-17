//
//  RunningInformationCell.swift
//  Runvis
//
//  Created by 吳政緯 on 2017/5/24.
//  Copyright © 2017年 吳政緯. All rights reserved.
//

import UIKit
import CoreData
class RunningInformationCell: UITableViewCell {

    @IBOutlet weak var averageSpeedLabel: UILabel!
    @IBOutlet weak var durationLabel:UILabel!
    @IBOutlet weak var heartRateLabel:UILabel!
    @IBOutlet weak var burnedCaloriesLabel:UILabel!
    @IBOutlet weak var physicalConditionLabel:UILabel!
    @IBOutlet weak var aQILabel:UILabel!
}


extension RunningInformationCell {
    
    internal func setupValue(by runInfo:RunInformation){
        
        let distance = runInfo.distance.doubleValue
        let duration = runInfo.duration.intValue
        
        //設置平均配速
        
        let averageSpeed = (distance/Double(duration) * 3.6 * 100).rounded()/100
        
        averageSpeedLabel.text = averageSpeed.timePerKmDisplay()
        
        //設置持續時間
        durationLabel.text = duration.timeDisplay()
        
        //設置心律
        heartRateLabel.text = "--"
        
        //設置消耗熱量
        burnedCaloriesLabel.text = "--"//runInfo.distance
        
        //設置身體狀況
        let physicalCondition:Int = Int(runInfo.physicalCondition)
        switch physicalCondition {
        case 0:
            physicalConditionLabel.font = UIFont(name: "PingFangTC-Regular", size: 20)
            physicalConditionLabel.text = "___ ___"
        case 1:
            physicalConditionLabel.text = "差"
        case 2:
            physicalConditionLabel.text = "普通"
        case 3:
            physicalConditionLabel.text = "良好"
        case 4:
            physicalConditionLabel.text = "很棒"
        default:
            break
        }
        
        //設置空污指數
        if let airQuality:AirQuality = runInfo.ownAirQuality {
            
            if airQuality.aQI != 0 {
                 aQILabel.text = "\(Int(airQuality.aQI))"
            } else {
                aQILabel.text = "--"
            }
        } else {
            aQILabel.text = "--"
        }
    }
}
