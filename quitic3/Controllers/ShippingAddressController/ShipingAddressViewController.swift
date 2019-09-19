//
//  ShipingAddressViewController.swift
//  quitic3
//
//  Created by DOT on 7/30/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialSnackbar
import DropDown
import CoreData
import Localize_Swift


class ShipingAddressViewController: UIViewController, UITextFieldDelegate {
    var currentLanguage = ""
    @objc func setText(){
        
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
        if self.currentLanguage == "en"{
            // self.title = "Shipping Address"
            btnNextlbl.setTitle("Next", for: .normal)
            btnNextlbl.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
            
            // self.zoneDropDownBtnOutlet.setTitle("Select Zone", for: .normal)
            self.countryDropDownBtnOutlet.setTitle("Select Country", for: .normal)
            countryDropDownBtnOutlet.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
            
            self.txtFirstName.placeholder = "Full Name"
            self.txtFirstName.font = UIFont(name: enLanguageConstant, size: 17)!
            
            // self.txtLastName.placeholder = "Last Name"
            self.txtAddress.placeholder = "Address"
            self.txtAddress.font = UIFont(name: enLanguageConstant, size: 17)!
            
            self.txtEmail.placeholder = "Email"
            self.txtEmail.font = UIFont(name: enLanguageConstant, size: 17)!
            
            //self.poxtCode.placeholder = "Post Code"
            self.txtCity.placeholder = "City"
            self.txtCity.font = UIFont(name: enLanguageConstant, size: 17)!
            
            self.txtTelephone.placeholder = "Telephone"
            self.txtTelephone.font = UIFont(name: enLanguageConstant, size: 17)!
            
            self.btnSelectCity.setTitle("Select City", for: .normal)
            btnSelectCity.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
            
            
        }
        else{
            // self.title = "عنوان الشحن"
            //  self.zoneDropDownBtnOutlet.setTitle("اختر المنطقة", for: .normal)
            self.countryDropDownBtnOutlet.setTitle("حدد الدولة", for: .normal)
            self.countryDropDownBtnOutlet.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            
            self.btnNextlbl.setTitle("التالي", for: .normal)
            self.btnNextlbl.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            
            
            self.txtFirstName.placeholder = "الإسم الكامل"
            self.txtFirstName.font = UIFont(name: arLanguageConstant, size: 17)!
            
            //  self.txtLastName.placeholder = "الكنية"
            self.txtAddress.placeholder = "العنوان"
            self.txtAddress.font = UIFont(name: arLanguageConstant, size: 17)!
            
            self.txtEmail.placeholder = "البريد الإلكتروني"
            self.txtEmail.font = UIFont(name: arLanguageConstant, size: 17)!
            
            //   self.poxtCode.placeholder = "الرمز البريدي"
            self.txtCity.placeholder = "مدينة"
            self.txtCity.font = UIFont(name: arLanguageConstant, size: 17)!
            
            self.txtTelephone.placeholder = "هاتف"
            self.txtTelephone.font = UIFont(name: arLanguageConstant, size: 17)!
            
            self.btnSelectCity.setTitle("حدد مدينة", for: .normal)
            btnSelectCity.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
        }
    }
    
