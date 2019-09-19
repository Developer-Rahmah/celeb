//
//  ConfirmOrderViewController.swift
//  quitic3
//
//  Created by APPLE on 8/10/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import CoreData
import Localize_Swift

class ConfirmOrderViewController: UIViewController {
	
	
	@IBOutlet weak var btnContinueShoping: UIButton!
	@IBOutlet weak var lblThankyouMessage: UILabel!
	@IBOutlet weak var lblThankyou: UILabel!
	@IBOutlet weak var orderNolbl: UILabel!
    
    var navController: UINavigationController?
	
	
	var stringPassed = ""
    var currentLanguage = ""
	
    @objc func setText(){
         let labels = AppLabels()
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
        
        self.title = labels.ORDERCONFIRMED
        lblThankyou.text = labels.THANKYOU
        lblThankyouMessage.text = labels.THANKYOUMESSAGE
        btnContinueShoping.setTitle(labels.CONTINUESHOPING, for: .normal)
        orderNolbl.text = labels.ORDERNUMBER
        
        if self.currentLanguage == "en"{
            lblThankyou.font = UIFont(name: enLanguageConstant, size: 17)!
            lblThankyouMessage.font = UIFont(name: enLanguageConstant, size: 17)!
            btnContinueShoping.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
        }
        else{
            lblThankyouMessage.font = UIFont(name: arLanguageConstant, size: 17)!
            lblThankyou.font = UIFont(name: arLanguageConstant, size: 17)!
            btnContinueShoping.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
        }
    }
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let backButton = UIBarButtonItem()
//        backButton.title = "Confirmation" //in your case it will be empty or you can put the title of your choice
//        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
//
         self.navigationController?.isNavigationBarHidden = true
        
        
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
        
        self.setText()
        
        self.orderNolbl.text = stringPassed
        // Do any additional setup after loading the view.
        deleteCartItems()
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        
        deleteCartItems()
        
        
        if let tabItems = self.tabBarController?.tabBar.items {
            // In this case we want to modify the badge number of the third tab:
            let tabItem = tabItems[4]
            
            CommonManager.shared.getCartQuantity { (quantity) in
                tabItem.badgeValue = "0"
                tabItem.badgeColor = UIColor.quiticPink
            }
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        self.navController?.popToRootViewController(animated: true)
    }
    

	 // MARK: -  actions
	@IBAction func continueBtnTapped( _ sender: UIButton)
    {
        self.navController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBarNavController") as! CustomRootNavController
        
        let TabViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
        
        TabViewController.selectedIndex = 0
        
        self.navController?.pushViewController(TabViewController, animated: false)
        self.sideMenuController?.rootViewController = self.navController

        
    
//        self.navigationController?.tabBarController?.selectedIndex = 0
//        let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//        self.navigationController?.pushViewController(homeVC, animated: true)
//
//
        
//        self.sideMenuController?.rootViewController = self.navigationController
//        self.navigationController?.tabBarController?.selectedIndex = 0
//        let cartVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//        self.navigationController?.pushViewController(cartVC, animated: true)

        
    //    self.dismiss(animated: true, completion: {
//            let TabViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
//            self.navigationController?.tabBarController?.selectedIndex = 0
//            //self.sideMenuController?.rootViewController = self.navigationController
//            self.navigationController?.setViewControllers([TabViewController], animated: true)
//
//
//            let TabViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
//
//            TabViewController.selectedIndex = 0
//
//            self.navigationController!.pushViewController(TabViewController, animated: false)
//            self.sideMenuController?.rootViewController = self.navigationController
//
            
    
//          //  self.sideMenuController?.rootViewController = self.navigationController
//            self.navigationController?.tabBarController?.selectedIndex = 0
//            let cartVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//            self.navigationController?.pushViewController(cartVC, animated: true)
    
            
  //      })

//        self.sideMenuController?.rootViewController = self.navigationController
//        self.navigationController?.tabBarController?.selectedIndex = 0
//        let cartVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//        self.navigationController?.pushViewController(cartVC, animated: true)
	}
	
    //CartItem
    func deleteCartItems() {
        guard let managedObjectContext = appDelegate?.persistentContainer.viewContext else { return }
                // Initialize Fetch Request
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItem")
                // Configure Fetch Request
                fetchRequest.includesPropertyValues = false
        
                do {
                    let items = try managedObjectContext.fetch(fetchRequest) as! [CartItem]
        
                    for item in items {
                        managedObjectContext.delete(item)
                    }                    // Save Changes
                    try managedObjectContext.save()
        
                } catch {
                    // Error Handling
                    
                    debugPrint("Could not fetch: \(error.localizedDescription)")
                }
    }
    
    
}
