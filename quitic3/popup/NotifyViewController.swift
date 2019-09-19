//
//  NotifyViewController.swift
//  quitic3
//
//  Created by ZWT on 5/15/19.
//  Copyright © 2019 DOT. All rights reserved.
//

import UIKit
import Localize_Swift
import MaterialComponents.MaterialSnackbar
import Alamofire
import AlamofireObjectMapper
import SwiftyJSON
import ANLoader
import ObjectMapper
import CoreData

class NotifyViewController: UIViewController {
    
    @IBOutlet weak var viewNotifyMe: UIView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnRemember: UIButton!
    @IBOutlet weak var txtMobileNumber: UITextField!
    
    @IBOutlet weak var lblRememberMe: UILabel!
    @IBOutlet weak var lblAddMobileNumber: UILabel!
    @IBOutlet weak var imgRememberMe: UIImageView!
    var currentLanguage = ""
    var productId:String = ""
    let userManager = UserManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        setText()
        CommonManager.shared.addLeftImageToTextFields(txtField: self.txtMobileNumber, txtImg: UIImage(named: "phone")!)
        
        
        btnSend.layer.cornerRadius = 5.0
        btnCancel.layer.cornerRadius = 5.0
        viewNotifyMe.layer.cornerRadius = 10.0
        
        
        if let strMobileNumber:String = UserDefaults.standard.value(forKeyPath: "phoneNumber") as? String
       {
            if strMobileNumber != ""
            {
                txtMobileNumber.text = strMobileNumber
                imgRememberMe.image = UIImage.init(named: "Rselected")
            }
            else
            {
                imgRememberMe.image = UIImage.init(named: "Runselected")
            }
       }
        else
        {
            imgRememberMe.image = UIImage.init(named: "Runselected")
        }
        
         checkLanguage()
    }
    
   
    @objc func setText(){
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
        if self.currentLanguage == "en"{
            
           // lblAddMobileNumber.text = ""
           // self.lblAddMobileNumber.font = UIFont(name: enLanguageConstant, size: 17)!
            
            self.txtMobileNumber.placeholder = "Enter Your Mobile Number"
            self.txtMobileNumber.font = UIFont(name: enLanguageConstant, size: 17)!
            
            self.btnCancel.setTitle("Cancel", for: .normal)
            self.btnCancel.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
            
            self.btnSend.setTitle("Send", for: .normal)
            self.btnSend.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
            
            lblRememberMe.text = "Remember Me"
            self.lblRememberMe.font = UIFont(name: enLanguageConstant, size: 12)!
        }
        else{
            
          //  lblAddMobileNumber.text = "إضافة رقم الجوال"
          //  self.lblAddMobileNumber.font = UIFont(name: arLanguageConstant, size: 17)!
            
            self.txtMobileNumber.placeholder = "أدخل رقم هاتفك المحمول"
            self.txtMobileNumber.font = UIFont(name: arLanguageConstant, size: 17)!
            
            self.btnCancel.setTitle("الغاء", for: .normal)
            self.btnCancel.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            
            self.btnSend.setTitle("إرسال", for: .normal)
            self.btnSend.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            
             lblRememberMe.text = "تذكرنى"
             self.lblRememberMe.font = UIFont(name: arLanguageConstant, size: 12)!
        }
    }
    
    func checkLanguage(){
        
        var semanticContentAttribute:UISemanticContentAttribute = .forceLeftToRight
        if self.currentLanguage  == "ar" {
            semanticContentAttribute = .forceRightToLeft
            self.txtMobileNumber.textAlignment = NSTextAlignment.right;
        }
        else{
            self.txtMobileNumber.textAlignment = NSTextAlignment.left;
        }
        UIView.appearance().semanticContentAttribute = semanticContentAttribute
        UINavigationBar.appearance().semanticContentAttribute = semanticContentAttribute
        UITextField.appearance().semanticContentAttribute = semanticContentAttribute
        UITextView.appearance().semanticContentAttribute = semanticContentAttribute
        
    }
    
    
    
    @IBAction func btnCancelTap(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func btnSendTap(_ sender: Any) {
        
        //txtTelephone
        if(txtMobileNumber.text == "" || txtMobileNumber.text == nil){
            let message = MDCSnackbarMessage()
            if self.currentLanguage == "en"{
                message.text = "Please enter mobile number"
            }
            else{
                message.text = "الرجاء إدخال رقم الجوال"
            }
            MDCSnackbarManager.show(message)
            return
        }
        else if txtMobileNumber.text != ""{
            
            let phoneNumberValidator = txtMobileNumber.text!.isPhoneNumber
            
            if phoneNumberValidator == false
            {
                let message = MDCSnackbarMessage()
                if self.currentLanguage == "en"
                {
                    message.text = "Mobile number should be 10 digits"
                }
                else{
                    message.text = "يجب أن يكون رقم الجوال 10 أرقام"
                }
                MDCSnackbarManager.show(message)
                return
            }
        }
        
        if imgRememberMe.image == UIImage.init(named: "Rselected")
        {
            UserDefaults.standard.set(txtMobileNumber.text, forKey: "phoneNumber")
            UserDefaults.standard.synchronize()
        }
        
        sendNotifyInfo()
        
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        dismiss(animated: true)
//    }
//
    @IBAction func btnRememberTap(_ sender: Any)
    {
        //txtTelephone
        if(txtMobileNumber.text == "" || txtMobileNumber.text == nil){
            let message = MDCSnackbarMessage()
            if self.currentLanguage == "en"{
                message.text = "Please enter mobile number"
            }
            else{
                message.text = "الرجاء إدخال رقم الجوال"
            }
            MDCSnackbarManager.show(message)
            return
        }
        
        if imgRememberMe.image == UIImage.init(named: "Runselected")
        {
            UserDefaults.standard.set(txtMobileNumber.text, forKey: "phoneNumber")
            UserDefaults.standard.synchronize()
            
            imgRememberMe.image = UIImage.init(named: "Rselected")
        }
        else
        {
            imgRememberMe.image = UIImage.init(named: "Runselected")
        }
    }
    
    func sendNotifyInfo()
    {
        userManager.SendNotifyInfo(productId: productId, phoneNumber: txtMobileNumber.text!) { (result) in
            let message = MDCSnackbarMessage()
            if result != "" {
                
                message.text = result
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            else
            {

            }
             MDCSnackbarManager.show(message)
        }
    }

}
