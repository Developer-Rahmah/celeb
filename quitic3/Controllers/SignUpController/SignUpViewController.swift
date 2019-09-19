//
//  SignUpViewController.swift
//  quitic3
//
//  Created by DOT on 7/16/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialSnackbar
import Localize_Swift
import ActiveLabel
import SwiftyJSON


//import SwiftyJSON

class SignUpViewController: UIViewController, UITextFieldDelegate {
    var testBtn = UIButton()
    var testLbl = UILabel()
    var pushed: Int = 0
    var currentLanguage = ""
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtContactNo: UITextField!
    @IBOutlet weak var MainContentView: UIView!
    var imgViewNavCenter = UIImageView()

    @IBOutlet weak var termsLabel: ActiveLabel!
    
    @IBOutlet weak var customNavBar: UINavigationBar!
    
    @IBOutlet weak var cancelNavBarBtn: UIBarButtonItem!
    
    @IBOutlet weak var createAccount: UILabel!
    
    @IBOutlet weak var iStripImage: UIImageView!
    
    let navBarTitleImage = UIImage(named: "MyBoutiques")
    
    let button = UIButton(type: UIButtonType.custom)
    
    
    @objc func setText(){
        print("Sign Up Set Text")
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
        if self.currentLanguage  == "en"{
            txtFirstName.placeholder = "First Name"
            txtFirstName.font = UIFont(name: enLanguageConstant, size: 17)!
            
            txtLastName.placeholder = "Last Name"
            txtLastName.font = UIFont(name: enLanguageConstant, size: 17)!
            
            txtEmailAddress.placeholder = "Your email"
            txtEmailAddress.font = UIFont(name: enLanguageConstant, size: 17)!
            
            txtContactNo.placeholder = "Mobile Number"
            txtContactNo.font = UIFont(name: enLanguageConstant, size: 17)!
            
            txtPassword.placeholder = "Password"
            txtPassword.font = UIFont(name: enLanguageConstant, size: 17)!
            
            let termsType = ActiveType.custom(pattern: "\\sTerms and conditions\\b")
            let privacyType = ActiveType.custom(pattern: "\\sPrivacy Policy\\b")
            let refundType = ActiveType.custom(pattern: "\\sRefund Policy\\b")
            termsLabel.enabledTypes = [.mention, .hashtag, .url, privacyType, refundType, termsType]
            
            termsLabel.text = " Terms and conditions , Privacy Policy and Refund Policy "
            termsLabel.font = UIFont(name: enLanguageConstant, size: 13)!
            
            termsLabel.customColor[termsType] = UIColor.accentBlue
            termsLabel.customSelectedColor[termsType] = UIColor.accentBlue
            
            termsLabel.customColor[privacyType] = UIColor.accentBlue
            termsLabel.customSelectedColor[privacyType] = UIColor.accentBlue
            
            termsLabel.customColor[refundType] = UIColor.accentBlue
            termsLabel.customSelectedColor[refundType] = UIColor.accentBlue

            termsLabel.handleCustomTap(for: termsType) { element in
                print("here termsType tapped: \(element)")
                let webViewController = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
                
                webViewController.type = "termsAndCondition"
                
                self.present(webViewController, animated: true)
                
//                self.navigationController?.pushViewController(webViewController, animated: true)
                
            }
            
            termsLabel.handleCustomTap(for: privacyType) { element in
                print("privacyType tapped: \(element)")
                
                let webViewController = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
                
                webViewController.type = "privacyPolicy"
                
                self.present(webViewController, animated: true)
                
            }
            termsLabel.handleCustomTap(for: refundType) { element in
                print("refundType tapped: \(element)")
                
                let webViewController = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
                
                webViewController.type = "refundPolicy"
                
                self.present(webViewController, animated: true)
                
            }
            
            btnRegisterlbl.setTitle("Register", for: .normal)
            self.btnRegisterlbl.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
            
            btnAlreadylbl.setTitle("Already have an account?Login", for: .normal)
            self.btnAlreadylbl.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
            
            
            self.cancelNavBarBtn.image = UIImage(named: "icons8-back-50")
            
            self.createAccount.text = "Creating an account means you're okay with our"
            self.createAccount.font = UIFont(name: enLanguageConstant, size: 13)!
            
            
        }
        else{
            let termsType = ActiveType.custom(pattern: "الشروط\\sوالأحكام")
            let privacyType = ActiveType.custom(pattern: "سياسة\\sالخصوصية")
            let refundType = ActiveType.custom(pattern: "وسياسة\\sرد\\sالأموال")
            
            txtFirstName.placeholder = "الاسم الاول"
            txtFirstName.font = UIFont(name: arLanguageConstant, size: 17)!
            
            txtLastName.placeholder = "الاسم الاخير"
            txtLastName.font = UIFont(name: arLanguageConstant, size: 17)!
            
            txtEmailAddress.placeholder = "بريدك الالكتروني"
            txtEmailAddress.font = UIFont(name: arLanguageConstant, size: 17)!
            
            txtContactNo.placeholder = "رقم الهاتف"
            txtContactNo.font = UIFont(name: arLanguageConstant, size: 17)!
            
            txtPassword.placeholder = "كلمة المرور"
            txtPassword.font = UIFont(name: arLanguageConstant, size: 17)!
            
            termsLabel.enabledTypes = [.mention, .hashtag, .url, termsType, privacyType, refundType]
            
            
            termsLabel.text = "الشروط والأحكام ، سياسة الخصوصية وسياسة رد الأموال"
            termsLabel.font = UIFont(name: arLanguageConstant, size: 13)!
            
            termsLabel.customColor[termsType] = UIColor.accentBlue
            termsLabel.customSelectedColor[termsType] = UIColor.accentBlue
            
            termsLabel.customColor[privacyType] = UIColor.accentBlue
            termsLabel.customSelectedColor[privacyType] = UIColor.accentBlue
            
            termsLabel.customColor[refundType] = UIColor.accentBlue
            termsLabel.customSelectedColor[refundType] = UIColor.accentBlue
            
            termsLabel.handleCustomTap(for: termsType) { element in
                print("termsType tapped: \(element)")
                
                let webViewController = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
                
                webViewController.type = "termsAndCondition"
                
                self.present(webViewController, animated: true)
                
            }
            
            termsLabel.handleCustomTap(for: privacyType) { element in
                print("privacyType tapped: \(element)")
                
                let webViewController = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
                
                webViewController.type = "privacyPolicy"
                
                self.present(webViewController, animated: true)
                
            }
            termsLabel.handleCustomTap(for: refundType) { element in
                print("refundType tapped: \(element)")
                let webViewController = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
                
                webViewController.type = "refundPolicy"
                
                self.present(webViewController, animated: true)
                
            }
            btnRegisterlbl.setTitle("تسجيل", for: .normal)
            btnRegisterlbl.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            
            
            btnAlreadylbl.setTitle("هل لديك حساب بالفعل؟ تسجيل الدخول", for: .normal)
            btnAlreadylbl.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            
            self.cancelNavBarBtn.image = UIImage(named: "rightPointing")
            
            self.createAccount.text = "إنشاء حساب يعني انك موافق على"
            createAccount.font = UIFont(name: arLanguageConstant, size: 13)!
        }
        self.checkLanguage()
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        button.setTitle("Return", for: UIControlState())
        button.setTitleColor(UIColor.black, for: UIControlState())
        button.frame = CGRect(x: 0, y: 163, width: 106, height: 53)
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(Done(_:)), for: UIControlEvents.touchUpInside)
        self.iStripImage.tintColor = UIColor.textPrimaryColor
        
