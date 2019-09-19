//
//  LanguageViewController.swift
//  quitic3
//
//  Created by DOT on 8/30/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import Localize_Swift

class LanguageViewController: UIViewController {
    
    
    @IBOutlet weak var englishCheckbox: Checkbox!
    
    @IBOutlet weak var arabicCheckbox: Checkbox!
    
    @IBOutlet weak var englishView: UIView!
    
    @IBOutlet weak var arView: UIView!
    
    @IBOutlet weak var saveBtnOutlet: UIButton!
    
    var lblHeader = UILabel()
    
    var currentLanguage: String = "en"
    var newChangedLanguage: String = "en"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
        
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
                self.newChangedLanguage = complete[0].name!
            }
            
            if self.currentLanguage == "en"{
                
                //self.title = "Language"
                self.englishTapped()
                self.saveBtnOutlet.setTitle("Save", for: .normal)
                self.saveBtnOutlet.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
                
            }
            else{
                
               // self.title = "لغة"
                self.arTapped()
                self.saveBtnOutlet.setTitle("حفظ", for: .normal)
                self.saveBtnOutlet.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            }
        }
        
        let enGesture = UITapGestureRecognizer(target: self, action:  #selector(self.englishTapped))
        self.englishView.addGestureRecognizer(enGesture)
        
        let arGesture = UITapGestureRecognizer(target: self, action:  #selector(self.arTapped))
        self.arView.addGestureRecognizer(arGesture)
        
        englishCheckbox.addTarget(self, action: #selector(enCheckboxValueChanged(sender:)), for: .valueChanged)
        
        arabicCheckbox.addTarget(self, action: #selector(arCheckboxValueChanged(sender:)), for: .valueChanged)
    }
    
    @objc func englishTapped(){
        print("English tapped")
        self.englishCheckbox.checkedBorderColor = UIColor.quiticPink
        self.englishCheckbox.uncheckedBorderColor = .black
        self.englishCheckbox.borderStyle = .square
        self.englishCheckbox.checkmarkColor = UIColor.quiticPink
        self.englishCheckbox.checkmarkStyle = .tick
        self.englishCheckbox.isChecked=true
        
        self.arabicCheckbox.checkedBorderColor = UIColor.quiticPink
        self.arabicCheckbox.uncheckedBorderColor = .black
        self.arabicCheckbox.borderStyle = .square
        self.arabicCheckbox.checkmarkColor = UIColor.quiticPink
        self.arabicCheckbox.checkmarkStyle = .tick
        self.arabicCheckbox.isChecked = false
        
        self.newChangedLanguage = "en"
    }
    
    @objc func arTapped(){
        print("ar tapped")
        self.englishCheckbox.checkedBorderColor = UIColor.quiticPink
        self.englishCheckbox.uncheckedBorderColor = .black
        self.englishCheckbox.borderStyle = .square
        self.englishCheckbox.checkmarkColor = UIColor.quiticPink
        self.englishCheckbox.checkmarkStyle = .tick
        self.englishCheckbox.isChecked = false
        
        self.arabicCheckbox.checkedBorderColor = UIColor.quiticPink
        self.arabicCheckbox.uncheckedBorderColor = .black
        self.arabicCheckbox.borderStyle = .square
        self.arabicCheckbox.checkmarkColor = UIColor.quiticPink
        self.arabicCheckbox.checkmarkStyle = .tick
        self.arabicCheckbox.isChecked = true
        
        self.newChangedLanguage = "ar"
    }

    
    @objc func enCheckboxValueChanged(sender: Checkbox) {
        print("enCheckbox value change: \(sender.isChecked)")
        self.englishTapped()
    }
    
    @objc func arCheckboxValueChanged(sender: Checkbox) {
        self.arTapped()
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        print("Change language btn clicked")
        
        if self.newChangedLanguage != self.currentLanguage{
            
            if self.newChangedLanguage == "en"{
                
                CommonManager.shared.saveCoreDataLanguage(lang: Languages.en.rawValue) { (complete) in
                    if complete {
                        UIView.appearance().semanticContentAttribute = .forceLeftToRight
                        LanguageManger.shared.setLanguage(language: Languages.en)
                        
                        let windows = UIApplication.shared.windows
                        for window in windows {
                            for view in window.subviews {
                                view.removeFromSuperview()
                                window.addSubview(view)
                            }
                        }
                        let menuLeftNavigationController = UISideMenuNavigationController()
                        menuLeftNavigationController.leftSide = true
                        
                        NotificationCenter.default.post(name: Notification.Name(LCLLanguageChangeNotification), object: nil)
                        
                        
                        
                        self.navigationController?.popViewController(animated: true)
                        
                        print("Languages.en saved")
                    }
                    else{
                        print("Languages.en not saved")
                    }
                }
            }
            else{
                
                print("Setting language arabic from language controller")
                CommonManager.shared.saveCoreDataLanguage(lang: Languages.ar.rawValue)
                { (complete) in
                    if complete {
                        LanguageManger.shared.setLanguage(language: Languages.ar)
                        
                        let windows = UIApplication.shared.windows
                        for window in windows {
                            for view in window.subviews {
                                view.removeFromSuperview()
                                window.addSubview(view)
                            }
                        }
                        
                        NotificationCenter.default.post(name: Notification.Name(LCLLanguageChangeNotification), object: nil)
                        
                    
                        
                        self.navigationController?.popViewController(animated: true)
                        
                        print("Languages.ar saved")
                    }else{
                        print("Languages.ar not saved")
                    }
                }

            }
            
            //LanguageManger.shared.setLanguage(language: Languages.en)
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lblHeader = UILabel.init(frame:  CGRect(x: view.frame.size.width / 2 - 75, y: -11, width: 150, height: 50))
        lblHeader.font = UIFont.init(name: headerFont, size: 30)
        lblHeader.textAlignment = .center
        lblHeader.textColor = UIColor.init(red: 251, green: 96, blue: 127)
        
        if self.currentLanguage == "en"
        {
            lblHeader.text = "Language"
            lblHeader.font = UIFont.init(name: enMarselLanguageConstant, size: 23)
        }
        else
        {
            lblHeader.text = "اللغة"
            lblHeader.font = UIFont.init(name: arLanguageConstant, size: 23)
        }

        self.navigationController?.navigationBar.addSubview(lblHeader)
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        lblHeader.removeFromSuperview()
    }
}
