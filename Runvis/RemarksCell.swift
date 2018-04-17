//
//  remarksCell.swift
//  Runvis
//
//  Created by 吳政緯 on 2017/5/24.
//  Copyright © 2017年 吳政緯. All rights reserved.
//

import UIKit
import CoreData

class RemarksCell: UITableViewCell {
    
    @IBOutlet weak var textView: UITextView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension RemarksCell{

    internal func setupValue(by runningInfo:RunInformation) {
        if let remark = runningInfo.remark {
                textView.text = remark
                textView.textColor = .black
        } else {
            textView.text = "新增備註"
            textView.textColor = UIColor.purpleyGrey
        }
    }
}



