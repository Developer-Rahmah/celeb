//
//  UISideMenuNavigationController.swift
//  quitic3
//
//  Created by DOT on 7/10/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit


class UISideMenuNavigationController: UINavigationController {
    @IBInspectable open var leftSide: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
