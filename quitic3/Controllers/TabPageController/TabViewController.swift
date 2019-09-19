//
//  TabViewController.swift
//  quitic3
//
//  Created by DOT on 7/17/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import Localize_Swift

class TabViewController: UITabBarController {
var currentLanguage = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func setText(){
        print("Tab Bar Name Should Change")
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
        
        if self.currentLanguage == "en"{
            self.tabBarController?.tabBar.items?[1].title = "tab title en"
            
        }
        else{
            
            self.tabBarController?.tabBar.items?[1].title = "tab title ar"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectedIndex(index: Int){
        self.tabBarController?.selectedIndex = index
    }
    
}
