//
//  BillingAddressViewController.swift
//  quitic3
//
//  Created by DOT on 8/6/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialSnackbar
import DropDown
import CoreData
import Localize_Swift

class BillingAddressViewController: UIViewController ,UITextFieldDelegate{
    @IBOutlet weak var lblsameShipping: UILabel!
    var currentLanguage = ""

    @IBOutlet weak var btnNextlbl: UIButton!
    @objc func setText(){
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
        if self.currentLanguage  == "en"{
           // self.title = "Billing Address"
            self.lblsameShipping.text = "Same As Shipping Address"
            self.lblsameShipping.font = UIFont(name: enLanguageConstant, size: 17)!
            
            btnNextlbl.setTitle("Next", for: .normal)
            btnNextlbl.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
            
            //self.zoneDropDownBtnOutlet.setTitle("Select Zone", for: .normal)
            self.countryDropDownBtnOutlet.setTitle("Select Country", for: .normal)
            self.countryDropDownBtnOutlet.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
            
            self.txtFirstName.placeholder = "Full Name"
            self.txtFirstName.font = UIFont(name: enLanguageConstant, size: 17)!
            
            //self.txtLastName.placeholder = "Last Name"
            self.txtAddress.placeholder = "Address"
            self.txtAddress.font = UIFont(name: enLanguageConstant, size: 17)!
            
            self.txtEmail.placeholder = "Email"
            self.txtEmail.font = UIFont(name: enLanguageConstant, size: 17)!
            
           // self.txtPostCode.placeholder = "Post Code"
            self.txtCity.placeholder = "City"
            self.txtCity.font = UIFont(name: enLanguageConstant, size: 17)!
            
            self.txtTelephone.placeholder = "Telephone"
            self.txtTelephone.font = UIFont(name: enLanguageConstant, size: 17)!
            
            self.btnCity.setTitle("Select City", for: .normal)
            self.btnCity.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
        }
        else{
           // self.title = "عنوان وصول الفواتير"
            //self.zoneDropDownBtnOutlet.setTitle("اختر المنطقة", for: .normal)
            self.countryDropDownBtnOutlet.setTitle("حدد الدولة", for: .normal)
            self.countryDropDownBtnOutlet.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            
            self.lblsameShipping.text = "نفس عنوان الشحن"
            self.lblsameShipping.font = UIFont(name: arLanguageConstant, size: 17)!
            
            self.btnNextlbl.setTitle("التالي", for: .normal)
            self.btnNextlbl.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            
            self.txtFirstName.placeholder = "الاسم الكامل"
            self.txtFirstName.font = UIFont(name: arLanguageConstant, size: 17)!
            
           // self.txtLastName.placeholder = "الكنية"
            self.txtAddress.placeholder = "العنوان"
            self.txtAddress.font = UIFont(name: arLanguageConstant, size: 17)!
            
            self.txtEmail.placeholder = "البريد الإلكتروني"
            self.txtEmail.font = UIFont(name: arLanguageConstant, size: 17)!
            
            //self.txtPostCode.placeholder = "الرمز البريدي"
            self.txtCity.placeholder = "المدينة"
            self.txtCity.font = UIFont(name: arLanguageConstant, size: 17)!
            
            self.txtTelephone.placeholder = "هاتف"
            self.txtTelephone.font = UIFont(name: arLanguageConstant, size: 17)!
            
            
            self.btnCity.setTitle("حدد مدينة", for: .normal)
            self.btnCity.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
        }
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
            //self.txtLastName.textAlignment = NSTextAlignment.right;
            self.txtAddress.textAlignment = NSTextAlignment.right;
            self.txtEmail.textAlignment = NSTextAlignment.right;
//            self.poxtCode.textAlignment = NSTextAlignment.right;
            self.txtCity.textAlignment = NSTextAlignment.right;
         //   self.txtPostCode.textAlignment = NSTextAlignment.right;
            self.txtTelephone.textAlignment = NSTextAlignment.right;
        }
        else{
            self.txtFirstName.textAlignment = NSTextAlignment.left;
            //self.txtLastName.textAlignment = NSTextAlignment.left;
            self.txtAddress.textAlignment = NSTextAlignment.left;
            self.txtEmail.textAlignment = NSTextAlignment.left;
//            self.poxtCode.textAlignment = NSTextAlignment.left;
            self.txtCity.textAlignment = NSTextAlignment.left;
           // self.txtPostCode.textAlignment = NSTextAlignment.left;
            self.txtTelephone.textAlignment = NSTextAlignment.left;
        }
        
