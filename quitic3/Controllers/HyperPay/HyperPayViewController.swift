//
//  HyperPayViewController.swift
//  quitic3
//
//  Created by DOT on 3/21/19.
//  Copyright © 2019 DOT. All rights reserved.
//

import UIKit
import SafariServices
import Localize_Swift
import SwiftyJSON
import Alamofire
import AlamofireObjectMapper

import MaterialComponents.MaterialSnackbar

enum CardParamsError: Error {
    case invalidParam(String)
}

class HyperPayViewController: UIViewController, SFSafariViewControllerDelegate {
    
    @IBOutlet var holderTextField: UITextField!
    @IBOutlet var numberTextField: UITextField!
    @IBOutlet var expiryMonthTextField: UITextField!
    @IBOutlet var expiryYearTextField: UITextField!
    @IBOutlet var cvvTextField: UITextField!
    @IBOutlet var processingView: UIActivityIndicatorView!
    @IBOutlet var cardBrandLabel: UILabel!
    
    
    @IBOutlet weak var lblCardHolder: UILabel!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var lblExpiryDate: UILabel!
    @IBOutlet weak var lblCVV: UILabel!
    @IBOutlet weak var btnPayNow: UIButton!
    
    
    var provider: OPPPaymentProvider?
    var transaction: OPPTransaction?
    var safariVC: SFSafariViewController?
    var paymentCode:String = ""
    
    var CardBrand = "VISA"
    var isCustomer = true
    
    var guestCartIdentity :String = ""
    var selectedPaymentMethod :String = ""
    var merchantTransactionId:String = ""
    let cartManager = CheckoutManager()
    var currentLanguage = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        self.cardBrandLabel.text = self.CardBrand
        
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
        
        if self.currentLanguage == "en"
        {
            lblCardHolder.text = "Card Holder"
            lblCardNumber.text = "Card Number"
            lblCVV.text = "CVV"
            lblExpiryDate.text = "Expiry Date"
            btnPayNow.setTitle("Pay Now", for: .normal)
            
            expiryMonthTextField.placeholder = "MM"
            expiryYearTextField.placeholder = "YY"
            
            
            
            lblCardHolder.font = UIFont(name: enLanguageConstant, size: 17)!
            lblCardNumber.font = UIFont(name: enLanguageConstant, size: 17)!
            lblCVV.font = UIFont(name: enLanguageConstant, size: 17)!
            lblExpiryDate.font = UIFont(name: enLanguageConstant, size: 17)!
            btnPayNow.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
        }
        else
        {
            lblCardHolder.text = "حامل البطاقة"
            lblCardNumber.text = "رقم البطاقة"
            lblCVV.text = "CVV"
            lblExpiryDate.text = "تاريخ الانتهاء"
            
            expiryMonthTextField.placeholder = "شهر"
            expiryYearTextField.placeholder = "نسة"
            
            lblCardHolder.font = UIFont(name: arLanguageConstant, size: 17)!
            lblCardNumber.font = UIFont(name: arLanguageConstant, size: 17)!
            lblCVV.font = UIFont(name: arLanguageConstant, size: 17)!
            lblExpiryDate.font = UIFont(name: arLanguageConstant, size: 17)!
            
            btnPayNow.setTitle("ادفع الان", for: .normal)
            btnPayNow.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
        }
        
//        self.holderTextField.text = Config.cardHolder
//        self.numberTextField.text = Config.cardNumber
//        self.expiryMonthTextField.text = Config.cardExpiryMonth
//        self.expiryYearTextField.text = Config.cardExpiryYear
//        self.cvvTextField.text = Config.cardCVV
        
