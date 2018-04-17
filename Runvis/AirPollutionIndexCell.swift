//
//  AirPollutionIndexCell.swift
//  Runvis
//
//  Created by 吳政緯 on 2017/5/16.
//  Copyright © 2017年 吳政緯. All rights reserved.
//

import UIKit

class AirPollutionIndexCell: UITableViewCell {
    
    @IBOutlet weak var cityAndDistrictLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var probabilityOfPrecipitationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var measureTimeLabel: UILabel!
    @IBOutlet weak var aQILabel: UILabel!
    @IBOutlet weak var airQualityLabel: UILabel!
    @IBOutlet weak var aQIColorView: UIView!
    @IBOutlet weak var backgroundColorView: UIView!
    @IBOutlet weak var weatherImage: UIImageView!
    
    override func awakeFromNib() {
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        weatherLabel.layer.cornerRadius = 10
        weatherLabel.backgroundColor = UIColor.init(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
        
        weatherLabel.clipsToBounds = true
        
        probabilityOfPrecipitationLabel.layer.cornerRadius = 10
        probabilityOfPrecipitationLabel.backgroundColor = UIColor.init(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
        probabilityOfPrecipitationLabel.clipsToBounds = true

        backgroundColorView.layer.cornerRadius = 4
        backgroundColorView.clipsToBounds = true
    }
}

extension AirPollutionIndexCell {
    
    func setValue(from data:AirQuality) {
        
        if !data.aQI.isZero {
            let value = data.aQI
            self.aQILabel.text  = "AQI \(Int(value))"
            self.airQualityLabel.text = "品質  \(AirPollutant.aQI(value).airQuality)"
            self.aQIColorView.backgroundColor = AirPollutant.aQI(value).correspodingColor
            
        } else {
            self.aQILabel.text  = "AQI 00"
            self.airQualityLabel.text = "品質"
            self.aQIColorView.backgroundColor = .purpleyGrey
        }
        
        //-1 代表缺降雨機率
        if data.precipitation != -1 {
            
            self.probabilityOfPrecipitationLabel.text = "降雨\(Int(data.precipitation))%"
        } else {
            
            self.probabilityOfPrecipitationLabel.text = "     "
        }

        if let weather = data.weather {
            
            let   weatherCondition:WeatherConditionDescription = weather.transformWeatherString()
            self.weatherLabel.text = weatherCondition.rawValue
            self.weatherImage.image = weatherCondition.getWeatherBlackImage()
        } else {
            
            self.weatherLabel.text = "     "
        }
        
        if let date = data.date {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "a h:mm"
            let stringDate = formatter.string(from: date as Date)
            self.measureTimeLabel.text = stringDate
        } else {
            
            self.measureTimeLabel.text = "--"
        }
        if !data.temperature.isZero {
            
            self.temperatureLabel.text = "\(Int(data.temperature))°C"
        } else {
            
            self.temperatureLabel.text  = "--°C"
        }
        
        if let city = data.city,let district = data.district {
            
            self.cityAndDistrictLabel.text = "\(city)-\(district)"
        } else {
            self.cityAndDistrictLabel.text = ""
        }
    }
    
    //cell設置空值，預防cell裡的值被reusable Cell值亂塞
    func setEmptyValue() {
        
        self.cityAndDistrictLabel.text = ""
        self.aQILabel.text  = "AQI 00"
        self.airQualityLabel.text = "品質"
        self.probabilityOfPrecipitationLabel.text =  "     "
        self.measureTimeLabel.text = "上午 0:00"
        self.temperatureLabel.text = "°C"
        self.cityAndDistrictLabel.text = ""
        self.weatherLabel.text = "     "
        self.weatherImage.image = nil
        self.aQIColorView.backgroundColor = .purpleyGrey
    }
    
    //預先設置cell的XX市XX區用
    func onlySetCityAndDistrictLabel(with data:CollectionArea){
        self.cityAndDistrictLabel.text = "\(data.city)-\(data.district)"
        self.aQILabel.text  = "AQI 00"
        self.airQualityLabel.text = "品質"
        self.probabilityOfPrecipitationLabel.text =  "     "
        self.measureTimeLabel.text = "上午 0:00"
        self.temperatureLabel.text = "°C"
        self.weatherLabel.text = "     "
        self.weatherImage.image = nil
        self.aQIColorView.backgroundColor = .purpleyGrey
    }
}
