//
//  AirPollutionIndex.swift
//  Runvis
//
//  Created by 吳政緯 on 2017/5/17.
//  Copyright © 2017年 吳政緯. All rights reserved.
//

import UIKit


//空氣汙染物（AirPolutionIndex也一併寫在這）
enum AirPollutant{
    
    case pM25(Double)
    case pM10(Double)
    case o3(Double)
    case nO2(Double)
    case sO2(Double)
    case cO(Double)
    case aQI(Double)
}

extension AirPollutant {
    
    var correspodingColor:UIColor {
        get {
            let color = get(self).correspodingColor
            return color
        }
    }
    
    //各個污染物的空氣品質
    var airQuality:String {
        get {
            let description = get(self).airQualityDescription
            return description
        }
    }
    
    var runningSuggestion:String? {
        get{
            let suggestion = getRunningSuggestion(self)
            return suggestion
        }
    }
    
    var aQIImage:UIImage? {
        get{
            let image = getAQIImage(self)
            return image
        }
    }
    
    var suggestRunningTime:Int? {
        get{
            guard let time = getSuggestRunningTime() else {return 0}
            return time
        }
    }
    
}


extension AirPollutant{
    
    //得到各個空氣污染物的對應顏色和空氣品質狀況
    fileprivate func get(_ airPollutant: AirPollutant) -> (correspodingColor:UIColor,airQualityDescription:String) {
        
        switch airPollutant {
            
        case .pM25(let μg):
            switch μg {
            case 0.0..<15.5:
                return (UIColor.airQualityLevelGreen,AirQualityDescription.great.rawValue)
            case 15.5..<35.5:
                return (UIColor.airQualityLevelYellow,AirQualityDescription.good.rawValue)
            case 35.5..<54.5:
                return (UIColor.airQualityLevelOrange,AirQualityDescription.soso.rawValue)
            case 54.5..<150.5:
                return (UIColor.airQualityLevelRed,AirQualityDescription.bad.rawValue)
            case 150.5..<250.5:
                return (UIColor.airQualityLevelPurple,AirQualityDescription.worse.rawValue)
            case 250.5..<600:
                return (UIColor.airQualityLevelCrimson,AirQualityDescription.awful.rawValue)
            default:
                return  (UIColor.clear,"--")
            }
            
        case .pM10(let μg):
            
            switch μg {
            case 0.0..<55:
                return (UIColor.airQualityLevelGreen,AirQualityDescription.great.rawValue)
            case 55..<126:
                return (UIColor.airQualityLevelYellow,AirQualityDescription.good.rawValue)
            case 126..<255:
                return (UIColor.airQualityLevelOrange,AirQualityDescription.soso.rawValue)
            case 255..<355:
                return (UIColor.airQualityLevelRed,AirQualityDescription.bad.rawValue)
            case 355..<425:
                return (UIColor.airQualityLevelPurple,AirQualityDescription.worse.rawValue)
            case 425..<700:
                return (UIColor.airQualityLevelCrimson,AirQualityDescription.awful.rawValue)
            default:
                return  (UIColor.clear,"--")
            }
            
        case .o3(let ppb):
            switch ppb {
            case 0.0..<55:
                return (UIColor.airQualityLevelGreen,AirQualityDescription.great.rawValue)
            case 55..<71:
                return (UIColor.airQualityLevelYellow,AirQualityDescription.good.rawValue)
            case 71..<86:
                return (UIColor.airQualityLevelOrange,AirQualityDescription.soso.rawValue)
            case 86..<106:
                return (UIColor.airQualityLevelRed,AirQualityDescription.bad.rawValue)
            case 106..<201:
                return (UIColor.airQualityLevelPurple,AirQualityDescription.worse.rawValue)
            case 201..<700:
                return (UIColor.airQualityLevelCrimson,AirQualityDescription.awful.rawValue)
            default:
                return  (UIColor.clear,"--")
            }
            
        case .nO2(let ppb):
            switch ppb {
            case 0.0..<54:
                return (UIColor.airQualityLevelGreen,AirQualityDescription.great.rawValue)
            case 54..<101:
                return (UIColor.airQualityLevelYellow,AirQualityDescription.good.rawValue)
            case 101..<361:
                return (UIColor.airQualityLevelOrange,AirQualityDescription.soso.rawValue)
            case 361..<650:
                return (UIColor.airQualityLevelRed,AirQualityDescription.bad.rawValue)
            case 650..<1250:
                return (UIColor.airQualityLevelPurple,AirQualityDescription.worse.rawValue)
            case 1250..<2100:
                return  (UIColor.airQualityLevelCrimson,AirQualityDescription.awful.rawValue)
            default:
                return  (UIColor.clear,"--")
            }
            
        case .sO2(let ppb):
            switch ppb {
            case 0.0..<36:
                return (UIColor.airQualityLevelGreen,AirQualityDescription.great.rawValue)
            case 36..<76:
                return (UIColor.airQualityLevelYellow,AirQualityDescription.good.rawValue)
            case 76..<186:
                return (UIColor.airQualityLevelOrange,AirQualityDescription.soso.rawValue)
            case 186..<305:
                return (UIColor.airQualityLevelRed,AirQualityDescription.bad.rawValue)
            case 305..<605:
                return (UIColor.airQualityLevelPurple,AirQualityDescription.worse.rawValue)
            case 605..<1050:
                return (UIColor.airQualityLevelCrimson,AirQualityDescription.awful.rawValue)
            default:
                return  (UIColor.clear,"--")
            }
            
        case .cO(let ppm):
            switch ppm {
            case 0.0..<4.5:
                return (UIColor.airQualityLevelGreen,AirQualityDescription.great.rawValue)
            case 4.5..<9.5:
                return (UIColor.airQualityLevelYellow,AirQualityDescription.good.rawValue)
            case 9.5..<12.5:
                return (UIColor.airQualityLevelOrange,AirQualityDescription.soso.rawValue)
            case 12.5..<15.5:
                return (UIColor.airQualityLevelRed,AirQualityDescription.bad.rawValue)
            case 15.5..<30.5:
                return (UIColor.airQualityLevelPurple,AirQualityDescription.worse.rawValue)
            case 30.5..<55:
                return (UIColor.airQualityLevelCrimson,AirQualityDescription.awful.rawValue)
            default:
                return  (UIColor.clear,"--")
            }
            
        case .aQI(let index):
            switch index {
            case 0.0..<51:
                return (UIColor.airQualityLevelGreen,AirQualityDescription.great.rawValue)
            case 51..<101:
                return (UIColor.airQualityLevelYellow,AirQualityDescription.good.rawValue)
            case 101..<151:
                return (UIColor.airQualityLevelOrange,AirQualityDescription.soso.rawValue)
            case 151..<201:
                return (UIColor.airQualityLevelRed,AirQualityDescription.bad.rawValue)
            case 201..<301:
                return (UIColor.airQualityLevelPurple,AirQualityDescription.worse.rawValue)
            case 301..<500:
                return (UIColor.airQualityLevelCrimson,AirQualityDescription.awful.rawValue)
            default:
                return  (UIColor.clear,"--")
            }
        }
    }
    
