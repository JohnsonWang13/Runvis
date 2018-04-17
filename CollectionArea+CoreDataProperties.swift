//
//  CollectionArea+CoreDataProperties.swift
//  Runvis
//
//  Created by 吳政緯 on 2017/5/22.
//  Copyright © 2017年 吳政緯. All rights reserved.
//

import Foundation
import CoreData


extension CollectionArea {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CollectionArea> {
        return NSFetchRequest<CollectionArea>(entityName: "CollectionArea")
    }

    @NSManaged public var city: String
    @NSManaged public var district: String
    @NSManaged public var sequence: Int16
}