    func checkLanguage(){
        
        var semanticContentAttribute:UISemanticContentAttribute = .forceLeftToRight
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
        if self.currentLanguage == "ar" {
            semanticContentAttribute = .forceRightToLeft
            self.txtFirstName.textAlignment = NSTextAlignment.right;
            //  self.txtLastName.textAlignment = NSTextAlignment.right;
            self.txtAddress.textAlignment = NSTextAlignment.right;
            self.txtEmail.textAlignment = NSTextAlignment.right;
            //  self.poxtCode.textAlignment = NSTextAlignment.right;
            self.txtCity.textAlignment = NSTextAlignment.right;
            self.txtTelephone.textAlignment = NSTextAlignment.right;
        }
        else{
            self.txtFirstName.textAlignment = NSTextAlignment.left;
            // self.txtLastName.textAlignment = NSTextAlignment.left;
            self.txtAddress.textAlignment = NSTextAlignment.left;
            self.txtEmail.textAlignment = NSTextAlignment.left;
            // self.poxtCode.textAlignment = NSTextAlignment.left;
            self.txtCity.textAlignment = NSTextAlignment.left;
            self.txtTelephone.textAlignment = NSTextAlignment.left;
        }
        UIView.appearance().semanticContentAttribute = semanticContentAttribute
        UINavigationBar.appearance().semanticContentAttribute = semanticContentAttribute
        UITextField.appearance().semanticContentAttribute = semanticContentAttribute
        UITextView.appearance().semanticContentAttribute = semanticContentAttribute
        
    }
    
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var poxtCode: UITextField!
    @IBOutlet weak var txtTelephone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var countryDropDownBtnOutlet: UIButton!
    @IBOutlet weak var zoneDropDownBtnOutlet: UIButton!
    
    @IBOutlet weak var btnSelectCity: UIButton!
    
    @IBOutlet weak var scrvShipingAdd: UIScrollView!
    var CountryListArray  = [CountryList] ()
    var selectedCountryObj = CountryList()
    var selectedCountry : String = ""
    var selectedZone : String = ""
    var selectedZoneId : String = ""
    var selectedZoneCode : String = ""
    var activeTextField = UITextField()
    let button = UIButton(type: UIButtonType.custom)

    var cityListArray = [Cities]()
    var selectedCityObj = Cities()
    var selectedCity : String = ""
    
    
    @IBOutlet weak var btnNextlbl: UIButton!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtPostCode: UITextField!
    
    @IBOutlet weak var globeIcon: UIImageView!
    @IBOutlet weak var dropDownZoneIcon: UIImageView!
    @IBOutlet weak var mapIcon: UIImageView!
    @IBOutlet weak var dropDownCountryIcon: UIImageView!
    
    let navBarTitleImage = UIImage(named: "navBarIcon")
    
    let dropDown = DropDown()
    let zoneDropDown = DropDown()
    let cityDropDown = DropDown()
    
    var countryTap: Bool = false
    var lblHeader = UILabel()
    var viewNavCenter = UIView()
    
