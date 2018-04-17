//
//  EachRunningRecordViewController.swift
//  RunRunRun
//
//  Created by 吳政緯 on 2017/5/15.
//  Copyright © 2017年 吳政緯. All rights reserved.
//


import UIKit
import CoreData

protocol EachRunningRecordDelegate {
    func tranformImageToData(_ image: UIImage)
}

class EachRunningRecordViewController: UIViewController, EachRunningRecordDelegate {
    
    let app = UIApplication.shared.delegate as! AppDelegate
    let persistentContainer = AppDelegate.persistentContainer
    let context = AppDelegate.context
    var runningInformation:RunInformation!
    var isFromStartRun: Bool = false
    var keyboardHeight = CGFloat()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        
        setupNavigation()
        setupVCTitle()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        
        setupTableView()
        
    }
    
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        var nib = UINib(nibName: "RunningInformationCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "runningInformationCell")
        nib = UINib(nibName: "RecordedMapCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "recordedMapCell")
        nib = UINib(nibName: "PhysicalConditionsCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "physicalConditionsCell")
        nib = UINib(nibName: "UserBasicInfoCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "userBasicInfoCell")
        nib = UINib(nibName: "RemarksCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "remarksCell")
        
        
//        let view = UIView()
//        let screenBounds = UIScreen.main.bounds
//        view.frame = CGRect(x: 0, y: 0, width: screenBounds.width, height: screenBounds.height)
//        view.backgroundColor = .white
//        tableView.tableHeaderView  = view
        
    }
    //設置NavigationController標題
    private func setupVCTitle(){

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/M/dd日"
        self.title = dateFormatter.string(from: runningInformation.timestamp)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            self.keyboardHeight = keyboardSize.height  //設置鍵盤高度
            print(keyboardHeight,"鍵盤高度")
        }
    }
    
    fileprivate func setupNavigation() {
        
        if isFromStartRun {
            let leftBtn = UIBarButtonItem(title: "刪除", style: .plain, target: self, action: #selector(navigationDeleteBtn))
            let rightBtn = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(navigationFinishBtn))
            self.navigationItem.leftBarButtonItem = leftBtn
            self.navigationItem.rightBarButtonItem = rightBtn
        }
    }
    
    @objc fileprivate func navigationDeleteBtn() {
        context.delete(runningInformation)
        app.saveContext()
        viewDissmiss()
    }
    
    @objc fileprivate func navigationFinishBtn() {
        app.saveContext()
        viewDissmiss()
    }
    
    fileprivate func viewDissmiss() {
        
        dismiss(animated: true, completion: nil)
        let tabBarController = self.app.window?.rootViewController as! TabBarViewController
        tabBarController.selectedIndex = 2
        
        let navController = tabBarController.selectedViewController as! UINavigationController
        navController.popToRootViewController(animated: true)
    }
    
    func tranformImageToData(_ image: UIImage) {
        if isFromStartRun {
            let imageData = UIImagePNGRepresentation(image)
            runningInformation.mapImage = imageData
        }
    }
}

//只有RecordedMapCell中的"標題"會用到
extension EachRunningRecordViewController:UITextFieldDelegate{
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        tableView.isScrollEnabled = false
        textField.returnKeyType = .done
        //關掉physicalConditionsCell的UserInteraction
        let sectionOne:IndexPath = NSIndexPath(row: 0, section: 1) as IndexPath
        let  physicalConditionsCell  = tableView.cellForRow(at: sectionOne) as! PhysicalConditionsCell
        physicalConditionsCell.isUserInteractionEnabled = false
        textField.becomeFirstResponder()
    }
    
    //按下右下角會完成編輯並隱藏keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        tableView.isScrollEnabled = true
        
        //開啟physicalConditionsCell的UserInteraction
        let sectionOne:IndexPath = NSIndexPath(row: 0, section: 1) as IndexPath
        let  physicalConditionsCell  = tableView.cellForRow(at: sectionOne) as! PhysicalConditionsCell
        physicalConditionsCell.isUserInteractionEnabled = true
        
        if let text = textField.text  {
            if text != ""{
                runningInformation.title = text
            }else{
                runningInformation.title = nil
            }
        }
        app.saveContext()
        let remarkCellIndexPath:IndexPath = NSIndexPath(row: 0, section: 4) as IndexPath
        tableView.reloadRows(at: [remarkCellIndexPath], with: .none)
        return true
    }
}


