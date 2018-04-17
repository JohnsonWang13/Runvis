//
//  ProfilePhotoCell.swift
//  Runvis
//
//  Created by 吳政緯 on 2017/5/25.
//  Copyright © 2017年 吳政緯. All rights reserved.
//

import UIKit

protocol ProfilePhotoCellDelegate {
    func selectPhotofromAlbum(sender:UIButton)
}

class ProfilePhotoCell: UITableViewCell {
    
    var delegate:ProfilePhotoCellDelegate? = nil
    
    @IBOutlet weak var profilePhotoButton: UIButton!

    override func layoutSubviews(){
        
        profilePhotoButton.addTarget(self,action: #selector(self.selectPhoto(sender:)),for: .touchUpInside)
        profilePhotoButton.imageView?.contentMode = .scaleAspectFill
        profilePhotoButton.layer.masksToBounds = false
        profilePhotoButton.layer.cornerRadius = profilePhotoButton.frame.height/2
        profilePhotoButton.clipsToBounds = true
    }

    func selectPhoto(sender:UIButton){
        
        self.delegate?.selectPhotofromAlbum(sender: sender)
    }
}

