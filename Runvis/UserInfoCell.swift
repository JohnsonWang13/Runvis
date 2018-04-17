//
//  UserInfoCell.swift
//  RunRunRun
//
//  Created by 吳政緯 on 2017/5/15.
//  Copyright © 2017年 吳政緯. All rights reserved.
//

import UIKit
import CoreData
class UserInfoCell: UITableViewCell {
    
    lazy var userInfo:UserInfo = {
        
        if let userInfo = CoreDataUtils.queryUserInfo() {
            return userInfo
        } else {
            //萬一APP初始化失敗，才會執行這行
            (UIApplication.shared.delegate as! AppDelegate).createUserInfo()
            return CoreDataUtils.queryUserInfo()!
        }
    }()
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightValueLabel: UILabel!
    @IBOutlet weak var heightValueLabel: UILabel!
    @IBOutlet weak var bMIValueLabel: UILabel!
    @IBOutlet weak var activityRecord: UILabel!
    @IBOutlet weak var totalDistanceValueLabel: UILabel!
    @IBOutlet weak var totalTimesLabel: UILabel!
    @IBOutlet weak var averageSpeedValueLabel: UILabel!
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var activityRecordBackGroundColorView: UIView!
    
    override func layoutSubviews() {
        
        profilePhoto.layer.masksToBounds = false
        profilePhoto.layer.cornerRadius = profilePhoto.frame.height/2
        profilePhoto.clipsToBounds = true
        
        activityRecord.textColor = .purpleyGrey
        
        backGroundView.backgroundColor = UIColor(white: 1, alpha: 0.5)
    }
}

extension UserInfoCell {
    
    internal func setValue( userInfo:UserInfo){
        
        if let nsData = userInfo.profilePhoto {
            
            let data = nsData as Data
            let photo = UIImage(data: data)
            profilePhoto.contentMode = .scaleAspectFill
            profilePhoto.image = photo
        } else {
            
            profilePhoto.contentMode = .center
            profilePhoto.image = #imageLiteral(resourceName: "photoCamera")
            profilePhoto.backgroundColor = .white
        }
        
        if let name = userInfo.name {
            nameLabel.text = name
        } else {
            nameLabel.text = "name"
        }
        
        if userInfo.height != 0 {
            let height = userInfo.height
            let decimal = height * 10
            heightValueLabel.text = "\(round(decimal) / 10)"
        } else {
            heightValueLabel.text = "--"
        }
        
        if userInfo.weight != 0 {
            let weight = userInfo.weight
            let decimal = weight * 10
            weightValueLabel.text = "\(round(decimal) / 10)"
        } else {
            weightValueLabel.text = "--"
        }
        
        if userInfo.height != 0 && userInfo.weight != 0 {
            let height = userInfo.height / 100   //單位換算成公尺
            let weight = userInfo.weight
            let bMI = weight / (height * height)
            let decimal = bMI * 10
            bMIValueLabel.text = "\(round(decimal) / 10)"
        } else {
            bMIValueLabel.text = "--"
        }
    }
    
    internal func setValue( runInformations:[RunInformation]){
        
        //檢查 runInformations 是否為空
        guard runInformations != [] else{
            print("runInformation是空的")
            return
        }
        
        totalTimesLabel.text = "\(runInformations.count)"
        
        var totalDistance = 0.0  //單位Km
        var totalDuration = 0
        for  runInformation in runInformations {
            let eachDistance = runInformation.distance.doubleValue
            totalDistance += eachDistance
            let eachDuration = runInformation.duration.intValue
            totalDuration += eachDuration
        }
        
        totalDistanceValueLabel.text = "\(totalDistance.toKmDisplay())km"
        let averageSpeed = (totalDistance/Double(totalDuration) * 3.6 * 100).rounded()/100

        averageSpeedValueLabel.text = "\(averageSpeed.timePerKmDisplay())" //平均速度
    }
}
