//
//  CategoriesTabsViewController.swift
//  quitic3
//
//  Created by DOT on 8/16/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import Localize_Swift
import SDWebImage

class CategoriesTabsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var categoriesTable: UITableView!
    
    var lblHeader = UILabel()
    var currentLanguage = ""
    var labels = AppLabels()
    
    @IBAction func drawerMenuClicked(_ sender: Any) {
        UserDefaults.standard.set("Category", forKey: "drawer")
        
        if self.currentLanguage == "en"{
            self.sideMenuController?.showLeftViewAnimated()
        }
        else{
            self.sideMenuController?.showRightViewAnimated()
            
        }
        
        NotificationCenter.default.post(name: Notification.Name("sideMenuBadgesUpdated"), object: nil)
    }
    
    var categoriesArray: [Items] = []
    let celebritiesManager = CelebritiesManager()
    let baseManager = BaseManager()
    let navBarTitleImage = UIImage(named: "MyBoutiques")
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @objc func setText(){
        labels = AppLabels()
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
                //self.title = labels.CATEGORIES
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
                self.GetCategories()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        

        NotificationCenter.default.addObserver(self, selector: #selector(goToBrands), name: NSNotification.Name("GoToBrands"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToShopByCategory), name: NSNotification.Name("ShopByCategory"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToVideos), name: NSNotification.Name("Videos"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ContactUS), name: NSNotification.Name("ContactUS"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(languagePopup), name: NSNotification.Name("languagePopup"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginScreen), name: NSNotification.Name("LoginScreen"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MyAccount), name: NSNotification.Name("MyAccount"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(faqs), name: NSNotification.Name("faqs"), object: nil)
        

        let width = (view.frame.size.width-0-10) / 3
        let layout = categoriesCollectionView.collectionViewLayout as!  UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource=self
        
        categoriesTable.delegate = self
        categoriesTable.dataSource = self
        
       setText()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        lblHeader = UILabel.init(frame:  CGRect(x: view.frame.size.width / 2 - 75, y: -11, width: 150, height: 50))
        lblHeader.text = labels.CATEGORIES
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
        
        desVC.mainItems = self.categoriesArray
        desVC.filteredCellItems = self.categoriesArray
        desVC.searchType = "Categories"
        
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
    @objc func LoginScreen(){
        
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        
        if controllerName! as! String == "Category"{
            let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
            loginViewController.pushed = 1
            
            self.navigationController?.pushViewController(loginViewController, animated: true)
        }
        
    }
    
    @objc func MyAccount(){
        
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        
        print("Controller Name: \(String(describing: controllerName))")
        
        if controllerName! as! String == "Category"{
            let brandsViewTabController = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "MyAccountViewController") as! MyAccountViewController
            self.navigationController?.pushViewController(brandsViewTabController, animated: true)
        }
        
    }
    
    @objc func faqs(){
        
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        
        if controllerName! as! String == "Category"{
            let webViewController = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
            
            webViewController.type = "faqs"
            webViewController.pushed = true
            
            self.navigationController?.pushViewController(webViewController, animated: true)
        }
        
    }
    
    @objc func goToBrands(){
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        
        if controllerName! as! String == "Category"
        {
            let brandsViewTabController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "brandsViewTabController") as! BrandsViewTabController
            self.navigationController?.pushViewController(brandsViewTabController, animated: true)
        }
        
    }
    
    @objc func goToShopByCategory(){
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        
        if controllerName! as! String == "Category"{
            
            self.tabBarController?.selectedIndex = 3
        }
        
    }
    
    @objc func goToVideos(){
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        
        if controllerName! as! String == "Category"{
            let TVViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TVViewController") as! TVViewController
            self.navigationController?.pushViewController(TVViewController, animated: true)
        }
    }
    
    @objc func ContactUS(){
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        
        if controllerName! as! String == "Category"{
            let contactUsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "contactUsViewController") as! contactUsViewController
            
            self.navigationController?.pushViewController(contactUsViewController, animated: true)
            
        }
    }
    
    @objc func languagePopup(){
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        
        if controllerName! as! String == "Category"{
            let LanguageViewController = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
            
            self.navigationController?.pushViewController(LanguageViewController, animated: true)
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoriesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:  "categoriesTabCell2", for: indexPath) as! ShopByCategoryTableViewCell
  
       
        //sdImageView Changes.
        let strCategoryImage:String = CATEGORY_IMAGE_URL+(Array(self.categoriesArray[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!
        
        
        let url = URL(string:strCategoryImage)
        
        cell.categoryImage.sd_setImage(with: url, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
        
        
//        BaseManager.Manager.request(CATEGORY_IMAGE_URL+(Array(self.categoriesArray[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!).responseImage { response in
//            if let image = response.result.value {
//                cell.categoryImage.image = image
//            }
//            else{
//                cell.categoryImage.image = UIImage(named: "ImagePlaceholder")
//            }
//        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.categoriesArray[indexPath.row].children! == "" {
            
            let desVC = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "splitPagerProducts") as! ProductPagerViewController
            
            desVC.previousData = self.categoriesArray
            desVC.selectedName = self.categoriesArray[indexPath.row].name!
            desVC.selectedId = self.categoriesArray[indexPath.row].id!
           // desVC.allId = self.categoriesArray[indexPath.row].id!
            
            self.navigationController?.pushViewController(desVC, animated: true)
        } else {
            
            let subCategoryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            
            subCategoryVC.previousData = self.categoriesArray
            subCategoryVC.selectedName = self.categoriesArray[indexPath.row].name!
            subCategoryVC.selectedId = self.categoriesArray[indexPath.row].id!
            
            self.navigationController?.pushViewController(subCategoryVC, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.categoriesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "categoriesTabCell", for: indexPath) as! CelebTabCollectionViewCell
        
        cell.celebName.text = self.categoriesArray[indexPath.row].name
       
        //sdImageView Changes.
        let strCategoryImage:String = CATEGORY_IMAGE_URL+(Array(self.categoriesArray[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!
        
        
        let url = URL(string:strCategoryImage)
        
        cell.celebImage.sd_setImage(with: url, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
        
//        BaseManager.Manager.request(CATEGORY_IMAGE_URL+(Array(self.categoriesArray[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!).responseImage { response in
//            if let image = response.result.value {
//                cell.celebImage.image = image
//            }
//            else{
//               cell.celebImage.image = UIImage(named: "ImagePlaceholder")
//            }
//        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let desVC = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "splitPagerProducts") as! ProductPagerViewController
        
        desVC.previousData = self.categoriesArray
        desVC.selectedName = self.categoriesArray[indexPath.row].name!
        desVC.selectedId = self.categoriesArray[indexPath.row].id!
        
        
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
    func GetCategories(pageSize:Int = 15,currentPage:Int = 1,fieldValue:Int = 2){
        
        self.categoriesCollectionView.isHidden = true
        self.categoriesTable.isHidden = true
        
        celebritiesManager.GetCelebritiesRequest(ApiURL : self.baseManager.ApiPathBuilder(apiPath: "categories/list", orderBy: "DESC", pageSize: pageSize, currentPage: currentPage, sortBy: "", conditionType: "", field: "parent_id", fieldValue: fieldValue)){ (data, error) in
            if error == nil{
                
                var tempCategories: [Items] = []
                for item in (data?.items!)!{
                    if item.is_active! && item.id != Constant_Brands_Id && item.id != Constant_Trending_Now_Id && item.id != Constant_Special_Collection_Id && item.id != Constant_Celebrities_Id{
                        
                        tempCategories.append(item)
                        
                    }
                }
                
                self.categoriesArray = CommonManager.shared.removeNullElement(items : tempCategories,attributeName : "image")
                
                
                self.categoriesTable.reloadData()
                self.categoriesTable.isHidden = false
                self.categoriesCollectionView.reloadData()
                self.categoriesCollectionView.isHidden = false
            }
            else{
                print(error!)
            }
        }
    }
    

}
