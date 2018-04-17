//
//  EachRunningRecordCell.swift
//  Runvis
//
//  Created by 吳政緯 on 2017/5/23.
//  Copyright © 2017年 吳政緯. All rights reserved.
//

import UIKit
import CoreData

class UserBasicInfoCell: UITableViewCell {
    @IBOutlet weak var weightValueLabel: UILabel!
    @IBOutlet weak var heightValueLabel: UILabel!
    @IBOutlet weak var bMIValueLabel: UILabel!
}

extension UserBasicInfoCell {
    
    func setupValue(by runningInfo:RunInformation) {
        
        //體重
        if let weight =  runningInfo.weight {
            
            let decimal = weight.doubleValue * 10
            weightValueLabel.text = "\(round(decimal) / 10)"
        } else {
            weightValueLabel.text  = "0"
        }
        //身高
        if let  height =  runningInfo.height {
            
            let decimal = height.doubleValue * 10
            heightValueLabel.text = "\(round(decimal) / 10)"
        } else {
            heightValueLabel.text  = "0"
        }
        
        //BMI
        if let weight =  runningInfo.weight, let  height =  runningInfo.height {
            let height = height.doubleValue / 100   //單位換算成公尺
            let weight = weight.doubleValue
            let bMI = weight / (height * height)
            let decimal = bMI * 10
            bMIValueLabel.text = "\(round(decimal) / 10)"
        } else {
            bMIValueLabel.text = "0"
            
        }
    }
}



