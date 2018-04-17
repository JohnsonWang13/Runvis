//
//  AirPollutionIndex.swift
//  RunRunRun
//
//  Created by 吳政緯 on 2017/5/15.
//  Copyright © 2017年 吳政緯. All rights reserved.
//



import UIKit
import CoreData
import CoreLocation


struct  CollectionAreaInformation {
    var collectionArea:CollectionArea
    var airQuality:AirQuality?
}


class AirPollutionIndexViewController:UIViewController{
    
    //附近區域Cell專用Loading圈圈
    let nearAreaIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.frame = CGRect.init(x: 0, y: 0, width: 18, height: 18) //加到header之後會在設置座標
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = .gray
        indicator.color = UIColor.darkishBlue
        indicator.stopAnimating()
        return indicator
    }()
    
    //請求位置用
    let locationManager = CLLocationManager()
    
    let loadingGroup = DispatchGroup()
    
    var neighborhoodsAirQuality: [AirQuality] = []
    var collectionAreasInformations:[CollectionAreaInformation] = []
    var cellStyleForEditing: UITableViewCellEditingStyle = .none
    
    var pullRefesher:UIRefreshControl = {
        let refesher = UIRefreshControl()
        refesher.frame = CGRect.init(x: 0, y: 0, width: 32, height: 32)
        return refesher
    }()
    
    @IBOutlet weak var airPollutionTableView: UITableView! {
        didSet{
            var nib = UINib(nibName: "AirPollutionIndexCell", bundle: nil)
            airPollutionTableView.register(nib, forCellReuseIdentifier: "airPollutionIndexCell")
            nib = UINib(nibName: "EmptyCell", bundle: nil)
            airPollutionTableView.register(nib, forCellReuseIdentifier: "emptyCell")
            airPollutionTableView.delegate = self
            airPollutionTableView.dataSource = self
            airPollutionTableView.separatorStyle = .none
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetCollectionAreaDatas()
        self.activityIndicator.stopAnimating()
        
        getAllCollectionAreasAirQualityData()
        setupLocationManager()
        
        updateLocationForViewDidLoad() //先確認APPdelegate有無請求到位置，沒有再更新位置
        
        
        pullRefesher.addTarget(self, action: #selector(self.refresh(sender:)
            ), for: UIControlEvents.valueChanged)  ///
        airPollutionTableView.addSubview(pullRefesher)
    }
    
    //show  CityAndDistrictVC
    @IBAction func goToCityAndDistrictVC(_ sender: UITabBarItem) {
        performSegue(withIdentifier: "toCityAndDistrictViewController", sender: sender)
    }
    
    //編輯收藏地區按鈕
    @IBAction func editCollectionArea(_ sender: UIBarButtonItem) {
        
        if(cellStyleForEditing == .none) {
            sender.title = "完成"
            self.navigationItem.leftBarButtonItem?.isEnabled = false
            cellStyleForEditing = .delete
        } else {
            sender.title = "編輯"
            self.navigationItem.leftBarButtonItem?.isEnabled = true
            cellStyleForEditing = .none
        }
        
        airPollutionTableView.setEditing(cellStyleForEditing != .none, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            
            switch identifier {
                
            case "toDetailedWeatherConditionVC":
                
                if let destinationVC = segue.destination as? DetailedWeatherConditionViewController
                    ,let indexPath = sender as? IndexPath{
                    switch indexPath.section {
                        
                    case 0:
                        if neighborhoodsAirQuality.count != 0 {
                            destinationVC.weatherData = neighborhoodsAirQuality[indexPath.row]
                        }
                    case 1:
                        if collectionAreasInformations.count != 0 {
                            if let airQuality = collectionAreasInformations[indexPath.row].airQuality {
                                destinationVC.weatherData = airQuality
                            }
                        }
                    default:
                        break
                    }
                }
                
            case "toCityAndDistrictViewController":
                
                if let destinationVC = segue.destination as? CityAndDistrictViewController{
                    destinationVC.delegate = self
                }
                
            default:
                break
            }
        }
    }
    
    //下拉更新資料
    @objc private func refresh(sender:UIRefreshControl) {
        
        sender.endRefreshing()
        guard  cellStyleForEditing == .none else{return}
        
        //收藏地區的indicatorView
        if !activityIndicator.isAnimating {
            resetCollectionAreaDatas()
            getAllCollectionAreasAirQualityData()
        }
        
        //附近區域的indicatorView
        if !nearAreaIndicatorView.isAnimating {
            resetNearAreaDatas()
            updateLocation()
        }
    }
    
    private func resetNearAreaDatas(){
        self.neighborhoodsAirQuality = []
    }
    
    //重置tableView的資料 (註解和func名稱需要再改)
    private func resetCollectionAreaDatas() {
        
        self.collectionAreasInformations =  []
        //self.airPollutionTableView.reloadSections(IndexSet(integer: 1), with: .none)
        let collectionAreas:[CollectionArea] = CoreDataUtils.queryCollectionArea()
        for collectionArea in collectionAreas{
            let collectionAreaInformation =  CollectionAreaInformation.init(collectionArea: collectionArea, airQuality: nil)
            self.collectionAreasInformations.append(collectionAreaInformation)
        }
        self.airPollutionTableView.reloadData()
    }
    
    //AppDategate有nearAreaAirQuality就用沒有就請求
    private func updateLocationForViewDidLoad() {
        let nearAreaAirQuality:AirQuality? = AppDelegate.app.nearAreaAirQuality
        if let nearAreaAirQuality = nearAreaAirQuality{
            neighborhoodsAirQuality = []
            neighborhoodsAirQuality.append(nearAreaAirQuality)
            
            let indexPath = NSIndexPath(row: 0, section: 0) as IndexPath
            airPollutionTableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            updateLocation()
        }
    }
    
    private func updateLocation() {
        
        if (Authorization.check.Gps{self.present($0, animated: true, completion: nil)}) {
            self.nearAreaIndicatorView.startAnimating() //測試
            locationManager.requestLocation()
        }
    }
    
    private func setupLocationManager() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestAlwaysAuthorization()
        
    }
    
    fileprivate func getAllCollectionAreasAirQualityData() {
        
        for collectionAreasInformation in self.collectionAreasInformations{
            loadingGroup.enter()
            print("loadingGroup enter")
            getCollectionAreasAirQualityData(by: collectionAreasInformation.collectionArea)
        }
        
        //完成所有異部之後所做的事情
        loadingGroup.notify(queue: .main) {
            print("Finished all requests.")
            self.activityIndicator.stopAnimating()
            self.airPollutionTableView.reloadData()
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    //取得某個收藏地區空污及天氣狀況資訊
    fileprivate func getCollectionAreasAirQualityData(by collectionArea:CollectionArea) {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        if collectionAreasInformations.count != 0 {
            self.activityIndicator.startAnimating()
            
            Request.getData.airQuality(by: collectionArea ) { [weak  self] data in
                
                if let weakSelf = self,let collectionAreaAirQuality:AirQuality =  Transform.data.toAirQuality(from: data){
                    DispatchQueue.main.async {
                        
                        //天氣資訊放入對應的collectionAreasInformation.airQuality
                        for (index,collectionAreasInformation)   in  weakSelf.collectionAreasInformations.enumerated(){
                            
                            if collectionAreasInformation.collectionArea.city == collectionAreaAirQuality.city && collectionAreasInformation.collectionArea.district == collectionAreaAirQuality.district{
                                weakSelf.collectionAreasInformations[index].airQuality = collectionAreaAirQuality
                            }
                        }
                        
                        self?.loadingGroup.leave()
                        self?.airPollutionTableView.reloadData() ////////////////
                        print("loadingGroup leave")
                    }
                } else {
                    
                    DispatchQueue.main.async {
                        self?.loadingGroup.leave()
                        self?.airPollutionTableView.reloadData() ////////////////
                        print("loadingGroup leave")
                    }
                }
            }
        } else { //如果沒有收藏地區
            
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.activityIndicator.stopAnimating()
        }
    }
}





//==========================================================================UITableViewDelegate
extension AirPollutionIndexViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            guard collectionAreasInformations.count != 0  else {
                return
            }
        }
        //        self.navigationController?.pushViewController(deta, animated: true)
        performSegue(withIdentifier: "toDetailedWeatherConditionVC", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = self.view.frame.height
        return  height * 137/667  //140
    }
    
    //是否每一行cell可以被編輯
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if indexPath.section  == 0 {
            
            return false
        }
        
        //編輯模式下才能被編輯
        if(cellStyleForEditing == .none) {
            
            return false
        } else {
            
            return true
        }
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////
    //按下小紅點會觸發的func，主要用來客製化cell右邊的delete 按鈕，但這次是要點下小紅點直接作刪除動作
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        defer {
            
            let context = AppDelegate.context
            let app  = AppDelegate.app
            
            self.airPollutionTableView.beginUpdates()
            
            
            self.airPollutionTableView.deleteRows(at: [indexPath], with: .left)
            context.delete(collectionAreasInformations[indexPath.row].collectionArea)
            collectionAreasInformations.remove(at: indexPath.row)
            
            //        let collectionAreas:[CollectionArea] = CoreDataUtils.queryCollectionArea()
            
            //改變CollectionArea的Sequence
            for ( index,collectionAreasInformation ) in self.collectionAreasInformations.enumerated() {
                collectionAreasInformation.collectionArea.sequence = Int16(index + 1)
            }
            
            app.saveContext()
            
            if collectionAreasInformations.count == 0 {
                self.airPollutionTableView.insertRows(at: [indexPath], with: .right)
                editCollectionArea(self.navigationItem.rightBarButtonItem!)
            }
            
            self.airPollutionTableView.endUpdates()
        }
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (action, index) in
        }
        
        return [deleteAction]
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let headerVeiew = (view as! UITableViewHeaderFooterView)
        headerVeiew.backgroundView?.backgroundColor = .clear
        headerVeiew.contentView.backgroundColor = .clear
        headerVeiew.textLabel?.font = UIFont(name: "PingFangTC-Regular", size: 13)
        headerVeiew.textLabel?.textColor = UIColor.purpleyGrey
        
        //多增加一個ActivityIndicator
        if section == 0 {
            nearAreaIndicatorView.frame = headerVeiew.frame //需要在調整
            headerVeiew.addSubview(nearAreaIndicatorView)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 18
    }
    
    
    
    // 完全客製化HeaderInSection的方法
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //
    //        let headerView = UIView()
    //        headerView.backgroundColor = .red
    //        let title = UILabel()
    //        title.font = UIFont(name: "System", size: 22)
    //        title.backgroundColor = UIColor.clear
    //        headerView.backgroundColor = UIColor.clear
    //        headerView.textLabel?.textColor = title.textColor
    //        headerView.textLabel?.textAlignment = NSTextAlignment.center
    //        headerView.addsubView(title)
    //        return headerView
    //
    //
    //    }
    
    
    //    //如果沒有寫這個func，預設編輯樣式為刪除
    //    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
    //        return .none
    //    }
    
    
}

