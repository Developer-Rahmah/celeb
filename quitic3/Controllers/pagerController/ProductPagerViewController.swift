//
//  ProductPagerViewController.swift
//  quitic3
//
//  Created by DOT on 8/29/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ProductPagerViewController: ButtonBarPagerTabStripViewController {

    var previousData: [Items] = []
    var previousType: String = ""
    var selectedName: String = ""
    var selectedId: Int = -1
    var selectedIndex: Int = -1
    var allId: Int  = -1
    var setTitle = ""
    var currentLanguage = "en"
    var mainData: [Items] = []
    var layoutLoaded: Bool = false
    var isReload = false
    let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)
    var lblHeader = UILabel()
    let labels = AppLabels()
    var viewNavCenter = UIView()
    var celebId:String = ""
    
    override func viewDidLoad() {
        
        self.mainData = self.previousData
        
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
       // self.title = labels.SHOP
        if self.currentLanguage == "en"{
            settings.style.buttonBarItemFont = UIFont(name: enLanguageConstant, size: 14)!
        }
        else{
            settings.style.buttonBarItemFont = UIFont(name: arLanguageConstant, size: 14)!
        }
        
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        
        settings.style.selectedBarBackgroundColor = UIColor.black
        
        //settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        
        
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        
        settings.style.buttonBarItemTitleColor = UIColor.textColorSecondary
        
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.textColorSecondary
            newCell?.label.textColor = UIColor.black
        }

        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewNavCenter = UIView(frame: CGRect(x: 40, y: -13, width:  (self.navigationController?.navigationBar.frame.size.width)! - 40, height: 20))
        viewNavCenter.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.addSubview(viewNavCenter)

        lblHeader = UILabel.init(frame:  CGRect(x: 30, y: -11, width: viewNavCenter.frame.size.width, height: 50))
        lblHeader.text = labels.SHOP
       // lblHeader.font = UIFont.init(name: headerFont, size: 30)
        lblHeader.textAlignment = .center
        lblHeader.textColor = UIColor.init(red: 251, green: 96, blue: 127)

        if self.currentLanguage == "en"
        {
            lblHeader.font = UIFont.init(name: enMarselLanguageConstant, size: 23)
        }
        else
        {
            lblHeader.font = UIFont.init(name: arLanguageConstant, size: 23)
        }

        self.navigationController?.navigationBar.addSubview(lblHeader)
    }
    override func viewWillDisappear(_ animated: Bool) {

        lblHeader.removeFromSuperview()
        viewNavCenter.removeFromSuperview()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //self.moveToViewController(at: 2)
        if !self.layoutLoaded{
            self.setSelectedTab()
            self.layoutLoaded = true 
        }
        
    }
    
    
    func setSelectedTab() {
        
        if(self.selectedName != "" || self.selectedId != -1){
            
            var matchedItemIndex = -1
            var iterate = 0
            for item in self.mainData {
                
                if item.name == self.selectedName || item.id == self.selectedId{
                    matchedItemIndex = iterate
                }
                
                iterate += 1
            }
            
            if(matchedItemIndex != -1) {
                
                if self.currentLanguage == "en" {
                    self.setSegmentIndex(index: matchedItemIndex+1)
                }
                else {
                    let arIndex: Int = (self.mainData.count - matchedItemIndex)-1
                    self.setSegmentIndex(index: arIndex)
                }
                
            }
            else {
                if self.currentLanguage == "en" {
                    self.setSegmentIndex(index: 0)
                }
                else {
                    self.setSegmentIndex(index: self.mainData.count+1)
                }
            }
        }
        else{
            if self.currentLanguage == "en" {
                self.setSegmentIndex(index: 0)
            }
            else {
                self.setSegmentIndex(index: self.mainData.count+1)
            }
        }
    }
    
    func setSegmentIndex(index: Int){
        self.moveToViewController(at: index, animated: true)
    }
    
    // MARK: - PagerTabStripDataSource
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        var controllers: [UIViewController] = []
        
        //For All Section
        
        if self.currentLanguage == "en"{
            
            let ProductListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
            
            ProductListViewController.title = "All"
            ProductListViewController.setTitle = "All"
            ProductListViewController.celebId = self.celebId
            if self.allId == -1 {
                
                ProductListViewController.categoryIdArray = []
            } else {
                
                var temp: [Int] = []
                temp.append(self.allId)
                ProductListViewController.categoryIdArray = temp
            }
            
            controllers.append(ProductListViewController)
            
            for item in self.previousData {
                
                if item.name != "Brands" && item.name != "Celebrities" && item.name != "Tv" {
                    
                    var tempIds: [Int] = []
                    let ProductListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
                    ProductListViewController.title = item.name
                    ProductListViewController.setTitle = item.name!
                    ProductListViewController.categoryId = item.id!
                    ProductListViewController.celebId = self.celebId
                    if(self.allId != -1){
                        
                        tempIds.append(self.allId)
                    }
                    tempIds.append(item.id!)
                    ProductListViewController.categoryIdArray = tempIds
                    controllers.append(ProductListViewController)
                }
            }
        }
        else {
            
            for item in self.previousData.reversed(){
                
                if item.name != "Brands" && item.name != "Celebrities" && item.name != "Tv"{
                    var tempIds: [Int] = []
                    let ProductListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
                    
                    ProductListViewController.title = item.name
                    ProductListViewController.setTitle = item.name!
                    ProductListViewController.categoryId = item.id!
                    ProductListViewController.celebId = self.celebId
                    
                    if(self.allId != -1){
                        
                        tempIds.append(self.allId)
                    }
                    
                    tempIds.append(item.id!)
                    ProductListViewController.categoryIdArray = tempIds
                    controllers.append(ProductListViewController)
                }
            }
            
            let ProductListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
            
            ProductListViewController.title = "الكل"
            ProductListViewController.setTitle = "الكل"
            ProductListViewController.celebId = self.celebId
            
            if self.allId == -1{
                ProductListViewController.categoryIdArray = []
            }
            else{
                var temp: [Int] = []
                temp.append(self.allId)
                ProductListViewController.categoryIdArray = temp
            }
            controllers.append(ProductListViewController)
        }
        return controllers
    }
}
