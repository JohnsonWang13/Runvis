//
//  DetailedWeatherCondition.swift
//  RunRunRun
//
//  Created by 吳政緯 on 2017/5/15.
//  Copyright © 2017年 吳政緯. All rights reserved.
//

import UIKit
import CoreData

class DetailedWeatherConditionViewController:UIViewController{
    
     var weatherData: AirQuality = {
        let entity:AirQuality = CoreDataUtils.createEmptyEntity()
        return entity
    }()
    
    @IBOutlet weak var detailedWeatherTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailedWeatherTableView.delegate = self
        detailedWeatherTableView.dataSource = self
        detailedWeatherTableView.separatorStyle = .none
        setNavigationTitle()
        regesterCellNib()
        
        //UIBarButtonItem的back Button title弄掉
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for:UIBarMetrics.default)
    }
    
    private func  setNavigationTitle() {
        
        if let city = weatherData.city,let district =  weatherData.district{
            
            self.navigationItem.title = "\(city)-\(district)"
        }
    }
    
    private func regesterCellNib(){
        
        var nib = UINib(nibName: "DetailedWeatherConditionFirstCell", bundle: nil)
        detailedWeatherTableView.register(nib, forCellReuseIdentifier: "detailedWeatherConditionFirstCell")
        nib = UINib(nibName: "DetailedWeatherConditionCell", bundle: nil)
        detailedWeatherTableView.register(nib, forCellReuseIdentifier: "detailedWeatherConditionCell")
        nib = UINib(nibName: "DetailedWeatherConditionSecondCell", bundle: nil)
        detailedWeatherTableView.register(nib, forCellReuseIdentifier: "detailedWeatherConditionSecondCell")
    }
}

extension DetailedWeatherConditionViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let screenHeight = UIScreen.main.bounds.height
        let section = indexPath.section
        
        switch section {
        case 0:
            return  180  //screenHeight * 180 / 667
        case 1:
            return 163   //screenHeight * 163/667
        case 2:
            return screenHeight * 469/667
        default:
            return 0
        }
    }
}



extension DetailedWeatherConditionViewController:UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            
            let cell = detailedWeatherTableView.dequeueReusableCell(withIdentifier: "detailedWeatherConditionFirstCell") as! DetailedWeatherConditionFirstCell
            cell.selectionStyle = .none
            cell.setValue(from: weatherData)
            return cell
        case 1:
            
            let cell = detailedWeatherTableView.dequeueReusableCell(withIdentifier: "detailedWeatherConditionCell") as! DetailedWeatherConditionCell
            cell.selectionStyle = .none
            cell.setValue(from: weatherData)
            return cell
        case 2:
            
            let cell = detailedWeatherTableView.dequeueReusableCell(withIdentifier: "detailedWeatherConditionSecondCell") as! DetailedWeatherConditionSecondCell
            cell.selectionStyle = .none
            cell.setValue(from: weatherData)
            return cell
        default:
            return UITableViewCell()
        }
    }
}




