//
//  DetailUserInfoViewController.swift
//  Runvis
//
//  Created by 吳政緯 on 2017/5/25.
//  Copyright © 2017年 吳政緯. All rights reserved.
//

import UIKit
import CoreData

class DetailUserInfoViewController:UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    let app = AppDelegate.app
    let userInfo:UserInfo = CoreDataUtils.queryUserInfo()!
    
    let screenWidth = UIScreen.main.bounds.width
    let screenheight = UIScreen.main.bounds.height
    var pickView:PickView!
    //    let datePicker = UIDatePicker()
    var maskView = UIView()
    let pickerSources = ["男", "女"]
    var currentGenderValue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupPickerView()
    }
    
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = nil
        tableView.tableFooterView = UIView()  
        let nib1 = UINib(nibName: "ProfilePhotoCell", bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: "profilePhotoCell")
        let nib2 = UINib(nibName: "DetailUserInfoCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "detailUserInfoCell")
    }
    
    func setupPickerView(){
        
        let view =  UINib(nibName: "PickView", bundle: nil).instantiate(withOwner:self , options: nil)[0] as! PickView
        pickView = view
        pickView.frame = CGRect(x: 0, y:0, width:self.screenWidth, height:self.pickView.bounds.height)
        pickView.pickView.delegate = self
        pickView.pickView.showsSelectionIndicator = true
        pickView.pickView.selectRow(2, inComponent: 0, animated: true)
        
        pickView.finishButton.addTarget(self, action: #selector(self.finishGenderPick), for: UIControlEvents.touchUpInside)
        pickView.cancelButton.addTarget(self, action: #selector(self.cancelGenderPick), for: UIControlEvents.touchUpInside)
        
        pickView.frame.origin.y = screenheight
        pickView.frame.origin.x = 0
        //        pickView.bounds  = CGRect(x: 0, y:0, width:self.screenWidth, height:self.pickView.bounds.height)
        maskView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenheight)
        maskView.backgroundColor = .black
        maskView.alpha = 0
        let gesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.cancelGenderPick))
        maskView.addGestureRecognizer(gesture)
    }
    
    @objc private func finishGenderPick(){
        
        UIView.animate(withDuration: 0.3,animations:{self.maskView.alpha = 0;self.pickView.frame.origin.y = self.view.frame.height }) { _ in
            
            if self.currentGenderValue.isEmpty{
                self.userInfo.gender = "男"
            } else {
                
                self.userInfo.gender = self.currentGenderValue
            }
            
            self.maskView.removeFromSuperview()
            self.pickView.removeFromSuperview()
            self.app.saveContext()
            self.tableView.reloadData()
        }
    }
    
    @objc  private func cancelGenderPick(){
        
        UIView.animate(withDuration: 0.3,animations:{self.maskView.alpha = 0;self.pickView.frame.origin.y = self.view.frame.height }) { _ in
            
            self.maskView.removeFromSuperview()
            self.pickView.removeFromSuperview()
        }
    }
}

extension DetailUserInfoViewController:UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        currentGenderValue =  pickerSources[row]
    }
}

extension DetailUserInfoViewController:UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return   pickerSources[row]
    }
}

extension DetailUserInfoViewController:UITextFieldDelegate{
    
