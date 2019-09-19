//
//  forgotPasswordViewController.swift
//  quitic3
//
//  Created by APPLE on 8/20/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import Localize_Swift
import MaterialComponents.MaterialSnackbar
import Alamofire
import AlamofireObjectMapper
import SwiftyJSON
import ANLoader
import ObjectMapper

class forgotPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailAddressLabel: UITextField!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var sendBtn: UIButton!
    var accountManager = AccountManager()
    var currentLanguage = ""
    @objc func setText(){
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
        if self.currentLanguage == "en"{
            self.forgotPasswordLabel.text = "forgot your password?"
            self.forgotPasswordLabel.font = UIFont(name: enLanguageConstant, size: 17)!
            
            self.emailAddressLabel.placeholder = "email address"
            self.emailAddressLabel.font = UIFont(name: enLanguageConstant, size: 17)!
            
            self.sendBtn.setTitle("send", for: .normal)
            self.sendBtn.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
        }
        else{
            self.forgotPasswordLabel.text = "هل نسيت كلمة المرور؟"
            self.forgotPasswordLabel.font = UIFont(name: arLanguageConstant, size: 17)!
            
            self.emailAddressLabel.placeholder = "عنوان البريد الإلكتروني"
            self.emailAddressLabel.font = UIFont(name: arLanguageConstant, size: 17)!
            
            self.sendBtn.setTitle("إرسال", for: .normal)
            self.sendBtn.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
        }
        self.checkLanguage()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        setText()
        CommonManager.shared.addLeftImageToTextFields(txtField: self.emailAddressLabel, txtImg: UIImage(named: "message")!)
        self.emailAddressLabel.delegate = self
        
        self.checkLanguage()
    }
    
    func checkLanguage(){
        
        var semanticContentAttribute:UISemanticContentAttribute = .forceLeftToRight
        if self.currentLanguage  == "ar" {
            semanticContentAttribute = .forceRightToLeft
            self.emailAddressLabel.textAlignment = NSTextAlignment.right;
        }
        else{
            self.emailAddressLabel.textAlignment = NSTextAlignment.left;
        }
        UIView.appearance().semanticContentAttribute = semanticContentAttribute
        UINavigationBar.appearance().semanticContentAttribute = semanticContentAttribute
        UITextField.appearance().semanticContentAttribute = semanticContentAttribute
        UITextView.appearance().semanticContentAttribute = semanticContentAttribute
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        var touch: UITouch? = touches.first
        if touch?.view != self.mainView {
            dismiss(animated: true)
        }
        self.view.endEditing(true)
    }
    
    
    //Pressing Return should also hide
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func sendClicked(_ sender: Any) {
        if self.emailAddressLabel.text == "" {
            let message = MDCSnackbarMessage()
            if self.currentLanguage == "en"{
                message.text = "Please enter your email"
            }
            else{
                message.text = "رجاءا أدخل بريدك الإلكتروني"
            }
            MDCSnackbarManager.show(message)
            return
        }
        else  if self.emailAddressLabel.text != ""{
            if  !CommonManager.shared.isValidEmail(testStr:self.emailAddressLabel.text!){
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
        //PutPlaceOrder
        let accountParams: Parameters = [
            "email": self.emailAddressLabel.text,
            "template": "email_reset",
            "websiteId": 1
        ]
        accountManager.PutForgetPassword(postParams: accountParams) { (result , error) in
            if error == nil{
                let message = MDCSnackbarMessage()
                if self.currentLanguage == "en"{
                    message.text = "Your request is sent check your email account"
                }
                else{
                    message.text = "يتم إرسال طلبك التحقق من حساب البريد الإلكتروني الخاص بك"
                }
                MDCSnackbarManager.show(message)
                self.dismiss(animated: true, completion: nil)
            }
            else{
                print(error!)
                let message = MDCSnackbarMessage()
                if self.currentLanguage == "en"{
                    message.text = "Error in sending request please try later"
                }
                else{
                    message.text = "خطأ في إرسال الطلب ، يرجى المحاولة لاحقًا"
                }
                MDCSnackbarManager.show(message)
            }
            //Move On Next
          
        }
    } 
}
