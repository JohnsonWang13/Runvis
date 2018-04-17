//
//  AppDelegate.swift
//  RunRunRun
//
//  Created by 吳政緯 on 2017/5/14.
//  Copyright © 2017年 吳政緯. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var delegate: NewRunDelegate?
    
    private let locationManager = CLLocationManager()
    internal var nearAreaAirQuality:AirQuality? = nil
    internal var allMonitoringStations:[MonitoringStation] = []
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        createUserInfo()
        setupNavigationBar()
        UIApplication.shared.statusBarStyle = .lightContent
        
        setupLocationManager()
        requestMonitoringStations()
        return true
    }
    
    //設置好LocationManager 並請求位置
    private func setupLocationManager() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation() //請求位置
        
    }
    
    //請求所有間測站點並儲存在self.allMonitoringStations
    private func requestMonitoringStations() {
        
        
        Request.getData.monitoringStations { datas in
            
            let monitoringStations:[MonitoringStation]  = Transform.data.toMonitoringStation(from: datas)
            //            print(monitoringStations)
            DispatchQueue.main.async {
                self.allMonitoringStations  = monitoringStations
            }
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Runvis")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                //                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //   方便索取的porperty
    static var app:AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    static var persistentContainer:NSPersistentContainer{
        return app.persistentContainer
    }
    
    static var context:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    //設置NavigationBar顏色和字型
    private func setupNavigationBar() {
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = .white
        navigationBarAppearace.barTintColor = .darkishBlue
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white,NSFontAttributeName: UIFont(name: "PingFangTC-Regular", size: 18)!]
    }
    
    //初始化UserInfo
    func createUserInfo(){
        if (try! AppDelegate.context.fetch(UserInfo.fetchRequest())).isEmpty {
            
            _ = NSEntityDescription.insertNewObject(forEntityName: "UserInfo", into: AppDelegate.context) as! UserInfo
//            print("初始化UserInfo")
            saveContext()
        }
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension AppDelegate:CLLocationManagerDelegate {
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0]
        let long = userLocation.coordinate.longitude
        let lat = userLocation.coordinate.latitude
        
        //每次requestLocation之後去請求附近地區天氣狀況
        self.getNearAreaAirQualityData(currentLocation: userLocation.coordinate)
        print(long, lat,"AppDelegate")
    }
    
    //Failed to find user's location
    internal  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    
    //request附近地區空污及天氣狀況
    private func getNearAreaAirQualityData(currentLocation:CLLocationCoordinate2D) {
        
        //        self.nearAreaIndicatorView.startAnimating()
        var location:[String:Double] = [:]
        location["Longitude"] = currentLocation.longitude
        location["Latitude"] = currentLocation.latitude
        Request.getData.nearAreaAirQuality(location:location){ data in
            if let data = data{
                
                if let airQuality:AirQuality = Transform.data.toNearByAirQuality(from: data){
                    DispatchQueue.main.async {
                        guard self.nearAreaAirQuality == nil else{return}
                        self.nearAreaAirQuality = airQuality
                        self.delegate?.aqi()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.nearAreaAirQuality = nil
                }
            }
        }
    }
}

