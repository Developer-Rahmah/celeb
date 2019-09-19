//
//  priceFilterViewController.swift
//  quitic3
//
//  Created by DOT on 8/19/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import Localize_Swift

class priceFilterViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var priceRangeSlider: RangeSlider!
    
    @IBOutlet weak var lblProduct: UILabel!
    @IBOutlet weak var btnCancellbl: UIButton!
    @IBOutlet weak var btnClearlbl: UIButton!
    @IBOutlet weak var btnApplylbl: UIButton!
    
    var setLowerValue: Int = -1
    var setUpperValue: Int = -1
    
    @IBOutlet weak var lowerPriceLabel: UILabel!
    
    @IBOutlet weak var upperPriceLabel: UILabel!
    
    var selectedPriceRange: ((_ lowerValue: Int, _ upperValue: Int) -> ())?
    var currentLanguage = ""
    @objc func setText(){
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
        if self.currentLanguage == "en"{
            self.lblProduct.text = "Product Price"
            self.lblProduct.font = UIFont(name: enLanguageConstant, size: 17)!
            
            self.btnApplylbl.setTitle("Apply", for: .normal)
            self.btnApplylbl.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
            
            self.btnClearlbl.setTitle("Clear", for: .normal)
            self.btnClearlbl.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
            
            self.btnCancellbl.setTitle("Cancel", for: .normal)
            self.btnCancellbl.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
        }
        else{
            self.lblProduct.text = "سعر المنتج"
            self.lblProduct.font = UIFont(name: arLanguageConstant, size: 17)!
            
            self.btnApplylbl.setTitle("تطبيق", for: .normal)
            self.btnApplylbl.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            
            self.btnClearlbl.setTitle("إعادة تعيين", for: .normal)
            self.btnClearlbl.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            
            self.btnCancellbl.setTitle("الغاء", for: .normal)
            self.btnCancellbl.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
          setText()
        self.priceRangeSlider.minimumValue = 0
        self.priceRangeSlider.maximumValue = 1000
        self.priceRangeSlider.lowerValue = 0
        self.priceRangeSlider.upperValue = 1000
        
        
        if self.setLowerValue != -1{
            self.priceRangeSlider.lowerValue = Double(self.setLowerValue)
            self.lowerPriceLabel.text = "\(self.setLowerValue)"
        }
        
        if self.setUpperValue != -1{
            self.priceRangeSlider.upperValue = Double(self.setUpperValue)
            self.upperPriceLabel.text = "\(self.setUpperValue)"
        }
        
        
        
        self.priceRangeSlider.addTarget(self, action: #selector(testRangeViewController.rangeSliderValueChanged(_:)),
                                 for: .valueChanged)

        
    }
    
    @objc func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
        self.lowerPriceLabel.text = "\(Int(self.priceRangeSlider.lowerValue))"
        self.upperPriceLabel.text = "\(Int(self.priceRangeSlider.upperValue))"
        
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        let touch: UITouch? = touches.first
        
        if touch?.view != self.mainView {
            dismiss(animated: true)
        }
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func clearBtnClicked(_ sender: Any) {
        self.priceRangeSlider.lowerValue = 0
        self.priceRangeSlider.upperValue = 1000
        self.lowerPriceLabel.text = "\(Int(self.priceRangeSlider.lowerValue))"
        self.upperPriceLabel.text = "\(Int(self.priceRangeSlider.upperValue))"
    }
    
    
    @IBAction func applyBtnClicked(_ sender: Any) {
        self.selectedPriceRange?(Int(self.lowerPriceLabel.text!)!, Int(self.upperPriceLabel.text!)!)
        dismiss(animated: true)
    }
    
    

}
