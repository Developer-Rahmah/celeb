//
//  contactUsViewController.swift
//  quitic3
//
//  Created by DOT on 8/20/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import WebKit
import ANLoader
import MaterialComponents.MaterialSnackbar

class contactUsViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var addressImage: UIImageView!
    @IBOutlet weak var phoneImage: UIImageView!
    @IBOutlet weak var messageImage: UIImageView!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var userMessageLabel: UILabel!
    
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var userMessage: UITextField!
    
    @IBOutlet weak var sendBtn: UIButton!
    let manager = ContactUsManager()
    var lblHeader = UILabel()
    
    var currentLanguage: String = "en"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addressImage.tintColor = UIColor.quiticPink
        self.phoneImage.tintColor = UIColor.quiticPink
        self.messageImage.tintColor = UIColor.quiticPink

        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
        
        if self.currentLanguage == "en"{
           // self.title = "Contact Us"
            addressLabel.text = "Amman, Jordan"
            addressLabel.textAlignment = .left
            addressLabel.font = UIFont(name: enLanguageConstant, size: 17)!
            phoneLabel.text = "00962799933717"
            phoneLabel.textAlignment = .left
            phoneLabel.font = UIFont(name: enLanguageConstant, size: 17)!
            userMessageLabel.text = "info@celebritiescart.com"
            userMessageLabel.textAlignment = .left
            userMessageLabel.font = UIFont(name: enLanguageConstant, size: 17)!
            
            fullName.textAlignment = .left
            fullName.font = UIFont(name: enLanguageConstant, size: 17)!
            fullName.placeholder = "Full Name"
            
            emailAddress.textAlignment = .left
            emailAddress.font = UIFont(name: enLanguageConstant, size: 17)!
            emailAddress.placeholder = "Email Address"
            
            userMessage.textAlignment = .left
            userMessage.font = UIFont(name: enLanguageConstant, size: 17)!
            userMessage.placeholder = "Your Message"
            
            self.sendBtn.setTitle("Send", for: .normal)
            self.sendBtn.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
            
            
            
        }
        else{
            //self.title = "اتصل بنا"
            addressLabel.text = "Amman, Jordan"
            addressLabel.textAlignment = .right
            addressLabel.font = UIFont(name: arLanguageConstant, size: 17)!
            phoneLabel.text = "00962799933717"
            phoneLabel.textAlignment = .right
            phoneLabel.font = UIFont(name: enLanguageConstant, size: 17)!
            userMessageLabel.text = "info@celebritiescart.com"
            userMessageLabel.textAlignment = .right
            userMessageLabel.font = UIFont(name: arLanguageConstant, size: 17)!
            
            
            fullName.textAlignment = .right
            fullName.font = UIFont(name: arLanguageConstant, size: 17)!
            fullName.placeholder = "الاسم الكامل"
            
            emailAddress.textAlignment = .right
            emailAddress.font = UIFont(name: arLanguageConstant, size: 17)!
            emailAddress.placeholder = "عنوان البريد الإلكتروني"
            
            userMessage.textAlignment = .right
            userMessage.font = UIFont(name: arLanguageConstant, size: 17)!
            userMessage.placeholder = "رسالتك"
            
            self.sendBtn.setTitle("إرسال", for: .normal)
            self.sendBtn.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
        }
        
        CommonManager.shared.addLeftImageToTextFields(txtField: self.fullName, txtImg: UIImage(named: "person")!)
        CommonManager.shared.addLeftImageToTextFields(txtField: self.emailAddress, txtImg: UIImage(named: "message")!)
        CommonManager.shared.addLeftImageToTextFields(txtField: self.userMessage, txtImg: UIImage(named: "chat")!)
        
        self.emailAddress.delegate = self
        self.fullName.delegate = self
        self.userMessage.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lblHeader = UILabel.init(frame:  CGRect(x: view.frame.size.width / 2 - 75, y: -11, width: 150, height: 50))
       
        lblHeader.font = UIFont.init(name: headerFont, size: 30)
        lblHeader.textAlignment = .center
        lblHeader.textColor = UIColor.init(red: 251, green: 96, blue: 127)
        

        if self.currentLanguage == "en"
        {
            lblHeader.text = "Contact Us"
            lblHeader.font = UIFont.init(name: enMarselLanguageConstant, size: 23)
        }
        else
        {
            lblHeader.text = "اتصل بنا"
            lblHeader.font = UIFont.init(name: arLanguageConstant, size: 23)
        }

        self.navigationController?.navigationBar.addSubview(lblHeader)
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        lblHeader.removeFromSuperview()
    }
    
    
    //Hide keyboard when user presses outside the field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Pressing Return should also hide
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func loader(message: String){
        ANLoader.activityColor = .quiticPink
        ANLoader.pulseAnimation = false
        ANLoader.activityBackgroundColor = .clear
        ANLoader.activityTextColor = .clear
        ANLoader.showLoading("",disableUI: true)
    }
    
    func disableLoader(){
        ANLoader.hide()
    }
    
    @IBAction func sendBtnClicked(_ sender: Any) {
        
        if fullName.text == "" {
            
            let message = MDCSnackbarMessage()
            if self.currentLanguage == "en"{
                message.text = "Please enter your full name"
            }
            else{
                message.text = "من فضلك ادخل اسمك الكامل"
            }
            MDCSnackbarManager.show(message)
            return
            /* Executes when the none of the above condition is true */
        }else if emailAddress.text == "" {
            
            let message = MDCSnackbarMessage()
            if self.currentLanguage == "en"{
                message.text = "Please enter your email address"
            }
            else{
                message.text = "الرجاء إدخال عنوان البريد الإلكتروني الخاص بك"
            }
            
            MDCSnackbarManager.show(message)
            return
            /* Executes when the none of the above condition is true */
        }else if emailAddress.text != ""{
            if !isValidEmail(testStr:emailAddress.text!){
                let message = MDCSnackbarMessage()
                if self.currentLanguage == "en"{
                    message.text = "Please enter valid email address"
                }
                else{
                    message.text = "الرجاء إدخال عنوان بريد إلكتروني صالح"
                }
                MDCSnackbarManager.show(message)
                return
            }
        }
        else if userMessage.text == "" {
            
            let message = MDCSnackbarMessage()
            if self.currentLanguage == "en"{
                message.text = "Please enter your message"
            }
            else{
                message.text = "أدخل رسالتك"
            }
            
            MDCSnackbarManager.show(message)
            return
            /* Executes when the none of the above condition is true */
        }

        self.loader(message: "")
        manager.GetContactUsRequest(fullname: fullName.text!, email: emailAddress.text! , message: userMessage.text!)
            { (response , error) in
                
                if response != "" {
                    let message = MDCSnackbarMessage()
                    if self.currentLanguage == "en"{
                        message.text = "The email has been sent!"
                    }
                    else{
                        message.text = "تم إرسال البريد الإلكتروني!"
                    }
                    self.fullName.text = ""
                    self.emailAddress.text = ""
                    self.userMessage.text = ""
                    ANLoader.hide()
                    MDCSnackbarManager.show(message)
                }
                else{
                     let message = MDCSnackbarMessage()
                    if self.currentLanguage == "en"{
                        message.text = "Error occured while posting email"
                    }
                    else{
                        message.text = "حدث خطأ أثناء نشر البريد الإلكتروني"
                    }
                    
                    ANLoader.hide()
                    MDCSnackbarManager.show(message)
                }
            }
        }
    
}
