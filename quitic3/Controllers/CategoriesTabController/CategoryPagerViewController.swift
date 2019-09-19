//
//  CategoryPagerViewController.swift
//  quitic3
//
//  Created by ZWT on 4/15/19.
//  Copyright © 2019 DOT. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class CategoryPagerViewController: SJSegmentedViewController {
    
    var selectedSegment: SJSegmentTab?
    var previousData: [Items] = []
    var previousType: String = ""
    var selectedName: String = ""
    var selectedId: Int = -1
    var selectedIndex: Int = 0
    var allId: Int  = -1
    var mainData: [Items] = []
    var currentLanguage = "en"
    var lblHeader = UILabel()
    let labels = AppLabels()
    var viewNavCenter = UIView()
    var arrayController:NSMutableArray = []
    var celebName = "";
    var celebId: Int = 0;
    var celebBanner: String = ""
    var layoutLoaded: Bool = false
    var isReload = false
    
    func UIViewAppearance(){
        //        var semanticContentAttribute:UISemanticContentAttribute = .forceLeftToRight
        self.view.semanticContentAttribute = .forceLeftToRight
        //        UIView.appearance().semanticContentAttribute = semanticContentAttribute
    }
    
    @objc func setText(){
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        UIViewAppearance()
        setText()
        
        let headerController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "CelebDetailsHeaderViewController") as! CelebDetailsHeaderViewController
        headerController.celebName = self.celebName
        headerController.celebBannerUrl = self.celebBanner
        
        if self.currentLanguage == "en"{
            
            let ProductListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
            
            ProductListViewController.title = "All"
            ProductListViewController.setTitle = "All"
            ProductListViewController.celebId = String(format:"%d",self.celebId)
            
            if self.allId == -1 {
                
                ProductListViewController.categoryIdArray = []
            } else {
                
                var temp: [Int] = []
                temp.append(self.allId)
                ProductListViewController.categoryIdArray = temp
            }
            
            arrayController.add(ProductListViewController)
            
            for item in self.previousData {
                
                if item.name != "Brands" && item.name != "Celebrities" && item.name != "Tv" {
                    
                    var tempIds: [Int] = []
                    let ProductListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
                    ProductListViewController.title = item.name
                    ProductListViewController.setTitle = item.name!
                    ProductListViewController.categoryId = item.id!
                    //ProductListViewController.celebId = self.celebId]
                    ProductListViewController.celebId = String(format:"%d",self.celebId)
                    if(self.allId != -1){
                        
                        tempIds.append(self.allId)
                    }
                    tempIds.append(item.id!)
                    ProductListViewController.categoryIdArray = tempIds
                    arrayController.add(ProductListViewController)
                }
            }
            
            segmentTitleFont = UIFont(name: enLanguageConstant, size: 14)!
            
            UserDefaults.standard.set("0", forKey: "arLanguage")
            UserDefaults.standard.set(arrayController.count, forKey: "tabcount")
            UserDefaults.standard.synchronize()
            
        } else {
            
            
            let ProductListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
            
            ProductListViewController.title = "الكل"
            ProductListViewController.setTitle = "الكل"
            ProductListViewController.celebId = String(format:"%d",self.celebId)
            
            if self.allId == -1{
                ProductListViewController.categoryIdArray = []
            }
            else{
                var temp: [Int] = []
                temp.append(self.allId)
                ProductListViewController.categoryIdArray = temp
            }
            arrayController.add(ProductListViewController)
            
            for item in self.previousData {
                
                if item.name != "Brands" && item.name != "Celebrities" && item.name != "Tv" {
                    
                    var tempIds: [Int] = []
                    let ProductListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
                    ProductListViewController.title = item.name
                    ProductListViewController.setTitle = item.name!
                    ProductListViewController.categoryId = item.id!
                    //ProductListViewController.celebId = self.celebId
                    ProductListViewController.celebId = String(format:"%d",self.celebId)
                    if(self.allId != -1){
                        
                        tempIds.append(self.allId)
                    }
                    tempIds.append(item.id!)
                    ProductListViewController.categoryIdArray = tempIds
                    arrayController.add(ProductListViewController)
                }
            }
            
            segmentTitleFont = UIFont(name: arLanguageConstant, size: 14)!
            
            UserDefaults.standard.set("1", forKey: "arLanguage")
            UserDefaults.standard.set(arrayController.count, forKey: "tabcount")
            UserDefaults.standard.synchronize()
            
        }
        headerViewController = headerController
        //  arrayController.add(desVC)
        
        segmentControllers = arrayController as! [UIViewController]
        
        headerViewHeight = 270
        selectedSegmentViewHeight = 3.0
        headerViewOffsetHeight = 0.0
        segmentViewHeight = 40
        segmentTitleColor = .darkGray
        selectedSegmentViewColor = .darkGray
        segmentShadow = SJShadow.light()
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        segmentBounces = false
        delegate = self
        
        
        self.navigationController?.isNavigationBarHidden = false
        
        super.viewDidLoad()
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
                    UserDefaults.standard.set(arrayController.count, forKey: "tabcount")
                    UserDefaults.standard.set("0", forKey: "arLanguage")
                    UserDefaults.standard.synchronize()
                    
                }
                else{
                    UserDefaults.standard.set(arrayController.count, forKey: "tabcount")
                    UserDefaults.standard.set("1", forKey: "arLanguage")
                    UserDefaults.standard.synchronize()
                }
            }
        }
        

 
        let aStrLanguage:String = UserDefaults.standard.value(forKey: "arLanguage") as! String
            
        let aIntTotalTab:Int = UserDefaults.standard.value(forKey: "tabcount") as! Int

        
//        var pageIndex = 0
        if (aStrLanguage == "1")
        {
//            if selectedIndex == 0
//            {
//                pageIndex = aIntTotalTab - 1
//            }
            if selectedIndex == aIntTotalTab - 2
            {
                selectedIndex = -1
            }
            

           //selectedIndex = selectedIndex
            print("arabic1 : \(selectedIndex)")
            
        }
//        else
//        {
//            selectedIndex = selectedIndex + 1
//              print("english : \(selectedIndex)")
//        }

         selectedIndex = selectedIndex + 1
        setSelectedSegmentAt(selectedIndex, animated: true)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set("0", forKey: "arLanguage")
        UserDefaults.standard.synchronize()
    }
    
}

extension CategoryPagerViewController: SJSegmentedViewControllerDelegate {
    
    func didMoveToPage(_ controller: UIViewController, segment: SJSegmentTab?, index: Int) {
        
        if selectedSegment != nil {
            selectedSegment?.titleColor(UIColor.darkGray)
        }
        print("moved index: \(index)")

        if segments.count > 0 {

            selectedSegment = segments[index]
            selectedSegment?.titleColor(UIColor.darkGray)
        }
    }
}

