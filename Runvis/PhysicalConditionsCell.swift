//
//  PhysicalConditionsCell.swift
//  Runvis
//
//  Created by 吳政緯 on 2017/5/23.
//  Copyright © 2017年 吳政緯. All rights reserved.
//

import UIKit
import CoreData
class PhysicalConditionsCell: UITableViewCell {
    
    @IBOutlet weak var badFaceBotton: UIButton!
    @IBOutlet weak var normalButton: UIButton!
    @IBOutlet weak var smileButton: UIButton!
    @IBOutlet weak var greatButton: UIButton!

//    let physicalConditionsegmentedControl = UISegmentedControl(
//        items: ["無","差","普通","良好","很棒"])
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension PhysicalConditionsCell{
    
    internal func setupValue(by runInfo:RunInformation){
        
        let selectedButton:Int = Int(runInfo.physicalCondition)
        switch selectedButton {
        case 0:
            
            badFaceBotton.isSelected = false
            normalButton.isSelected  = false
            smileButton.isSelected  = false
            greatButton.isSelected  = false
            print("0")
        case 1:
            
            badFaceBotton.isSelected = true
            normalButton.isSelected  = false
            smileButton.isSelected  = false
            greatButton.isSelected  = false
             print("1")
        case 2:
            
            badFaceBotton.isSelected = false
            normalButton.isSelected  = true
            smileButton.isSelected  = false
            greatButton.isSelected  = false
            print("2")
        case 3:
            
            badFaceBotton.isSelected = false
            normalButton.isSelected  = false
            smileButton.isSelected  = true
            greatButton.isSelected  = false
             print("3")
        case 4:
            
            badFaceBotton.isSelected = false
            normalButton.isSelected  = false
            smileButton.isSelected  = false
            greatButton.isSelected  = true
             print("4")
        default:
            break
        }
    }
}
