//
//  testRangeViewController.swift
//  quitic3
//
//  Created by DOT on 8/20/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
//import WARangeSlider

class testRangeViewController: UIViewController {

    
    @IBOutlet weak var testRange: RangeSlider!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.testRange.minimumValue = 0
        self.testRange.maximumValue = 1000
        self.testRange.lowerValue = 0
        self.testRange.upperValue = 1000
        

        self.testRange.addTarget(self, action: #selector(testRangeViewController.rangeSliderValueChanged(_:)),
                              for: .valueChanged)
    }

    @objc func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
    }

    

}
