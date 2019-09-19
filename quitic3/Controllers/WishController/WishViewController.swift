//
//  WishViewController.swift
//  quitic3
//
//  Created by APPLE on 7/27/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import Localize_Swift
import MaterialComponents.MaterialSnackbar
import ANLoader
import SDWebImage


class WishViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var currentLanguage = ""
    var labels = AppLabels()
    var imgViewNavCenter = UIImageView()
    var lblHeader = UILabel()
    var viewNavCenter = UIView()
    
    @objc func setText(){
        
        print("Set Text WishViewController")
        labels = AppLabels()
        
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            
            if complete.count>0{

                self.currentLanguage = complete[0].name!
              //  self.title = labels.WISHLIST
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
            }
        }
    }

    @IBAction func drawerMenuClicked(_ sender: Any) {
        
        UserDefaults.standard.set("Wish", forKey: "drawer")
        
        if self.currentLanguage == "en"{
            
            self.sideMenuController?.showLeftViewAnimated()
        }
        else{
            self.sideMenuController?.showRightViewAnimated()
        }
    }
    
    var wishListArray  = [WishListModel] ()
    let manager = WishListManager()
    
    @IBOutlet weak var wishCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.wishListArray.count
    }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "WishCollectionViewCell", for: indexPath) as! WishCollectionViewCell
        
        cell.viewOuterBorder.layer.borderColor = UIColor.quiticPink.cgColor
        cell.viewOuterBorder.layer.borderWidth = 1.0
        
        cell.RemoveProduct.setTitle(labels.REMOVEPRODUCT, for: .normal)
        
        cell.reviews.text = "\(wishListArray[indexPath.row].reviews!) \(labels.REVIEWS)"
        if self.currentLanguage == "en"{
            cell.ProductName.textAlignment = .left
            cell.RemoveProduct.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)
            cell.PriceTag.font = UIFont(name: enLanguageConstant, size: 13)!
            cell.ProductName.font = UIFont(name: enLanguageConstant, size: 13)!
            cell.reviews.font = UIFont(name: enLanguageConstant, size: 10)!
            cell.imgNewTag.image = UIImage(named:"newTag")
        }
        else{
            cell.ProductName.textAlignment = .right
            cell.RemoveProduct.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)
