//
//  BrandContainerViewController.swift
//  quitic3
//
//  Created by ZWT on 4/24/19.
//  Copyright © 2019 DOT. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class BrandContainerViewController: SJSegmentedViewController {


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
    var celebBanner: String = ""
    var layoutLoaded: Bool = false
    var isReload = false
    var data=""
    
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
         if(data == ""){
        let headerController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "BrandDetailHeaderViewController") as! BrandDetailHeaderViewController
        headerController.celebName = self.celebName
        headerController.celebBannerUrl = self.celebBanner
            headerViewController = headerController

        
        var tempIds: [Int] = []
        let ProductListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
        
        ProductListViewController.categoryId = selectedId
        ProductListViewController.celebId = ""
        
        tempIds.append(selectedId)

        ProductListViewController.categoryIdArray = tempIds
            arrayController.add(ProductListViewController)
            
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
            
         }else{
            
            
            var tempIds: [Int] = []
            let ProductListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
            
            ProductListViewController.categoryId = selectedId
            ProductListViewController.celebId = ""
            
            tempIds.append(selectedId)
            
            ProductListViewController.categoryIdArray = tempIds
            arrayController.add(ProductListViewController)
            
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
      
        if self.currentLanguage == "en"
        {
            UserDefaults.standard.set("0", forKey: "arLanguage")
            UserDefaults.standard.set(arrayController.count, forKey: "tabcount")
            UserDefaults.standard.synchronize()
        }
        else
        {
            UserDefaults.standard.set("0", forKey: "arLanguage")
            UserDefaults.standard.set(arrayController.count, forKey: "tabcount")
            UserDefaults.standard.synchronize()
        }
    
        super.viewDidLoad()
    }
    
}
