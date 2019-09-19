//
//  CelebContainerViewController.swift
//  quitic3
//
//  Created by ZWT on 4/18/19.
//  Copyright © 2019 DOT. All rights reserved.
//

import UIKit

class CelebContainerViewController: UIViewController {
    
    var celebItem: Any = {};
    var celebName = "";
    var celebId: Int = 0;
    var celebBanner: String = ""
    var currentLanguage = ""
    var labels = AppLabels()
    var lblHeader = UILabel()
    var viewNavCenter = UIView()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setText()
        
        let celbDetails = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CelebDetailsViewController") as! CelebDetailsViewController
        
        
        celbDetails.celebName = celebName
        celbDetails.celebId = celebId
        celbDetails.celebItem = celebItem
        celbDetails.celebBanner = celebBanner
        
      //  celbDetails.view.frame = self.view.bounds
        self.addChildViewController(celbDetails)
        self.view.addSubview(celbDetails.view)
        celbDetails.didMove(toParentViewController: self)
        
    }

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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewNavCenter = UIView(frame: CGRect(x: 40, y: -13, width:  (self.navigationController?.navigationBar.frame.size.width)! - 80, height: 20))
        viewNavCenter.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.addSubview(viewNavCenter)
        
        lblHeader = UILabel.init(frame:  CGRect(x: 30, y: -7, width: self.view.frame.size.width - 60, height: 50))
        lblHeader.text = self.celebName
        //lblHeader.font = UIFont.init(name: headerFont, size: 30)
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
        
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "reloadTableView"), object: nil)
    }
}