//            cell.PriceTag.font = UIFont(name: arLanguageConstant, size: 13)!
            cell.PriceTag.font = UIFont(name: enLanguageConstant, size: 13)!

            cell.ProductName.font = UIFont(name: arLanguageConstant, size: 13)!
            cell.reviews.font = UIFont(name: arLanguageConstant, size: 10)!
            cell.imgNewTag.image = UIImage(named:"newTagAr")
        }
        
        
        
        //sdImageView Changes.
        let strProductImage:String = PRODUCT_IMAGE_URL+(wishListArray[indexPath.row].product?.thumbnail)!
        
        let url = URL(string:strProductImage)
        
        cell.ProductImage.sd_setImage(with: url, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
        
//        BaseManager.Manager.request(PRODUCT_IMAGE_URL+(wishListArray[indexPath.row].product?.thumbnail)!).responseImage { response in
//            if let image = response.result.value {
//                cell.ProductImage.image = image
//            }
//            else{
//                cell.ProductImage.image = UIImage(named: "ImagePlaceholder")
//            }
//        }
        
        
         cell.productCount.isHidden = true
        
//        let dictQty:quantity_and_stock_status = (wishListArray[indexPath.row].product?.quantity_and_stock_status)!
//
//        let qty : Int = dictQty.qty!
//        var qtyFinal = String(qty)
//
////        //add product avalilable count
//        cell.productCount.text = qtyFinal

        if((Array(wishListArray[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "is_new" })) != nil)
        {
            if ((Array(wishListArray[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "is_new" })?.value)!) != "0"
            {
                cell.imgNewTag.isHidden = false
            }
            else
            {
                cell.imgNewTag.isHidden = true
            }
        }

        cell.PriceTag.text = (wishListArray[indexPath.row].product?.price)! + "JOD"
        cell.ProductName.text=(wishListArray[indexPath.row].product?.name)!
        cell.cellDelegate = self
        cell.index = indexPath
//        let myColor = UIColor.quiticPink
//        cell.imageSectionView.layer.borderWidth = 0.5
//        cell.imageSectionView.layer.borderColor = myColor.cgColor
        if wishListArray[indexPath.row].avg_rating_percent! > 0 {
            cell.ratingcosmos.rating = Double(((wishListArray[indexPath.row].avg_rating_percent!*(5 - 1)) / 100)+1)
        }
        else {
            cell.ratingcosmos.rating = 0
        }
        
        //set brand name into product list screen. 18/06/2019
        if (wishListArray[indexPath.row].custom_attributes != nil)
        {
            for custom_attribute in wishListArray[indexPath.row].custom_attributes!
            {
                if custom_attribute.attribute_code == "brands"
                {
                     cell.lblBrandName.text = custom_attribute.value
                    if self.currentLanguage == "en"{
                       
                         cell.lblBrandName.font = UIFont(name: enMarselLanguageConstant, size: 17)!
                        
                    }
                    else{
                      
                        cell.lblBrandName.font = UIFont(name: arLanguageConstant, size: 17)
                        //            cell.PriceTag.font = UIFont(name: arLanguageConstant, size: 13)!
                        
                    
                    }
                    
                   
                }
                
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = mainStoryBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        
        if wishListArray[indexPath.row].avg_rating_percent! > 0 {
            desVC.customRate = Double(((wishListArray[indexPath.row].avg_rating_percent!*(5 - 1)) / 100)+1)
        }
        else {
            desVC.customRate = Double(0)
        }
        
        desVC.productId = Int(wishListArray[indexPath.row].product_id)!
        
        desVC.productImageStringValue = PRODUCT_IMAGE_URL+(wishListArray[indexPath.row].product?.thumbnail)!
        
        let productItem = Items()

        productItem.sku = wishListArray[indexPath.row].product!.sku!

        desVC.productItem = productItem
    
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        var cellSize: CGSize = collectionView.bounds.size
//        cellSize.width = ((wishCollectionView.frame.size.width/2) - 8)
//
//        if AppDelegate.isIPhone5W()
//        {
//            cellSize.height = cellSize.width * 2.3
//        }
//        else if AppDelegate.isIPhone6W()
//        {
//            cellSize.height = cellSize.width * 1.974522293
//        }
//        else if AppDelegate.isIPhone6PlusW()
//        {
//            cellSize.height = cellSize.width * 1.9
//        }
        
        var cellSize: CGSize = collectionView.bounds.size
        cellSize.width = ((wishCollectionView.frame.size.width/2) - 8)
        cellSize.height = 250
        return cellSize
    }
    
    
    override func viewWillDisappear(_ animated: Bool)
    {
         lblHeader.removeFromSuperview()
         viewNavCenter.removeFromSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if  (UserDefaults.standard.string(forKey: "token") == nil) {
            let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
            loginViewController.pushed = 1
            self.navigationController?.pushViewController(loginViewController, animated: true)
            
            
        }
        
//        if  (UserDefaults.standard.string(forKey: "token") == nil) {
//            let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
//            //            loginViewController.pushed = 1
//
//            self.present(loginViewController, animated: true)
//        }
        else{
            GetWishList()
        }
        
        /////////////// Resizing Celeb Second Collection//////////////////////////
        let wishCollectionWidth = (view.frame.size.width-20-16) / 2
        let wishCollectionViewLayout = wishCollectionView.collectionViewLayout as!  UICollectionViewFlowLayout
        wishCollectionViewLayout.itemSize = CGSize(width: wishCollectionWidth, height: wishCollectionWidth+130)
        wishCollectionView.delegate = self
        wishCollectionView.dataSource = self
        
    
        viewNavCenter = UIView(frame: CGRect(x: 0, y: -13, width:  (self.navigationController?.navigationBar.frame.size.width)!, height: 20))
        viewNavCenter.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.addSubview(viewNavCenter)
        
        
        
//        lblHeader = UILabel.init(frame:  CGRect(x: viewNavCenter.frame.origin.x + 10, y: -11, width: viewNavCenter.frame.size.width - 20, height: 50))
        
        lblHeader = UILabel.init(frame:  CGRect(x: 50, y: -7, width: self.view.frame.width - 100, height: 50))
        
        
        lblHeader.text = labels.WISHLIST
//        lblHeader.textAlignment = .center
//        lblHeader.textColor = UIColor.init(red: 251, green: 96, blue: 127)
//
        
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

    override func viewDidLoad()
    {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        setText()

        NotificationCenter.default.addObserver(self, selector: #selector(goToBrands), name: NSNotification.Name("GoToBrands"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToShopByCategory), name: NSNotification.Name("ShopByCategory"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToVideos), name: NSNotification.Name("Videos"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ContactUS), name: NSNotification.Name("ContactUS"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToLogin), name: NSNotification.Name("NotifyWishList"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(languagePopup), name: NSNotification.Name("languagePopup"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginScreen), name: NSNotification.Name("LoginScreen"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MyAccount), name: NSNotification.Name("MyAccount"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(faqs), name: NSNotification.Name("faqs"), object: nil)
        
    }
    
    @IBAction func searchBtnClicked(_ sender: Any) {
        let desVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
        desVC.searchType = "Categories"
        
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    @objc func goToLogin(){
        if  (UserDefaults.standard.string(forKey: "token") == nil) {
            let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
            loginViewController.pushed = 1
            self.navigationController?.pushViewController(loginViewController, animated: true)
        }
    }
    
    @objc func LoginScreen(){
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        if controllerName! as! String == "Wish"{
            let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
            loginViewController.pushed = 1
            self.navigationController?.pushViewController(loginViewController, animated: true)
        }
    }
    
    @objc func MyAccount(){
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        if controllerName! as! String == "Wish"{
            let brandsViewTabController = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "MyAccountViewController") as! MyAccountViewController
            self.navigationController?.pushViewController(brandsViewTabController, animated: true)
        }
    }
    
    @objc func faqs(){
        
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        if controllerName! as! String == "Wish"{
            let webViewController = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
            webViewController.type = "faqs"
            webViewController.pushed = true
            self.navigationController?.pushViewController(webViewController, animated: true)
        }
        
    }
    
    @objc func goToBrands(){
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        if controllerName! as! String == "Wish"{
            let brandsViewTabController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "brandsViewTabController") as! BrandsViewTabController
            self.navigationController?.pushViewController(brandsViewTabController, animated: true)
        }
        
    }
    
    @objc func goToShopByCategory(){
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        if controllerName! as! String == "Wish"{
            self.tabBarController?.selectedIndex = 3
        }
    }
    
    @objc func goToVideos(){
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
            if controllerName! as! String == "Wish"{
            let TVViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TVViewController") as! TVViewController
            self.navigationController?.pushViewController(TVViewController, animated: true)
        }
    }
    
    @objc func ContactUS(){
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        if controllerName! as! String == "Wish"{
            let contactUsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "contactUsViewController") as! contactUsViewController
            self.navigationController?.pushViewController(contactUsViewController, animated: true)
            
        }
    }
    
    @objc func languagePopup(){
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        if controllerName! as! String == "Wish"{
            let LanguageViewController = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
            self.navigationController?.pushViewController(LanguageViewController, animated: true)
        }
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @objc func didUpdateWishList()
    {
    } // end func didFinishDownloading
    
  fileprivate  func GetWishList(){
    
        self.loader(message: "loading")
    
        manager.fetchWishList { (wishListArray, error) in
            
            if wishListArray != nil{
                
                 self.wishListArray = [WishListModel] ()
                for wish in wishListArray!{
                    self.wishListArray.append(wish)
                    dump(wish)
                }
                self.wishCollectionView.reloadData()
                self.disableLoader()
            }
            else{
                UserDefaults.standard.removeObject(forKey:"token")
                self.disableLoader()
                let message = MDCSnackbarMessage()
                if self.currentLanguage == "en"{
                    message.text = "Token Expired please again login for proceed"
                }
                else{
                    message.text = "انتهت صلاحية الرمز المميز يرجى تسجيل الدخول مرة أخرى للمتابعة"
                }
                MDCSnackbarManager.show(message)
                let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
                loginViewController.pushed = 1
                self.navigationController?.pushViewController(loginViewController, animated: true)
            }
        }
    }
    func loader(message: String){
        ANLoader.activityColor = .quiticPink
        ANLoader.pulseAnimation = false
        ANLoader.activityBackgroundColor = .clear
        ANLoader.activityTextColor = .clear
        ANLoader.showLoading("",disableUI: true)
    }
    
    func disableLoader(){
        ANLoader.hide()
    }
    fileprivate  func DeleteWishListItem(itemId :String , indexAt : Int){
        manager.deleteWishList (wishlistItemId: itemId){ (wishListresponse, error) in
            if error == nil{
                self.wishListArray.remove(at: indexAt)
                self.GetWishList()
//                let message = MDCSnackbarMessage()
//               
//                if self.currentLanguage == "en"{
//                    message.text = "Item removed successfully"
//                }
//                else{
//                    message.text = "تمت إزالة العنصر بنجاح"
//                }
//                MDCSnackbarManager.show(message)
            }
            else{
                print(error!)
            }
        }
    }
}
extension WishViewController :RemoveItemWishListProtocol{
    func clickRemoveToWishListBtn(index: Int) {
            if self.wishListArray.count > 0{
            DeleteWishListItem(itemId:String(self.wishListArray[index].wishlist_item_id),indexAt: index)
        }
    }
}
