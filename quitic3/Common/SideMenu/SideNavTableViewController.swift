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
import FBSDKLoginKit
import SDWebImage

struct CellData {
    let lable :String?
}

class SideNavTableViewController: UITableViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var profileName: UILabel!
    
    @IBOutlet weak var profileEmail: UILabel!
    
    @IBOutlet weak var profileSection: UIView!
    
    @IBOutlet weak var profileWelcome: UILabel!
    var data = [CellData]()
        var currentLanguage = ""
    
    
    var navController: UINavigationController?
    var menuList = [
        ["Home",""],
        ["Celebrities",""],
        ["Brands",""],
        ["Shop By Category", ""],
        ["My Account", ""],
        ["Contact Us", ""],
        ["Language", ""],
        ["FAQ's", ""],
        ["Login", ""]
    ]
    
    var enMenuList = [
        ["Home",""],
        ["Celebrities",""],
        ["Brands",""],
        ["Shop By Category", ""],
        ["My Account", ""],
        ["Contact Us", ""],
        ["Language", ""],
        ["FAQ's", ""],
        ["Login", ""]
    ]
    
    var arMenuList = [
        ["الصفحة الرئيسية",""],
        ["المشاهير ",""],
        ["العلامات التجارية",""],
        ["جميع الأقسام", ""],
        ["حسابي", ""],
        ["اتصل بنا", ""],
        ["اللغة", ""],
        ["الأسئلة المتكررة", ""],
        ["تسجيل الدخول", ""]
    ]
    
    override func viewWillAppear(_ animated: Bool) {
 
        self.loginStatus()
        
        self.navController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBarNavController") as! CustomRootNavController

        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setBadges), name: NSNotification.Name("sideMenuBadgesUpdated"), object: nil)
        
        self.setText()
        self.setBadges()
        self.profileImage.image = UIImage(named: "applogoprofile")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //NotificationCenter.default.post(name: Notification.Name("NotifyLoginStatus"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(loginStatus), name: NSNotification.Name("NotifyLoginStatus"), object: nil)
        
        setText()
        self.profileImage.image = UIImage(named: "applogoprofile")
    }
    
    @objc func loginStatus(){
        if  (UserDefaults.standard.string(forKey: "token") != nil)  {
            
            
            CommonManager.shared.fetchUserCoreData { (data) in
                if data.count > 0 {
                    self.profileSection.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 119.0)
                    self.profileSection.isHidden = false
                    self.profileName.text = data[0].name
                    self.profileEmail.text = data[0].email
//                    self.profileImage
                    
                   if (data[0].profileImage != nil)
                    {
                        
                        //sdImageView Changes.
                        let aStrProfileImage:String = String(format: "%@customer/%@",CELEB_VIDEOS_IMAGE_URL, data[0].profileImage!)
                        
                        let url = URL(string:aStrProfileImage)
                        
                        self.profileImage.sd_setImage(with: url, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
                        self.profileImage.contentMode = .scaleAspectFit
                        
//                        // set user profile image while user enter into my account.
//                        BaseManager.Manager.request(aStrProfileImage).responseImage { response in
//                            if let image = response.result.value {
//                                //  self.profileImage.setImage(image, for: UIControl.State.normal)
//
//                                self.profileImage.image = image
//                            }
//                            else{
//                                self.profileImage.image = UIImage(named: "ImagePlaceholder")
//                            }
//                        }
                    }
                    else
                   {
                     self.profileImage.image = UIImage(named: "applogoprofile")
                    }
                    
                    self.tableView.reloadData()
                }
            }
            
            menuList[8][0]="Logout"
            enMenuList[8][0]="Logout"
            arMenuList[8][0]="الخروج"
            
             self.setText()
            
        }else{
            
            CommonManager.shared.logoutUserCoreData { (status) in
                print("core data logout \(status)")
                self.profileSection.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 0.0)
                self.profileSection.isHidden = true
                self.tableView.reloadData()
            }
            
            
            menuList[8][0]="Login"
            enMenuList[8][0]="Login"
            arMenuList[8][0]="تسجيل الدخول"
            
            
            self.setText()
        }
        
    }

    
    @objc func setBadges(){
        CommonManager.shared.getSideMenuBadge { (sideMenuBadges) in
            for badge in sideMenuBadges{
                if badge.name == "celebBadge"{
                    self.menuList[1][1] = "\(badge.badgeTotal)"
                    self.enMenuList[1][1] = "\(badge.badgeTotal)"
                    self.arMenuList[1][1] = "\(badge.badgeTotal)"
                }
                
                if badge.name == "categoryBadge"{
                    self.menuList[3][1] = "\(badge.badgeTotal)"
                    self.enMenuList[3][1] = "\(badge.badgeTotal)"
                    self.arMenuList[3][1] = "\(badge.badgeTotal)"
                }
                
//                if badge.name == "videosBadge"{
//                    self.menuList[4][1] = "\(badge.badgeTotal)"
//                    self.enMenuList[4][1] = "\(badge.badgeTotal)"
//                    self.arMenuList[4][1] = "\(badge.badgeTotal)"
//                }

                if badge.name == "brandsBadge"{
                    self.menuList[2][1] = "\(badge.badgeTotal)"
                    self.enMenuList[2][1] = "\(badge.badgeTotal)"
                    self.arMenuList[2][1] = "\(badge.badgeTotal)"
                }
            }
        }
    }
    @objc func setText(){

        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
            
        
        }
        for i in (0..<menuList.count)
        {
             if self.currentLanguage == "en"{
                menuList[i][0] = enMenuList[i][0]
            }
            else{
                menuList[i][0] = arMenuList[i][0]
            }
        }
        
        if self.currentLanguage == "en"{
            self.profileEmail.textAlignment = .left
            self.profileName.textAlignment = .left
            self.profileWelcome.textAlignment = .left
        }
        else{
            self.profileEmail.textAlignment = .right
            self.profileName.textAlignment = .right
            self.profileWelcome.textAlignment = .right
        }
        
        
        self.tableView.reloadData()
    }
    
    
   
    
    //    @IBAction func SwitchLanguage(_ sender: Any) {
    //        LanguageManger.shared.setLanguage(language:Languages.ar)
    //    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