    //    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
    //        if newText.length() == 0 {
    //            let alertController = self.presentedViewController as? UIAlertController
    //            if (alertController != nil) {
    //                let okAction = alertController!.actions.last! as UIAlertAction
    //                okAction.setValue(CommonTools.getUIColorFromRGB(0x999999), forKey: "titleTextColor")
    //            }
    //        }else{
    //            let alertController = self.presentedViewController as? UIAlertController
    //            if (alertController != nil) {
    //                let okAction = alertController!.actions.last! as UIAlertAction
    //                okAction.setValue(CommonTools.getUIColorFromRGB(0x17c8ce), forKey: "titleTextColor")
    //            }
    //        }
    //        return true;
    //    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension DetailUserInfoViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let screenHeight = UIScreen.main.bounds.height
        if indexPath.section == 0 {
            return screenHeight * 160/667
        }
        if indexPath.section == 1{
            return screenHeight * 52/667
        }
        return 0
        
    }
    
    
    //didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1{
            switch indexPath.row {
            case 0,3,4,5:
                let cell =  tableView.cellForRow(at: indexPath) as! DetailUserInfoCell
                let text = cell.titleLabel.text ?? "未知標題"
                callAlertController(title: text, rowofIndex: indexPath.row)
            case 1:   ///
                showGenderPickerView()
            case 2:   ///
                break
            default:
                break
            }
        }
    }
    
    
    
    
    private func callAlertController(title:String,rowofIndex row:Int) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        //設置字型和大小
        let titleFont = UIFont(name: "PingFangTC-Medium", size: 17.0)
        let attributedString = NSAttributedString(string: "修改\(title)", attributes: [
            NSFontAttributeName : titleFont!
            ])
        alertController.setValue(attributedString, forKey: "attributedTitle")
        
        
        let cancelAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (action) in
            
        }
        let OKAction = UIAlertAction.init(title: "確定", style: UIAlertActionStyle.default) { (action) in
            
            let textField = (alertController.textFields?.first)! as UITextField
            self.checkAndSetValue(value:textField.text!,row: row)
            print("\(textField.text!)")
        }
        
        //OKAction.setValue(UIColor.purple, forKey:"titleTextColor")
        
        alertController.addTextField { (textfield) in
            
            textfield.placeholder = ""
            textfield.delegate = self ///
            textfield.font = UIFont(name: "PingFangTC-Medium", size: 13)
            
            if row == 0{
                textfield.keyboardType = .default
            }else{
                textfield.keyboardType = .decimalPad
            }
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func checkAndSetValue(value:String,row: Int){
        //姓名
        if row == 0{
            if value != ""{
                userInfo.name  = value
                self.app.saveContext()
                self.tableView.reloadData()
            }else{
                userInfo.name  = nil
                self.app.saveContext()
                self.tableView.reloadData()
            }
        }
        //身高
        if row == 3{
            if let height = Double(value){
                userInfo.height  =  height
                self.app.saveContext()
                self.tableView.reloadData()
            }else{
                userInfo.height  = 0
                self.app.saveContext()
                self.tableView.reloadData()
            }
        }
        //體重
        if row == 4{
            if let weight = Double(value){
                userInfo.weight  =  weight
                self.app.saveContext()
                self.tableView.reloadData()
            }else{
                userInfo.weight  = 0
                self.app.saveContext()
                self.tableView.reloadData()
            }
        }
//        //平均心律
//        if row == 5{
//            if let heartRate = Double(value){
//                userInfo.averageHeartRate  =  heartRate
//                self.app.saveContext()
//                self.tableView.reloadData()
//            }else{
//                userInfo.averageHeartRate  = 0
//                self.app.saveContext()
//                self.tableView.reloadData()
//            }
//        }
        //體脂肪
        if row == 5{
            if let bodyFatRate = Double(value) {
                userInfo.bodyFatRate  =  bodyFatRate
                self.app.saveContext()
                self.tableView.reloadData()
            }else{
                userInfo.bodyFatRate  = 0
                self.app.saveContext()
                self.tableView.reloadData()
            }
        }
    }
    
    private func showDatePicker() {
        
        let myDatePicker = UIDatePicker()
        myDatePicker.datePickerMode = .date
        myDatePicker.locale = Locale(identifier: "zh_TW")
    }
    
    private func showGenderPickerView(){
        
        self.view.addSubview(maskView)
        self.view.addSubview(pickView)
        maskView.alpha = 0
        //設定pickerView與螢幕等寬
        UIView.animate(withDuration: 0.3) {   //view移動動畫
            self.maskView.alpha = 0.49
            self.pickView.frame.origin.y = self.view.frame.height-self.pickView.frame.height
        }
    }
}








