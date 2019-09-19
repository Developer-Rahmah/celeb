//
//  HomeTestViewController.swift
//  quitic3
//
//  Created by DOT on 8/9/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import LGSideMenuController

class HomeTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBAction func openLeftView(_ sender: Any) {
//    }
//
    @IBAction func openMenu(_ sender: Any) {
        openLeftView(sender)
//        openRightView(sender)
    }
    
    
}