        UIView.appearance().semanticContentAttribute = semanticContentAttribute
        UINavigationBar.appearance().semanticContentAttribute = semanticContentAttribute
        UITextField.appearance().semanticContentAttribute = semanticContentAttribute
        UITextView.appearance().semanticContentAttribute = semanticContentAttribute
        
    }
    
    var IsSameShipping:Int16 = 0
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var countryDropDownBtnOutlet: UIButton!
    @IBOutlet weak var zoneDropDownBtnOutlet: UIButton!
    @IBOutlet weak var deaultCheckBox: Checkbox!
    @IBOutlet weak var txtTelephone: UITextField!
    
    var activeTextField = UITextField()
    let button = UIButton(type: UIButtonType.custom)
    
    @IBOutlet weak var globeIcon: UIImageView!
    @IBOutlet weak var countryDropDownIcon: UIImageView!
    @IBOutlet weak var zoneDropDownIcon: UIImageView!
    @IBOutlet weak var mapIcon: UIImageView!
    
    var CountryListArray  = [CountryList] ()
    var selectedCountryObj = CountryList()
    var selectedCountry : String = ""
    var selectedZone : String = ""
    var selectedZoneId : String = ""
    var selectedZoneCode : String = ""
    
    var cityListArray = [Cities]()
    var selectedCityObj = Cities()
    var selectedCity : String = ""
    
    @IBOutlet weak var btnCity: UIButton!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtPostCode: UITextField!
    
    @IBOutlet weak var scrvBillingAdd: UIScrollView!
    let navBarTitleImage = UIImage(named: "navBarIcon")
    
    @IBOutlet weak var viewMain: UIView!
    let dropDown = DropDown()
    let cityDropDown = DropDown()
    let zoneDropDown = DropDown()
    var countryTap: Bool = false
    var lblHeader = UILabel()
    var viewNavCenter = UIView()
    
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
       // self.mapIcon.tintColor = UIColor.textPrimaryColor
       // self.zoneDropDownIcon.tintColor = UIColor.textPrimaryColor
        self.countryDropDownIcon.tintColor = UIColor.textPrimaryColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.setText()
        self.checkLanguage()
        
        self.txtFirstName.delegate = self
   //     self.txtLastName.delegate = self
        self.txtAddress.delegate = self
        self.txtEmail.delegate = self
        self.txtCity.delegate = self
        //txtPostCode
       // self.txtPostCode.delegate = self
        self.txtTelephone.delegate = self
        self.deaultCheckBox.checkedBorderColor = UIColor.quiticPink
        self.deaultCheckBox.uncheckedBorderColor = .black
        self.deaultCheckBox.borderStyle = .square
        self.deaultCheckBox.checkmarkColor = UIColor.quiticPink
        self.deaultCheckBox.checkmarkStyle = .tick
        self.deaultCheckBox.valueChanged = { (value) in
            if value {
                self.IsSameShipping = 1
                var adressItems: [AddressInformation] = []
                guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AddressInformation")
                
                do{
                    adressItems = try managedContext.fetch(fetchRequest) as! [AddressInformation]
                    
                    print("Getting AddressInformation from persistentContainer")
                    print(adressItems[0])
                    dump(adressItems[0])
                    
                    self.txtFirstName.text = adressItems[0].firstname!
                    
                    self.txtEmail.text = adressItems[0].email ?? " "
                    self.txtTelephone.text = adressItems[0].telephone ?? " "
                   // self.txtLastName.text = adressItems[0].lastname!
                    self.txtAddress.text = adressItems[0].street ?? " "
                    self.txtCity.text = adressItems[0].city ?? " "
                    self.selectedCity = adressItems[0].city ?? " "
                    self.btnCity.setTitle(adressItems[0].city ?? " ", for:.normal)
                //    self.txtPostCode.text = adressItems[0].postcode!
                    self.selectedZone = adressItems[0].region ?? " "
                   // self.selectedZoneId = adressItems[0].region_id!
                    self.selectedCountryObj.lable = adressItems[0].country_id ?? " "
                    
                  //  self.selectedZoneCode = adressItems[0].region_code!
                    
                    for country in self.CountryListArray{
                        
                        if country != nil && country.lable != nil{
                            
                            if(country.lable == self.selectedCountryObj.lable){
                                
                                //                            self.selectedCountry = country.full_name_english!
                                self.countryDropDownBtnOutlet.setTitle("\(country.code!)", for: .normal)
                                self.getCity()
//                                if((country.available_regions?.count)! > 0){
//                                    for zone in country.available_regions!{
//                                        if zone.name == self.selectedZone {
//                                            self.zoneDropDownBtnOutlet.setTitle("\(zone.name!)", for: .normal)
//                                            self.selectedZoneCode = zone.code!
//                                            self.selectedZoneId = zone.id!
//                                        }
//                                    }
//                                }
                            }
                        }
                    }
                }catch{
                    debugPrint("Could not fetch: \(error.localizedDescription)")
                    return
                }            }
            else{
                self.IsSameShipping = 0
            }
        }
        
        self.GetCountries()
        self.dropDown.anchorView = self.countryDropDownBtnOutlet
        self.cityDropDown.anchorView = self.btnCity
		dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        cityDropDown.bottomOffset = CGPoint(x: 0, y: (cityDropDown.anchorView?.plainView.bounds.height)!)
        self.zoneDropDown.anchorView = self.zoneDropDownBtnOutlet
        
        self.cityDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.btnCity.setTitle("\(item)", for: .normal)
            self.selectedCity = item
            self.selectedCityObj = self.cityListArray[index]
        }
        
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.countryDropDownBtnOutlet.setTitle("\(item)", for: .normal)
            
            self.selectedCountry = item
            self.selectedCountryObj = self.CountryListArray[index]
            
            self.getCity()
            
            self.zoneDropDown.dataSource = []
            
            for country in self.CountryListArray{
                
                if country != nil && country.lable != nil {
                    
                    if(country.lable == item){
                        
//                        if((country.available_regions?.count)! > 0){
//
//                            for zone in country.available_regions!{
//
//                                print(zone.name!)
//                                self.zoneDropDown.dataSource.append(zone.name!)
//                                self.cityDropDown.dataSource.append(zone.name!)
//                            }
//                        }
                    }
                }
             
            }
        }
        
        self.zoneDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.zoneDropDownBtnOutlet.setTitle("\(item)", for: .normal)
        }
        
        self.dropDown.width = 300
        self.dropDown.direction = .bottom
        self.cityDropDown.width = 300
        self.cityDropDown.direction = .bottom
        self.zoneDropDown.width = 300
        self.zoneDropDown.direction = .bottom
        
        
