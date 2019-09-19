//
//  MainViewController.swift
//  quitic3
//
//  Created by DOT on 8/9/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import LGSideMenuController

class MainViewController: LGSideMenuController {
var currentLanguage = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
            else{
                CommonManager.shared.saveCoreDataLanguage(lang: Languages.en.rawValue) { (complete) in
                    if complete {
                        UIView.appearance().semanticContentAttribute = .forceLeftToRight
                        let windows = UIApplication.shared.windows
                        for window in windows {
                            for view in window.subviews {
                                view.removeFromSuperview()
                                window.addSubview(view)
                            }
                        }
                        let menuLeftNavigationController = UISideMenuNavigationController()
                        menuLeftNavigationController.leftSide = true
                        // SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
                        dismiss(animated: true, completion: nil)
                        self.sideMenuController?.hideLeftViewAnimated()
                        self.sideMenuController?.hideRightViewAnimated()
                    }
                    else{
                        
                    }
                }
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
