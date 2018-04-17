//
//  ViewController.swift
//  RunRunRun
//
//  Created by 吳政緯 on 2017/5/14.
//  Copyright © 2017年 吳政緯. All rights reserved.
//

import UIKit
import CoreData



class UserInfoViewController: UIViewController {
    
    let app = UIApplication.shared.delegate as! AppDelegate
    let persistentContainer = AppDelegate.persistentContainer
    let context = AppDelegate.context
    var runningInformations:[RunInformation] = []
    
    lazy  var userInfo : UserInfo = {
        if let userInfo = CoreDataUtils.queryUserInfo(){
            return userInfo
        }else{
            //萬一APP初始化失敗，才會執行這行
            (UIApplication.shared.delegate as! AppDelegate).createUserInfo()
            return CoreDataUtils.queryUserInfo()!
        }
    }()
    
    @IBOutlet weak var userInfoTavleView: UITableView!{
        didSet{
            
            var nib = UINib(nibName: "UserInfoCell", bundle: nil)
            userInfoTavleView.register(nib, forCellReuseIdentifier: "userInfoCell")
            nib = UINib(nibName: "RunningRecordCell", bundle: nil)
            userInfoTavleView.register(nib, forCellReuseIdentifier: "runningRecordCell")
            userInfoTavleView.delegate = self
            userInfoTavleView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //抓取所有的RunInfomation
        runningInformations = CoreDataUtils.queryRunInfomation()
        runningInformations.append(CoreDataUtils.createEmptyEntity())
        //        //時間轉成日期的方法
        //        let calendar = Calendar.current
        //        let date = Date()
        //        let dateComponents = calendar.dateComponents([.year,.month, .day, .hour,.minute,.second], from: date )
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        runningInformations = CoreDataUtils.queryRunInfomation()
        userInfoTavleView.reloadData() ///////
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toEachRunningRecordVC"{
            
            if let destinationVC = segue.destination as? EachRunningRecordViewController
                ,let indexPath = sender as? IndexPath{
                destinationVC.runningInformation =   runningInformations[indexPath.row]
            }
        }
    }
    
    @IBAction func goToDetailUserInfoVC(_ sender: UINavigationItem) {
        
        performSegue(withIdentifier: "toDetailUserInfoVC", sender: nil)
    }
}

extension UserInfoViewController:UITableViewDelegate{
    
//    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        
//        if editingStyle == .delete{
//            if indexPath.row == 1 {
//                
//            } else {
//                
//                let runRecord = runningInformation[indexPath.row]  //暫時測試
//                context.delete(runRecord)
//                app.saveContext()
//                runningInformation =  CoreDataUtils.queryRunInfomation()
//                
//            }
//            
//        }
//    }
    
    
    //cell的預設高度
    internal func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 205
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let screenHeight = UIScreen.main.bounds.height
        switch indexPath.section {
        case 0:
            
            return  screenHeight * 325/667
        case 1:
            return  99
        default:
            return 0
        }
    }
    //哪一行被點選，並做一些事情
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let indexPath = tableView.indexPathForSelectedRow{
            
            if indexPath.section == 1{
                print("第\(indexPath.section)區塊的第\(indexPath.row)被點了！！")
                performSegue(withIdentifier: "toEachRunningRecordVC", sender: indexPath)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
}

extension UserInfoViewController:UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return runningInformations.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            
             let cell = userInfoTavleView.dequeueReusableCell(withIdentifier: "userInfoCell") as! UserInfoCell
             cell.selectionStyle = .none
             cell.setValue(userInfo: userInfo)
             cell.setValue(runInformations: runningInformations )
            return cell
            
        case 1:
            let cell = userInfoTavleView.dequeueReusableCell(withIdentifier: "runningRecordCell") as! RunningRecordCell
            cell.selectionStyle = .none
            cell.setValue(by: runningInformations[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
    }
}