    fileprivate func getRunningSuggestion(_ aQIindex:AirPollutant)->String?{
        
        switch  aQIindex {
        case .aQI(let index):
            
            switch index {
            case 0.0..<51:
                return "空氣質量很棒，有時間就出門走走吧，可以進行任何戶外活動噢～"
            case 51..<101:
                return "空氣質量不錯，可正常戶外活動，特殊敏感族群應注意可能產生咳嗽或呼吸急促症狀。"
            case 101..<151:
                return "敏感性族群應減少體力消耗與外出，一般民眾仍可進行戶外活動，但建議避免長時間劇烈運動。"
            case 151..<201:
                return "敏感性族群應減少體力消耗與外出，進行戶外活動時應增加休息時間，避免長時間劇烈運動。"
            case 201..<301:
                return "敏感性族群、孩童及老年人應留在室內並減少體力消耗，必要外出應配戴口罩，盡量漸少在外時間。"
            case 301..<500:
                return "應避免戶外活動，室內應緊閉門窗，外出應配戴口罩等防護用具，可以在家或室內運動場做運動。"
            default:
                return "看來AQI遺失了，還是在家裡下棋吧！"
            }
        default:
            return nil
        }
    }
    
    fileprivate func getAQIImage(_ image:AirPollutant)-> UIImage?{
        
        switch  image {
        case .aQI(let index):
            switch index {
            case 0.0..<51:
                return #imageLiteral(resourceName: "runShoe")
            case 51..<101:
                return #imageLiteral(resourceName: "kite")
            case 101..<151:
                return #imageLiteral(resourceName: "bike")
            case 151..<201:
                return #imageLiteral(resourceName: "spinningBike")
            case 201..<301:
                return #imageLiteral(resourceName: "chess")
            case 250.5..<600:
                return #imageLiteral(resourceName: "gasMasks")
            default:
                return #imageLiteral(resourceName: "spinningBike")
            }
        default:
            return nil
        }
    }
    
    //Double單位 秒
   fileprivate func getSuggestRunningTime()->Int? {
        
        switch self {
        case .aQI(let index):
            
            switch index {
            case 0.0..<50:
                return 0
            case 50..<65:
                return 90 * 60
            case 65..<80:
                return 60 * 60
            case 80..<100:
                return 45 * 60
            case 100..<150:
                return 30 * 60
            case 150..<200:
                return 15 * 60
            default:
                return  0
            }
//            switch index {
//            case 0.0..<20:
//                return 0
//            case 20..<25:
//                return 120 * 60
//            case 25..<30:
//                return 75 * 60
//            case 30..<35:
//                return 60 * 60
//            case 35..<40:
//                return 45 * 60
//            case 40..<50:
//                return 30 * 60
//            case 50..<75:
//                return 30 * 60
//            case 75..<110:
//                return 15 * 60
//            default:
//                return  0
//            }
        default:
            return nil
            
        }
    }
}
