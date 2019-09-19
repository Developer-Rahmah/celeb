//
//  TermsViewController.swift
//  quitic3
//
//  Created by DOT on 9/6/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import WebKit

class TermsViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webBrowse: WKWebView!
    @IBOutlet weak var Activity: UIActivityIndicatorView!
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navTitle: UINavigationItem!
    
    @IBOutlet weak var leftBackButton: UIBarButtonItem!
    
    @IBOutlet weak var navTopView: UIView!
    
    let webResponseManager = WebManager()
    
    @IBAction func leftBackButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var webTopConst: NSLayoutConstraint!
    
    var currentLanguage: String = ""
    var type: String = ""
    var videoUrl: URL = URL(string: API.baseURL.staging+"cmsPage/534")!
    var lblHeader = UILabel()
    var viewNavCenter = UIView()
    
    var pushed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.pushed {
        
            self.navBar.isHidden = true
            self.navTopView.isHidden = false
            webTopConst.constant = -94
            CommonManager.shared.CheckCurrentLanguage(){ (complete) in
                if complete.count>0{
                    self.currentLanguage = complete[0].name!
                }
            }
            
            if self.currentLanguage == "en"{
                self.leftBackButton.image = UIImage(named: "icons8-back-50")
                if self.type == "privacyPolicy"{
                    self.navTitle.title = "Privacy Policy"
                    videoUrl = URL(string: API.baseURL.staging+"cmsPage/4")!
                    getResponseFromAPI(url: API.baseURL.staging+"cmsPage/4")
                }
                else if self.type == "termsAndCondition"{
                    self.navTitle.title = "Terms And Condition"
                    videoUrl = URL(string: API.baseURL.staging+"cmsPage/549")!
                    getResponseFromAPI(url: API.baseURL.staging+"cmsPage/549")
                }
                else if self.type == "refundPolicy"{
                    self.navTitle.title = "Refund Policy"
                    videoUrl = URL(string: API.baseURL.staging+"cmsPage/550")!
                    getResponseFromAPI(url: API.baseURL.staging+"cmsPage/550")
                }
                else if self.type == "faqs"{
                    //  self.navTitle.title = "FAQ's"
                    //self.title = "FAQ's"
                    videoUrl = URL(string: API.baseURL.staging+"cmsPage/535")!
                    getResponseFromAPI(url: API.baseURL.staging+"cmsPage/535")
                }
                else{
                    self.navTitle.title = "About Us"
                    videoUrl = URL(string: API.baseURL.staging+"cmsPage/534")!
                    getResponseFromAPI(url: API.baseURL.staging+"cmsPage/534")
                }
                
            }
            else{
                self.leftBackButton.image = UIImage(named: "rightPointing")
                
                if self.type == "privacyPolicy"{
                    self.navTitle.title = "سياسة الخصوصية"
                    videoUrl = URL(string: API.baseURL.staging+"cmsPage/551")!
                    getResponseFromAPI(url: API.baseURL.staging+"cmsPage/551")
                }
                else if self.type == "termsAndCondition"{
                    self.navTitle.title = "شروط الخدمة"
                    videoUrl = URL(string: API.baseURL.staging+"cmsPage/552")!
                    getResponseFromAPI(url: API.baseURL.staging+"cmsPage/552")
                }
                else if self.type == "refundPolicy"{
                    self.navTitle.title = "سياسة الاسترجاع"
                    videoUrl = URL(string: API.baseURL.staging+"cmsPage/553")!
                    getResponseFromAPI(url: API.baseURL.staging+"cmsPage/553")
                }
                else if self.type == "faqs"{
                    // self.navTitle.title = "أسئلة وأجوبة"
                    // self.title = "أسئلة وأجوبة"
                    videoUrl = URL(string: API.baseURL.staging+"cmsPage/554")!
                    getResponseFromAPI(url: API.baseURL.staging+"cmsPage/554")
                }
                else{
                    self.navTitle.title = "حول"
                    videoUrl = URL(string: API.baseURL.staging+"cmsPage/534")!
                    getResponseFromAPI(url: API.baseURL.staging+"cmsPage/534")
                }
            }
            
        }
        else
        {
             self.title = ""
             self.navTitle.title = ""
            CommonManager.shared.CheckCurrentLanguage(){ (complete) in
                if complete.count>0{
                    self.currentLanguage = complete[0].name!
                }
            }
            if self.currentLanguage == "en"{
                self.leftBackButton.image = UIImage(named: "icons8-back-50")
                if self.type == "privacyPolicy"{
                    videoUrl = URL(string: API.baseURL.staging+"cmsPage/4")!
                    getResponseFromAPI(url: API.baseURL.staging+"cmsPage/4")
                }
                else if self.type == "termsAndCondition"{
                    videoUrl = URL(string: API.baseURL.staging+"cmsPage/549")!
                    getResponseFromAPI(url: API.baseURL.staging+"cmsPage/549")
                }
                else if self.type == "refundPolicy"{
                    videoUrl = URL(string: API.baseURL.staging+"cmsPage/550")!
                    getResponseFromAPI(url: API.baseURL.staging+"cmsPage/550")
                }
                else if self.type == "faqs"{
                    videoUrl = URL(string: API.baseURL.staging+"cmsPage/535")!
                    getResponseFromAPI(url: API.baseURL.staging+"cmsPage/535")
                }
                else{
                    videoUrl = URL(string: API.baseURL.staging+"cmsPage/534")!
                    getResponseFromAPI(url: API.baseURL.staging+"cmsPage/534")
                }
                
            }
            else{
                self.leftBackButton.image = UIImage(named: "rightPointing")
                
                if self.type == "privacyPolicy"{
                    videoUrl = URL(string: API.baseURL.staging+"cmsPage/551")!
                    getResponseFromAPI(url: API.baseURL.staging+"cmsPage/551")
                }
                else if self.type == "termsAndCondition"{
                    videoUrl = URL(string: API.baseURL.staging+"cmsPage/552")!
                    getResponseFromAPI(url: API.baseURL.staging+"cmsPage/552")
                }
                else if self.type == "refundPolicy"{
                    videoUrl = URL(string: API.baseURL.staging+"cmsPage/553")!
                    getResponseFromAPI(url: API.baseURL.staging+"cmsPage/553")
                }
                else if self.type == "faqs"{
                    videoUrl = URL(string: API.baseURL.staging+"cmsPage/554")!
                    getResponseFromAPI(url: API.baseURL.staging+"cmsPage/554")
                }
                else{
                    videoUrl = URL(string: API.baseURL.staging+"cmsPage/534")!
                    getResponseFromAPI(url: API.baseURL.staging+"cmsPage/534")
                }
            }
        }
        
        
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
        viewNavCenter = UIView(frame: CGRect(x: 40, y: -13, width:  (self.navBar.frame.size.width), height: 10))
        viewNavCenter.backgroundColor = UIColor.white
        self.navBar.addSubview(viewNavCenter)


        lblHeader = UILabel.init(frame:  CGRect(x: 50, y: -11, width: self.view.frame.width - 100, height: 50))
        lblHeader.text = "FAQ's"
        //lblHeader.font = UIFont.init(name: headerFont, size: 30)
        lblHeader.textAlignment = .center
        lblHeader.textColor = UIColor.init(red: 251, green: 96, blue: 127)
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
        if self.currentLanguage == "en"{
            self.leftBackButton.image = UIImage(named: "back")
            if self.type == "privacyPolicy"{
                lblHeader.text = "Privacy Policy"
            }
            else if self.type == "termsAndCondition"{
                lblHeader.text = "Terms And Condition"
            }
            else if self.type == "refundPolicy"{
                lblHeader.text = "Refund Policy"
            }
            else if self.type == "faqs"{
                lblHeader.text = "FAQ's"
            }
            else{
                lblHeader.text = "About Us"
            }

        }
        else{
            self.leftBackButton.image = UIImage(named: "arback")

            if self.type == "privacyPolicy"{
                lblHeader.text = "سياسة الخصوصية"
            }
            else if self.type == "termsAndCondition"{
                lblHeader.text = "شروط الخدمة"
            }
            else if self.type == "refundPolicy"{
                lblHeader.text = "سياسة الاسترجاع"
            }
            else if self.type == "faqs"{
                lblHeader.text = "أسئلة وأجوبة"
            }
            else{
                lblHeader.text = "حول"
            }
        }

        if self.currentLanguage == "en"
        {
            lblHeader.font = UIFont.init(name: enMarselLanguageConstant, size: 23)
        }
        else
        {
            lblHeader.font = UIFont.init(name: arLanguageConstant, size: 23)
        }

        self.navBar.addSubview(lblHeader)
        
        if pushed
        {
            viewNavCenter = UIView(frame: CGRect(x: 0, y: -13, width:  (self.view.frame.size.width), height: 20))
            viewNavCenter.backgroundColor = UIColor.white
            self.navigationController?.navigationBar.addSubview(viewNavCenter)
            
            
            lblHeader = UILabel.init(frame:  CGRect(x: 50, y: -11, width: self.view.frame.width - 100, height: 50))
            lblHeader.text = "FAQ's"
            //lblHeader.font = UIFont.init(name: headerFont, size: 30)
            lblHeader.textAlignment = .center
            lblHeader.textColor = UIColor.init(red: 251, green: 96, blue: 127)
            
            if self.currentLanguage == "en"{
                self.leftBackButton.image = UIImage(named: "icons8-back-50")
                if self.type == "privacyPolicy"{
                    lblHeader.text = "Privacy Policy"
                }
                else if self.type == "termsAndCondition"{
                    lblHeader.text = "Terms And Condition"
                }
                else if self.type == "refundPolicy"{
                    lblHeader.text = "Refund Policy"
                }
                else if self.type == "faqs"{
                    lblHeader.text = "FAQ's"
                }
                else{
                    lblHeader.text = "About Us"
                }
                
            }
            else{
                self.leftBackButton.image = UIImage(named: "rightPointing")
                
                if self.type == "privacyPolicy"{
                    lblHeader.text = "سياسة الخصوصية"
                }
                else if self.type == "termsAndCondition"{
                    lblHeader.text = "شروط الخدمة"
                }
                else if self.type == "refundPolicy"{
                    lblHeader.text = "سياسة الاسترجاع"
                }
                else if self.type == "faqs"{
                    lblHeader.text = "الأسئلة المتكررة"
                }
                else{
                    lblHeader.text = "حول"
                }
            }
            
            if self.currentLanguage == "en"
            {
                lblHeader.font = UIFont.init(name: enMarselLanguageConstant, size: 23)
            }
            else
            {
                lblHeader.font = UIFont.init(name: arLanguageConstant, size: 23)
            }
            
            self.navigationController?.navigationBar.addSubview(lblHeader)
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        lblHeader.removeFromSuperview()
        viewNavCenter.removeFromSuperview()
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.Activity.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.Activity.stopAnimating()
    }
    
    func getResponseFromAPI(url: String){
        self.Activity.startAnimating()
        self.webResponseManager.GetWebResponse(url: url) { (data, error) in
            if error == nil {
                
                CommonManager.shared.CheckCurrentLanguage(){ (complete) in
                    if complete.count>0{
                        self.currentLanguage = complete[0].name!
                    }
                    
                    if self.currentLanguage == "en"{
                        
                        self.webBrowse.loadHTMLString("<!DOCTYPE html><html><head><meta name=\"viewport\" content=\"width=150, initial-scale=1.0\"><style>@font-face{font-family: \'Belleza\';font-weight: normal;src: url(MarselisSerifOT.otf);}</style></head><body><p style=\"font-family: 'Belleza';\"><font size=\"3\">\((data?.content)!)</font></p></body></html>", baseURL: Bundle.main.bundleURL)
                        
                    }
                    else{
                        
                        self.webBrowse.loadHTMLString("<!DOCTYPE html><html><head><meta name=\"viewport\" content=\"width=150, initial-scale=1.0\"><style>@font-face{font-family: \'GE Flow\';  src: local('GE Flow'), url(geflow.otf)}</style></head><body><p style=\"text-align: right; font-family: 'GE Flow';\"><font size=\"3\">\((data?.content)!)</font></p></body></html>", baseURL: Bundle.main.bundleURL)
                    }
                    
                    self.webBrowse.addSubview(self.Activity)
                    
                    self.webBrowse.navigationDelegate = self
                    self.Activity.hidesWhenStopped = true
                }
            }
        }
    }

    

}