//只有RemarksCell中的TextView會用到
extension EachRunningRecordViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        animateViewMoving(up: true, moveValue: keyboardHeight)
        textView.becomeFirstResponder()
        textView.returnKeyType = UIReturnKeyType.done
        if textView.text == "新增備註"{
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    
    func textViewDidEndEditing(_ textView: UITextView) {
        animateViewMoving(up: false, moveValue: keyboardHeight)
        let indexPath = NSIndexPath(row: 0, section: 4) as IndexPath
        print(textView.text,"textView")
        guard  !textView.text.isEmpty else{
            tableView.reloadRows(at: [indexPath], with: .none)
            return
        }
        guard textView.text != "新增備註" else{
            tableView.reloadRows(at: [indexPath], with: .none)
            return
        }
        runningInformation.remark = textView.text
        app.saveContext()
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    private func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.tableView.frame = self.tableView.frame.offsetBy(dx: 0,  dy: movement * 0.8) ///dy:可能需要在調整
        UIView.commitAnimations()
    }
}


extension EachRunningRecordViewController: UITableViewDelegate{
    
    //cell的預設高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        switch indexPath.section {
        case 0:
            return screenHeight * 265 / 667
        case 1:
            return screenHeight * 89 / 667
        case 2:
            return screenHeight * 184 / 667
        case 3:
            return screenHeight * 111 / 667
        case 4:
            return screenHeight * 162 / 667
        default:
            return 0
        }
    }
}
extension EachRunningRecordViewController:UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 1
        case 4:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            
        //地圖Cell
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "recordedMapCell") as! RecordedMapCell
            cell.selectionStyle = .none
            cell.titleLabel.delegate = self
            cell.runPath = runningInformation.ownLocations.array as! [RunningLocations]
            cell.setupValue(by: runningInformation)
            cell.delegate = self
            return  cell
        //身體狀況Cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "physicalConditionsCell") as! PhysicalConditionsCell
            cell.selectionStyle = .none
            cell.badFaceBotton.addTarget(self, action: #selector(changeFaceValue(sender:)), for:.touchUpInside )
            cell.normalButton.addTarget(self, action: #selector(changeFaceValue(sender:)), for:.touchUpInside )
            cell.smileButton.addTarget(self, action: #selector(changeFaceValue(sender:)), for:.touchUpInside )
            cell.greatButton.addTarget(self, action: #selector(changeFaceValue(sender:)), for:.touchUpInside )
            cell.setupValue(by:runningInformation)
            return cell
        //跑步資訊Cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "runningInformationCell") as! RunningInformationCell
            cell.selectionStyle = .none
            if isFromStartRun == true{
                //需要優化
                if let areaAirQuality = app.nearAreaAirQuality{
                    let entitiyDesc = NSEntityDescription.entity(forEntityName: "AirQuality", in: context)
                    let sub = AirQuality.init(entity: entitiyDesc!, insertInto: context)
                    sub.aQI = areaAirQuality.aQI
                    runningInformation.ownAirQuality = sub
                }
            }
            cell.setupValue(by:runningInformation)
            return cell
            
        //個人基本資訊Cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "userBasicInfoCell") as! UserBasicInfoCell
            cell.selectionStyle = .none
            if isFromStartRun == true{
                let height:NSNumber? = CoreDataUtils.queryUserInfo()?.height as NSNumber?
                let weight:NSNumber? = CoreDataUtils.queryUserInfo()?.weight as NSNumber?

                runningInformation.height = height  ?? nil
                runningInformation.weight = weight ?? nil
            }
            cell.setupValue(by:runningInformation)
            return cell
        case 4:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "remarksCell") as! RemarksCell
            cell.selectionStyle = .none
            cell.textView.delegate = self
            cell.setupValue(by:runningInformation)
            return  cell
        default:
            return UITableViewCell()
        }
    }
    @objc private func changeFaceValue(sender:UIButton){
        switch sender.currentTitle! {
        case "差":
            
            runningInformation.physicalCondition = 1
            print("點選了Button1")
        case "普通":
            runningInformation.physicalCondition = 2
            print("點選了Button2")
        case "良好":
            runningInformation.physicalCondition = 3
            print("點選了Button3")
        case "很棒":
            runningInformation.physicalCondition = 4
            print("點選了Button4")
        default:
            print("按下表情符號不該出現這行字，出現請Debug")
            
        }
        app.saveContext()
        let PhysicalIndexPath:IndexPath = NSIndexPath(row: 0, section: 1) as IndexPath
        let runInfoIndexPath:IndexPath = NSIndexPath(row: 0, section: 2) as IndexPath
        tableView.reloadRows(at: [PhysicalIndexPath,runInfoIndexPath], with: .none)
        
    }
}

extension EachRunningRecordViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = Transition()
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = Transition()
        return transition
    }
}