        if pushed != 0 {
            self.customNavBar.isHidden = true
        }
        
        self.navigationItem.titleView = UIImageView(image: navBarTitleImage)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

//        txtFirstName.text = "Muhammad Talha"
//        txtLastName.text = "Afzal"
//        txtEmailAddress.text = "muhammadtalhaafzal12@gmail.com"
//        txtContactNo.text = "0322808768"
//        txtPassword.text = "Admin123"
    
        CommonManager.shared.addLeftImageToTextFields(txtField: txtFirstName, txtImg: UIImage(named: "person")!)
        CommonManager.shared.addLeftImageToTextFields(txtField: txtLastName, txtImg: UIImage(named: "person")!)
        CommonManager.shared.addLeftImageToTextFields(txtField: txtPassword, txtImg: UIImage(named: "lock")!)
        CommonManager.shared.addLeftImageToTextFields(txtField: txtContactNo, txtImg: UIImage(named: "phone")!)
        CommonManager.shared.addLeftImageToTextFields(txtField: txtEmailAddress, txtImg: UIImage(named: "message")!)
        
        self.txtFirstName.delegate = self
        self.txtLastName.delegate = self
        self.txtEmailAddress.delegate = self
        self.txtContactNo.delegate = self
        self.txtPassword.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        
        self.setText()
        self.checkLanguage()
//        initializeTextFields()
    }
    
    // Designate this class as the text fields' delegate
    // and set their keyboards while we're at it.
