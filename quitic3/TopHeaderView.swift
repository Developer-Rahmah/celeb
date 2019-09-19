//
//  TopHeaderView.swift
//  quitic3
//
//  Created by APPLE on 03/10/2018.
//  Copyright © 2018 DOT. All rights reserved.
//

import Foundation
import UIKit
import Localize_Swift
import GSKStretchyHeaderView
protocol changeSegmentActionProtocol {
    func changeSegmentAction(index: Int)
}
class TopHeaderView: GSKStretchyHeaderView {
    @IBOutlet weak var celebImage: UIImageView!
    
    @IBOutlet weak var celebName: UILabel!
    
    
    
    var currentLanguage = "en"
    var labels = AppLabels()
    @objc func setText(){
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                labels = AppLabels()
                self.currentLanguage = complete[0].name!
                
            }
        }
    }
    var changeSegmentActionDelegate: changeSegmentActionProtocol?
    @IBAction func segmentAction(_ sender: Any) {
        changeSegmentActionDelegate?.changeSegmentAction(index: segmentTab.selectedSegmentIndex)
    }
   //  @IBOutlet weak var celebrityImage: UIImageView!
    
    @IBOutlet weak var segmentTab: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.expansionMode = GSKStretchyHeaderViewExpansionMode(rawValue: GSKStretchyHeaderViewExpansionMode.topOnly.rawValue)!
        self.minimumContentHeight = 63
        
        //self.minimumContentHeight = 64
        self.maximumContentHeight  = 400
        //        segmentTab.removeAllSegments()
        //  let items = ["Green", "Red", "Blue"]

//        let myColor = UIColor.gray
//        //segmentTab.layer.borderWidth = 2.0
//        segmentTab.layer.borderColor = myColor.cgColor
        if self.currentLanguage == "en"{
            segmentTab.setTitle(ENMYBOUTIQUES, forSegmentAt: 0)
            segmentTab.setTitle(ENVIDEOS, forSegmentAt: 1)
            segmentTab.setTitle(ENSOCIALMEDIA, forSegmentAt: 2)
        }
        else{
            segmentTab.setTitle(ARMYBOUTIQUES, forSegmentAt: 0)
            segmentTab.setTitle(ARVIDEOS, forSegmentAt: 1)
            segmentTab.setTitle(ARSOCIALMEDIA, forSegmentAt: 2)
        }
        
//        let buttonBar = UIView()
        // This needs to be false since we are using auto layout constraints
//        buttonBar.translatesAutoresizingMaskIntoConstraints = false
//        buttonBar.backgroundColor = UIColor.orange
        // Below view.addSubview(segmentedControl)
        // Constrain the top of the button bar to the bottom of the segmented control
//        buttonBar.topAnchor.constraint(equalTo: (segmentTab?.bottomAnchor)!).isActive = true
//        buttonBar.heightAnchor.constraint(equalToConstant: 2).isActive = true
        // Constrain the button bar to the left side of the segmented control
//        buttonBar.leftAnchor.constraint(equalTo: (segmentTab?.leftAnchor)!).isActive = true
        // Constrain the button bar to the width of the segmented control divided by the number of segments
//        buttonBar.widthAnchor.constraint(equalTo: (segmentTab?.widthAnchor)!, multiplier: 1 / CGFloat((segmentTab?.numberOfSegments)!)).isActive = true
        //        self.segmentTab.titles = ["title","title","title"]
        //here you can add things to your view....
        //        segmentTab = UISegmentedControl(items: items)
        //        segmentTab.insertSegment(withTitle: "Green", at: 0, animated: true)
        //        segmentTab.insertSegment(withTitle: "Red", at: 1, animated: true)
        //        segmentTab.insertSegment(withTitle: "Blue", at: 2, animated: true)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.setText()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.setText()
        
    }
    //    private func commonInit(items :[String])
    //    {    let items = ["Green", "Red", "Blue"]
    //        //here you can add things to your view....
    //        self.segmentTab = UISegmentedControl(items: items)
    //        print("commonInit called")
    //    }
    
    //    private func createView(items: [String]) -> UIView {
    //        let segmentedControl = UISegmentedControl(items: items)
    //        segmentedControl.tintColor = .white
    //        segmentedControl.selectedSegmentIndex = 0
    //
    //        return segmentedControl
    //    }
    
}