extension DetailUserInfoViewController:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return 1
        }
        if section == 1 {
            return 6
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profilePhotoCell") as! ProfilePhotoCell
            cell.separatorInset = UIEdgeInsets.zero
            cell.delegate = self
            
            if let nsData = userInfo.profilePhoto{
                let image =  UIImage(data: nsData as Data)
                cell.profilePhotoButton.setImage(image?.withRenderingMode(.automatic), for: .normal) ///
            }else{
                cell.profilePhotoButton.setImage(#imageLiteral(resourceName: "photoCamera").withRenderingMode(.alwaysOriginal), for: .normal)
                cell.profilePhotoButton.backgroundColor = .white
            }
            return cell
        }
        
        if indexPath.section == 1 {
            
            if indexPath.row == 2 { //客製化出生年月欄位
                
                var cell = tableView.dequeueReusableCell(withIdentifier: "detailUserInfoCell") as! DetailUserInfoCell
                cell.valueTextField.delegate = self  /////
                setupValue(with: &cell, indexPath: indexPath.row)
                cell.valueLabel.isHidden = true
                cell.valueTextField.isHidden = false
                cell.valueTextField.tag = 100 /////
                cell.valueTextField.addTarget(self, action: #selector(self.dateTextInputPressed(sender:)), for: UIControlEvents.editingDidBegin)
                
                return cell
            } else {
                
                var cell = tableView.dequeueReusableCell(withIdentifier: "detailUserInfoCell") as! DetailUserInfoCell
                setupValue(with: &cell, indexPath: indexPath.row)
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
    ///出生年月日按下去觸發
    func dateTextInputPressed(sender: UITextField) {
        
        let maskView = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenheight))
        maskView.backgroundColor = .black
        maskView.alpha = 0.49
        
        let gesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.cancelButton))
        maskView.addGestureRecognizer(gesture)
        maskView.tag = 50 ///
        self.view.addSubview(maskView)
        
        let datePickerView = UIDatePicker()
        datePickerView.sizeToFit()
        datePickerView.datePickerMode = .date
        datePickerView.backgroundColor = .white
        datePickerView.locale = Locale(identifier: "zh_TW")
        
        if let nsDate = userInfo.birthday{
            datePickerView.date = nsDate as Date
        }else{
            datePickerView.date = Date()
        }
        datePickerView.tag = 150 ///
        
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 14/255, green: 126/255, blue: 254/255, alpha: 1)
        toolBar.backgroundColor = UIColor(red: 221/255, green: 224/255, blue: 229/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "完成", style: .plain, target: self,action: #selector(self.doneButton))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(self.cancelButton))
        
        //        toolBar.addSubview()    //增加title用
        toolBar.setItems([cancelButton,spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        sender.inputView = datePickerView
        sender.inputAccessoryView = toolBar
        
        //        datePickerView.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: UIControlEvents.valueChanged)
        
    }
    
    func doneButton(sender:Any,picker:UIDatePicker){
        
        let birthDayTextField = self.view?.viewWithTag(100) as? UITextField
        let datePickerView = birthDayTextField?.inputView as? UIDatePicker
        userInfo.birthday =  datePickerView?.date as NSDate? ///
        app.saveContext()
        self.tableView.reloadData()
        birthDayTextField?.resignFirstResponder()
        let maskView = self.view?.viewWithTag(50)
        maskView?.removeFromSuperview()
        
    }
    
    func cancelButton(sender:Any){
        if let _ = sender as? UIButton{
            let birthDayTextField = self.view?.viewWithTag(100) as? UITextField
            birthDayTextField?.resignFirstResponder()
            let maskView = self.view?.viewWithTag(50)
            maskView?.removeFromSuperview()
        }else{ //按下陰影跳出DatePicker
            let birthDayTextField = self.view?.viewWithTag(100) as? UITextField
            birthDayTextField?.resignFirstResponder()
            let maskView = self.view?.viewWithTag(50)
            maskView?.removeFromSuperview()
        }
    }
    
    //暫時寫在這 寫在cell會比較好
    private func setupValue(with cell: inout DetailUserInfoCell ,indexPath:Int) {
        
        switch indexPath {
        case 0:
            cell.titleLabel.text = "姓名"
            if let name = userInfo.name{
                cell.valueLabel.text = name
                cell.valueLabel.textColor = .darkishBlue
            }else{
                cell.valueLabel.text = "預設值"
                cell.valueLabel.textColor = .purpleyGrey
            }
        case 1:
            cell.titleLabel.text = "性別"
            
            if let gender = userInfo.gender{
                cell.valueLabel.text = gender
                cell.valueLabel.textColor = .darkishBlue
            }else{
                cell.valueLabel.text = "預設值"
                cell.valueLabel.textColor = .purpleyGrey
            }
        case 2:
            cell.titleLabel.text = "出生年月"
            if let birthday:NSDate = userInfo.birthday{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy年M月dd日"
                let birthday:String = dateFormatter.string(from: birthday as Date)
                
                cell.valueTextField.text = birthday /////
                cell.valueTextField.textColor = .darkishBlue
            }else{
                cell.valueTextField.text = "預設值"
                cell.valueTextField.textColor = .purpleyGrey
            }
        case 3:
            cell.titleLabel.text = "身高"
            if  userInfo.height != 0{
                cell.valueLabel.text = String(userInfo.height)
                cell.valueLabel.textColor = .darkishBlue
            }else{
                cell.valueLabel.text = "預設值"
                cell.valueLabel.textColor = .purpleyGrey
            }
        case 4:
            cell.titleLabel.text = "體重"
            if  userInfo.weight != 0{
                cell.valueLabel.text = String(userInfo.weight)
                cell.valueLabel.textColor = .darkishBlue
            }else{
                cell.valueLabel.text = "預設值"
                cell.valueLabel.textColor = .purpleyGrey
            }
//        case 5:
//            cell.titleLabel.text = "平均心律"
//            if userInfo.averageHeartRate != 0{
//                cell.valueLabel.text = String(userInfo.averageHeartRate )
//                cell.valueLabel.textColor = .darkishBlue
//            }else{
//                cell.valueLabel.text = "預設值"
//                cell.valueLabel.textColor = .purpleyGrey
//            }
        case 5:
            cell.titleLabel.text = "體脂肪"
            if  userInfo.bodyFatRate != 0 {
                cell.valueLabel.text = String(userInfo.bodyFatRate)
                cell.valueLabel.textColor = .darkishBlue
            }else{
                cell.valueLabel.text = "預設值"
                cell.valueLabel.textColor = .purpleyGrey
            }
        default:
            break
        }
    }
}


extension DetailUserInfoViewController:ProfilePhotoCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func selectPhotofromAlbum( sender: UIButton) {
        
        if (Authorization.check.photoLibrary { self.present($0! , animated: true, completion: nil)})
        {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //獲取選取的圖片
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            let imageData = UIImageJPEGRepresentation(image, 1.0)!
            userInfo.profilePhoto = imageData as NSData
            self.app.saveContext()
            tableView.reloadData()
        }else{
            
            print("選到的圖片不能轉成UIImage")
        }
        picker.dismiss(animated: true, completion:nil)
    }
    
    private func notifyUserAnMessage(message: String,messageTitle:String) {
        
        let alertController = UIAlertController(title: messageTitle,
                                                message: message,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "我知道了",
                                     style: .default,
                                     handler: nil)
        
        alertController.addAction(okAction)
        
        self.present(alertController,
                     animated: true, completion: nil)
    }
}
