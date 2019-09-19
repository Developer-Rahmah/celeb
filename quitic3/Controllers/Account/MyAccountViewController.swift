//
//  MyAccountViewController.swift
//  quitic3
//
//  Created by DOT on 9/5/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import Localize_Swift
import CoreData
import ImageSlideshow
import SideMenu
import MaterialComponents.MaterialSnackbar
import Alamofire
import Photos
import SDWebImage

class MyAccountViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var dateOfBirthView: UIView!
    @IBOutlet weak var dateOfBirth: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    @IBOutlet weak var dropDownPersonImage: UIImageView!
    @IBOutlet weak var dropDownImage: UIImageView!
    var userEmail:String = ""
    var userId :Int = 0
    var currentLanguage: String = "en"
    
    var galleryText: String = "Gallery"
    var cameraText: String = "Camera"
    var cancelText: String = "Cancel"
    var chooseMessage: String = "Pick Image From"
    var chooseTitle: String = "Choose Image"
    var lblHeader = UILabel()
    var strCustomFiled:String = ""
    var viewNavCenter = UIView()

    
    let userManager = UserManager()
    let accountManager = AccountManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dropDownPersonImage.tintColor = UIColor.textPrimaryColor
        self.dropDownImage.tintColor = UIColor.textPrimaryColor
        
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
                
                if self.currentLanguage == "en"{
                    //self.title = "My Account"
                    self.saveBtn.setTitle("Save", for: .normal)
                    self.saveBtn.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
                    
                    self.firstName.textAlignment = .left
                    
                    self.firstName.placeholder = ""
                    self.firstName.font = UIFont(name: enLanguageConstant, size: 17)!
                    
                    self.lastName.placeholder = ""
                    self.lastName.font = UIFont(name: enLanguageConstant, size: 17)!
                    
                    self.dateOfBirth.text = ""
                    self.dateOfBirth.font = UIFont(name: enLanguageConstant, size: 17)!
                    
                    self.lastName.textAlignment = .left
                    self.dateOfBirth.textAlignment = .left
                    
                    galleryText = "Gallery"
                    cameraText = "Camera"
                    cancelText = "Cancel"
                    chooseMessage = "Pick Image From"
                    chooseTitle = "Choose Image"
                    
                }
                else{
                    //self.title = "حسابي"
                    self.saveBtn.setTitle("حفظ", for: .normal)
                    self.saveBtn.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
                    
                    self.firstName.textAlignment = .right
                    self.lastName.textAlignment = .right
                    self.dateOfBirth.textAlignment = .right
                    
                    self.firstName.placeholder = "الاسم الاول"
                    self.firstName.font = UIFont(name: arLanguageConstant, size: 17)!
                    
                    self.lastName.placeholder = "الكنية"
                    self.lastName.font = UIFont(name: arLanguageConstant, size: 17)!
                    
                    self.dateOfBirth.text = "تاريخ الولادة"
                    self.dateOfBirth.font = UIFont(name: arLanguageConstant, size: 17)!
                    
                    
                    galleryText = "صالة عرض"
                    cameraText = "الة تصوير"
                    cancelText = "الغاء"
                    chooseMessage = "اختر الصورة من"
                    chooseTitle = "اختر صورة"
                }
            }
        }
        
