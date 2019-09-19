//
//  CelebDetailsViewController.swift
//  quitic3
//
//  Created by DOT on 7/17/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import SJSegmentedScrollView
import Localize_Swift


class CelebDetailsViewController:  SJSegmentedViewController {
    
    var selectedSegment: SJSegmentTab?
    
    var celebItem: Any = {};
    var celebName = "";
    var celebId: Int = 0;
    var celebBanner: String = ""
    var currentLanguage = ""
    var labels = AppLabels()
    var lblHeader = UILabel()
    var viewNavCenter = UIView()
    
    
    @objc func setText(){
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                labels = AppLabels()
                self.currentLanguage = complete[0].name!

            }
        }
    }
    
    func UIViewAppearance(){
//        var semanticContentAttribute:UISemanticContentAttribute = .forceLeftToRight
        self.view.semanticContentAttribute = .forceLeftToRight
//        UIView.appearance().semanticContentAttribute = semanticContentAttribute
    }
    override func viewDidLoad() {
       UIViewAppearance()
        if let storyboard = self.storyboard {
            let headerController = storyboard
                .instantiateViewController(withIdentifier: "CelebDetailsHeaderViewController") as! CelebDetailsHeaderViewController
            headerController.celebName = self.celebName
            headerController.celebBannerUrl = self.celebBanner
            let firstViewController = storyboard
                .instantiateViewController(withIdentifier: "MyBoutiquesViewController") as! MyBoutiquesViewController
            firstViewController.celebId = self.celebId
            firstViewController.celebName = self.celebName
            firstViewController.celebBanner = self.celebBanner
            
            
            let secondViewController = storyboard
                .instantiateViewController(withIdentifier: "MyVideosViewController") as! MyVideosViewController
            secondViewController.celebId = self.celebId
            secondViewController.celebItem = self.celebItem
            let thirdViewController = UIStoryboard(name: "LoginStoryboard", bundle: nil)
                .instantiateViewController(withIdentifier: "SocialViewController") as! SocialViewController
            
            thirdViewController.celebItem = self.celebItem

            
            CommonManager.shared.CheckCurrentLanguage(){ (complete) in
                if complete.count>0{
                    self.currentLanguage = complete[0].name!
                    if self.currentLanguage == "en"{
                        let fullNameArr = self.celebName.components(separatedBy: " ")
                        
                        let name    = fullNameArr[0]
                        firstViewController.title = name+"'s Cart"
                        secondViewController.title = ENVIDEOS
                        thirdViewController.title = ENSOCIALMEDIA
                        title = self.celebName
                        segmentControllers = [firstViewController,
                                              thirdViewController]
                        segmentTitleFont = UIFont(name: enMarselLanguageConstant, size: 14)!
                    }
                    else{
                        let fullNameArr = self.celebName.components(separatedBy: " ")
                        
                        let name    = fullNameArr[0]
                        firstViewController.title = name+" "+"كارت"
                        secondViewController.title = ARVIDEOS
                        thirdViewController.title = ARSOCIALMEDIA
                        title = self.celebName
                        segmentControllers = [firstViewController,
                                              thirdViewController]
                        segmentTitleFont = UIFont(name: arLanguageConstant, size: 14)!
                        
                    }
                }
            }
            headerViewController = headerController
            headerViewHeight = 270
            selectedSegmentViewHeight = 3.0
            headerViewOffsetHeight = 0.0
            segmentViewHeight = 60.0
            segmentTitleColor = .quiticPink
            selectedSegmentViewColor = .quiticPink
            segmentShadow = SJShadow.light()
            showsHorizontalScrollIndicator = false
            showsVerticalScrollIndicator = false
            segmentBounces = false
            delegate = self
        }
        
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.setText()
        
    }
    
    func printConstraintConstants(for view: UIView) {
        for constraint in view.constraints {
            print(view, constraint.constant)
        }
        
        for subview in view.subviews {
            printConstraintConstants(for: subview)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //self.moveToViewController(at: 2)
        print("==================")
        for constraint in self.view.constraints {
            print(constraint)
            print("Constant: ", constraint.constant)
        }
        print("==================")
        for constraint in self.view.constraints {
            constraint.constant = 0.0
        }
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
                if self.currentLanguage == "en"{
                    UserDefaults.standard.set(2, forKey: "tabcount")
                    UserDefaults.standard.set("0", forKey: "arLanguage")
                    UserDefaults.standard.synchronize()
                    
                }
                else{
                    UserDefaults.standard.set(2, forKey: "tabcount")
                    UserDefaults.standard.set("1", forKey: "arLanguage")
                    UserDefaults.standard.synchronize()
                }
            }
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
          UserDefaults.standard.set("0", forKey: "arLanguage")
          UserDefaults.standard.synchronize()
    }
}

extension CelebDetailsViewController: SJSegmentedViewControllerDelegate {
    
    func didMoveToPage(_ controller: UIViewController, segment: SJSegmentTab?, index: Int) {
        
        if selectedSegment != nil {
            selectedSegment?.titleColor(.quiticPink)
        }
        print("moved index: \(index)")

        if segments.count > 0 {
            
            selectedSegment = segments[index]
            selectedSegment?.titleColor(.quiticPink)
        }
    }
}