//    func initializeTextFields() {
//   
//        txtContactNo.keyboardType = UIKeyboardType.numbersAndPunctuation
//        
//    }
    @objc func buttonAction(sender: UIButton!) {
        self.navigationController?.popViewController(animated: true)    }
    override func viewWillAppear(_ animated: Bool) {
        ///added for navigation bar setting.
        //set large size navigation bar image.
        if(self.navigationController?.navigationBar.isHidden == true){
            if self.currentLanguage == "en"
            {
                let image = UIImage(named: "back") as UIImage?
                
                testBtn.setImage(image, for: .normal)
                
                testBtn.frame = CGRect(x: self.view.frame.size.width/100, y: 13, width: 30, height: 50)
                
                testLbl.frame = CGRect(x: 0, y: 65, width: self.view.frame.size.width, height: 1)
                testLbl.backgroundColor = UIColor.gray
                
                //        testBtn.backgroundColor = UIColor.red
                //        testBtn.setTitle("Name your Button ", for: .normal)
                testBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                testLbl.alpha  = 0.5
                self.view.addSubview(testBtn)
                self.view.addSubview(testLbl)
                
            }
            else
            {
                testLbl.frame = CGRect(x: 0, y: 65, width: self.view.frame.size.width, height: 1)
                testLbl.alpha  = 0.5
                
                testLbl.backgroundColor = UIColor.gray
                let image = UIImage(named: "arback") as UIImage?
                
                testBtn.setImage(image, for: .normal)
                
                testBtn.frame = CGRect(x: self.view.frame.size.width/1.1, y: 13, width: 30, height: 50)
                //        testBtn.backgroundColor = UIColor.red
                //        testBtn.setTitle("Name your Button ", for: .normal)
                testBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                self.view.addSubview(testBtn)
                self.view.addSubview(testLbl)
                
            }
            
        }
        
        
        if  (UserDefaults.standard.string(forKey: "token") != nil)
        {
            if self.pushed != 0
            {
                self.navigationController?.popViewController(animated: true)
            }
            else
            {
                self.dismiss(animated: true, completion: nil)
            }
            NotificationCenter.default.post(name: Notification.Name("NotifyLoginStatus"), object: nil)
        }
        
//        imgViewNavCenter = UIImageView(image: UIImage(named: "centerHeader"))
        imgViewNavCenter.frame = CGRect(x: view.frame.size.width / 2 - 51, y: -9, width: 103, height: 100)
        //        imgViewNavCenter.frame = CGRect(x: view.frame.size.width / 2 - 75, y: -15, width: 150, height: 50) //
        
        //change height and width accordingly
        
        
        
        
        //        self.navigationController?.navigationBar.addSubview(imgViewNavCenter)
        //       // customNavBar.addSubview(imgViewNavCenter)
        //
        if self.isBeingPresented
        {
            customNavBar.addSubview(imgViewNavCenter)
        }
        else
        {
            //  self.navigationController?.navigationBar.addSubview(imgViewNavCenter)
        }
        
        
        let titleImgView = UIImageView(frame: CGRect(x: 0, y: 0, width:0, height: 0))
        let image = UIImage(named: "")
        titleImgView.image = image
        navigationItem.titleView = titleImgView
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        imgViewNavCenter.removeFromSuperview()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    @objc func keyboardWillShow(_ note : Notification) -> Void{
        DispatchQueue.main.async { () -> Void in
            self.button.isHidden = true
            let keyBoardWindow = UIApplication.shared.windows.last
            self.button.frame = CGRect(x: 0, y: -11, width: 106, height: 53)
            keyBoardWindow?.addSubview(self.button)
            keyBoardWindow?.bringSubview(toFront: self.button)
            
            UIView.animate(withDuration: (((note.userInfo! as NSDictionary).object(forKey: UIKeyboardAnimationCurveUserInfoKey) as AnyObject).doubleValue)!, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
                self.view.frame = self.view.frame.offsetBy(dx: 0, dy: 0)
            }, completion: { (complete) -> Void in
                print("Complete")
            })
        }
        
    }
    
    @objc func Done(_ sender : UIButton){
        
        DispatchQueue.main.async { () -> Void in
            
            self.txtContactNo.resignFirstResponder()
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkLanguage(){
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
        var semanticContentAttribute:UISemanticContentAttribute = .forceLeftToRight
        if self.currentLanguage  == "ar" {
            semanticContentAttribute = .forceRightToLeft
            self.txtFirstName.textAlignment = NSTextAlignment.right;
            self.txtLastName.textAlignment = NSTextAlignment.right;
            self.txtEmailAddress.textAlignment = NSTextAlignment.right;
            self.txtPassword.textAlignment = NSTextAlignment.right;
            self.txtContactNo.textAlignment = NSTextAlignment.right;
        }
        else{
            self.txtFirstName.textAlignment = NSTextAlignment.left;
            self.txtLastName.textAlignment = NSTextAlignment.left;
            self.txtEmailAddress.textAlignment = NSTextAlignment.left;
            self.txtPassword.textAlignment = NSTextAlignment.left;
            self.txtContactNo.textAlignment = NSTextAlignment.left;
        }
        
        print("checkLanguage: \(Localize.currentLanguage())")
        
        UIView.appearance().semanticContentAttribute = semanticContentAttribute
        UINavigationBar.appearance().semanticContentAttribute = semanticContentAttribute
        UITextField.appearance().semanticContentAttribute = semanticContentAttribute
        UITextView.appearance().semanticContentAttribute = semanticContentAttribute
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBOutlet weak var btnRegisterlbl: UIButton!
    
    
    @IBOutlet weak var btnAlreadylbl: UIButton!
    
    
    
    @IBAction func btnAlreadylblAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true) 
//        let loginViewController = LoginViewController()
//        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    
    /// Validate email string
    ///
    /// - parameter email: A String that rappresent an email address
    ///
    /// - returns: A Boolean value indicating whether an email is valid.
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    

    
    @IBAction func RegisterBtnClicked(_ sender: Any) {
        var userData = UserForm() // struct
        userData.firstName = txtFirstName.text
        userData.lastName = txtLastName.text
        userData.email = txtEmailAddress.text
        userData.contactNo = txtContactNo.text
        userData.password = txtPassword.text
        
        
       // var userData1 = userData.dictionaryRepresentation
        
        

        UserDefaults.standard.set(txtContactNo.text, forKey: "phoneNumber")
        UserDefaults.standard.synchronize()
        
        
        if txtFirstName.text == "" {
            let message = MDCSnackbarMessage()
            if self.currentLanguage == "en"{
                message.text = "Please enter your first name"
            }
            else{
                message.text = "يرجى ادخال الاسم الاول"
            }
            MDCSnackbarManager.show(message)
            return
        } else if txtLastName.text == "" {
            
            let message = MDCSnackbarMessage()
            if self.currentLanguage == "en"{
                message.text = "Please enter your last name"
            }
            else{
                message.text = "الرجاء إدخال اسمك الأخير"
            }
            MDCSnackbarManager.show(message)
            return
            /* Executes when the none of the above condition is true */
        }else if txtEmailAddress.text == "" {
            
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
        }else if txtEmailAddress.text == "" {
            
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
        }else if txtContactNo.text == "" {
            
            let message = MDCSnackbarMessage()
            if self.currentLanguage == "en"{
               message.text = "Please enter your contact no"
            }
            else{
                message.text = "الرجاء إدخال اسمك لا"
            }
            
            MDCSnackbarManager.show(message)
            return
            /* Executes when the none of the above condition is true */
        }
        else if txtContactNo.text != ""{
            
            let phoneNumberValidator = txtContactNo.text!.isPhoneNumber
            
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
        else if txtPassword.text == "" {
            
            let message = MDCSnackbarMessage()
            if self.currentLanguage == "en"{
                message.text = "Please enter your password"
            }
            else{
                message.text = "من فضلك أدخل رقمك السري"
            }
            MDCSnackbarManager.show(message)
            return
            /* Executes when the none of the above condition is true */
        }else if txtEmailAddress.text != ""{
            if !isValidEmail(testStr:txtEmailAddress.text!){
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
        
    
        print("User DATA here:")
       // dump(userData1)
        
        
        APIManager.shared.SignUpRequest(data: userData){(data) -> Void in
            print("From user signup data:")
            print(data)

            if data["hasError"] == false {

//                let dictResponse = data["response"]
//
//
//              //  let responseString = String(data: data, encoding: .utf8)
//
//                let data = dictResponse.string!.data(using: String.Encoding.utf8)
//
//               // let data = dictResponse.data(using: String.Encoding.utf8, allowLossyConversion: false)!
//
//                if let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
//
//                    let arrayCustomAttribute:NSMutableArray = dictResponse["custom_attributes"] as! NSMutableArray
//
//                    if arrayCustomAttribute.count > 0
//                    {
//                        let dictMobileNumber:Custom_attributes = arrayCustomAttribute.object(at: 0) as! Custom_attributes
//
//                        UserDefaults.standard.set(dictMobileNumber.value as! CVarArg, forKey: "phoneNumber")
//                        UserDefaults.standard.synchronize()
//
//                    }
//
//                }

                let message = MDCSnackbarMessage()
                message.text = "Signup successful, Login Now"
                MDCSnackbarManager.show(message)

                RunLoop.current.run(until: NSDate(timeIntervalSinceNow:2) as Date)
                if let navController = self.navigationController {
                    print("poping signup nav")
                    navController.popViewController(animated: true)
                }
                else{
                    self.dismiss(animated: true)
                    print("dismissing signup presentation")
                }



//                self.present(TabViewController, animated: true, completion: nil)
            }
            else{
                let message = MDCSnackbarMessage()

                if data["response"]["message"] == "A customer with the same email already exists in an associated website."{

                    if self.currentLanguage == "en"{
                         message.text = "Account already exists"
                    }
                    else{
                        message.text = "الحساب موجود بالفعل"
                    }
                }

//                print('SignUp Error: \(data["response"]["message"])')
                print("SignUp Error: \(data["response"]["message"])")

                if data["response"]["message"].string?.range(of:"Please enter a password") != nil {

                    if self.currentLanguage == "en"{
                        message.text = "Please enter a password with length of 8 characters including lower case, upper case, digits, special characters."
                    }
                    else{
                        message.text = "الرجاء إدخال كلمة مرور ، كتابة رسالة مخصصة"
                    }
                }
                MDCSnackbarManager.show(message)
                print(data)
            }
        }
    }
    
    @IBAction func btnCancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    

//    func validate(value: String) -> Bool {
//        let PHONE_REGEX = "^[7-9][0-9]{9}$"
//        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
//        let result =  phoneTest.evaluate(with: value)
//        return result
//    }
    
}
extension String {
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count && self.count == 10
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}