//      //  http://siteproofs.net/magento2/osama/boutiqa/pub/media/customer/1/1/123.png
//
//        // set user profile image while user enter into my account.
//        BaseManager.Manager.request("http://siteproofs.net/magento2/osama/boutiqa/pub/media/customer/1/_/1.png").responseImage { response in
//            if let image = response.result.value {
//                self.profileButton.setImage(image, for: UIControl.State.normal)
//            }
//            else{
//                self.profileButton.setImage(UIImage(named: "ImagePlaceholder"), for: UIControl.State.normal)
//            }
//        }
//
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.showDateOfBirth))
        
        self.dateOfBirthView.addGestureRecognizer(tap)
        
        
        CommonManager.shared.addLeftImageToTextFields(txtField: self.firstName, txtImg: UIImage(named: "person")!)
        
        CommonManager.shared.addLeftImageToTextFields(txtField: self.lastName, txtImg: UIImage(named: "person")!)
        
        
        print("MyAccount View Controller is Called")
        

        self.fetchUser()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewNavCenter = UIView(frame: CGRect(x: 0, y: -9, width:  (self.navigationController?.navigationBar.frame.size.width)!, height: 20))
        viewNavCenter.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.addSubview(viewNavCenter)
        
        ///added for navigation bar setting.
        //set large size navigation bar image.
//        imgViewNavCenter = UIImageView(image: UIImage(named: "centerHeader"))
//        imgViewNavCenter.frame = CGRect(x: view.frame.size.width / 2 - 75, y: 5, width: 150, height: 5) //
//        imgViewNavCenter.contentMode = .scaleAspectFill
//
//        //change height and width accordingly
//        self.navigationController?.navigationBar.addSubview(imgViewNavCenter)
//
//        let titleImgView = UIImageView(frame: CGRect(x: 0, y: 0, width:0, height: 0))
//        let image = UIImage(named: "")
//        titleImgView.image = image
//        navigationItem.titleView = titleImgView
        
        
        
        
        
        lblHeader = UILabel.init(frame:  CGRect(x: view.frame.size.width / 2 - 100, y: -11, width: 200, height: 50))
       // lblHeader.text = "My Account"
        lblHeader.font = UIFont.init(name: headerFont, size: 30)
        lblHeader.textAlignment = .center
        lblHeader.textColor = UIColor.init(red: 251, green: 96, blue: 127)
        
        if self.currentLanguage == "en"
        {
            lblHeader.text = "My Account"
            lblHeader.font = UIFont.init(name: enMarselLanguageConstant, size: 23)
        }
        else
        {
            lblHeader.text = "حسابي"
            lblHeader.font = UIFont.init(name: arLanguageConstant, size: 23)
        }
         self.navigationController?.navigationBar.addSubview(lblHeader)
        
