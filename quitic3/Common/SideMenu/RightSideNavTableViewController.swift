//
//  SideNavTableViewController.swift
//  quitic3
//
//  Created by APPLE on 7/18/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import SideMenu
import Localize_Swift
//
//struct CellData {
//    let lable :String?
//}

class RightSideNavTableViewController: UITableViewController {
    
    var data = [CellData]()
    
    var navController: UINavigationController?
    
    var menuList = [
        ["",""],
        ["Qiotic Pick","232"],
        ["المشاهير","49"],
        ["العلامات التجارية","135"],
        ["تسوق حسب الأقسام", "8"],
        ["أشرطة فيديو", "250"],
        ["الحساب", ""],
        ["الإنجليزية", ""],
        ["عربى", ""],
        ["أسئلة وأجوبة", ""]
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.navController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBarNavController") as! CustomRootNavController
        
        if  (UserDefaults.standard.string(forKey: "token") == nil) {
            menuList[0][0]="Login"
        }
        if  (UserDefaults.standard.string(forKey: "token") != nil)  {
            menuList[0][0]="Logout"
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        
        self.setText()
        
    }
    
    
    @objc func setText(){
        
        for i in (0..<menuList.count)
        {
            menuList[i][0] = menuList[i][0].localized()
        }
    }
    
    
    
    
    //    @IBAction func SwitchLanguage(_ sender: Any) {
    //        LanguageManger.shared.setLanguage(language:Languages.ar)
    //    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        // #warning Incomplete implementation, return the number of rows
    //       // return 5
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "sideNavCell") as! SideNavCell
        
        cell.lblTitle.text = menuList[indexPath.row][0]
        cell.lblBadge.text = menuList[indexPath.row][1]
        
        if(menuList[indexPath.row][1] == ""){
            cell.lblBadge.isHidden = true
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath.row)
        if indexPath.row == 0{
            if  (UserDefaults.standard.string(forKey: "token") == nil) {
                let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
                //                   self.present(loginViewController, animated: true, completion: nil)
                
                //    self.navigationController?.pushViewController(loginViewController, animated: true)
                
                self.present(loginViewController, animated: true)
                
                
            }
            if  (UserDefaults.standard.string(forKey: "token") != nil)  {
                
                print(UserDefaults.standard.string(forKey: "token")!)
                UserDefaults.standard.removeObject(forKey:"token")
                
                UserDefaults.standard.set(true, forKey: "logoutSuccess")
                
                //                let TabViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
                
                
                menuList[0][0]="Login"
                dismiss(animated: true, completion: nil)
                self.sideMenuController?.hideLeftViewAnimated()
                self.sideMenuController?.hideRightViewAnimated()
                
                //  self.present(TabViewController, animated: true, completion: nil)
                //                self.navigationController?.pushViewController(TabViewController, animated: false)
                
                //                self.show(TabViewController, sender: self)
            }
            // else {
            //            print(UserDefaults.standard.string(forKey: "token")!)
            //            UserDefaults.standard.removeObject(forKey:"token")
            //        }
        }
        if indexPath.row == 1{
            self.navigationController?.popViewController(animated: true)
            let HomeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.navigationController?.pushViewController(HomeViewController, animated: true)
            dismiss(animated: true, completion: nil)
            self.sideMenuController?.hideLeftViewAnimated()
            self.sideMenuController?.hideRightViewAnimated()
        }
        if indexPath.row == 2{
            
            let TabViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
            
            TabViewController.selectedIndex = 3
            
            self.sideMenuController?.rootViewController = self.navController
            self.navController?.pushViewController(TabViewController, animated: true)
            
            self.sideMenuController?.hideLeftViewAnimated()
            self.sideMenuController?.hideRightViewAnimated()
        }
        if indexPath.row == 3{
            
            let TabViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
            
            TabViewController.selectedIndex = 2
            
            self.sideMenuController?.rootViewController = self.navController
            self.navController?.pushViewController(TabViewController, animated: true)
            
            self.sideMenuController?.hideLeftViewAnimated()
            self.sideMenuController?.hideRightViewAnimated()
            
        }
        
        if indexPath.row == 4{
            self.navigationController?.popViewController(animated: true)
            let shopByCategoryViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShopByCategoryViewController") as! ShopByCategoryViewController
            self.navigationController?.pushViewController(shopByCategoryViewController, animated: true)
            dismiss(animated: true, completion: nil)
            self.sideMenuController?.hideLeftViewAnimated()
            self.sideMenuController?.hideRightViewAnimated()
        }
        
        if indexPath.row == 5{
            self.navigationController?.popViewController(animated: true)
            let tvController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TVViewController") as! TVViewController
            
            self.navigationController?.pushViewController(tvController, animated: true)
            dismiss(animated: true, completion: nil)
            self.sideMenuController?.hideLeftViewAnimated()
            self.sideMenuController?.hideRightViewAnimated()
        }
        
        if indexPath.row == 7{
            //LanguageManger.shared.setLanguage(language: Languages.en)
            
//            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            dump(Localize.availableLanguages())
            Localize.setCurrentLanguage("en")
            LanguageManger.shared.setLanguage(language: Languages.en)
            self.setText()
            let windows = UIApplication.shared.windows
            for window in windows {
                for view in window.subviews {
                    view.removeFromSuperview()
                    window.addSubview(view)
                }
            }
            let menuLeftNavigationController = UISideMenuNavigationController()
            menuLeftNavigationController.leftSide = true
            // SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
            dismiss(animated: true, completion: nil)
            self.sideMenuController?.hideLeftViewAnimated()
            self.sideMenuController?.hideRightViewAnimated()
        }
        
        if indexPath.row == 8{
            LanguageManger.shared.setLanguage(language: Languages.ar)
            let menuLeftNavigationController = UISideMenuNavigationController()
            menuLeftNavigationController.leftSide = false
            dump(Localize.availableLanguages())
            Localize.setCurrentLanguage("ar")
            self.setText()
            let windows = UIApplication.shared.windows
            for window in windows {
                for view in window.subviews {
                    view.removeFromSuperview()
                    window.addSubview(view)
                }
            }
            dismiss(animated: true, completion: nil)
            self.sideMenuController?.hideLeftViewAnimated()
            self.sideMenuController?.hideRightViewAnimated()
        }
    }
    
    
    
    
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        print(indexPath.row)
    //        if indexPath.row == 0{
    //            if  (UserDefaults.standard.string(forKey: "token") == nil) {
    //                let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
    //                self.present(loginViewController, animated: true, completion: nil)
    //
    //            }
    //            if  (UserDefaults.standard.string(forKey: "token") != nil)  {
    //                print(UserDefaults.standard.string(forKey: "token")!)
    //                UserDefaults.standard.removeObject(forKey:"token")
    //                let TabViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
    //                //self.present(TabViewController, animated: true, completion: nil)
    //
    //                self.navigationController?.pushViewController(TabViewController, animated: false)
    //            }
    //            // else {
    //            //            print(UserDefaults.standard.string(forKey: "token")!)
    //            //            UserDefaults.standard.removeObject(forKey:"token")
    //            //        }
    //        }
    //    }
    
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    
}
