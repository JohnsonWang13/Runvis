//
//  RunRequestAPI.swift
//  Runvis
//
//  Created by 吳政緯 on 2017/5/15.
//  Copyright © 2017年 吳政緯. All rights reserved.
//

import UIKit
import CoreData

enum HTTPMethod {
    case post
    case get
}

class Api {
    
    static let request = Api()
    private init() {}
    
    func getData(from url: String, method: HTTPMethod, parameter: [String: Any]? ,completion: @escaping  (Data?) -> Void) {
        
        var request = URLRequest(url: URL(string: url)!)
        
        if method == .post {
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: parameter!){
                
                request.httpMethod = "POST"
                request.httpBody = jsonData
                request.addValue("application/json", forHTTPHeaderField:"Content-Type")
            }
        }
        
        // If have JSON，insert json data to the request
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) {(data, response, error) -> Void
            in
            
            if error != nil{
                print("伺服器傳回Error")
                completion(nil)
            }
            else {
                
                // check for httpStatus
                if let httpStatus = response as? HTTPURLResponse{
                    
                    switch httpStatus.statusCode {
                        
                    case 200,400:
                        completion(data)
                    default:
                        
                        print("statusCode should be 200 or 400, but is \(httpStatus.statusCode)")
                        print("response = \(String(describing: response))")
                        completion(nil)
                    }
                }
            }
        }
        task.resume()
    }
}


class Request {
    
    static let getData = Request()
    private init() {}
    
    //抓取收藏地區的空污指數和天氣狀況
    func airQuality(by data:CollectionArea, completion: @escaping  (Data?) -> Void) {
        var parameters:[String:String] = [:]
        parameters["city"] = data.city
        parameters["district"] = data.district
        Api.request.getData(from: ServerURL.collectionAreas, method: .post, parameter: parameters, completion: completion)
    }
    
    //抓取全台灣所有間測站地點
    func monitoringStations(completion: @escaping  (Data?) -> Void){
        Api.request.getData(from: ServerURL.allMonitoringStations, method: .get, parameter: nil, completion: completion)
    }
    
    //抓取附附近地區的空氣資訊
    func nearAreaAirQuality(location: [String:Double] ,completion: @escaping  (Data?) -> Void) {
        Api.request.getData(from: ServerURL.nearAreaAirQuality, method: .post, parameter: location, completion: completion)
    }
    
    //抓取附近運動地點
    func sportPlace(location: [String:Double], completion: @escaping  (Data?) -> Void) {
        Api.request.getData(from: ServerURL.sportPlace, method: .post, parameter: location, completion: completion)
    }
}


//把request下來的Data轉換成各個Model
class Transform {
    
    static let data = Transform()
    private init() {}
    
