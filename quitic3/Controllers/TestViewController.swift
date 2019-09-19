//
//  TestViewController.swift
//  quitic3
//
//  Created by MacBook Pro on 25/08/2019.
//  Copyright © 2019 DOT. All rights reserved.
//

import UIKit
import  SJSegmentedViewController
class TestViewController: SJSegmentedViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        segmentControllers = arrayController as! [UIViewController]
        segmentTitleFont = UIFont(name: enLanguageConstant, size: 14)!
        
        
        headerViewHeight = 200
        selectedSegmentViewHeight = 3.0
        headerViewOffsetHeight = 0.0
        segmentViewHeight = 0.0
        segmentTitleColor = .quiticPink
        selectedSegmentViewColor = .quiticPink
        segmentShadow = SJShadow.light()
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        segmentBounces = false
        
        self.navigationController?.isNavigationBarHidden = false
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
