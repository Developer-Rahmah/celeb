//
//  AddToCartPopupController.swift
//  quitic3
//
//  Created by Admin on 28/03/19.
//  Copyright © 2019 DOT. All rights reserved.
//

import UIKit


protocol AddToCartPopupControllerDelegate {
    
    func checkOutAction()
}

class AddToCartPopupController: UIViewController {

    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var viewWhite: UIView!
    @IBOutlet weak var btnCheckOut: UIButton!
    @IBOutlet weak var lblCheckOut: UILabel!
    
    var currentLanguage = ""
    var addToCartPopUpDelegate: AddToCartPopupControllerDelegate!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        prepareView()
    }
    
    func prepareView() {
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        btnYes.layer.cornerRadius = 5.0
        btnCheckOut.layer.cornerRadius = 5.0
        viewWhite.layer.cornerRadius = 10.0
        
        CommonManager.shared.CheckCurrentLanguage() { (complete) in
            
            if complete.count > 0 {
                
                self.currentLanguage = complete[0].name!
                
                if self.currentLanguage == "en"{
                    
                    btnYes.setTitle("YES", for: .normal)
                    btnCheckOut.setTitle("CHECKOUT", for: .normal)
                    lblCheckOut.text = "Item has been added to your Bag.Continue Shopping?"
                }
                else {
                    
                    btnYes.setTitle("نعم", for: .normal)
                    btnCheckOut.setTitle("الدفع", for: .normal)
                    lblCheckOut.text = "تم اضافة المتج الى عربة التسوق. هل ترغب بأكمال عملية التسوق"
                }
            }
        }
    }
    
    @IBAction func btnCheckOutAction(_ sender: Any) {
        
        dismiss(animated: true)
       
        //self.tabBarController?.selectedIndex = 4
        addToCartPopUpDelegate.checkOutAction()
    }
    
    @IBAction func btnYesAction(_ sender: Any) {
        
        dismiss(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        dismiss(animated: true)
    }
}
