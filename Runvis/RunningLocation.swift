
import Foundation
import CoreData

class RunningLocations: NSManagedObject {
    
    @NSManaged var timestamp: Date
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var runInformation: NSManagedObject

}
