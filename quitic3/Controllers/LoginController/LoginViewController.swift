//
//  LoginViewController.swift
//  quitic3
//
//  Created by APPLE on 7/16/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import SwiftyJSON
import MaterialComponents.MaterialSnackbar
import Localize_Swift
import GoogleSignIn
import FBSDKLoginKit
import AlamofireObjectMapper
import Alamofire
import MaterialComponents.MaterialSnackbar
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate, GIDSignInDelegate,GIDSignInUIDelegate, LoginButtonDelegate {
    var window: UIWindow?
    var pushed: Int = 0
    var imgViewNavCenter = UIImageView()

    @IBOutlet weak var customNavBar: UINavigationBar!
    let userManager = UserManager()
    var testBtn = UIButton()
    var testLbl = UILabel()

    let navBarTitleImage = UIImage(named: "MyBoutiques")
    var currentLanguage = ""
    let socialAccountManager = SocialAccountManager()
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var btnLoginlbl: UIButton!
    
    @IBOutlet weak var googleLoginButton: UIButton!
    
    @IBOutlet weak var facebookLoginOutlet: UIButton!
    
    @IBOutlet weak var iStripImage: UIImageView!
    
    @IBOutlet weak var btnForgettenLbl: UIButton!
    @IBOutlet weak var btnSignUplbl: UIButton!
    @IBOutlet weak var btnCancellbl: UIBarButtonItem!
//    var imgViewNavCenter = UIImageView()
    
    @IBAction func btnCancelClicked(_ sender: Any) {
         dismiss(animated: true, completion: nil)
        let HomeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(HomeViewController, animated: true)
     
    }
    
    @objc func setText(){
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
        if self.currentLanguage == "en"{
            email.placeholder = "Email"
            email.font = UIFont(name: enLanguageConstant, size: 17)!
            
            password.placeholder = "Password"
            password.font = UIFont(name: enLanguageConstant, size: 17)!
            self.btnCancellbl.image = UIImage(named: "icons8-back-50")
            
            
            btnLoginlbl.setTitle("Log In", for: .normal)
            btnLoginlbl.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
            
            btnSignUplbl.setTitle("If you don't have an account? Signup", for: .normal)
            btnLoginlbl.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
            
            btnForgettenLbl.setTitle(" Forget Password ", for: .normal)
            btnForgettenLbl.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
            
            facebookLoginOutlet.setTitle("Facebook Log In", for: .normal)
            facebookLoginOutlet.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
            
            googleLoginButton.setTitle("Google Log In", for: .normal)
            googleLoginButton.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
        }
        else{
            email.placeholder = "البريد الإلكتروني"
            email.font = UIFont(name: arLanguageConstant, size: 17)!
            
            password.placeholder = "كلمة المرور"
            password.font = UIFont(name: arLanguageConstant, size: 17)!
            
//            btnCancellbl.title = "إلغاء"
            self.btnCancellbl.image = UIImage(named: "rightPointing")
            
            btnLoginlbl.setTitle("تسجيل الدخول", for: .normal)
            btnLoginlbl.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            
            btnSignUplbl.setTitle("ليس عضو ؟ تسجيل حساب جديد", for: .normal)
            btnSignUplbl.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            
            btnForgettenLbl.setTitle("نسيت كلمة السر", for: .normal)
            btnForgettenLbl.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            
            facebookLoginOutlet.setTitle("تسجيل دخول بواسطة فيسبوك", for: .normal)
            facebookLoginOutlet.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            
            googleLoginButton.setTitle("تسجيل دخول بواسطة جوجل", for: .normal)
            googleLoginButton.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            
        }
        self.checkLanguage()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        facebookLoginOutlet.isHidden = true;
        googleLoginButton.isHidden = true;
        let height: CGFloat = 20 //whatever height you want to add to the existing height
//        let bounds = self.navigationController!.navigationBar.bounds
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: 200, height: 20)
//        let height = CGFloat(20)
//        self.cus.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
        let backButton = UIBarButtonItem()
        backButton.title = "" //in your case it will be empty or you can put the title of your choice
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        
        self.iStripImage.tintColor = UIColor.textPrimaryColor
        
        if self.pushed != 0 {
            self.customNavBar.isHidden = true
        }
        
      //  self.navigationItem.titleView = UIImageView(image: navBarTitleImage)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //lblvalidation.isHidden = true;
        // Do any additional setup after loading the view
//        addLeftImageToTextFields(txtField: email, txtImg: UIImage(named: "message")!)
//        addLeftImageToTextFields(txtField: password, txtImg: UIImage(named: "lock")!)
        
        CommonManager.shared.addLeftImageToTextFields(txtField: email, txtImg: UIImage(named: "message")!)
        CommonManager.shared.addLeftImageToTextFields(txtField: password, txtImg: UIImage(named: "lock")!)
        
//        email.text = "muhammadtalhaafzal12@gmail.com"
//        password.text = "Admin123"
        
        self.email.delegate = self
        self.password.delegate = self
        
        
        self.checkLanguage()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.setText()
    }
    @objc func buttonAction(sender: UIButton!) {
        self.navigationController?.popViewController(animated: true)    }
    
    override func viewWillAppear(_ animated: Bool) {
        ///added for navigation bar setting.
        //set large size navigation bar image.
//        facebookLoginOutlet.isHidden = true;
//        googleLoginButton.isHidden = true;
         self.navigationController?.navigationBar.isHidden = true

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
        
        
        
        
        imgViewNavCenter = UIImageView(image: UIImage(named: "centerHeader"))
        imgViewNavCenter.frame = CGRect(x: view.frame.size.width / 2 - 51, y: -20, width: 103, height: 50)
       imgViewNavCenter.frame = CGRect(x: view.frame.size.width / 2 - 75, y: 10, width: 150, height: 100) //
        
        //change height and width accordingly
        
        
        
        
//        self.navigationController?.navigationBar.addSubview(imgViewNavCenter)
//customNavBar.addSubview(imgViewNavCenter)
//
        if self.isBeingPresented
        {
//            customNavBar.addSubview(imgViewNavCenter)
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

    
    func loginButton(_ loginButton: FBLoginButton!, didCompleteWith result: LoginManagerLoginResult!, error: Error!)
    {
        print(" didCompleteWith")
        if error != nil
        {
            print("some error")
        }
        else if result.isCancelled{
            print("User cancle login")
        }
        else{
            
            print("User logedin successfully")
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton!) {
    }
    func getProfile(){
        let accesstoken = AccessToken.current;
        guard let accessTokenString = accesstoken?.tokenString else {return}
        GraphRequest(graphPath: "/me", parameters: ["fields" : "id, name, first_name, last_name, email, birthday, picture"]).start { (connection, result, err) in
            if(err != nil){
                print("Failed to start GraphRequest", err ?? "")
                return
            }
            print(result ?? "")
            if(result != nil){
                self.sendDetailsForFacebookLogin(result: result as! NSDictionary)
            }else{
            }
        }
    }
//
//    func sendDetailsForFacebookLogin(result:NSDictionary){
//        print("sendDetailsForFacebookLogin")
//        self.socialAccountManager.SigninGoogleAccount(socialId: (result["id"])! as! String, socialType: "facebook") { (response,errorSignin) in
//            if errorSignin != nil{
//                var socialUserData = SocialUserForm(firstName: (result["first_name"])! as! String, lastName: (result["last_name"])! as! String, email: (result["email"])! as! String) // struct
//                APIManager.shared.SocialSignUpRequest(data: socialUserData){(data) -> Void in
//                    if data  != "" {
//                        self.socialAccountManager.SigninGoogleAccountWithCustomerId(socialId: (result["id"])! as! String ,socialType : "facebook", customerId: data) { (response,errorSignin) in
//                            self.socialAccountManager.SigninGoogleAccount(socialId: (result["id"])! as! String, socialType: "facebook") { (response,errorSignin) in
//                                if errorSignin != nil{}
//                                else{
//                                    self.userManager.GetUserRequest(token: response!.string!) { (data, error) in
//                                        if error == nil {
//                                            CommonManager.shared.saveUserCoreData(user: data!, token: response!.string!, completion: { (status) in
//                                                UserDefaults.standard.set(response!.string!, forKey: "token")
//                                                self.dismiss(animated: true, completion: nil)
//                                                NotificationCenter.default.post(name: Notification.Name("NotifyLoginStatus"), object: nil)
//
//                                            })}}}}}}}
//
//            }
//            else
//            {
//                self.userManager.GetUserRequest(token: response!.string!) { (data, error) in
//                    if error == nil {
//                        CommonManager.shared.saveUserCoreData(user: data!, token: response!.string!, completion: { (status) in
//                            UserDefaults.standard.set(response!.string!, forKey: "token")
//                            self.dismiss(animated: true, completion: nil)
//                            NotificationCenter.default.post(name: Notification.Name("NotifyLoginStatus"), object: nil)
//                        })
//                    }
//                }
//            }
//        }
//    }
    
    func sendDetailsForFacebookLogin(result:NSDictionary)
    {
        print("sendDetailsForFacebookLogin")
        
//        let params: Parameters = [
//            "socialId":(result["id"])! as! String,
//            "socialType": "facebook",
//            "firstname": (result["first_name"])! as! String,
//            "lastname": (result["last_name"])! as! String,
//            "email":(result["email"])! as! String
//        ]
        
        //get profile image url
        
        let dictProfileImg:[String:Any] = (result["picture"])! as! [String:Any]
    
        let data:[String:Any] = dictProfileImg["data"] as! [String:Any]!
    
        //profile picture facebook.
        var strProfilePicture:String = ""
        
        if let strProfile:String = data["url"] as! String
        {
            strProfilePicture = strProfile
        }
        
        let str = "?socialId=\((result["id"])! as! String)&email=\((result["email"])! as! String)&firstname=\((result["first_name"])! as! String)&socialType=facebook&lastname=\((result["last_name"])! as! String)"//"&profile_picture=\(strProfilePicture)"

        self.socialAccountManager.SigninSocialAccount(socialSignInParams: str){ (response,errorSignin) in
            if errorSignin != nil
            {
                if(response != nil)
                {
                    self.userManager.GetUserRequest(token: response!.string!) { (data, error) in
                        if error == nil {
                            CommonManager.shared.saveUserCoreData(user: data!, token: response!.string!, completion: { (status) in
                                UserDefaults.standard.set(response!.string!, forKey: "token")

                                UserDefaults.standard.synchronize()

                                if self.pushed != 0
                                {
                                    self.navigationController?.popViewController(animated: true)
                                }
                                else
                                {
                                    self.dismiss(animated: true, completion: nil)
                                }
                                NotificationCenter.default.post(name: Notification.Name("NotifyLoginStatus"), object: nil)
                                
                            })}}
                }
            }
            else
            {
                self.userManager.GetUserRequest(token: response!.string!) { (data, error) in
                    if error == nil {
                        CommonManager.shared.saveUserCoreData(user: data!, token: response!.string!, completion: { (status) in
                            
                            UserDefaults.standard.set(response!.string!, forKey: "token")
                            UserDefaults.standard.synchronize()
                            if self.pushed != 0
                            {
                                self.navigationController?.popViewController(animated: true)
                            }
                            else
                            {
                                self.dismiss(animated: true, completion: nil)
                            }
                            NotificationCenter.default.post(name: Notification.Name("NotifyLoginStatus"), object: nil)
                        })
                    }
                }
            }
            
            
            let message = MDCSnackbarMessage()
            if self.currentLanguage == "en"{
                message.text = "You are login successfully"
            }
            else{
                message.text = "أنت تسجيل الدخول بنجاح"
            }
            MDCSnackbarManager.show(message)
            
            
            
        }
    }

    @IBAction func facebookBtnClicked(_ sender: Any) {
       // loginbutton.readPermissions = ["public_profile","email", "user_friends"]
        //loginbutton.delegate = self
        LoginManager().logIn(permissions: ["email", "public_profile"], from: self) { (result, err) in
            if err != nil{
                return
            }
            else
                if (result?.isCancelled)!{
                    print("User cancle login")
            }else{
                    print(result?.token?.tokenString)
                 self.getProfile()
            }
           
            
        }
    }
    
    @IBAction func googleLoginBtnClicked(_ sender: Any) {
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    @IBAction func signUpBtnClicked(_ sender: Any) {
        
        let desVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        
       
        if self.pushed != 0{
            desVC.pushed = self.pushed
            print("sign up pushing")
            self.navigationController?.pushViewController(desVC, animated: true)
        }
        else{
            print("sign up presenting")
            self.present(desVC, animated: true)
        }
        
    }
    
    func checkLanguage(){
        
        var semanticContentAttribute:UISemanticContentAttribute = .forceLeftToRight
        if self.currentLanguage == "ar" {
            semanticContentAttribute = .forceRightToLeft
            self.email.textAlignment = NSTextAlignment.right;
            self.password.textAlignment = NSTextAlignment.right;
        }
        else{
            self.email.textAlignment = NSTextAlignment.left;
            self.password.textAlignment = NSTextAlignment.left;
        }
        
        UIView.appearance().semanticContentAttribute = semanticContentAttribute
        UINavigationBar.appearance().semanticContentAttribute = semanticContentAttribute
        UITextField.appearance().semanticContentAttribute = semanticContentAttribute
        UITextView.appearance().semanticContentAttribute = semanticContentAttribute
        
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
    
    @IBAction func PostLogin(_ sender: Any) {
         var loginData = LoginForm() // struct
        loginData.email = email.text
        loginData.password = password.text
        if email.text == "" {
            let message = MDCSnackbarMessage()
            if self.currentLanguage == "en"{
                  message.text = "Please enter your email"
            }
            else{
                message.text = "رجاءا أدخل بريدك الإلكتروني"
            }
            MDCSnackbarManager.show(message)
            return
        }else if password.text == "" {
            
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
        }
        else  if email.text != ""{
            if !isValidEmail(testStr:email.text!){
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
        APIManager.shared.PostLoginRequest(data: loginData){(data) -> Void in
           // print(data)
            if !(data["hasError"].bool)! {
                let authToken=data["response"].string
                print("authToken:\(String(describing: authToken))")
                UserDefaults.standard.set(authToken, forKey: "token")
                
//                print("token from api:", data["response"])
                
                self.userManager.GetUserRequest(token: authToken!) { (data, error) in
                    if error == nil {
                        print("GetUserRequest firstname:", data?.firstname!)
                        

                        let arrCustomAttribute:NSArray = data!.custom_attributes! as NSArray
                    
                        if arrCustomAttribute.count > 0
                        {
                            for index in arrCustomAttribute
                            {
                                let dictMobileNo:Custom_attributes = index as! Custom_attributes
                                
                                let strMobileNo:String = dictMobileNo.attribute_code!
                                
                                if strMobileNo == "mobile_no"
                                {
                                    UserDefaults.standard.set(dictMobileNo.value, forKey: "phoneNumber")
                                    UserDefaults.standard.synchronize()
                                }
                            }
                        }
                        CommonManager.shared.saveUserCoreData(user: data!, token: authToken!, completion: { (status) in
                            print(status)
                            
                         UserDefaults.standard.set(data?.id, forKey: "userId")

                            if self.pushed != 0
                            {
                                self.navigationController?.popViewController(animated: true)
                            }
                            else
                            {
                                self.dismiss(animated: true, completion: nil)
                            }
                            NotificationCenter.default.post(name: Notification.Name("NotifyLoginStatus"), object: nil)
                            
                        })
                    }
                    else{
                        print("GetUserRequest:", error)
                    }
                }
    
            }
            else{
                let message = MDCSnackbarMessage()
                
                if self.currentLanguage == "en"{
                    message.text = "Please enter valid username or password"
                }
                else{
                    message.text = "الرجاء إدخال اسم مستخدم أو كلمة مرور صالحة"
                }
                MDCSnackbarManager.show(message)
            }
        }
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

    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let err = error {
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            
            if let err = error
            {
                return
            }
            else
            {
                let user = Auth.auth().currentUser
                let firstName: String = (user?.displayName)!.components(separatedBy: " ")[0]
                let lastName: String? = (user?.displayName)!.components(separatedBy: " ").count > 1 ? (user?.displayName)!.components(separatedBy: " ")[1] : nil
                
                let profilePicture:URL? = (user?.photoURL)
                
                var strProfilePicture:String = ""
                
                if let strProfile:String = profilePicture!.absoluteString
                {
                    strProfilePicture = strProfile
                }
                
                guard let lName = lastName else { return }
                
                let str = "?socialId=\((user?.uid)!)&email=\((user?.email)!)&firstname=\(firstName)&socialType=google&lastname=\(lName)&profile_picture=\(strProfilePicture)"
                //                let params: Parameters = [
                //                    "socialId":(user?.uid)!,
                //                    "socialType": "google",
                //                    "firstname": firstName,
                //                    "lastname": lastName!,
                //                    "email":(user?.email)!
                //                ]
                
                self.socialAccountManager.SigninSocialAccount(socialSignInParams: str){ (response,errorSignin) in
                    if errorSignin != nil
                    {
                        if(response != nil)
                        {
                            self.userManager.GetUserRequest(token: response!.string!) { (data, error) in
                                if error == nil {
                                    CommonManager.shared.saveUserCoreData(user: data!, token: response!.string!, completion: { (status) in
                                        UserDefaults.standard.set(response!.string!, forKey: "token")
                                        if self.pushed != 0
                                        {
                                            self.navigationController?.popViewController(animated: true)
                                        }
                                        else
                                        {
                                            self.dismiss(animated: true, completion: nil)
                                        }
                                        NotificationCenter.default.post(name: Notification.Name("NotifyLoginStatus"), object: nil)
                                        
                                    })}}
                        }
                    }
                    else
                    {
                        self.userManager.GetUserRequest(token: response!.string!) { (data, error) in
                            if error == nil {
                                CommonManager.shared.saveUserCoreData(user: data!, token: response!.string!, completion: { (status) in
                                    UserDefaults.standard.set(response!.string!, forKey: "token")
                                    if self.pushed != 0
                                    {
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                    else
                                    {
                                        self.dismiss(animated: true, completion: nil)
                                    }
                                    NotificationCenter.default.post(name: Notification.Name("NotifyLoginStatus"), object: nil)
                                })
                            }
                        }
                    }
                    
                    
                    let message = MDCSnackbarMessage()
                    if self.currentLanguage == "en"{
                        message.text = "You are login successfully"
                    }
                    else{
                        message.text = "أنت تسجيل الدخول بنجاح"
                    }
                    MDCSnackbarManager.show(message)
                    print("Successfully logged in to Firebase with Google")
                    
                }
                //                self.socialAccountManager.SigninGoogleAccount(socialId: (user?.uid)!, socialType: "google") { (response,errorSignin) in
                //                    if errorSignin != nil{
                //                        var socialUserData = SocialUserForm(firstName: firstName, lastName: lastName!, email: (user?.email)!) // struct
                //                        APIManager.shared.SocialSignUpRequest(data: socialUserData){(data) -> Void in
                //                            if data  != "" {
                //                                self.socialAccountManager.SigninGoogleAccountWithCustomerId(socialId: (user?.uid)!,socialType : "google", customerId: data) { (response,errorSignin) in
                //                                    self.socialAccountManager.SigninGoogleAccount(socialId: (user?.uid)!, socialType: "google") { (response,errorSignin) in
                //                                        if errorSignin != nil{}
                //                                        else{
                //                                            self.userManager.GetUserRequest(token: response!.string!) { (data, error) in
                //                                                if error == nil {
                //                                                    CommonManager.shared.saveUserCoreData(user: data!, token: response!.string!, completion: { (status) in
                //                                                        UserDefaults.standard.set(response!.string!, forKey: "token")
                //                                                        self.window?.rootViewController?.dismiss(animated: true, completion: nil)
                //                                                        NotificationCenter.default.post(name: Notification.Name("NotifyLoginStatus"), object: nil)
                //
                //                                                    })}}}}}}}}
                //                    else {
                //                        self.userManager.GetUserRequest(token: response!.string!) { (data, error) in
                //                            if error == nil {
                //                                CommonManager.shared.saveUserCoreData(user: data!, token: response!.string!, completion: { (status) in
                //                                    UserDefaults.standard.set(response!.string!, forKey: "token")
                //                                    self.window?.rootViewController?.dismiss(animated: true, completion: nil)
                //                                    NotificationCenter.default.post(name: Notification.Name("NotifyLoginStatus"), object: nil)
                //                                })
                //                            }
                //                        }
                //                    }
                //                }
            }
            
        }
    }
    

}
