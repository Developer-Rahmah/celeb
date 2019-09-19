//
//  CategoryContainerViewController.swift
//  quitic3
//
//  Created by ZWT on 4/18/19.
//  Copyright © 2019 DOT. All rights reserved.
//

import UIKit

class CategoryContainerViewController: UIViewController {
    
    var currentLanguage = ""

    var previousData: [Items] = []
    var previousType: String = ""
    var selectedName: String = ""
    var selectedId: Int = -1
    var selectedIndex: Int = 0
    var allId: Int  = -1
    var mainData: [Items] = []
    var lblHeader = UILabel()
    var lblHeadertest = UILabel()
var testBtn  = UIButton ()
    let labels = AppLabels()
    var viewNavCenter = UIView()
    var arrayController:NSMutableArray = []
    var celebName = "";
    var celebId: Int = 0
    var celebBanner: String = ""
    var layoutLoaded: Bool = false
    var isReload = false
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
         UIViewAppearance()

        // Do any additional setup after loading the view.
        
        let categoryPager = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "CategoryPagerViewController") as! CategoryPagerViewController
        
        categoryPager.previousData = previousData
        categoryPager.selectedName = selectedName
        categoryPager.selectedId = selectedId
        categoryPager.selectedIndex = selectedIndex
        categoryPager.allId = self.allId
        categoryPager.celebName = celebName
        categoryPager.celebBanner = self.celebBanner
        categoryPager.celebId = self.celebId


      //  categoryPager.view.frame = self.view.bounds
        self.addChildViewController(categoryPager)
        self.view.addSubview(categoryPager.view)
        categoryPager.didMove(toParentViewController: self)

    }
    
    func UIViewAppearance(){
        //        var semanticContentAttribute:UISemanticContentAttribute = .forceLeftToRight
        self.view.semanticContentAttribute = .forceLeftToRight
        //        UIView.appearance().semanticContentAttribute = semanticContentAttribute
    }
    @objc func buttonAction(sender: UIButton!) {
 self.navigationController?.popViewController(animated: true)    }
    
    func backAction() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        var backbutton = UIButton(type: .custom)
//        backbutton.setImage(UIImage(named: "back"), for: .normal) // Image can be downloaded from here below link
//        backbutton.setTitle("Back", for: .normal)
//        backbutton.setTitleColor(backbutton.tintColor, for: .normal) // You can change the TitleColor
//        backbutton.addTarget(self, action: "backAction", for: .touchUpInside)
//
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
       
//        let button1 = UIBarButtonItem(image: UIImage(named: "home"), style: .plain, target: self, action: Selector("backAction")) // action:#selector(Class.MethodName) for swift 3
//        self.navigationItem.rightBarButtonItem  = button1
//
        
        
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }}
        
        viewNavCenter = UIView(frame: CGRect(x: 0, y: -13, width:  (self.navigationController?.navigationBar.frame.size.width)!, height: 52))
        viewNavCenter.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.addSubview(viewNavCenter)
        
        lblHeader = UILabel.init(frame:  CGRect(x: view.frame.size.width / 2 - 75, y: -11, width: 150, height: 50))
        
          lblHeadertest = UILabel.init(frame:  CGRect(x: view.frame.size.width / 2 - 75, y: -11, width: 150, height: 70))
        lblHeader.text = labels.SHOP
        lblHeadertest.text = "teeeeest"
        // lblHeader.font = UIFont.init(name: headerFont, size: 30)
        lblHeader.textAlignment = .center
        lblHeader.textColor = UIColor.init(red: 251, green: 96, blue: 127)
        lblHeadertest.textColor = UIColor.init(red: 255, green: 0, blue: 0)

       
        
        
        
        if self.currentLanguage == "en"
        {
            let image = UIImage(named: "back") as UIImage?
            
            testBtn.setImage(image, for: .normal)
            
            testBtn.frame = CGRect(x: self.view.frame.size.width/100, y: 0, width: 30, height: 50)
            //        testBtn.backgroundColor = UIColor.red
            //        testBtn.setTitle("Name your Button ", for: .normal)
            testBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            self.view.addSubview(testBtn)
            lblHeader.font = UIFont.init(name: enMarselLanguageConstant, size: 23)
        }
        else
        {
            
            let image = UIImage(named: "arback") as UIImage?
            
            testBtn.setImage(image, for: .normal)
            
            testBtn.frame = CGRect(x: self.view.frame.size.width/1.1, y: -11, width: 30, height: 50)
            //        testBtn.backgroundColor = UIColor.red
            //        testBtn.setTitle("Name your Button ", for: .normal)
            testBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            self.view.addSubview(testBtn)
            lblHeader.font = UIFont.init(name: arLanguageConstant, size: 23)
        }
//        self.navigationController?.navigationBar.addSubview(backbutton)

        self.navigationController?.navigationBar.addSubview(lblHeader)
//        self.navigationController?.navigationBar.addSubview(lblHeadertest)
        self.navigationController?.navigationBar.addSubview(testBtn)

        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        lblHeader.removeFromSuperview()
        viewNavCenter.removeFromSuperview()
        lblHeadertest.removeFromSuperview()
        testBtn.removeFromSuperview()

        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "reloadTableView"), object: nil)
    }
    
}
