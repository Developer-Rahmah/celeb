//
//  HomeNavController.swift
//  quitic3
//
//  Created by DOT on 8/2/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import Localize_Swift

class HomeNavController: UINavigationController {

    var currentLanguage: String = "en"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        
        self.setText()
        
    }
    
    @objc func setText(){
        
        var navigationFont = UIFont(name: enLanguageConstant, size: 24)!
        
        CommonManager.shared.CheckCurrentLanguage() { (complete) in
            
            if complete.count>0 {
                
                self.currentLanguage = complete[0].name!
            }
            
            if self.currentLanguage != "en"{
                
                navigationFont = UIFont(name: arLanguageConstant, size: 24)!
            }
            
            let navigationFontAttributes = [NSAttributedStringKey.font: navigationFont]
            
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font:UIFont(name: headerFont, size: 24) ?? UIFont.systemFont(ofSize: 24.0) ,NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white]
            
            UIBarButtonItem.appearance().setTitleTextAttributes(navigationFontAttributes, for: .normal)
        }
        
    }


}
