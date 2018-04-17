//
//  WeatherConditionDescription.swift
//  Runvis
//
//  Created by 吳政緯 on 2017/5/30.
//  Copyright © 2017年 吳政緯. All rights reserved.
//

import UIKit



enum WeatherConditionDescription:String{
    
    case mostlyClear = "晴時多雲"
    case rainning = "下雨"
    case sunny = "晴天"
    case sunnyRain = "短暫陣雨"
    case thunderCloud = "雷雲"
    case thunderRain =  "雷雨"
}

extension WeatherConditionDescription{
    
    var weatherImage:UIImage{
        get {
            let image = getWeatherImage()
            return image
        }
    }
    var weatherBlackImage:UIImage{
        get {
            let image = getWeatherBlackImage()
            return image
        }
    }

}

extension WeatherConditionDescription {
    
    func getWeatherImage() ->UIImage{
        switch self {
        case .mostlyClear:
            return #imageLiteral(resourceName: "mostlyClear")
        case .rainning:
            return #imageLiteral(resourceName: "rainning")
        case .sunny:
            return #imageLiteral(resourceName: "sunny")
        case .sunnyRain:
            return #imageLiteral(resourceName: "sunnyRain")
        case .thunderCloud:
            return #imageLiteral(resourceName: "thunderCloud")
        case .thunderRain:
            return #imageLiteral(resourceName: "thunderRain")
        }
    }
    
    func getWeatherBlackImage() ->UIImage{
        switch self {
        case .mostlyClear:
            return #imageLiteral(resourceName: "mostClearBlack")
        case .rainning:
            return #imageLiteral(resourceName: "rainningBlack")
        case .sunny:
            return #imageLiteral(resourceName: "sunnyBlack")
        case .sunnyRain:
            return #imageLiteral(resourceName: "rainningBlack")
        case .thunderCloud:
            return #imageLiteral(resourceName: "thunderCloudBlack")
        case .thunderRain:
            return #imageLiteral(resourceName: "thunderRainBlack")
        }
    }
    
    
    
//    
//    //直接傳入字串判斷取得image
//    func getWeatherImage(by Description:String) -> UIImage?{
//        switch Description   {
//        case WeatherConditionDescription.mostlyClear.rawValue:
//            return #imageLiteral(resourceName: "mostlyClear")
//        case WeatherConditionDescription.rainning.rawValue:
//            return #imageLiteral(resourceName: "rainning")
//        case WeatherConditionDescription.sunny.rawValue:
//            return #imageLiteral(resourceName: "sunny")
//        case WeatherConditionDescription.sunnyRain.rawValue:
//            return #imageLiteral(resourceName: "sunnyRain")
//        case WeatherConditionDescription.thunderCloud.rawValue:
//            return #imageLiteral(resourceName: "thunderCloud")
//        case WeatherConditionDescription.thunderRain.rawValue:
//            return #imageLiteral(resourceName: "thunderRain")
//        default:
//            return nil
//        }
//    }
    
}