//        self.navigationController?.navigationBar.addSubview(lblHeader)
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        lblHeader.removeFromSuperview()
    }
    
    
    @objc func showDateOfBirth(){
        print("Show date of birth")
        self.datePickerView.isHidden = false
        self.datePicker.datePickerMode = .date
        self.dateOfBirth.textColor = UIColor.textColorSecondary
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.dateOfBirth.text = formatter.string(from: self.datePicker.date)
        
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        print("value changed")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.dateOfBirth.textColor = UIColor.textColorSecondary
        self.dateOfBirth.text = formatter.string(from: self.datePicker.date)
    }
    
    @IBAction func profileBtnClicked(_ sender: Any) {
        print("profile btn clicked")
        
        let alert = UIAlertController(title: self.chooseTitle, message: self.chooseMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        
        let galleryAction = UIAlertAction(title: self.galleryText, style: .default) { (action) in
            print("gallery Clicked")
            self.imagePicker(source: "gallery")
        }
        
        let cameraAction = UIAlertAction(title: self.cameraText, style: .default) { (action) in
            print("camera Clicked")
            self.imagePicker(source: "camera")
        }
        
        let cancelAction = UIAlertAction(title: self.cancelText, style: .destructive, handler: nil)
        
        
        alert.addAction(galleryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func imagePicker(source: String){
        
        let image = UIImagePickerController()
        image.delegate = self
        
        
        if source == "gallery"{
            
            // Get the current authorization state.
            let status = PHPhotoLibrary.authorizationStatus()
            
            if (status == PHAuthorizationStatus.authorized)
            {
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    
                    image.sourceType = UIImagePickerControllerSourceType.photoLibrary
                    
                    self.present(image, animated: true, completion: nil)
                }
            }
                
            else if (status == PHAuthorizationStatus.denied) {
                
                let message = MDCSnackbarMessage()
                message.text = "Please Turn On photolibrary access permission. Go to Settings > Privacy > Photos"
                MDCSnackbarManager.show(message)
                
               // self.showAlertWithMessage(message:"Please Turn On camera access permission. Go to Settings > Privacy > Photos")
            }
                
            else if (status == PHAuthorizationStatus.notDetermined) {
                
                // Access has not been determined.
                PHPhotoLibrary.requestAuthorization({ (newStatus) in
                    
                    if (newStatus == PHAuthorizationStatus.authorized)
                    {
                        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                            
                            image.sourceType = UIImagePickerControllerSourceType.photoLibrary
                            
                            self.present(image, animated: true, completion: nil)
                        }
                    }
                        
                    else {
                        
                        let message = MDCSnackbarMessage()
                        message.text = "Please Turn On photolibrary access permission. Go to Settings > Privacy > Photos"
                        MDCSnackbarManager.show(message)
                        
                        
                       // self.showAlertWithMessage(message:"Please Turn On camera access permission. Go to Settings > Privacy > Photos")
                    }
                })
            }
                
            else if (status == PHAuthorizationStatus.restricted) {
                // Restricted access - normally won't happen.
            }
            
          //  image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        else{
            image.sourceType = UIImagePickerControllerSourceType.camera
            self.present(image, animated: true)
        }
        
       
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.profileButton.setImage(image, for: .normal)
            self.profileButton.contentMode = .scaleAspectFit
            PostUserProfilePicture()
        }
        else{
            print("Image error")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        print("Save BTN Clicked")
       
        let message = MDCSnackbarMessage()
        if self.dateOfBirth.text == nil
        {
             message.text = "Please date of birth."
            MDCSnackbarManager.show(message)
            return
        }
       
        
        PutCustomerInformation(Id: self.userId, dob: self.dateOfBirth.text!, FirstName: self.firstName.text!, LastName: self.lastName.text!, Email: self.userEmail,customField: strCustomFiled)
    }
    
    //Hide keyboard when user presses outside the field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var touch: UITouch? = touches.first
        
        if touch?.view != self.datePickerView {
            self.datePickerView.isHidden = true
        }
        
        self.view.endEditing(true)
    }
    //Send payment information Start
    fileprivate  func PutCustomerInformation(Id:Int,dob:String,FirstName:String,LastName:String,Email:String,customField:String){
        
        var arrayCustomAttribute:NSMutableArray = []
        
        let dictCustomAttributed:NSMutableDictionary = ["attribute_code":"profile_picture","value":strCustomFiled]
        
        
        if let strMobileNumber:String = UserDefaults.standard.value(forKeyPath: "phoneNumber") as? String
        {
              let dictCustomAttributedMobile:NSMutableDictionary = ["attribute_code":"mobile_no","value":strMobileNumber]
        }
        
      
        arrayCustomAttribute.add(dictCustomAttributed)
        
    
        let parameters: Parameters = [
            "customer":[
                "id": Id,
                "dob": dob,
                "email": Email,
                "firstname": FirstName,
                "lastname": LastName,
                "store_id": 1,
                "website_id": 1,
                "custom_attributes":arrayCustomAttribute
            ]
        ]
        accountManager.PutCustomerInfo(postParams: parameters) { (result,error) in
           let message = MDCSnackbarMessage()
            if result != nil {
                
                let authToken = (UserDefaults.standard.string(forKey: "token")!).replacingOccurrences(of: "\"", with: "")
                self.userManager.GetUserRequest(token: authToken) { (data, error) in
                    if error == nil {
                        print("GetUserRequest firstname:", data?.firstname!)
                        CommonManager.shared.saveUserCoreData(user: data!, token: authToken, completion: { (status) in
                            print(status)
                             NotificationCenter.default.post(name: Notification.Name("NotifyLoginStatus"), object: nil)
                        })
                    }
                    else{
                        print("GetUserRequest:", error)
                    }
                }

            }else{
                if self.currentLanguage == "en"{
                    message.text = "Error while updating profile"
                }
                else{
                    message.text = "خطأ أثناء تحديث ملف التعريف"
                }
            }
        }
        
    }
    
    //take user image for pass to the api
    
    func PostUserProfilePicture()
    {
        if let photo = profileButton.currentImage
        {
            let dictUserImg:NSMutableDictionary = ["key":"profile_picture","photo":photo]
            let arrayImg:NSMutableArray = [dictUserImg]
            
            accountManager.PostUserProfilePicture(imgArray: arrayImg){ (result,error) in
                let message = MDCSnackbarMessage()
                if result != nil {
                  
                    self.strCustomFiled = (result?.stringValue)!
                 
                }else{
                    if self.currentLanguage == "en"{
                        message.text = "Error while updating profile"
                    }
                    else{
                        message.text = "خطأ أثناء تحديث ملف التعريف"
                    }
                }
            }
        }
    }
    
    
    //Send payment information End
    //Pressing Return should also hide
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func fetchUser(){
        self.activity.isHidden = false
        userManager.GetUserRequest(token: nil) { (data, error) in
            if error == nil {
                self.firstName.text = data?.firstname
                self.lastName.text = data?.lastname
                self.activity.isHidden = true
                self.userEmail = (data?.email)!
                self.userId = (data?.id)!
                self.dateOfBirth.text = data?.dob
                
                
                if data?.custom_attributes != nil
                {
                    let arrCustomAttribute:NSArray = data!.custom_attributes! as NSArray
                    
                    if arrCustomAttribute.count > 0
                    {
                        for index in arrCustomAttribute
                        {
                            let dictMobileNo:Custom_attributes = index as! Custom_attributes
                            
                            let strMobileNo:String = dictMobileNo.attribute_code!
                            
                            if strMobileNo == "profile_picture"
                            {
                                //sdImageView Changes.
                                let aStrProfileImage:String = String(format: "%@customer/%@",CELEB_VIDEOS_IMAGE_URL, dictMobileNo.value as! CVarArg)

                                let url = URL(string:aStrProfileImage)
                                
                                self.profileButton!.sd_setImage(with: url, for: .normal, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
                                self.profileButton.imageView?.contentMode = .scaleAspectFit
//                                self.profileButton!.imageView!.sd_setImage(with: url, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
                                
//                                // set user profile image while user enter into my account.
//                                BaseManager.Manager.request(aStrProfileImage).responseImage { response in
//                                    if let image = response.result.value {
//                                        self.profileButton.setImage(image, for: UIControl.State.normal)
//                                    }
//                                    else{
//                                        self.profileButton.setImage(UIImage(named: "ImagePlaceholder"), for: UIControl.State.normal)
//                                    }
//                                }
                            }
                        }
                    }
                    
                    
                    
//                    //set userprofile image.
//                    let arrProfilePicture:NSArray = data!.custom_attributes! as NSArray
//
//                    if arrProfilePicture.count > 0
//                    {
//                        let dictProfilePicture:Custom_attributes = arrProfilePicture.object(at: 0) as! Custom_attributes
//
//                        let aStrProfileImage:String = String(format: "%@customer%@",CELEB_VIDEOS_IMAGE_URL, dictProfilePicture.value as! CVarArg)
//
//
//                        // set user profile image while user enter into my account.
//                        BaseManager.Manager.request(aStrProfileImage).responseImage { response in
//                            if let image = response.result.value {
//                                self.profileButton.setImage(image, for: UIControl.State.normal)
//                            }
//                            else{
//                                self.profileButton.setImage(UIImage(named: "ImagePlaceholder"), for: UIControl.State.normal)
//                            }
//                        }
//
//                    }
                }
                
                
            }
        }
    }
}
