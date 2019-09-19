//
//  RateViewController.swift
//  quitic3
//
//  Created by APPLE on 8/29/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import WebKit
import Localize_Swift

class RateViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var btnOk: UIButton!
    //    var webView: WKWebView!
    var url_key = ""
    var productId = ""
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBAction func btnOkAction(_ sender: Any) {
        selectedRate?("")
          dismiss(animated: true)
    }
    @IBOutlet weak var webView: WKWebView!
    var currentLanguage = ""
        var selectedRate: ((_ data: String) -> ())?
//    @IBOutlet weak var activity : UIActivityIndicatorView!
//    override func loadView() {
//        webView = WKWebView()
//        webView.navigationDelegate = self
//        view = webView
//    }
    
    @objc func setText(){
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
        if self.currentLanguage == "en"{
            lblTitle.text = "Rate/Reviews"
            btnOk.setTitle("Ok", for: .normal)
        }
        else{
            lblTitle.text = "معدل / التعليقات"
            btnOk.setTitle("اوافق", for: .normal)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.setText()
//        let url = URL(string: "https://ecommerce.mystaging.me/\(self.url_key).html#reviews")!
//        webView.load(URLRequest(url: url))
//        self.webView.addSubview(self.activity)
//        self.activity.startAnimating()
//        self.webView.navigationDelegate = self
//        self.activity.hidesWhenStopped = true
//        
//        
//        
//        webView.allowsBackForwardNavigationGestures = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         selectedRate?("")
            dismiss(animated: true)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activity.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.activity.stopAnimating()
    }
}