    func toMonitoringStation(from data:Data?) -> [CollectionArea] {
        if let data = data {
            do {
                var entitys:[CollectionArea] = []
                let jsons = try JSONSerialization.jsonObject(with: data, options: []) as! NSArray
                
                for json in jsons {
                    if  let json = json as? NSDictionary{
                        let city =  json["city"] as? String ?? "缺縣市"
                        let districts = json["district"] as? [String] ?? []
                        for  district in districts{
                            let entity:CollectionArea = CoreDataUtils.createEmptyEntity()
                            entity.city = city
                            entity.district = district
                            entitys.append(entity)
                        }
                    }
                }
                return entitys
            } catch {
                print(error,"轉換資料失敗")
            }
        }
        return []
    }
    
    
    func toAirQuality(from data:Data?) -> AirQuality? {
        
        if let data = data {
            do {
                let jsons = try JSONSerialization.jsonObject(with: data, options: []) as! NSArray
//                print(jsons)
                
                for json in jsons {
                    if  let json = json as? NSDictionary{
//                        print(json)
                        let entity:AirQuality = CoreDataUtils.createEmptyEntity()
                        entity.district = json["SiteName"] as? String ?? "缺"
                        
                        entity.city = json["County"] as? String ?? "缺"
                        entity.aQI = (json["AQI"] as? NSString)?.doubleValue ?? 0
                        entity.sO2 = (json["SO2"] as? NSString)?.doubleValue ?? 0
                        entity.cO = (json["CO_8hr"] as? NSString)?.doubleValue ?? 0
                        entity.o3 = (json["O3_8hr"] as? NSString)?.doubleValue ?? 0
                        entity.pM10 = (json["PM10"] as? NSString)?.doubleValue ?? 0
                        entity.pM25 = (json["PM25"] as? NSString)?.doubleValue ?? 0
                        entity.nO2 = (json["NO2"] as? NSString)?.doubleValue ?? 0
                        entity.ultraviolet = (json["UVI"] as? NSString)?.doubleValue ?? 0
                        
                        //時間判斷式
                        if let publishTime = json["PublishTime"] as? String{
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                            let date = dateFormatter.date(from: publishTime)
                            if date != nil{
                                entity.date = date! as NSDate
                            }
                        }
                        //判斷降雨率 天氣狀況 以及 溫度
                        if let weather = json["weather"] as? NSDictionary{
                            let rain = weather["rain"] as? String ?? "缺"
                            entity.precipitation = Double(rain[0..<2]) ?? 0
                            let temp = weather["temp"]  as? String ?? "缺"
                            entity.temperature = Double(temp[0..<2]) ?? 0
                            entity.weather = weather["status"] as? String ?? nil
                        }else{
                            entity.temperature = 0
                            entity.precipitation = -1
                            entity.weather =  nil
                        }
                        return entity
                    }
                }
                return nil
            } catch {
                print("AQI Error: ", error)
            }
        }
        return nil
    }
    
    
    func toNearByAirQuality(from data:Data?) -> AirQuality? {
        
        if let data = data {
            do {
                if  let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary{
//                    print(json)
                    let entity:AirQuality = CoreDataUtils.createEmptyEntity()
                    entity.district = json["SiteName"] as? String ?? "缺"
                    
                    entity.city = json["County"] as? String ?? "缺"
                    entity.aQI = (json["AQI"] as? NSString)?.doubleValue ?? 0
                    entity.sO2 = (json["SO2"] as? NSString)?.doubleValue ?? 0
                    entity.cO = (json["CO_8hr"] as? NSString)?.doubleValue ?? 0
                    entity.o3 = (json["O3_8hr"] as? NSString)?.doubleValue ?? 0
                    entity.pM10 = (json["PM10"] as? NSString)?.doubleValue ?? 0
                    entity.pM25 = (json["PM2.5"] as? NSString)?.doubleValue ?? 0
                    entity.nO2 = (json["NO2"] as? NSString)?.doubleValue ?? 0
                    entity.ultraviolet = (json["UVI"] as? NSString)?.doubleValue ?? 0
                    
                    //時間判斷式
                    if let publishTime = json["PublishTime"] as? String{
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                        let date = dateFormatter.date(from: publishTime)
                        if date != nil{
                            entity.date = date! as NSDate
                        }
                    }
                    
                    //判斷降雨率 天氣狀況 以及 溫度
                    if let weather = json["weather"] as? NSDictionary {
                        let rain = weather["rain"] as? String ?? "缺"
                        entity.precipitation = Double(rain[0..<2]) ?? 0
                        let temp = weather["temp"]  as? String ?? "缺"
                        entity.temperature = Double(temp[0..<2]) ?? 0
                        entity.weather = weather["status"] as? String ?? nil
                    }else{
                        entity.temperature = 0
                        entity.precipitation = -1
                        entity.weather =  nil
                    }
                    
                    return entity
                }
                
                return nil
            } catch {
                print("Error: ", error)
            }
        }
        return nil
    }
    
    
    func toSportPlaceCoordinate(from data: Data?) -> [SportLocation]? {
        
        //        result: [(location), (location)]
        
        if let data = data {
            do {
                
                if let jsons = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String:AnyObject] {
                    
                    var sportLocations = [SportLocation]()
                    
                    if let locations = jsons["result"] as? [[String: Any]]{
                        
                        for location in locations {
                            
                            var sportLocation = SportLocation()
                            
                            if let name = location["name"] as? String, let address = location["address"] as? String, let latitude = location["lat"] as? Double, let longitude = location["lon"] as? Double {
                                
//                                print(name, address, latitude, longitude)
                                sportLocation.name = name
                                sportLocation.address = address
                                sportLocation.latitude = latitude
                                sportLocation.longitude = longitude
                                
                                sportLocations.append(sportLocation)
                            }
                        }
                    }
                    return sportLocations
                }
            } catch {
                print("Error: ", error)
            }
        }
        return nil
    }
    
    //    func transformData(from data:Data?) -> [RunInfomation] {
    //
    //        return []
    //    }
}



