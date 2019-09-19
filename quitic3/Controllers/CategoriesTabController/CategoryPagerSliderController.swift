//
//  CategoryPagerSliderController.swift
//  quitic3
//
//  Created by ZWT on 4/15/19.
//  Copyright © 2019 DOT. All rights reserved.
//

import UIKit
import ViewPagerController

class CategoryPagerSliderController: UIViewController {

    @IBOutlet weak var layerView : UIView!
    
    var pagerController : ViewPagerController?
    var intVarCounter:Int = 0
    var intIncCounter:Int = 1
    var previousData: [Items] = []
    var previousType: String = ""
    var selectedName: String = ""
    var selectedId: Int = -1
    var selectedIndex: Int = -1
    var allId: Int  = -1
    var mainData: [Items] = []
    var currentLanguage = "en"
    var lblHeader = UILabel()
    let labels = AppLabels()
    var viewNavCenter = UIView()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewNavCenter = UIView(frame: CGRect(x: 0, y: -13, width:  (self.navigationController?.navigationBar.frame.size.width)!, height: 20))
        viewNavCenter.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.addSubview(viewNavCenter)
        
        lblHeader = UILabel.init(frame:  CGRect(x: view.frame.size.width / 2 - 75, y: -11, width: 150, height: 50))
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
        
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        lblHeader.removeFromSuperview()
        viewNavCenter.removeFromSuperview()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        intVarCounter = self.previousData.count
        
        self.mainData = self.previousData
        
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
    
        let pagerController = ViewPagerController()
        pagerController.setParentController(self, parentView: self.layerView)
        
        var appearance = ViewPagerControllerAppearance()
        
        appearance.headerHeight = 200.0
        appearance.scrollViewMinPositionY = 0.0
        appearance.scrollViewObservingType = .header

        
        let imageView = UIImageView(image: UIImage(named: "sample_header_image.jpg"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        appearance.headerContentsView = imageView
        
        appearance.tabMenuAppearance.selectedViewBackgroundColor = UIColor.clear
        appearance.tabMenuAppearance.backgroundColor = UIColor.darkGray
        appearance.tabMenuAppearance.defaultTitleColor = UIColor.lightGray
        appearance.tabMenuAppearance.selectedViewInsets = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
      
        pagerController.updateAppearance(appearance)
        
        
        pagerController.updateSelectedViewHandler = { selectedView in
            selectedView.layer.cornerRadius = selectedView.frame.size.height * 0.5
        }
        
        pagerController.willBeginTabMenuUserScrollingHandler = { selectedView in
            print("call willBeginTabMenuUserScrollingHandler")
            selectedView.alpha = 0.0
        }
        
        pagerController.didEndTabMenuUserScrollingHandler = { selectedView in
            print("call didEndTabMenuUserScrollingHandler")
            selectedView.alpha = 1.0
        }
        
        pagerController.didShowViewControllerHandler = { controller in
            print("call didShowViewControllerHandler")
            print("controller : \(String(describing: controller.title))")
            let currentController = pagerController.currentContent()
            print("currentContent : \(String(describing: currentController?.title))")
        }
        
        pagerController.changeObserveScrollViewHandler = { controller in
            print("call didShowViewControllerObservingHandler")
            let detailController = controller as! ProductListViewController
            
            return detailController.productsCollectionView
        }
        
        pagerController.didChangeHeaderViewHeightHandler = { height in
            print("call didChangeHeaderViewHeightHandler : \(height)")
        }
        
        pagerController.didScrollContentHandler = { percentComplete in
            print("call didScrollContentHandler : \(percentComplete)")
        }
        
        for item in self.previousData {
            
            if intIncCounter != intVarCounter
            {
                intIncCounter = intIncCounter + 1
                if item.name != "Brands" && item.name != "Celebrities" && item.name != "Tv"{
                    var tempIds: [Int] = []
                    let ProductListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
                    ProductListViewController.title = item.name
                    ProductListViewController.setTitle = item.name!
                    ProductListViewController.categoryId = item.id!
                    if(self.allId != -1){
                        tempIds.append(self.allId)
                    }
                    tempIds.append(item.id!)
                    ProductListViewController.categoryIdArray = tempIds
                    pagerController.addContent(item.name!, viewController: ProductListViewController)
                }
            }
            
        }
        self.pagerController = pagerController
    }


    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
}
