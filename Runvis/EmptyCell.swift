//
//  EmptyCell.swift
//  Runvis
//
//  Created by 吳政緯 on 2017/5/25.
//  Copyright © 2017年 吳政緯. All rights reserved.
//

import UIKit

class EmptyCell: UITableViewCell {
    
    @IBOutlet weak var backGroundView: UIView!
    
    override func layoutSubviews() {
        
        backGroundView.layer.cornerRadius = 4
    }
}
