//
//  ViewController.swift
//  quitic3
//
//  Created by DOT on 7/10/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let navBarTitleImage = UIImage(named: "navBarIcon")
        
        self.navigationItem.titleView = UIImageView(image: navBarTitleImage)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