extension AirPollutionIndexViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            
            let collectionArea:[CollectionArea] = CoreDataUtils.queryCollectionArea()
            
            if collectionArea.count == 0 && collectionAreasInformations.count == 0 {
                return 1
            }else{
                return  collectionAreasInformations.count
            }
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = airPollutionTableView.dequeueReusableCell(withIdentifier: "airPollutionIndexCell") as! AirPollutionIndexCell
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets.zero
            
            if !neighborhoodsAirQuality.isEmpty {
                cell.setValue(from: neighborhoodsAirQuality[0])
            }else{
                
                cell.setEmptyValue()
            }
            return cell
        case 1:
            
            if collectionAreasInformations.count == 0 {
                let cell = airPollutionTableView.dequeueReusableCell(withIdentifier: "emptyCell") as! EmptyCell
                cell.selectionStyle = .none
                cell.separatorInset = UIEdgeInsets.zero
                self.navigationItem.rightBarButtonItem?.isEnabled = false //////不太好的寫法
                return cell
            } else if collectionAreasInformations.count != 0 {
                
                let cell = airPollutionTableView.dequeueReusableCell(withIdentifier: "airPollutionIndexCell") as! AirPollutionIndexCell
                cell.selectionStyle = .none
                cell.separatorInset = UIEdgeInsets.zero
                
                //判斷collectionAreasInformations此變數是否有放入收藏地區資訊
                if let airQuality = collectionAreasInformations[indexPath.row].airQuality {
                    cell.setValue(from: airQuality)
                } else {
                    cell.onlySetCityAndDistrictLabel(with: collectionAreasInformations[indexPath.row].collectionArea)
                }
                return cell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "附近監測站"
        case 1:
            return "收藏監測站"
        default:
            return nil
        }
    }
}

