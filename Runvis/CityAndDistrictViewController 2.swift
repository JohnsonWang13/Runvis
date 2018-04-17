//
//  CityAndDistrictViewController.swift
//  Runvis
//
//  Created by 吳政緯 on 2017/5/17.
//  Copyright © 2017年 吳政緯. All rights reserved.
//

import UIKit
import CoreData



typealias MonitoringStation = CollectionArea
typealias city = String
typealias districts = String

class CityAndDistrictViewController:UIViewController{
    
    var delegate:DetailedWeatherConditionDelegate?
    var monitoringStations : [MonitoringStation] = []
    var sortedmonitoringStations : [city:[districts]] = [:]
    let app = AppDelegate.app
    
    var deselecting = false{
        didSet{
//            print(deselecting)
        }
    }
    var selectedIndexPath:[IndexPath] =  [] //??
    
    //折疊
    lazy var collapses:[Bool] = {
        var boolValue = [Bool]()
        for  index in 0...self.sortedmonitoringStations.count{
            boolValue.append(true)
        }
        return boolValue
    }()
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        activityIndicator.stopAnimating()
        getAllMonitoringStations()
        
        //UIBarButtonItem的back Button title弄掉
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for:UIBarMetrics.default)
    }
    
    private func getAllMonitoringStations() {
        
        if app.allMonitoringStations.isEmpty {
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
            Request.getData.monitoringStations { [weak self] datas in
                
                let monitoringStations:[MonitoringStation]  = Transform.data.toMonitoringStation(from: datas)
                //            print(monitoringStations)
                DispatchQueue.main.async {
                    
                    if let `self` = self {
                        `self`.app.allMonitoringStations  = monitoringStations  //請求完之後放到Appdelegate存放
                        //已收藏的地區不加到monitoringStations中，防止重複收藏相同地區
                        for monitoringStation in monitoringStations {
                            
                            if self.didCollectedThisArea(monitoringStation) == false {
                                `self`.monitoringStations.append(monitoringStation)
                            }
                        }
                        `self`.sortedmonitoringStations = `self`.sort(monitoringStations: &`self`.monitoringStations)
                        `self`.tableView.reloadData()
                        `self`.activityIndicator.stopAnimating()
                    }
                }
            }
        } else {
            let monitoringStations = app.allMonitoringStations
            
            //已收藏的地區不加到monitoringStations中，防止重複收藏相同地區
            for monitoringStation in monitoringStations {
                
                if didCollectedThisArea(monitoringStation) == false{
                    self.monitoringStations.append(monitoringStation)
                }
            }
            self.sortedmonitoringStations = self.sort(monitoringStations: &self.monitoringStations)
            self.tableView.reloadData()
        }
    }
    
    
    //檢查某一MonitoringStation是否重複
    private func didCollectedThisArea(_  data:MonitoringStation)->Bool{
        
        let allCollectionAreas = CoreDataUtils.queryCollectionArea()
        
        for  collectionArea in allCollectionAreas {
            if collectionArea.city == data.city &&  collectionArea.district == data.district{
                return true
            }
        }
        return false
    }
    
    //把資料排序成[city:[districts]]
    private func sort(monitoringStations datas:inout [MonitoringStation]) -> [city:[districts]] {
        var sortedmonitoringStations = [city:[districts]]()
        
        for data in datas {
            
            if sortedmonitoringStations[data.city] != nil {
                sortedmonitoringStations[data.city]!.append(data.district)
            } else {
                sortedmonitoringStations[data.city] = [data.district]
            }
        }
        return sortedmonitoringStations
    }
}


extension CityAndDistrictViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.collapses[indexPath.section] == true {
            return 0
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = UIColor.white
        headerView.tag = section
        let headerString = UILabel(frame: CGRect(x: 12, y: 0, width: tableView.frame.size.width-24, height: 50))
        headerString.text = Array(sortedmonitoringStations.keys)[section]
        headerString.textColor = .black
//        headerString.font = /
        headerView.addSubview(headerString)
        
        if  self.collapses[section] == false {
            let image = UIImageView(image: #imageLiteral(resourceName: "arrowDown"))
            image.frame = CGRect(x: tableView.frame.size.width-24, y: headerView.frame.height/2 - image.frame.height/2 , width: image.frame.width , height: image.frame.height)
            
            headerView.addSubview(image)
        }else{
            let image =  UIImageView(image: #imageLiteral(resourceName: "arrowRight"))
            image.frame = CGRect(x: tableView.frame.size.width-24, y: headerView.frame.height/2 - image.frame.height/2, width: image.frame.width , height: image.frame.height)
            headerView.addSubview(image)
        }
        let headerTapped = UITapGestureRecognizer (target: self, action:#selector(sectionHeaderTapped(recognizer:)))
        headerView .addGestureRecognizer(headerTapped)
        
        return headerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = Array(sortedmonitoringStations.keys)[indexPath.section]
        let districts = sortedmonitoringStations[selectedCity]!
        let selectedDistrict = districts[indexPath.row]
        let count = CoreDataUtils.queryCollectionArea().count
        let sequence =  count + 1
        
        let app = AppDelegate.app
        let context = AppDelegate.context
        let collectionArea = CollectionArea(context:context)
        collectionArea.city = selectedCity
        collectionArea.district = selectedDistrict
        collectionArea.sequence = Int16(sequence)
        
        app.saveContext()
        self.delegate?.updateCollectionArea(byAdding:collectionArea)
        self.navigationController?.popViewController(animated: true)
    }
    
    func sectionHeaderTapped(recognizer: UITapGestureRecognizer) {
        let indexPath : NSIndexPath = NSIndexPath(row: 0, section: (recognizer.view?.tag as Int!)!)
    
        if (indexPath.row == 0) {
            self.collapses[indexPath.section] = !self.collapses[indexPath.section]
            
            //reload specific section animated
            let range = NSMakeRange(indexPath.section, 1)
            let sectionToReload = NSIndexSet(indexesIn: range)
            self.tableView.reloadSections(sectionToReload as IndexSet, with: .fade)
        }
    }
}

extension CityAndDistrictViewController:UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedmonitoringStations.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let city = Array(sortedmonitoringStations.keys)[section]
        let districts = sortedmonitoringStations[city]!
        return districts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityAndDistrictCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        
        //好方法～水水的!!!!!!!!!!!!!!!!!!!!!!!
        let city = Array(sortedmonitoringStations.keys)[indexPath.section]
        let districts = sortedmonitoringStations[city]!
        let district = districts[indexPath.row]
        
        cell.textLabel?.text = "   \(district)"
        return cell
    }
    
    //header顯示的名稱
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let city = Array(sortedmonitoringStations.keys)[section]
        return city
    }
}

protocol DetailedWeatherConditionDelegate {
    
    func updateCollectionArea(byAdding area:CollectionArea )
}
