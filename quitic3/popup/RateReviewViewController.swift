//
//  RateReviewViewController.swift
//  quitic3
//
//  Created by APPLE on 9/7/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import Localize_Swift
import MaterialComponents.MaterialSnackbar
import Alamofire

class RateReviewViewController: UIViewController ,UITextViewDelegate , UITextFieldDelegate{
    let rateReviewManager = RateReviewManager()
    let userManager = UserManager()
    var url_key = ""
    var productId = ""
    var currentLanguage = ""
    var firstName = ""
    var lastName = ""
    var userEmail = ""
    var userId = 0
    var titleRate : [String] = ["Very Bad", "Not good", "Quite ok", "Very Good", "Excellent !!!"]
    @objc func setText(){
        print("Set Text WishViewController")
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
        if self.currentLanguage == "en"{
             self.title = "Rate/Reviews"
            if textView.text.isEmpty {
                textView.text = "Please write your comment here ... "
                textView.textColor = UIColor.lightGray
            }
            self.lblRateProduct.text = "Rate this product"
            self.lblFeedback.text = "Please give your feedback"
            btnLater.setTitle("Later", for: .normal)
            btnSubmit.setTitle("Submit", for: .normal)
            btnCancel.setTitle("Cancel", for: .normal)

        }
        else{
            self.lblRateProduct.text = "قيم هذا المنتج"
            self.lblRateProduct.font = UIFont(name: arLanguageConstant, size: 17)!
            self.title = "معدل / التعليقات"
//            self.title.font = UIFont(name: arLanguageConstant, size: 17)!
            self.lblFeedback.text = "يرجى تقديم ملاحظاتك"
            self.lblFeedback.font = UIFont(name: arLanguageConstant, size: 17)!
            if textView.text.isEmpty {
                textView.text = "رجاء اكتب تعليقك هنا ... "
                textView.font = UIFont(name: arLanguageConstant, size: 17)!
                textView.textColor = UIColor.lightGray
            }
            btnLater.setTitle("في وقت لاحق", for: .normal)
            btnLater.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            btnSubmit.setTitle("إرسال", for: .normal)
            btnSubmit.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            btnCancel.setTitle("الغاء", for: .normal)
            btnCancel.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            rateTitle.font = UIFont(name: arLanguageConstant, size: 17)!
            if rateCosmos.rating == 1{
                self.rateTitle.text = "سيئ جدا"
            }
            if rateCosmos.rating  == 2{
                self.rateTitle.text = "غير جيد"
            }
            if rateCosmos.rating  == 3{
                self.rateTitle.text = "جيد"
            }
            if rateCosmos.rating  == 4{
                self.rateTitle.text = "جيد جدا"
            }
            if rateCosmos.rating  == 5{
                self.rateTitle.text = "ممتاز !!!"
            }
        }
        
    }
    @IBOutlet weak var lblRateProduct: UILabel!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var lblFeedback: UILabel!
    @IBOutlet weak var rateCosmos: CosmosView!
    @IBOutlet weak var btnLater: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var rateTitle: UILabel!
    @IBOutlet weak var textView: UITextView!
    var selectedRate: ((_ data: String) -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        textView.textColor = UIColor.lightGray
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.setText()
        textView.delegate = self
        if self.currentLanguage == "en"{
            self.rateTitle.text = "Quite ok"
            rateCosmos.rating = 3
        }
        else{
            self.rateTitle.text = "هدوء"
            rateCosmos.rating = 3
        }
        // Do any additional setup after loading the view.
        
        // Called when user finishes changing the rating by lifting the finger from the view.
        // This may be a good place to save the rating in the database or send to the server.
        self.rateCosmos.didFinishTouchingCosmos = { rating in
           // print("didFinishTouching:\(rating)")
        }
        
        // A closure that is called when user changes the rating by touching the view.
        // This can be used to update UI as the rating is being changed by moving a finger.
        self.rateCosmos.didTouchCosmos = { rating in
            
            if self.currentLanguage == "en"{
                self.rateTitle.text = self.titleRate[Int(rating-1)]
            }
            else{
          
                if rating == 1{
                    self.rateTitle.text = "سيئ جدا"
                }
                if rating == 2{
                    self.rateTitle.text = "غير جيد"
                }
                if rating == 3{
                    self.rateTitle.text = "هدوء"
                }
                if rating == 4{
                    self.rateTitle.text = "جيد جدا"
                }
                if rating == 5{
                    self.rateTitle.text = "ممتاز !!!"
                }
            }
        }
    }

    @IBAction func LaterReview(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func CancelReview(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func SubmitReview(_ sender: Any) {
        PostRateReview()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please write your comment here ... "
            textView.textColor = UIColor.lightGray
        }
    }
    
    //Post RateReview Start
    fileprivate  func PostRateReview(){
        
        let parameters: Parameters = [
            "productId": self.productId,
            "nickname": self.firstName,
            "title": self.rateTitle.text!,
            "detail": textView.text,
            "ratingData": [[
                "rating_id": "1",
                "ratingCode": "Quality",
                "ratingValue": self.rateCosmos.rating
                ], [
                    "rating_id": "2",
                    "ratingCode": "Value",
                    "ratingValue": self.rateCosmos.rating
                ], [
                    "rating_id": "3",
                    "ratingCode": "Price",
                    "ratingValue": self.rateCosmos.rating
                ]
            ],
            "customer_id":String(self.userId),
            "storeId": "1"
        ]
        rateReviewManager.postRateReview(postParams: parameters) { (result) in
            if result != nil {
               // let message = MDCSnackbarMessage()
                
//                if self.currentLanguage == "en"{
//                    message.text = "your feedback submitted successfully"
//                }
//                else{
//                    message.text = "تم إرسال تعليقاتك بنجاح"
//                }
//                MDCSnackbarManager.show(message)
                
                self.selectedRate?("")
                self.dismiss(animated: true)
            }
            else{
                let message = MDCSnackbarMessage()
                
                if self.currentLanguage == "en"{
                    message.text = "Error occured while submitting your feedback"
                }
                else{
                    message.text = "حدث خطأ أثناء إرسال ملاحظاتك"
                }
                MDCSnackbarManager.show(message)
                 self.selectedRate?("")
               self.dismiss(animated: true)
            }

        }
        
    }
    //Post RateReview End
    
    
    func fetchUser(){
        userManager.GetUserRequest(token: nil) { (data, error) in
            if error == nil {
                print("Activity Here ???")
                self.firstName = (data?.firstname)!
                self.lastName = (data?.lastname)!
                self.activity.isHidden = true
                self.userEmail = (data?.email)!
                self.userId = (data?.id)!
            }
            else{
                self.activity.isHidden = true
            }
        }
    }

    //Hide keyboard when user presses outside the field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textView.endEditing(true)
    }
    
    //Pressing Return should also hide
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textView.resignFirstResponder()
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