//        self.navigationItem.titleView = UIImageView(image: navBarTitleImage)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
//        txtFirstName.text = "Muhammad Talha"
        //txtLastName.text = "Afzal"
//        txtAddress.text = "374-E PIA Housing Society Lahore"
//        txtEmail.text = "muhammadtalha@email.com"
//        txtCity.text = "Lahore"
      //  txtPostCode.text = "54000"
        
    
        
        
        CommonManager.shared.addLeftImageToTextFields(txtField: txtFirstName, txtImg: UIImage(named: "person")!)
      //  CommonManager.shared.addLeftImageToTextFields(txtField: txtLastName, txtImg: UIImage(named: "person")!)
        CommonManager.shared.addLeftImageToTextFields(txtField: txtAddress, txtImg: UIImage(named: "address")!)
        CommonManager.shared.addLeftImageToTextFields(txtField: txtEmail, txtImg: UIImage(named: "message")!)
        CommonManager.shared.addLeftImageToTextFields(txtField: txtCity, txtImg: UIImage(named: "geo_fence")!)
        CommonManager.shared.addLeftImageToTextFields(txtField: txtTelephone, txtImg: UIImage(named: "phone")!)
      //  CommonManager.shared.addLeftImageToTextFields(txtField: txtPostCode, txtImg: UIImage(named: "define_location")!)
        
    }
    @objc func Done(_ sender : UIButton){
        
        DispatchQueue.main.async { () -> Void in
            
            self.txtTelephone.resignFirstResponder()
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.button.isHidden = true

        viewNavCenter = UIView(frame: CGRect(x: 40, y: -13, width:  (self.navigationController?.navigationBar.frame.size.width)!, height: 20))
        viewNavCenter.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.addSubview(viewNavCenter)

        lblHeader = UILabel.init(frame:  CGRect(x: 50, y: -11, width: self.view.frame.width - 100, height: 50))
        //lblHeader.font = UIFont.init(name: headerFont, size: 30)
        lblHeader.textAlignment = .center
        lblHeader.textColor = UIColor.init(red: 251, green: 96, blue: 127)
        
        if self.currentLanguage == "en"
        {
            lblHeader.text = "Billing Address"
            lblHeader.font = UIFont.init(name: enMarselLanguageConstant, size: 23)
            
            self.countryDropDownBtnOutlet.titleEdgeInsets = UIEdgeInsetsMake(10,36,10,10)
            self.btnCity.titleEdgeInsets = UIEdgeInsetsMake(10,36,10,10)
        }
        else
        {
            lblHeader.text = "عنوان الفاتورة"
            lblHeader.font = UIFont.init(name: arLanguageConstant, size: 23)
            
            self.countryDropDownBtnOutlet.titleEdgeInsets = UIEdgeInsetsMake(10,10,10,36)
            self.btnCity.titleEdgeInsets = UIEdgeInsetsMake(10,10,10,36)
        }
        
        self.navigationController?.navigationBar.addSubview(lblHeader)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.button.isHidden = true

        lblHeader.removeFromSuperview()
        viewNavCenter.removeFromSuperview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.button.isHidden = true

        // Dispose of any resources that can be recreated.
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
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        self.button.isHidden = true
//
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        self.activeTextField = textField
//    }
//    
//    @objc func keyboardWillShow(_ note : Notification) -> Void{
//        DispatchQueue.main.async { () -> Void in
//            
//            self.txtTelephone.keyboardType = .asciiCapableNumberPad
//            
//           self.button.isHidden = true
//            if  self.activeTextField == self.txtTelephone{
//                self.button.isHidden = true
//                
//            }else{
//                self.button.isHidden = true
//                
//                
//            }
//        }}

    
    @IBAction func btnNextClicked(_ sender: Any)
    {
        for country in self.CountryListArray
        {
            if country != nil && country.lable != nil{
                if(country.lable == self.selectedCountryObj.lable){
                    self.selectedCountry = country.code!
//                    if((country.available_regions?.count)! > 0){
//                        for zone in country.available_regions!{
//                            if zone.name == self.selectedZone {
//                                self.selectedZoneCode = zone.code!
//                                self.selectedZoneId = zone.id!
//                            }
//                        }
//                    }
                }}
        }
        //self.dropDown.show()
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
//            if self.currentLanguage == "en"{
//                message.text = "Please Select Zone"
//            }
//            else{
//                message.text = "يرجى اختيار المنطقة"
//            }
//            MDCSnackbarManager.show(message)
//            return
//        }
        if(txtFirstName.text == "" || txtFirstName.text == nil){
            let message = MDCSnackbarMessage()
            message.text = ""
            if self.currentLanguage == "en"{
                message.text = "Please enter first name"
            }
            else{
                message.text = "يرجى إدخال الاسم الأول"
            }

            MDCSnackbarManager.show(message)
            return
        }
//        if(txtLastName.text == "" || txtLastName.text == nil){
//            let message = MDCSnackbarMessage()
//            if self.currentLanguage == "en"{
//                message.text = "Please enter last name"
//            }
//            else{
//                message.text = "يرجى إدخال الاسم الأخير"
//            }
//            MDCSnackbarManager.show(message)
//            return
//        }
        if(txtEmail.text == "" || txtEmail.text == nil)
        {
            let message = MDCSnackbarMessage()
            if self.currentLanguage == "en"{
                message.text = "Please enter email address"
            }
            else{
                message.text = "الرجاء إدخال عنوان البريد الإلكتروني"
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
        //txtTelephone
        if(txtTelephone.text == "" || txtTelephone.text == nil){
            let message = MDCSnackbarMessage()
            if self.currentLanguage == "en"
            {
                message.text = "Please enter telephone number "
            }
            else
            {
                message.text = "الرجاء إدخال رقم الهاتف"
            }
            MDCSnackbarManager.show(message)
            return
        }
        else if txtTelephone.text != ""{
            
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

        if(txtAddress.text == "" || txtAddress.text == nil){
            let message = MDCSnackbarMessage()
            if self.currentLanguage == "en"{
                message.text = "Please enter billing address"
            }
            else{
                message.text = "يرجى إدخال عنوان الفواتير"
            }

            MDCSnackbarManager.show(message)
            return
        }
        

           let message = MDCSnackbarMessage()
        CommonManager.shared.saveBillingAddress(region: "", region_id: "", country_id: selectedCountryObj.lable!, postcode: "", city: selectedCity, firstname: txtFirstName.text!, lastname: "", region_code: "",street:txtAddress.text! ,sameAsShipping:self.IsSameShipping , email: txtEmail.text! ,telephone: txtTelephone.text!) { (complete) in
            if complete {
                if self.currentLanguage == "en"{
                    message.text = "Billing Address posted"
                }
                else{
                    message.text = "تم إرسال عنوان الفواتير"
                }
            }else{
                if self.currentLanguage == "en"{
                    message.text = "Error while posting to address"
                }
                else{
                    message.text = "حدث خطأ أثناء النشر للعنوان"
                }
            }
            MDCSnackbarManager.show(message)
        }
        //Move On Next
        let OrderSummaryViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderNowViewController") as! OrderNowViewController
        self.navigationController?.pushViewController(OrderSummaryViewController, animated: true)
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
    
    @IBAction func cityDropDownClick(_ sender: Any) {
        
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
    
    func GetCountries(){
        
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
