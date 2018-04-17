//
//  RunningRecordCell.swift
//  Runvis
//
//  Created by 吳政緯 on 2017/5/23.
//  Copyright © 2017年 吳政緯. All rights reserved.
//

import UIKit
import CoreData
class RunningRecordCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var airQuailty: UILabel!
    @IBOutlet weak var runningRouteImageView: UIImageView!{
        didSet{
            runningRouteImageView.contentMode = .scaleToFill
            runningRouteImageView.layer.masksToBounds = false
            runningRouteImageView.layer.cornerRadius = 10
            runningRouteImageView.clipsToBounds = true
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

extension RunningRecordCell{
    
    internal func setValue(by runningInfo: RunInformation){
        
        //設置標題
        if let title = runningInfo.title {
            titleLabel.text = title
            
        } else {
            titleLabel.text = "某一次的路跑"
        }
        //設置跑步日期
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/M/dd日"
        dateLabel.text = dateFormatter.string(from: runningInfo.timestamp)  ///可能有問題
        
        //設置跑步距離
        let distance = runningInfo.distance.doubleValue
        distanceLabel.text = distance.toKmDisplay() + "公里"
        
        //設置跑了多久
        let duration = runningInfo.duration.intValue
        durationLabel.text  = duration.timeDisplay()
        
        //設置空氣狀況
        if let airQuilty = runningInfo.ownAirQuality {
            if  airQuilty.aQI != 0{    /////篩選條件可能會改
                let aQI = airQuilty.aQI
                let description:String = AirPollutant.aQI(aQI).airQuality
                airQuailty.text = "空氣況狀 \(description)"
            } else {
                airQuailty.text = "空氣狀況 --"
            }
        } else {
            airQuailty.text = "空氣狀況 --"
        }
        
        //設置跑步路徑圖片
        if let data = runningInfo.mapImage {
            runningRouteImageView.image = UIImage(data: data)
        } else {
            runningRouteImageView.image = nil
            runningRouteImageView.backgroundColor = UIColor(red: 107/255, green: 108/255, blue: 109/255, alpha: 1)
        }
    }
}
