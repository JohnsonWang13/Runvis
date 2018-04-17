//
//  CoreDataUtils.swift
//  RunRunRun
//
//  Created by 吳政緯 on 2017/5/14.
//  Copyright © 2017年 吳政緯. All rights reserved.
//

import UIKit
import CoreData


class  CoreDataUtils {
    static let app = UIApplication.shared.delegate as! AppDelegate
    static let context = AppDelegate.context
    static let persistentedContainer = AppDelegate.persistentContainer
    
    
    class func queryUserInfo() -> UserInfo? {
        do {
            //單純的fetchRequest所抓出來的物件型別為[Any]
            let allUsers = try CoreDataUtils.context.fetch(UserInfo.fetchRequest()) as! [UserInfo]
            return allUsers.first!
        }catch{
            print(error,"嘗試讀取UserInfo(失敗")
        }
        print("獲取不到UserInfo")
        return nil  //99.99％不會發生
    }
    
    
    class func queryRunInfomation() -> [RunInformation] {
        do {
            //單純的fetchRequest所抓出來的物件型別為[Any]
            var  runInfomation = try CoreDataUtils.context.fetch(RunInformation.fetchRequest()) as! [RunInformation]
            runInfomation = runInfomation.sorted {$0.0.timestamp >  $0.1.timestamp}  //可優化，因為CoreData資料排序應該用preditor還是啥的
            return runInfomation
        }catch{
            print(error)
        }
        return []
    }
    
    class func queryCollectionArea() -> [CollectionArea]{
        
        do {
            //單純的fetchRequest所抓出來的物件型別為[Any]
            var collectionArea = try CoreDataUtils.context.fetch(CollectionArea.fetchRequest()) as! [CollectionArea]
            collectionArea = collectionArea.sorted {$0.0.sequence < $0.1.sequence}  //可優化
            return collectionArea
        }catch{
            print(error)
        }
        return []
    
    }
    
   
    
    //創造一個空的Entity，用於暫時裝資料，並沒有要儲存
    class func createEmptyEntity() -> RunInformation {
        let entitiyDescription = NSEntityDescription.entity(forEntityName: "RunInformation", in: context)
        let entity = RunInformation.init(entity: entitiyDescription!, insertInto: nil)
        entity.timestamp = Date()
        return entity
    }
    class func createEmptyEntity() -> CollectionArea {
        let entitiyDescription = NSEntityDescription.entity(forEntityName: "CollectionArea", in: context)
        let entity = CollectionArea.init(entity: entitiyDescription!, insertInto: nil)
        return entity
    }
    class func createEmptyEntity() -> AirQuality {
        let entitiyDescription = NSEntityDescription.entity(forEntityName: "AirQuality", in: context)
        let entity = AirQuality.init(entity: entitiyDescription!, insertInto: nil)
        return entity
    }
}

