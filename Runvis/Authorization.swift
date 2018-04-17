//
//  Authorization.swift
//  Runvis
//
//  Created by 吳政緯 on 2017/5/28.
//  Copyright © 2017年 吳政緯. All rights reserved.
//

import UIKit
import CoreLocation
import Photos

class Authorization {
    
    static let check = Authorization()
    private init() {}
    
    fileprivate let locationManager = CLLocationManager()
    
    
    func Gps(completion: (UIViewController) -> Void) -> Bool {
        
        switch CLLocationManager.authorizationStatus() {
            
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        // ...
        case .notDetermined:
            self.locationManager.requestAlwaysAuthorization()
        case  .restricted, .denied:
            let alertController = UIAlertController(
                title: "取用 GPS 被拒絕",
                message: "點擊\"設定\"，開啟權限",
                preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            let openAction = UIAlertAction(title: "設定", style: .default) { (action) in
                if let url = URL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(openAction)
            completion(alertController)
            
        }
        return false
    }
    
    func photoLibrary(completion:@escaping (UIViewController?) -> Void) -> Bool {
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
            
        case .authorized:
            return true
            
        case .notDetermined:
            return true
        
        default: ()
        DispatchQueue.main.async(execute: { () -> Void in
            let alertController = UIAlertController(title: "圖片庫未開啟權限",
                                                    message: "點擊\"設定\"，開啟權限", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title:"取消", style: .cancel, handler:nil)
            
            let settingsAction = UIAlertAction(title:"設定", style: .default, handler: {
                (action) -> Void in
                let url = URL(string: UIApplicationOpenSettingsURLString)
                if let url = url, UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url, options: [:],
                                                  completionHandler: {
                                                    (success) in
                        })
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)
            
            completion(alertController)
        })
        }
        return false
    }
    
}
