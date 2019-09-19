//
//  CelebTabViewController.swift
//  quitic3
//
//  Created by DOT on 7/20/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import AlamofireImage
import Localize_Swift
import SDWebImage

class CelebTabViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var  currentLanguage = ""
    var productPageSize = 10
    var totalPages = 1
    var pageNo = 1
    
    
    var labels = AppLabels()
    var lblHeader = UILabel()
    @objc func setText(){
        labels = AppLabels()
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
              //  self.title = labels.CELEBRITIES
                self.tabBarController?.tabBar.items?[0].title = labels.HOME
                self.tabBarController?.tabBar.items?[1].title = labels.WISHLIST
                self.tabBarController?.tabBar.items?[2].title = labels.CELEBRITIES
                self.tabBarController?.tabBar.items?[3].title = labels.CATEGORIES
                self.tabBarController?.tabBar.items?[4].title = labels.CART
                if self.currentLanguage == "en"{
                    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: enLanguageConstant, size: 10)!], for: .normal)
                    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: enLanguageConstant, size: 10)!], for: .selected)
                }
                else{
                    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: arLanguageConstant, size: 10)!], for: .normal)
                    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: arLanguageConstant, size: 10)!], for: .selected)
                }
                
                manager = CelebritiesManager()
                self.getCelebrities(pageSize: 10,currentPage: 1,fieldValue: 48)
            }
        }
    }
    @IBOutlet weak var CelebCollections: UICollectionView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    let baseManager = BaseManager()
    var celebritiesCollectionlist:[Items]=[Items]()
    
    var manager = CelebritiesManager()

    
    let navBarTitleImage = UIImage(named: "MyBoutiques")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToBrands), name: NSNotification.Name("GoToBrands"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToShopByCategory), name: NSNotification.Name("ShopByCategory"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToVideos), name: NSNotification.Name("Videos"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ContactUS), name: NSNotification.Name("ContactUS"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(languagePopup), name: NSNotification.Name("languagePopup"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginScreen), name: NSNotification.Name("LoginScreen"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MyAccount), name: NSNotification.Name("MyAccount"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(faqs), name: NSNotification.Name("faqs"), object: nil)
        
        
        //  self.tabBarController?.selectedIndex = 2
        let width = (view.frame.size.width-2-1) / 3
        let layout = CelebCollections.collectionViewLayout as!  UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width+50)
        
        CelebCollections.delegate = self
        CelebCollections.dataSource=self
        
        self.navigationItem.titleView = UIImageView(image: navBarTitleImage)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.red,
             NSAttributedString.Key.font: UIFont(name: "Baskerville", size: 21)!]
        
        setText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        lblHeader = UILabel.init(frame:  CGRect(x: view.frame.size.width / 2 - 75, y: -7, width: 150, height: 50))
        lblHeader.text = labels.CELEBRITIES
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
    }

    @IBAction func searchBtnClicked(_ sender: Any) {
        let desVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
        desVC.mainItems = self.celebritiesCollectionlist
        desVC.filteredCellItems = self.celebritiesCollectionlist
        desVC.allId = Constant_Celebrities_Id
        desVC.searchType = "Celebrities"
        
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
    @objc func LoginScreen(){
        
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        
        if controllerName! as! String == "Celebrity"{
            let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
            loginViewController.pushed = 1
            
            self.navigationController?.pushViewController(loginViewController, animated: true)
        }
        
    }
    
    @objc func MyAccount(){
        
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        
        print("Controller Name: \(String(describing: controllerName))")
        
        if controllerName! as! String == "Celebrity"{
            let brandsViewTabController = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "MyAccountViewController") as! MyAccountViewController
            self.navigationController?.pushViewController(brandsViewTabController, animated: true)
        }
        
    }
    
    @objc func faqs(){
        
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        
        if controllerName! as! String == "Celebrity"{
            let webViewController = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
            
            webViewController.type = "faqs"
            webViewController.pushed = true
            
            self.navigationController?.pushViewController(webViewController, animated: true)
        }
        
    }
    
    
    @objc func goToBrands(){
        print("Home Go To Brands")
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        
        print("Controller Name: \(String(describing: controllerName))")
        
        if controllerName! as! String == "Celebrity"{
            let brandsViewTabController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "brandsViewTabController") as! BrandsViewTabController
            self.navigationController?.pushViewController(brandsViewTabController, animated: true)
        }
        
    }
    
    @objc func goToShopByCategory(){
        print("goToShopByCategory called")
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        
        print("Controller Name: \(String(describing: controllerName))")
        
        if controllerName! as! String == "Celebrity"{
            self.tabBarController?.selectedIndex = 3
        }
        
    }
    
    @objc func goToVideos(){
        print("goToShopByCategory called")
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        
        print("Controller Name: \(String(describing: controllerName))")
        
        if controllerName! as! String == "Celebrity"{
            let TVViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TVViewController") as! TVViewController
            self.navigationController?.pushViewController(TVViewController, animated: true)
        }
    }
    
    @objc func ContactUS(){
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        
        if controllerName! as! String == "Celebrity"{
            let contactUsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "contactUsViewController") as! contactUsViewController
            
            
            
            self.navigationController?.pushViewController(contactUsViewController, animated: true)
            
        }
    }
    
    @objc func languagePopup(){
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        
        if controllerName! as! String == "Celebrity"{
            let LanguageViewController = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
            
            
            
            self.navigationController?.pushViewController(LanguageViewController, animated: true)
            
        }
    }
    
    @IBAction func drawerMenuClicked(_ sender: Any) {
        UserDefaults.standard.set("Celebrity", forKey: "drawer")
        
        if self.currentLanguage == "en"{
            self.sideMenuController?.showLeftViewAnimated()
            
            
        }
        else{
            self.sideMenuController?.showRightViewAnimated()
            
        }
        
        NotificationCenter.default.post(name: Notification.Name("sideMenuBadgesUpdated"), object: nil)
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        //        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Number of view in celebrities
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.celebritiesCollectionlist.count
    }
    
    //populate views
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "CelebTabCollectionViewCell", for: indexPath) as! CelebTabCollectionViewCell
        
        cell.celebName.text = celebritiesCollectionlist[indexPath.row].name
        
        if self.currentLanguage == "en"{
            cell.celebName.font = UIFont(name: enMarselLanguageConstant, size: 12)!
        }
        else{
            cell.celebName.font = UIFont(name: arLanguageConstant, size: 12)!
        }
       
        //sdImageView Changes.
        let strCelebImageImage:String = CATEGORY_IMAGE_URL+(Array(celebritiesCollectionlist[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!
        
        let url = URL(string:strCelebImageImage)
        
        cell.celebImage.sd_setImage(with: url, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
        
//        BaseManager.Manager.request(CATEGORY_IMAGE_URL+(Array(celebritiesCollectionlist[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!).responseImage { response in
//            if let image = response.result.value {
//                cell.celebImage.image = image
//            }
//            else{
//                cell.celebImage.image = UIImage(named: "ImagePlaceholder")
//            }
//        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = mainStoryBoard.instantiateViewController(withIdentifier: "CelebContainerViewController") as! CelebContainerViewController
        
        desVC.celebName = self.celebritiesCollectionlist[indexPath.row].name!
        desVC.celebId = self.celebritiesCollectionlist[indexPath.row].id!
        desVC.celebItem = self.celebritiesCollectionlist[indexPath.row]
        
        desVC.celebBanner = CATEGORY_IMAGE_URL+(Array(self.celebritiesCollectionlist[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!
        
        
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
    func getCelebrities(pageSize:Int = 10,currentPage:Int = 1,fieldValue:Int = 48){
        print("Get Celebs function called");
        self.CelebCollections.isHidden = true
        manager.GetCelebritiesRequest(ApiURL : baseManager.ApiPathBuilder(apiPath: "categories/list", orderBy: "DESC", pageSize: pageSize, currentPage: currentPage, sortBy: "", conditionType: "", field: "parent_id", fieldValue: fieldValue)){ (celebritiesArray, error) in
            
            if error == nil{
                self.celebritiesCollectionlist = (celebritiesArray?.items!)!
                self.CelebCollections.reloadData()
                self.CelebCollections.isHidden = false
            }
            else{
                print(error!)
            }
        }
    }
    
}