extension AirPollutionIndexViewController:DetailedWeatherConditionDelegate {
    //加入新的收藏地區之後並reload data
    internal func updateCollectionArea(byAdding area: CollectionArea) {
        
        let data:CollectionAreaInformation = CollectionAreaInformation.init(collectionArea: area, airQuality: nil)
        self.collectionAreasInformations.append(data)
        self.airPollutionTableView.reloadData()
        //=============================
        loadingGroup.enter()
        print("loadingGroup enter")
        //=============================
        
        self.getCollectionAreasAirQualityData(by:data.collectionArea)
        
        //=============================
        //完成所有異部之後所做的事情
        loadingGroup.notify(queue: .main) {
            print("Finished all requests.")
            self.activityIndicator.stopAnimating()
            //            let indexPath = NSIndexPath(row: 0, section: 0) as IndexPath
            //            self.airPollutionTableView.reloadRows(at:[indexPath] , with: .automatic)
            self.airPollutionTableView.reloadData() /////b
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        //=============================
    }
}



extension AirPollutionIndexViewController:CLLocationManagerDelegate {
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.nearAreaIndicatorView.startAnimating()
        let userLocation:CLLocation = locations[0]
        let long = userLocation.coordinate.longitude
        let lat = userLocation.coordinate.latitude
        
