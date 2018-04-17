//
//  DetailedWeatherConditionSecondCell.swift
//  Runvis
//
//  Created by 吳政緯 on 2017/5/16.
//  Copyright © 2017年 吳政緯. All rights reserved.
//

import UIKit

class DetailedWeatherConditionSecondCell: UITableViewCell {

    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var ultravioletIndexLabel: UILabel!
    @IBOutlet weak var ultravioletIndexImageView: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!        //先當成降雨機率
    @IBOutlet weak var humidityImageView: UIImageView! //先當成降雨機率
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureImageView: UIImageView!
    @IBOutlet weak var pM25IndexLabel: UILabel!
    @IBOutlet weak var pM25ConditionLabel: UILabel!
    @IBOutlet weak var pM25ColorView: UIView!
    @IBOutlet weak var pM10IndexLabel: UILabel!
    @IBOutlet weak var pM10ConditionLabel: UILabel!
    @IBOutlet weak var pM10ColorView: UIView!
    @IBOutlet weak var o3IndexLabel: UILabel!
    @IBOutlet weak var o3ConditionLabel: UILabel!
    @IBOutlet weak var o3ColorView: UIView!
    @IBOutlet weak var nO2IndexLabel: UILabel!
    @IBOutlet weak var nO2ConditionLabel: UILabel!
    @IBOutlet weak var nO2ColorView: UIView!
    @IBOutlet weak var sO2IndexLabel: UILabel!
    @IBOutlet weak var sO2ConditionLabel: UILabel!
    @IBOutlet weak var sO2ColorView: UIView!
    @IBOutlet weak var cOIndexLabel: UILabel!
    @IBOutlet weak var cOConditionLabel: UILabel!
    @IBOutlet weak var cOColorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .detailWeatherBackBround
    }
    
//    private func setupLabels() {
//        let size = FontSizeForEachDevice.overrideFontSize(fontSize: 24)
//        let font = UIFont(name: "PingFangTC-Regular", size:size )
//        pM25IndexLabel.font = font
//        pM25ConditionLabel.font = font
//        pM10IndexLabel.font = font
//        pM10ConditionLabel.font = font
//        o3IndexLabel.font = font
//        o3ConditionLabel.font = font
//        nO2IndexLabel.font = font
//        nO2ConditionLabel.font = font
//        sO2IndexLabel.font = font
//        sO2ConditionLabel.font = font
//        cOIndexLabel.font = font
//        cOConditionLabel.font = font
//    }
}


extension DetailedWeatherConditionSecondCell {
    
    func setValue(from data:AirQuality){
        
        if let weather = data.weather{
            let weatherCondition:WeatherConditionDescription = weather.transformWeatherString()
            self.weatherLabel.text = weatherCondition.rawValue
            self.weatherImageView.image = weatherCondition.getWeatherImage()
        }
        
        if  !data.ultraviolet.isZero {
            self.ultravioletIndexLabel.text = String(data.ultraviolet)
        }
        
        if !data.precipitation.isZero {
            let precipitation = Int(data.precipitation)
            self.humidityLabel.text = String(precipitation)+"%"
        }
        
        if !data.temperature.isZero {
            self.temperatureLabel.text = String(data.temperature)+"°C"
        }
        
        if !data.pM25.isZero {
            let value = data.pM25
            self.pM25IndexLabel.text = String(value)
            self.pM25ColorView.backgroundColor = AirPollutant.pM25(value).correspodingColor
            self.pM25ConditionLabel.text = AirPollutant.pM25(value).airQuality
        }
        
        if !data.pM10.isZero {
            let value = data.pM10
            self.pM10IndexLabel.text = String(value)
            self.pM10ColorView.backgroundColor = AirPollutant.pM10(value).correspodingColor
            self.pM10ConditionLabel.text = AirPollutant.pM10(value).airQuality
        }
        
        if !data.o3.isZero {
            let value = data.o3
            self.o3IndexLabel.text = String(value)
            self.o3ColorView.backgroundColor = AirPollutant.o3(value).correspodingColor
            self.o3ConditionLabel.text = AirPollutant.o3(value).airQuality
        }
        
        if !data.nO2.isZero {
            let value = data.nO2
            self.nO2IndexLabel.text = String(value)
            self.nO2ColorView.backgroundColor = AirPollutant.nO2(value).correspodingColor
            self.nO2ConditionLabel.text = AirPollutant.nO2(value).airQuality
        }
        
        if !data.sO2.isZero {
            
            let value = data.sO2
            self.sO2IndexLabel.text = String(value)
            self.sO2ColorView.backgroundColor = AirPollutant.sO2(value).correspodingColor
            self.sO2ConditionLabel.text = AirPollutant.sO2(value).airQuality
        }
        
        if !data.cO.isZero {
            let value = data.cO
            self.cOIndexLabel.text = String(value)
            self.cOColorView.backgroundColor = AirPollutant.cO(value).correspodingColor
            self.cOConditionLabel.text = AirPollutant.cO(value).airQuality
        }
    }
}