        self.provider = OPPPaymentProvider.init(mode: .live)
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }

    @IBAction func payButtonAction(_ sender: Any) {
        do {
            try self.validateFields()
        } catch CardParamsError.invalidParam(let reason) {
            Utils.showResult(presenter: self, success: false, message: reason)
            return
        } catch {
            Utils.showResult(presenter: self, success: false, message: "Parameters are invalid")
            return
        }
        
        self.view.endEditing(true)
        self.processingView.startAnimating()
        self.processingView.isHidden = false
        
        if(self.isCustomer)
        {
             self.getOrderIdCustomer()
            //self.placeOrderAPI()
        }
        else
        {
            //self.getOrderIdGuest()
            self.placeOrderAPI()
        }
        
//        Request.requestCheckoutID(amount: Config.amount,paymentCode:self.paymentCode,merchantTransactionId:self.merchantTransactionId, currency: Config.currency) { (checkoutID) in
//            DispatchQueue.main.async {
//                guard let checkoutID = checkoutID else {
//                    self.processingView.stopAnimating()
//                    self.processingView.isHidden = true
//                    Utils.showResult(presenter: self, success: false, message: "Checkout ID is empty")
//                    return
//                }
//
//                guard let transaction = self.createTransaction(checkoutID: checkoutID) else {
//                    self.processingView.stopAnimating()
//                    self.processingView.isHidden = true
//                    return
//                }
//
//                self.provider!.submitTransaction(transaction, completionHandler: { (transaction, error) in
//                    DispatchQueue.main.async {
//                        self.processingView.stopAnimating()
//                        self.processingView.isHidden = true
//                        self.handleTransactionSubmission(transaction: transaction, error: error)
//                    }
//                })
//            }
//        }
    }
    
    // MARK: - Payment helpers
    
    func createTransaction(checkoutID: String) -> OPPTransaction? {
        do {
            let params = try OPPCardPaymentParams.init(checkoutID: checkoutID, paymentBrand: self.CardBrand, holder: self.holderTextField.text!, number: self.numberTextField.text!, expiryMonth: self.expiryMonthTextField.text!, expiryYear: self.expiryYearTextField.text!, cvv: self.cvvTextField.text!)
            //params.shopperResultURL = Config.urlScheme + "://payment"
            
             params.shopperResultURL = Config.urlScheme + "://result"
            return OPPTransaction.init(paymentParams: params)
        } catch let error as NSError {
            Utils.showResult(presenter: self, success: false, message: error.localizedDescription)
            return nil
        }
    }
    
    func handleTransactionSubmission(transaction: OPPTransaction?, error: Error?) {
        guard let transaction = transaction else {
            Utils.showResult(presenter: self, success: false, message: error?.localizedDescription)
            return
        }
        
        self.transaction = transaction
        if transaction.type == .synchronous {
            // If a transaction is synchronous, just request the payment status
            self.requestPaymentStatus()
        } else if transaction.type == .asynchronous {
            // If a transaction is asynchronous, you should open transaction.redirectUrl in a browser
            // Subscribe to notifications to request the payment status when a shopper comes back to the app
            NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveAsynchronousPaymentCallback), name: Notification.Name(rawValue: Config.asyncPaymentCompletedNotificationKey), object: nil)
            self.presenterURL(url: self.transaction!.redirectURL!)
        } else {
            Utils.showResult(presenter: self, success: false, message: "Invalid transaction")
        }
    }
    
    func presenterURL(url: URL)
    {
        UIApplication.shared.open(url)
//        self.safariVC = SFSafariViewController(url: url)
//        self.safariVC?.delegate = self;
//        self.present(safariVC!, animated: true)
//        {
//            print("Your payment was successful")
//        }
        //self.present(safariVC!, animated: true, completion: nil)
    }
    
    func requestPaymentStatus() {
        // You can either hard-code resourcePath or request checkout info to get the value from the server
        // * Hard-coding: "/v1/checkouts/" + checkoutID + "/payment"
        // * Requesting checkout info:
        
        guard let checkoutID = self.transaction?.paymentParams.checkoutID else {
            Utils.showResult(presenter: self, success: false, message: "Checkout ID is invalid")
            return
        }
        self.transaction = nil
        
        self.processingView.isHidden = false
        self.processingView.startAnimating()
        self.provider!.requestCheckoutInfo(withCheckoutID: checkoutID) { (checkoutInfo, error) in
            DispatchQueue.main.async {
                guard var resourcePath = checkoutInfo?.resourcePath else {
                    self.processingView.stopAnimating()
                    self.processingView.isHidden = true
                    Utils.showResult(presenter: self, success: false, message: "Checkout info is empty or doesn't contain resource path")
                    return
                }
                
                Request.requestPaymentStatus(resourcePath: resourcePath, paymentCode:self.paymentCode) { (success) in
                    DispatchQueue.main.async {
                        self.processingView.stopAnimating()
                        self.processingView.isHidden = true
                        
                        
                        let arraySucess:Array = success
                        
                        if arraySucess.count > 0
                        {
                            let code:String = arraySucess[0] as! String
                            let orderId:String = arraySucess[2] as! String
                            let message:String = arraySucess[3] as! String
                            
                            
                            if ((code == "000.100.110") || (code == "000.000.000"))
                            {
                                let ConfirmOrderViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConfirmOrderViewController") as! ConfirmOrderViewController
                                ConfirmOrderViewController.stringPassed = "Your order no is: \(orderId)"
                                self.navigationController?.pushViewController(ConfirmOrderViewController, animated: true)
                            }
                            else
                            {
                                Utils.showResult(presenter: self, success: true, message: message)
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Async payment callback
    
    @objc func didReceiveAsynchronousPaymentCallback() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: Config.asyncPaymentCompletedNotificationKey), object: nil)
        
         self.requestPaymentStatus()
        
//        self.safariVC?.dismiss(animated: true, completion: {
//            DispatchQueue.main.async {
//                self.requestPaymentStatus()
//            }
//        })
    }
    
    // MARK: - Fields validation
    
    func validateFields() throws {
        guard let holder = self.holderTextField.text, OPPCardPaymentParams.isHolderValid(holder) else {
            throw CardParamsError.invalidParam("Card holder name is invalid.")
        }
        
        guard let number = self.numberTextField.text, OPPCardPaymentParams.isNumberValid(number, luhnCheck: true) else {
            throw CardParamsError.invalidParam("Card number is invalid.")
        }
        
        guard let month = self.expiryMonthTextField.text, let year = self.expiryYearTextField.text, !OPPCardPaymentParams.isExpired(withExpiryMonth: month, andYear: year) else {
            throw CardParamsError.invalidParam("Expiry date is invalid")
        }
        
        guard let cvv = self.cvvTextField.text, OPPCardPaymentParams.isCvvValid(cvv) else {
            throw CardParamsError.invalidParam("CVV is invalid")
        }
    }
    
    // MARK: - Safari Delegate
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true) {
            DispatchQueue.main.async {
                self.requestPaymentStatus()
            }
        }
    }
    
    // MARK: - Keyboard dismissing on tap
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func getOrderIdGuest()
    {
        let itemParams: Parameters = [
            "paymentMethod":  [
                "method": selectedPaymentMethod
            ]
        ]
        
        cartManager.postPaymentInformation(postParams: itemParams) { (result) in
            
            let ConfirmOrderViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConfirmOrderViewController") as! ConfirmOrderViewController
            if Localize.currentLanguage() == "en"
            {
                if result != nil
                {
                    
                    let merchantId:String = "\(result)"
                     self.requestForCheckOutId(merchantId: merchantId)
                    
                   // ConfirmOrderViewController.stringPassed = "Your order no is: \(result)"
                   // self.navigationController?.pushViewController(ConfirmOrderViewController, animated: true)
                }
                else{
                    let message = MDCSnackbarMessage()
                    message.text = "Error occured while placing order"
                    MDCSnackbarManager.show(message)
                }
            }
            else{
                if result != JSON.null{
                    ConfirmOrderViewController.stringPassed = "\(result)" + "طلبك لا:"
                    self.navigationController?.pushViewController(ConfirmOrderViewController, animated: true)
                }
                else{
                    let message = MDCSnackbarMessage()
                    message.text = "حدث خطأ أثناء تقديم الطلب"
                    MDCSnackbarManager.show(message)
                    
                }
            }
        }
        
        
//        cartManager.PutPlaceOrder(guestCartId: self.guestCartIdentity, postParams: itemParams) { (result , error) in
//            let ConfirmOrderViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConfirmOrderViewController") as! ConfirmOrderViewController
//
//            if Localize.currentLanguage() == "en"{
//                print("result: ", result)
//                if result! != JSON.null{
////                    let s = UIStoryboard(name: "Main", bundle: nil)
////                    let vc = s.instantiateViewController(withIdentifier: "ConfirmOrderViewController") as! ConfirmOrderViewController
////                    vc.stringPassed = "Your order no is: \(result!)"
////                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//                else{
//                    let message = MDCSnackbarMessage()
//                    message.text = "Error occured while placing order"
//                    MDCSnackbarManager.show(message)
//                }
//
//            }
//            else{
//                if result! != JSON.null{
//                    ConfirmOrderViewController.stringPassed = "\(result!)" + "طلبك لا:"
//                    self.navigationController?.pushViewController(ConfirmOrderViewController, animated: true)
//                }
//                else{
//                    let message = MDCSnackbarMessage()
//                    message.text = "حدث خطأ أثناء تقديم الطلب"
//                    MDCSnackbarManager.show(message)
//
//                }
//
//            }
//        }
    }

    func getOrderIdCustomer()
    {
        let itemParams: Parameters = [
            "paymentMethod":  [
                "method": selectedPaymentMethod
            ]
        ]
        
        cartManager.postPaymentInformation(postParams: itemParams) { (result) in

            let ConfirmOrderViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConfirmOrderViewController") as! ConfirmOrderViewController
            if Localize.currentLanguage() == "en"
            {
                if result != nil
                {
                    let merchantId:String! = "\(result)"
                    
                    Constant_OrderId = merchantId
                
                    self.requestForCheckOutId(merchantId: merchantId)
                    
                   // ConfirmOrderViewController.stringPassed = "Your order no is: \(result)"
                   // self.navigationController?.pushViewController(ConfirmOrderViewController, animated: true)
                }
                else{
                    let message = MDCSnackbarMessage()
                    message.text = "Error occured while placing order"
                    MDCSnackbarManager.show(message)
                }
            }
            else{
                if result != JSON.null{
                    ConfirmOrderViewController.stringPassed = "\(result)" + "طلبك لا:"
                    self.navigationController?.pushViewController(ConfirmOrderViewController, animated: true)
                }
                else{
                    let message = MDCSnackbarMessage()
                    message.text = "حدث خطأ أثناء تقديم الطلب"
                    MDCSnackbarManager.show(message)

                }
            }
        }
    }
    
    func requestForCheckOutId(merchantId:String)
    {
        
        Request.requestCheckoutID(amount: Config.amount,paymentCode:self.paymentCode,merchantTransactionId:merchantId, currency: Config.currency) { (checkoutID) in
            DispatchQueue.main.async {
                guard let checkoutID = checkoutID else {
                    self.processingView.stopAnimating()
                    self.processingView.isHidden = true
                    Utils.showResult(presenter: self, success: false, message: "Checkout ID is empty")
                    return
                }
                
                guard let transaction = self.createTransaction(checkoutID: checkoutID) else {
                    self.processingView.stopAnimating()
                    self.processingView.isHidden = true
                    return
                }
                
                self.provider!.submitTransaction(transaction, completionHandler: { (transaction, error) in
                    DispatchQueue.main.async {
                        self.processingView.stopAnimating()
                        self.processingView.isHidden = true
                        self.handleTransactionSubmission(transaction: transaction, error: error)
                    }
                })
            }
        }
    }
    
    func placeOrderAPI()
    {
        let itemParams: Parameters = [
            "paymentMethod":  [
                "method": selectedPaymentMethod
            ]
        ]

        cartManager.PutPlaceOrder(guestCartId: self.guestCartIdentity, postParams: itemParams) { (result , error) in
            let ConfirmOrderViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConfirmOrderViewController") as! ConfirmOrderViewController

            
            if Localize.currentLanguage() == "en"
            {
                if result != nil
                {
                    let merchantId:String = String(format: "%@", (result?.rawString())!)
                    
                    Constant_OrderId = merchantId
                    
                    self.requestForCheckOutId(merchantId: merchantId)
                    
                    // ConfirmOrderViewController.stringPassed = "Your order no is: \(result)"
                    // self.navigationController?.pushViewController(ConfirmOrderViewController, animated: true)
                }
                else{
                    let message = MDCSnackbarMessage()
                    message.text = "Error occured while placing order"
                    MDCSnackbarManager.show(message)
                }
            }
            else{
                if result != JSON.null{
                    ConfirmOrderViewController.stringPassed = "\(result)" + "طلبك لا:"
                    self.navigationController?.pushViewController(ConfirmOrderViewController, animated: true)
                }
                else{
                    let message = MDCSnackbarMessage()
                    message.text = "حدث خطأ أثناء تقديم الطلب"
                    MDCSnackbarManager.show(message)
                    
                }
            }
        
        }
    }

}
