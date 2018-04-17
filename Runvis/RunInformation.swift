
import Foundation
import CoreData

public class RunInformation: NSManagedObject {
    
    @NSManaged var duration: NSNumber
    @NSManaged var distance: NSNumber
    @NSManaged var timestamp: Date
    @NSManaged var ownLocations: NSOrderedSet
    
//    @NSManaged var bMI: NSNumber?
    @NSManaged var height:NSNumber?
    @NSManaged var weight:NSNumber?
    @NSManaged var burnedCalories:NSNumber?
    @NSManaged var remark:String?
    @NSManaged var title:String?
    @NSManaged var physicalCondition:Int16
    @NSManaged var ownAirQuality:AirQuality?
    @NSManaged var mapImage:Data?
}