    //Hide keyboard when user presses outside the field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Pressing Return should also hide
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func Done() {
        self.view.endEditing(true)
        
        
    }
    @objc func Done(_ sender : UIButton){
        
        DispatchQueue.main.async { () -> Void in
            
            self.txtTelephone.resignFirstResponder()
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        button.isHidden = true
        button.setTitle("Done", for: UIControlState())
        button.setTitleColor(UIColor.black, for: UIControlState())
        button.frame = CGRect(x: 0, y: 163, width: 106, height: 53)
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(self.Done(_:)), for: UIControlEvents.touchUpInside)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: Selector("endEditing:")))
        self.globeIcon.tintColor = UIColor.textPrimaryColor
        self.dropDownCountryIcon.tintColor = UIColor.textPrimaryColor
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.setText()
        self.checkLanguage()
        self.txtFirstName.delegate = self
        self.txtAddress.delegate = self
        self.txtEmail.delegate = self
        self.txtCity.delegate = self
        self.txtTelephone.delegate = self
        self.txtTelephone.returnKeyType = .done
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        self.GetCountries()
        
        self.dropDown.anchorView = self.countryDropDownBtnOutlet
        self.cityDropDown.anchorView = self.btnSelectCity
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        cityDropDown.bottomOffset = CGPoint.init(x: 0, y: (cityDropDown.anchorView?.plainView.bounds.height)!)
        
        
        
        cityDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.btnSelectCity.setTitle("\(item)", for: .normal)
            self.selectedCity = item
            self.selectedCityObj = self.cityListArray[index]
        }
        
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.countryDropDownBtnOutlet.setTitle("\(item)", for: .normal)
            self.selectedCountry = item
            self.selectedCountryObj = self.CountryListArray[index]
            
            self.getCity()
            
            //            self.zoneDropDown.dataSource = []
            //
            //                for country in self.CountryListArray{
            //
            //                    if country != nil && country.full_name_english != nil{
            //
            //                        if(country.full_name_english == item){
            //
            //                            if((country.available_regions?.count)! > 0){
            //
            //                                for zone in country.available_regions!{
            //
            //                                   // self.zoneDropDown.dataSource.append(zone.name!)
            //                                }
            //                            }
            //                        }
            //                    }
            //
            //                }
        }
        
        self.zoneDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectedZone = item
            
            self.zoneDropDownBtnOutlet.setTitle("\(item)", for: .normal)
        }
        
        self.dropDown.width = 300
        self.dropDown.direction = .bottom
        
        self.cityDropDown.width = 300
        self.cityDropDown.direction = .bottom
        
        //self.zoneDropDown.width = 300
        //self.zoneDropDown.direction = .bottom
        
        
        //        self.navigationItem.titleView = UIImageView(image: navBarTitleImage)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
        //        txtFirstName.text = "Muhammad Talha"
        // txtLastName.text = "Afzal"
        //        txtAddress.text = "374-E PIA Housing Society Lahore"
        //        txtEmail.text = "muhammadtalha@email.com"
        //        txtCity.text = "Lahore"
        // txtPostCode.text = "54000"
        
        CommonManager.shared.addLeftImageToTextFields(txtField: txtFirstName, txtImg: UIImage(named: "person")!)
        //  CommonManager.shared.addLeftImageToTextFields(txtField: txtLastName, txtImg: UIImage(named: "person")!)
        CommonManager.shared.addLeftImageToTextFields(txtField: txtAddress, txtImg: UIImage(named: "address")!)
        CommonManager.shared.addLeftImageToTextFields(txtField: txtEmail, txtImg: UIImage(named: "message")!)
        CommonManager.shared.addLeftImageToTextFields(txtField: txtCity, txtImg: UIImage(named: "geo_fence")!)
        CommonManager.shared.addLeftImageToTextFields(txtField: txtTelephone, txtImg: UIImage(named: "phone")!)
        //  CommonManager.shared.addLeftImageToTextFields(txtField: txtPostCode, txtImg: UIImage(named: "define_location")!)
        
    }
    
    //    func textFieldDidBeginEditing(_ textField: UITextField) {
    //        if textField == self.txtEmail {
    //        }
    //    }
    //
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewNavCenter = UIView(frame: CGRect(x: 40, y: -13, width:  (self.navigationController?.navigationBar.frame.size.width)!, height: 20))
        viewNavCenter.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.addSubview(viewNavCenter)
        
        lblHeader = UILabel.init(frame:  CGRect(x: 50, y: -11, width: self.view.frame.width - 100, height: 50))
        //lblHeader.font = UIFont.init(name: headerFont, size: 30)
        lblHeader.textAlignment = .center
        lblHeader.textColor = UIColor.init(red: 251, green: 96, blue: 127)
        
        if self.currentLanguage == "en"
        {
            lblHeader.text = "Shipping Address"
            lblHeader.font = UIFont.init(name: enMarselLanguageConstant, size: 23)
            
            self.countryDropDownBtnOutlet.titleEdgeInsets = UIEdgeInsetsMake(10,36,10,10)
            self.btnSelectCity.titleEdgeInsets = UIEdgeInsetsMake(10,36,10,10)
            
            
        }
        else
        {
            lblHeader.text = "عنوان الشحن"
            lblHeader.font = UIFont.init(name: arLanguageConstant, size: 23)
            
            self.countryDropDownBtnOutlet.titleEdgeInsets = UIEdgeInsetsMake(10,10,10,36)
            self.btnSelectCity.titleEdgeInsets = UIEdgeInsetsMake(10,10,10,36)
            
            
        }
        
        self.navigationController?.navigationBar.addSubview(lblHeader)
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        lblHeader.removeFromSuperview()
        viewNavCenter.removeFromSuperview()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        self.activeTextField = textField
    }
    
    @objc func keyboardWillShow(_ note : Notification) -> Void{
        DispatchQueue.main.async { () -> Void in
            self.txtTelephone.keyboardType = .asciiCapableNumberPad

            self.button.isHidden = true
            if  self.activeTextField == self.txtTelephone{
                self.button.isHidden = true

            }else{
                self.button.isHidden = true

            
        }
            
            
            let keyBoardWindow = UIApplication.shared.windows.last
            self.button.frame = CGRect(x: 0, y: (keyBoardWindow?.frame.size.height)!-53, width: 106, height: 53)
            keyBoardWindow?.addSubview(self.button)
            keyBoardWindow?.bringSubview(toFront: self.button)
            
            UIView.animate(withDuration: (((note.userInfo! as NSDictionary).object(forKey: UIKeyboardAnimationCurveUserInfoKey) as AnyObject).doubleValue)!, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
                self.view.frame = self.view.frame.offsetBy(dx: 0, dy: 0)
            }, completion: { (complete) -> Void in
                print("Complete")
            })
        }
        
    }
    
    @IBAction func btnNextClicked(_ sender: Any) {
        if((self.selectedCountry) == ""){
            let message = MDCSnackbarMessage()
            if self.currentLanguage == "en"{
                message.text = "Please Select Country"
            }
            else{
                message.text = "الرجاء اختيار الدولة"
            }
            MDCSnackbarManager.show(message)
            return
        }
        //        if(self.selectedZone == ""){
        //            let message = MDCSnackbarMessage()
        //
        //            if self.currentLanguage == "en"{
        //               message.text = "Please Select Zone"
        //            }
        //            else{
        //                message.text = "من فضلك اختر المنطقة"
        //            }
        //            MDCSnackbarManager.show(message)
        //            return
        //        }
        if(txtFirstName.text == "" || txtFirstName.text == nil){
            let message = MDCSnackbarMessage()
            
            if self.currentLanguage == "en"{
                message.text = "Please enter your name"
            }
            else{
                message.text = "أدخل أسمك"
            }
            MDCSnackbarManager.show(message)
            return
        }
        //        if(txtLastName.text == "" || txtLastName.text == nil){
        //            let message = MDCSnackbarMessage()
        //
        //      if self.currentLanguage == "en"{
        //                message.text = "Please enter last name"
        //            }
        //            else{
        //                message.text = "الرجاء إدخال الاسم الأخير"
        //            }
        //            MDCSnackbarManager.show(message)
        //            return
        //        }
        if(txtEmail.text == "" || txtEmail.text == nil){
            let message = MDCSnackbarMessage()
            
            if self.currentLanguage == "en"{
                message.text = "Please enter email"
            }
            else{
                message.text = "الرجاء إدخال البريد الإلكتروني"
            }
            MDCSnackbarManager.show(message)
            return
        }
        
        if(txtEmail.text != "" || txtEmail.text != nil)
        {
            if(!(isValidEmail(testStr: txtEmail.text!)))
            {
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
        
        if(txtAddress.text == "" || txtAddress.text == nil){
            let message = MDCSnackbarMessage()
            
            if self.currentLanguage == "en"{
                message.text = "Please enter shipping address"
            }
            else{
                message.text = "الرجاء إدخال عنوان الشحن"
            }
            MDCSnackbarManager.show(message)
            return
        }
        
        //txtTelephone
        if(txtTelephone.text == "" || txtTelephone.text == nil){
            txtTelephone.returnKeyType = .done
            
            let message = MDCSnackbarMessage()
            if self.currentLanguage == "en"{
                message.text = "Please enter telephone number "
            }
            else{
                message.text = "الرجاء إدخال رقم الهاتف"
                
            }
            MDCSnackbarManager.show(message)
            return
        }
        else if txtTelephone.text != ""{
            txtTelephone.returnKeyType = .done
            
            let phoneNumberValidator = txtTelephone.text!.isPhoneNumber
            
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
        
        
        //txtCity
        if self.selectedCity == nil {
            let message = MDCSnackbarMessage()
            if self.currentLanguage == "en"{
                message.text = "Please enter city "
            }
            else{
                message.text = "الرجاء إدخال المدينة"
                
            }
            MDCSnackbarManager.show(message)
            return
        }
        //txtPostCode
        //        if(txtPostCode.text == "" || txtPostCode.text == nil){
        //            let message = MDCSnackbarMessage()
        //            if self.currentLanguage == "en"{
        //                message.text = "Please enter post code"
        //            }
        //            else{
        //                message.text = "الرجاء إدخال الرمز البريدي"
        //
        //            }
        //            MDCSnackbarManager.show(message)
        //            return
        //        }
        
        
        
        for country in self.CountryListArray {
            if(country.lable == self.selectedCountry) {
                for country in self.CountryListArray{
                    if country != nil && country.lable != nil{
                        if(country.lable == self.selectedCountry){
                            selectedCountryObj = country
                            //                            if((country.available_regions?.count)! > 0){
                            //                                for zone in country.available_regions!{
                            //                                    if zone.name == self.selectedZone {
                            //                                        self.selectedZoneCode = zone.code!
                            //                                        self.selectedZoneId = zone.id!
                            //                                    }
                            //                                }
                            //                            }
                        }
                    }
                    
                }
                
            }
        }
        let message = MDCSnackbarMessage()
        
        CommonManager.shared.saveAddress(region: "", region_id: "", country_id: selectedCountryObj.lable!, postcode: "", city: selectedCity, firstname: txtFirstName.text!, lastname: "", region_code: "",street:txtAddress.text!,email: txtEmail.text! , telePhone : txtTelephone.text!) { (complete) in
            if complete {
                
                if self.currentLanguage == "en"{
                    message.text = "Address posted"
                }
                else{
                    message.text = "العنوان المنشور"
                }
                
                let BillingAddressViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BillingAddressViewController") as! BillingAddressViewController
                self.navigationController?.pushViewController(BillingAddressViewController, animated: true)
                
            }else{
                
                if self.currentLanguage == "en"{
                    message.text = "Error while posting to address"
                }
                else{
                    message.text = "خطأ أثناء النشر للعنوان"
                }
            }
            MDCSnackbarManager.show(message)
        }
        
    }
    
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @IBAction func countryDropDownClicked(_ sender: Any) {
        
        self.view.endEditing(true)
        self.dropDown.show()
    }
    
    @IBAction func SelectCityClicked(_ sender: Any) {
        self.view.endEditing(true)
        self.cityDropDown.show()
    }
    
    @IBAction func zoneDropDownClicked(_ sender: Any) {
        self.zoneDropDown.show()
    }
    
    func getCity() {
        
        APIManager.shared.GetCityRequest(countryCode: selectedCountryObj.lable!) { (arraCity, error) in
            
            if error == nil {
                
                self.cityListArray = arraCity as! [Cities]
                self.cityDropDown.dataSource = []
                
                for city in self.cityListArray {
                    
                    if city.name != nil{
                        
                        self.cityDropDown.dataSource.append(city.name!)
                    }
                }
                
                let sortedElement = self.cityDropDown.dataSource.sorted { $0 < $1 }
                self.cityDropDown.dataSource = sortedElement
            } else {
                
                print(error!)
            }
        }
    }
    
    func GetCountries() {
        
        self.CountryListArray = [CountryList] ()
        
        APIManager.shared.GetCountriesRequest { (arrCountry, error) in
            
            if error == nil{
                
                self.CountryListArray = arrCountry as! [CountryList]
                self.dropDown.dataSource = []
                
                for country in self.CountryListArray {
                    
                    if country != nil && country.lable != nil{
                        
                        self.dropDown.dataSource.append(country.code!)
                    }
                }
                let sortedElement = self.dropDown.dataSource.sorted { $0 < $1 }
                self.dropDown.dataSource = sortedElement
            }
            else{
                print(error!)
            }
        }
    }
}
