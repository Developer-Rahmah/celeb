//
//  CartViewController.swift
//  quitic3
//
//  Created by APPLE on 7/19/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import CoreData
import MaterialComponents.MaterialSnackbar
import Localize_Swift
import SDWebImage

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var btnExplore: UIButton!
    @IBOutlet weak var lblCartEmpty: UILabel!
    @IBOutlet weak var btnCheckout: UIButton!
    @IBOutlet weak var viewEmptyCart: UIView!
    @IBOutlet weak var viewCart: UIStackView!
    var currentLanguage = ""
    var lblHeader = UILabel()
    let labels = AppLabels()
    var navController: UINavigationController?
    var categoryItems: [Items] = []
   
    
    @objc func setText(){
       
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
        
       // self.title = labels.MYCART
        btnCheckout.setTitle("الدفع", for: .normal)
        if self.currentLanguage == "en"{
            //Check Out
            btnCheckout.setTitle(labels.CHECKOUT, for: .normal)
            btnCheckout.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
            
            self.tabBarController?.tabBar.items?[0].title = "Home"
            self.tabBarController?.tabBar.items?[1].title = "Wishlist"
            self.tabBarController?.tabBar.items?[2].title = "Celebrities"
            self.tabBarController?.tabBar.items?[3].title = "Categories"
            self.tabBarController?.tabBar.items?[4].title = "Cart"
            
         
            lblCartEmpty.font = UIFont(name: enLanguageConstant, size: 17)!
            lblCartEmpty.text = "Your Cart is Empty."
            
            btnExplore.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
            btnExplore.setTitle("Explore", for: .normal)
          
            
        }
        else{
            btnCheckout.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            
            self.tabBarController?.tabBar.items?[0].title = "الصفحة الرئيسية"
            self.tabBarController?.tabBar.items?[1].title = "قائمة الأمنيات"
            self.tabBarController?.tabBar.items?[2].title = " المشاهير"
            self.tabBarController?.tabBar.items?[3].title = "الأقسام"
            self.tabBarController?.tabBar.items?[4].title = "سلة المشتريات"
            
            lblCartEmpty.font = UIFont(name: arLanguageConstant, size: 17)!
            lblCartEmpty.text = "سلة المشتريات فارغة"

            btnExplore.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            btnExplore.setTitle("إستكشاف", for: .normal)

        }
    }
    var cartItems: [CartItem] = []
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblTotalItems: UILabel!
    
    @IBOutlet weak var lblTotalPrice: UILabel!
    
    
    let navBarTitleImage = UIImage(named: "MyBoutiques")
    
    @IBAction func drawerMenuClicked(_ sender: Any) {
        UserDefaults.standard.set("Cart", forKey: "drawer")
        
        if self.currentLanguage == "en"{
            self.sideMenuController?.showLeftViewAnimated()
            
            
        }
        else{
            self.sideMenuController?.showRightViewAnimated()
            
        }
    }
    var productsArray:[Items] = [Items]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.setText()
        tableView.delegate = self
        tableView.dataSource = self
        
      //  self.navigationItem.titleView = UIImageView(image: navBarTitleImage)
        

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToBrands), name: NSNotification.Name("GoToBrands"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToShopByCategory), name: NSNotification.Name("ShopByCategory"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToVideos), name: NSNotification.Name("Videos"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ContactUS), name: NSNotification.Name("ContactUS"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(languagePopup), name: NSNotification.Name("languagePopup"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginScreen), name: NSNotification.Name("LoginScreen"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MyAccount), name: NSNotification.Name("MyAccount"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(faqs), name: NSNotification.Name("faqs"), object: nil)
        
        self.fetchCategoryCoreData()
        
    }

    
    @IBAction func searchBtnClicked(_ sender: Any) {
        let desVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
        desVC.searchType = "Categories"
        
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
    @objc func LoginScreen(){
        
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        
        if controllerName! as! String == "Cart"{
            let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
            loginViewController.pushed = 1
            
            self.navigationController?.pushViewController(loginViewController, animated: true)
        }
        
    }
    
    @objc func MyAccount(){
        
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        
        print("Controller Name: \(String(describing: controllerName))")
        
        if controllerName! as! String == "Cart"{
            let brandsViewTabController = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "MyAccountViewController") as! MyAccountViewController
            self.navigationController?.pushViewController(brandsViewTabController, animated: true)
        }
        
    }
    
    @objc func faqs(){
        
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        
        if controllerName! as! String == "Cart"{
            let webViewController = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
            
            webViewController.type = "faqs"
            webViewController.pushed = true
            
            self.navigationController?.pushViewController(webViewController, animated: true)
        }
        
    }
    
    @objc func goToBrands(){
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        
        if controllerName! as! String == "Cart"{
            let brandsViewTabController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "brandsViewTabController") as! BrandsViewTabController
            self.navigationController?.pushViewController(brandsViewTabController, animated: true)
        }
        
    }
    
    @objc func goToShopByCategory(){
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        
        if controllerName! as! String == "Cart"{
            
            self.tabBarController?.selectedIndex = 3
        }
        
    }
    
    @objc func goToVideos(){
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        
        if controllerName! as! String == "Cart"{
            let TVViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TVViewController") as! TVViewController
            self.navigationController?.pushViewController(TVViewController, animated: true)
        }
    }
    
    @objc func ContactUS(){
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        
        if controllerName! as! String == "Cart"{
            let contactUsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "contactUsViewController") as! contactUsViewController
            
            
            
            self.navigationController?.pushViewController(contactUsViewController, animated: true)
            
        }
    }
    
    @objc func languagePopup(){
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        
        if controllerName! as! String == "Cart"{
            let LanguageViewController = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
            self.navigationController?.pushViewController(LanguageViewController, animated: true)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchFromCoreData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        setText()
        
        lblHeader = UILabel.init(frame:  CGRect(x: 50, y: -7, width: self.view.frame.width - 100, height: 50))
        lblHeader.text = labels.CART
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartTableViewCell
        
//        cell.productImage.image = UIImage(named: "ImagePlaceholder")
    
        var url :String = ""
//        url = URL(string:(cartItems[indexPath.row].imageUrl!))
        
        if cartItems[indexPath.row].imageUrl != nil {
            url = cartItems[indexPath.row].imageUrl!
        }
        else {
            url = ""
        }
        
         let urlProduct = URL(string:url)
        
        //sdImageView Changes.
        cell.productImage!.sd_setImage(with: urlProduct, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
        
        
//        BaseManager.Manager.request(url).responseImage { response in
//            if let image = response.result.value {
//                cell.productImage.image = image
//            }
//            else{
//                cell.productImage.image = UIImage(named: "ImagePlaceholder")
//            }
//        }
        
        if self.currentLanguage == "en"{
            cell.productTitle.font = UIFont(name: enLanguageConstant, size: 17)!
            cell.productPrice.font = UIFont(name: enLanguageConstant, size: 14)!
            cell.productQuantity.font = UIFont(name: enLanguageConstant, size: 14)!
            cell.productQuantity.text = "\(self.cartItems[indexPath.row].quantity)x"
        }
        else{
            cell.productTitle.font = UIFont(name: arLanguageConstant, size: 17)!
            cell.productPrice.font = UIFont(name: enLanguageConstant, size: 14)!
            cell.productQuantity.font = UIFont(name: enLanguageConstant, size: 14)!
            cell.productQuantity.text = "\(self.cartItems[indexPath.row].quantity)"
        }
        
        cell.productPrice.text = String(self.cartItems[indexPath.row].price) + " JOD"
        cell.productTitle.text = self.cartItems[indexPath.row].name
        
        
        cell.addQuantityDelegate = self
        cell.deleteItemDelegate = self
        cell.subtractQuantityDelegate = self
        cell.index = indexPath
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = mainStoryBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        
        let items:Items = Items ()
        
        items.sku = cartItems[indexPath.row].sku!
        
        items.id = Int(cartItems[indexPath.row].id)
        desVC.productItem = items
    
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
  
    @IBAction func btnCheckoutClicked(_ sender: Any) {
        if self.cartItems.count > 0 {
        let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = mainStoryBoard.instantiateViewController(withIdentifier: "ShipingAddressViewController") as! ShipingAddressViewController
        
        self.navigationController?.pushViewController(desVC, animated: true)
        }
        else{
            let message = MDCSnackbarMessage()
            if self.currentLanguage == "en"{
                message.text = "Your cart is empty Please add items in your cart"
            }
            else{
                message.text = "عربة التسوق فارغة يرجى إضافة عناصر في سلة التسوق الخاصة بك"
            }
            
            MDCSnackbarManager.show(message)

        }
    }
    @IBAction func btnExplore(_ sender: Any)
    {
        let desVC = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "splitPagerProducts") as! ProductPagerViewController
        
        desVC.previousData = self.categoryItems
        
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    func GetProducts(){
        print("Getting Products")
        APIManager.shared.GetProductsRequest(pageSize: 10) { (data) in
            self.productsArray = CommonManager.shared.removeNullElement(items : data,attributeName : "image")
            
            
            //display empty cart view.
            if self.productsArray.count == 0
            {
               self.viewEmptyCart.isHidden = false
               self.tableView.isHidden = true
               self.viewCart.isHidden = true
            }
            else
            {
                self.viewEmptyCart.isHidden = true
                self.tableView.isHidden = false
                self.viewCart.isHidden = false
                self.tableView.reloadData()
            }
           
        }
    }
    
    func fetchFromCoreData(){
        self.fetch { (complete) in
            if complete {
                self.tableView.reloadData()
                self.updateTotal()
                
            }else{
                print("unsuccessfl")
            }
        }
    }
    
}

extension CartViewController {
    func fetch(completion: (_ complete: Bool) -> ()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItem")
        
        do{
            cartItems = try managedContext.fetch(fetchRequest) as! [CartItem]
            
            //display empty cart view.
            if cartItems.count == 0
            {
                self.viewEmptyCart.isHidden = false
                self.tableView.isHidden = true
                self.viewCart.isHidden = true
            }
            else
            {
                self.viewEmptyCart.isHidden = true
                self.tableView.isHidden = false
                self.viewCart.isHidden = false
                self.tableView.reloadData()
            }
            
            completion(true)
        }catch{
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func removeCartItem(atIndex index: Int){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        managedContext.delete(cartItems[index])
        
        let message = MDCSnackbarMessage()
        do {
            try managedContext.save()
            
//            if self.currentLanguage == "en"{
//                message.text = "Item removed from cart"
//            }
//            else{
//                message.text = "تمت إزالة العنصر من العربة"
//            }
            
        }catch{
            print("Could not remove: \(error.localizedDescription)")
            message.text = "Could not remove"
            MDCSnackbarManager.show(message)
        }
        
        
    }
    
    func upadateCartItem(atIndex index: Int, type: Bool){
        //Type 1 === true && Type 0 === false
        
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
    
        let choosenCartItem = cartItems[index]
        
        if type == true {
            choosenCartItem.quantity += 1
            self.cartItems[index].quantity  = choosenCartItem.quantity
            
        }else {
            if choosenCartItem.quantity != 0 {
                if choosenCartItem.quantity == 1{
                    removeCartItem(atIndex: index)
                    cartItems.remove(at: index)
                }
                else{
                    choosenCartItem.quantity -= 1
                    self.cartItems[index].quantity = choosenCartItem.quantity
                }
                
            }
        }
        
        do{
            try managedContext.save()
            
        }catch{
            print("Could not remove: \(error.localizedDescription)")
        }
        
        
    }
    
    func  updateTotal(){
        var totalItems: Int32 = 0
        var totalPrice: Double = 0
        for item in cartItems{
            let currentPrice = Double(item.quantity) * item.price
            totalItems += item.quantity
            totalPrice += currentPrice
        }
        
        if self.currentLanguage == "en"{
            
            self.lblTotalItems.text = "Total items (\(totalItems))"
            self.lblTotalItems.font = UIFont(name: enLanguageConstant, size: 17)!
            
            self.lblTotalItems.textAlignment = .left
            self.lblTotalPrice.textAlignment = .left
            
            self.lblTotalPrice.font = UIFont(name: enLanguageConstant, size: 24)!
        }
        else{
            
            self.lblTotalItems.text = "مجموع المشتريات (\(totalItems))"
            self.lblTotalItems.font = UIFont(name: enLanguageConstant, size: 17)!
            
            self.lblTotalItems.textAlignment = .right
            self.lblTotalPrice.textAlignment = .right
            
            self.lblTotalPrice.font = UIFont(name: enLanguageConstant, size: 24)!
        }
        
        self.lblTotalPrice.text = "\(totalPrice) JOD"
        
        NotificationCenter.default.post(name: Notification.Name("updateCartQuantityBadge"), object: nil)
    }
    
    
    func fetchCategoryCoreData(){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoryCore")
    
        var celebItems: [CategoryCore] = []
        do{
            
            celebItems = try managedContext.fetch(fetchRequest) as! [CategoryCore]

            var arrAccending:[Int] = []
            
            for object in celebItems {
                
                let newItem: Items = Items()
                newItem.id = Int(object.id)
                newItem.name = object.name
                
                arrAccending.append(newItem.id!)
            
            }
            
            arrAccending.sort()
            for element in arrAccending
            {
                for object in celebItems {
                    
                    if object.id == element
                    {
                        let newItem: Items = Items()
                        newItem.id = Int(object.id)
                        newItem.name = object.name
                        
                        self.categoryItems.append(newItem)
                    }
                }
            }
            
            
        }catch{
            debugPrint("Could not fetch: \(error.localizedDescription)")
        }
    }
    
    
    
}

extension CartViewController: deleteItemProtocol, addQuantityBtnProtocol, subtractQuantityProtocol {
    func deleteItemBtn(index: IndexPath) {
        self.removeCartItem(atIndex: index.row)
        self.fetchFromCoreData()
    }
    
    func addQuantityBtnButton(index: IndexPath) {
        self.upadateCartItem(atIndex: index.row, type: true)
        self.tableView.reloadData()
        self.updateTotal()
    }
    
    func subtractQuantityBtn(index: IndexPath) {
        self.upadateCartItem(atIndex: index.row, type: false)
        self.tableView.reloadData()
        self.updateTotal()
    }
}