//        return 70 // Please change its according to you
//    }
//    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
//        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.bounds.size.width, height: 70.0))
//        
//        view.backgroundColor = UIColor.quiticPink
//        
////        var profileImageView = UIImageView(frame: CGRectMake(40, 5, 60, 60)) // Change frame size according to you ..
////        profileImageView.image = UIImage(named: "image name") //Image set your
////        view.addSubview(profileImageView)
//        
//        return view
//    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "sideNavCell") as! SideNavCell
        
        if self.currentLanguage == "en"{
            cell.lblTitle.font = UIFont(name: enLanguageConstant, size: 17)!
            cell.lblBadge.font = UIFont(name: enLanguageConstant, size: 12)!
        }
        else{
            cell.lblTitle.font = UIFont(name: arLanguageConstant, size: 17)!
            cell.lblBadge.font = UIFont(name: enLanguageConstant, size: 12)!
        }
        
        cell.lblTitle.text = menuList[indexPath.row][0]
        cell.lblBadge.text = menuList[indexPath.row][1]
        
        if(menuList[indexPath.row][1] == ""){
            cell.lblBadge.isHidden = true
        }
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath.row)
        if indexPath.row == 8{
            if  (UserDefaults.standard.string(forKey: "token") == nil) {
                let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
                
               self.present(loginViewController, animated: true)
            }
            if  (UserDefaults.standard.string(forKey: "token") != nil)  {
                UserDefaults.standard.removeObject(forKey:"token")
                UserDefaults.standard.set(true, forKey: "logoutSuccess")
                UserDefaults.standard.synchronize()
                NotificationCenter.default.post(name: Notification.Name("NotifyWishList"), object: nil)
                NotificationCenter.default.post(name: Notification.Name("NotifyLoginStatus"), object: nil)
                LoginManager().logOut()
                
                if  (UserDefaults.standard.string(forKey: "token") != nil)  {
                    
                    
                    CommonManager.shared.fetchUserCoreData { (data) in
                        if data.count > 0 {
                            self.profileSection.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 119.0)
                            self.profileSection.isHidden = false
                            self.profileName.text = data[0].name
                            self.profileEmail.text = data[0].email
                            //                    self.profileImage
                            
                        
                        if (data[0].profileImage != nil)
                        {
                            //sdImageView Changes.
                            let aStrProfileImage:String = String(format: "%@customer%@",CELEB_VIDEOS_IMAGE_URL, data[0].profileImage!)

                            let url = URL(string:aStrProfileImage)
                            
                            self.profileImage.sd_setImage(with: url, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
                            
                            
//                                                    // set user profile image while user enter into my account.
//                                                    BaseManager.Manager.request(aStrProfileImage).responseImage { response in
//                                                        if let image = response.result.value {
//                                                          //  self.profileImage.setImage(image, for: UIControl.State.normal)
//
//                                                            self.profileImage.image = image
//                                                        }
//                                                        else{
//                                                            self.profileImage.image = UIImage(named: "ImagePlaceholder")
//                                                        }
//                                                    }
                            
                        }

                            
                            self.tableView.reloadData()
                        }
                    }
                    
                    
                    menuList[8][0]="Logout"
                    enMenuList[8][0]="Logout"
                    arMenuList[8][0]="الخروج"
                }else{
                    
                    
                    CommonManager.shared.logoutUserCoreData { (status) in
                        print("core data logout \(status)")
                        self.profileSection.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 0.0)
                        
                        self.profileSection.isHidden = true
                        self.tableView.reloadData()
                    }
                    
                    
                    menuList[8][0]="Login"
                    enMenuList[8][0]="Login"
                    arMenuList[8][0]="تسجيل الدخول"
                    
                }
                
                self.sideMenuController?.hideLeftViewAnimated()
                self.sideMenuController?.hideRightViewAnimated()
            }
        }
        if indexPath.row == 0{
            
            let TabViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
            
            TabViewController.selectedIndex = 0
            
            self.navController?.pushViewController(TabViewController, animated: false)
            self.sideMenuController?.rootViewController = self.navController
          
            self.sideMenuController?.hideLeftViewAnimated()
            self.sideMenuController?.hideRightViewAnimated()
        }
        if indexPath.row == 1{
            
            let TabViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
            
            TabViewController.selectedIndex = 2
            
            self.navController?.pushViewController(TabViewController, animated: false)
            self.sideMenuController?.rootViewController = self.navController
          
            self.sideMenuController?.hideLeftViewAnimated()
            self.sideMenuController?.hideRightViewAnimated()
        }
        if indexPath.row == 2{

            NotificationCenter.default.post(name: Notification.Name("GoToBrands"), object: nil)
            
            self.sideMenuController?.hideLeftViewAnimated()
            self.sideMenuController?.hideRightViewAnimated()
            
        }
        
        if indexPath.row == 3{

            NotificationCenter.default.post(name: Notification.Name("ShopByCategory"), object: nil)
            
                    
            self.sideMenuController?.hideLeftViewAnimated()
            self.sideMenuController?.hideRightViewAnimated()
        }
        
