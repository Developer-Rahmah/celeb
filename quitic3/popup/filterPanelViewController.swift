//
//  filterPanelViewController.swift
//  quitic3
//
//  Created by DOT on 8/19/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import Localize_Swift

class filterPanelViewController: UIViewController {
    
    @IBOutlet weak var btnNewestlbl: UIButton!
    
    @IBOutlet weak var btnAZlbl: UIButton!
    
    @IBOutlet weak var btnZAlbl: UIButton!
    
    @IBOutlet weak var btnPriceLowToHighlbl: UIButton!
    @IBOutlet weak var btnPriceHighToLowlbl: UIButton!
    @IBOutlet weak var filterView: UIView!
    
    var selectedFilter: ((_ data: String) -> ())?
    var currentLanguage = ""
    @objc func setText(){
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
        if self.currentLanguage == "en"{
            btnNewestlbl.setTitle("Newest", for: .normal)
            btnNewestlbl.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
            
            btnAZlbl.setTitle("A-Z", for: .normal)
            btnAZlbl.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
            
            btnZAlbl.setTitle("Z-A", for: .normal)
            btnZAlbl.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
            
            btnPriceLowToHighlbl.setTitle("Price : Low - High", for: .normal)
            btnPriceLowToHighlbl.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
            
            btnPriceHighToLowlbl.setTitle("Price : High - Low", for: .normal)
            btnPriceHighToLowlbl.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
            
        }
        else{
        
            btnNewestlbl.setTitle("أحدث", for: .normal)
            btnNewestlbl.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            
            btnAZlbl.setTitle("ا-ئ", for: .normal)
            btnAZlbl.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            
            btnZAlbl.setTitle("ئ-ا", for: .normal)
            btnZAlbl.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            
            btnPriceLowToHighlbl.setTitle("السعر: منخفض - مرتفع", for: .normal)
            btnPriceLowToHighlbl.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            
            btnPriceHighToLowlbl.setTitle("السعر: مرتفع - منخفض", for: .normal)
            btnPriceHighToLowlbl.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.setText()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        var touch: UITouch? = touches.first
        //location is relative to the current view
        // do something with the touched point
        
        print(touch?.view)
        
        if touch?.view != self.filterView {
//            self.filterView.isHidden = true
            selectedFilter?("")
            dismiss(animated: true)
        }
    }
    
    
    @IBAction func newestClicked(_ sender: Any) {
        selectedFilter?("created_at")
        dismiss(animated: true)
    }
    
    
    @IBAction func azClicked(_ sender: Any) {
        selectedFilter?("ASC")
        dismiss(animated: true)
    }
    
    @IBAction func zaClicked(_ sender: Any) {
        selectedFilter?("DESC")
        dismiss(animated: true)
    }
    
    
    @IBAction func hlClicked(_ sender: Any) {
        selectedFilter?("PriceHtoL")
        dismiss(animated: true)
    }
    
    @IBAction func lhClicked(_ sender: Any) {
        selectedFilter?("PriceLtoH")
        dismiss(animated: true)
    }
}