        print(long, lat)
        //每次requestLocation之後去請求附近地區天氣狀況
        self.getNearAreaAirQualityData(currentLocation: userLocation.coordinate)
    }
    
    //Failed to find user's location
    internal  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    //request附近地區空污及天氣狀況
    fileprivate func getNearAreaAirQualityData(currentLocation:CLLocationCoordinate2D){
        
        //        self.nearAreaIndicatorView.startAnimating()
        var location:[String:Double] = [:]
        location["Longitude"] = currentLocation.longitude
        location["Latitude"] = currentLocation.latitude
        Request.getData.nearAreaAirQuality(location:location){ data in
            if let data = data {
                
                if let airQuality:AirQuality = Transform.data.toNearByAirQuality(from: data) {
                    DispatchQueue.main.async {
                        AppDelegate.app.nearAreaAirQuality = airQuality  //更新APPdelegate的附近airQuality
                        self.neighborhoodsAirQuality.append(airQuality)
                        self.nearAreaIndicatorView.stopAnimating()
                        //                        let indexPath = NSIndexPath(row: 0, section: 0) as IndexPath
                        //                        self.airPollutionTableView.reloadRows(at: [indexPath], with: .fade)
                        self.airPollutionTableView.reloadData()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.nearAreaIndicatorView.stopAnimating()
                    self.airPollutionTableView.reloadData()
                    //                    let indexPath = NSIndexPath(row: 0, section: 0) as IndexPath
                    //                    self.airPollutionTableView.reloadRows(at: [indexPath], with: .fade) ///動畫效果可更換
                    let indexPath = NSIndexPath(row: 0, section: 0) as IndexPath
                    self.airPollutionTableView.reloadRows(at: [indexPath], with: .fade) ///動畫效果可更換
                }
            }
        }
    }
}