//        if indexPath.row == 4{
//            NotificationCenter.default.post(name: Notification.Name("Videos"), object: nil)
//
//            self.sideMenuController?.hideLeftViewAnimated()
//            self.sideMenuController?.hideRightViewAnimated()
//        }
        
        if indexPath.row == 4{
            
            if  (UserDefaults.standard.string(forKey: "token") != nil)  {
                NotificationCenter.default.post(name: Notification.Name("MyAccount"), object: nil)
            }
            else{
                NotificationCenter.default.post(name: Notification.Name("LoginScreen"), object: nil)
            }
            
            self.sideMenuController?.hideLeftViewAnimated()
            self.sideMenuController?.hideRightViewAnimated()
        }
        if indexPath.row == 5{
            NotificationCenter.default.post(name: Notification.Name("ContactUS"), object: nil)
            
            self.sideMenuController?.hideLeftViewAnimated()
            self.sideMenuController?.hideRightViewAnimated()
        }
        if indexPath.row == 6{
            NotificationCenter.default.post(name: Notification.Name("languagePopup"), object: nil)
            
            self.sideMenuController?.hideLeftViewAnimated()
            self.sideMenuController?.hideRightViewAnimated()
        }
        
        if indexPath.row == 7{
            
            //Faqs
            NotificationCenter.default.post(name: Notification.Name("faqs"), object: nil)
            
            self.sideMenuController?.hideLeftViewAnimated()
            self.sideMenuController?.hideRightViewAnimated()

        
        }
    }
}
