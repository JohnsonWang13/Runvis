//
//  APIModel.swift
//  Runvis
//
//  Created by 吳政緯 on 2017/5/15.
//  Copyright © 2017年 吳政緯. All rights reserved.
//

import Foundation


typealias APIindex = String

struct ServerURL {
    
//    static let heroku = "https://boiling-citadel-47122.herokuapp.com/allcity"
//    static let allMonitoringStations = "https://boiling-citadel-47122.herokuapp.com/allcity"
//    static let collectionAreas = "https://boiling-citadel-47122.herokuapp.com/getcity"
//    static let nearAreaAirQuality = "https://boiling-citadel-47122.herokuapp.com/location"
//    static let sportPlace = "https://boiling-citadel-47122.herokuapp.com/sportPlace"
    
//    static let heroku = "http://13.113.93.111:3000/allcity"
//    static let allMonitoringStations = "http://13.113.93.111:3000/allcity"
//    static let collectionAreas = "http://13.113.93.111:3000/getcity"
//    static let nearAreaAirQuality = "http://13.113.93.111:3000/location"
//    static let sportPlace = "http://13.113.93.111:3000/sportPlace"
    
        static let heroku = "https://devche.com/runrunrun/allcity"
        static let allMonitoringStations = "https://devche.com/runrunrun/allcity"
        static let collectionAreas = "https://devche.com/runrunrun/getcity"
        static let nearAreaAirQuality = "https://devche.com/runrunrun/location"
        static let sportPlace = "https://devche.com/runrunrun/sportPlace"


}



//enum APIRouter {
//    
//    case performance(IndexPerformance)
//    case group(IndexGroup)
//    case member(IndexMember)
//    
//    var index: String {
//        get {
//            switch self {
//            case .member(_):
//                return "/member/"
//            case .group(_):
//                return "/group/"
//            case .performance(_):
//                return "/showinfo/"
//            }
//        }
//    }
//    
//   
//    
//    func routing() -> URL{
//        switch self {
//        case .member(let raw):
//            return URL(string: ServerURL.heroku + index + raw.rawValue)!
//        case .group(let raw):
//            return URL(string: ServerURL.heroku + index + raw.rawValue)!
//        case .performance(let raw):
//            return URL(string: ServerURL.heroku + index + raw.rawValue)!
//        }
//    }
//}
//
//enum IndexPerformance:APIindex {
//    case all = "all"
//    case single = "/single"
//    case coordinate = "/"
//    case city = "/city"
//    case top10 = "/top10"
//    case keyword = "/findbyrelative"
//    case nearly = "/findbyDate"
//    case dateAndLocation = "/findByDateAndLocation"
//}
//
//enum IndexGroup:APIindex {
//    case all = "/all"
//    case single = "/single"
//    case coordinate = "/"
//    case city = "/city"
//    case top10 = "/top10"
//    case keyword = "/findbyrelative"
//    case nearly = "/findbyDate"
//    case dateAndLocation = "/findByDateAndLocation"
//}
//
//enum IndexMember:APIindex {
//    case all = "/all"
//    case single = "/single"
//    case coordinate = "/"
//    case city = "/city"
//    case top10 = "/top10"
//    case keyword = "/findbyrelative"
//    case nearly = "/findbyDate"
//    case dateAndLocation = "/findByDateAndLocation"
//}
