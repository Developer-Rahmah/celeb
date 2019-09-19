//
//  MyBoutiquesViewController.swift
//  quitic3
//
//  Created by DOT on 7/18/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import Localize_Swift
import MaterialComponents.MaterialSnackbar
import SJSegmentedScrollView
import SDWebImage

class MyBoutiquesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var endOfPage: UILabel!
    @IBOutlet weak var categoriesCollectionUIViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var productCollectionUIViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var categoriesCollectionUIView: UIView!
    
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var CategoriesCollectionView: UICollectionView!
    @IBOutlet weak var productsPaginatingActivity: UIView!
    let baseManager = BaseManager()
    let celebritiesManager = CelebritiesManager()
    let productManager = ProductsManager()
    let wishManager = WishListManager()
   
    
    @IBOutlet weak var scrvMyBoutiques: UIScrollView!
    
    let array:[String] = ["perfume", "perfume", "perfume", "perfume", "perfume", "perfume"]
    
    var celebId = 0
    var celebName = ""
    var categories: [Items] = []
    var products: [Items] = []
    var wishListArray = [WishListModel] ()
    var cartItems: [CartItem] = []
    var celebBanner: String = ""
    
    
    var productPageSize = 5
    var totalPages = 1
    var pageNo = 1
    var sortBy = "created_at"
    var orderBy = "DESC"
    var currentLanguage = ""
    
    @IBOutlet weak var btnSeeAll: UIButton!
    @IBOutlet weak var lblCelebriticlbl: UILabel!
    @objc func setText(){
        let labels = AppLabels()
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
        lblCelebriticlbl.text = labels.CELEBRITYPICKS
         btnSeeAll.setTitle(labels.SEEALL, for: .normal)
        if self.currentLanguage == "en"{
            lblCelebriticlbl.font = UIFont(name: enMarselLanguageConstant, size: 15)!
            lblCelebriticlbl.text = "Best Picks"
            btnSeeAll.titleLabel?.font = UIFont(name: enMarselLanguageConstant, size: 15)!
            
            self.btnSeeAll.setImage(UIImage(named: "rightArrow"), for: .normal)
            self.btnSeeAll.semanticContentAttribute = .forceRightToLeft
            self.btnSeeAll.contentHorizontalAlignment = .right
            self.btnSeeAll.titleEdgeInsets.right = 10.0
        }
        else{
            lblCelebriticlbl.font = UIFont(name: arLanguageConstant, size: 15)!
            lblCelebriticlbl.text = " المشاهير"
            btnSeeAll.titleLabel?.font = UIFont(name: arLanguageConstant, size: 15)!
            
            self.btnSeeAll.setImage(UIImage(named: "leftArrow"), for: .normal)
            self.btnSeeAll.semanticContentAttribute = .forceLeftToRight
            self.btnSeeAll.contentHorizontalAlignment = .left
            self.btnSeeAll.titleEdgeInsets.left = 10.0
        }
    }
    

    @objc func loginStatus(){
        products = [Items]()
        self.GetProductByCategoryId(orderBy: self.orderBy, sortBy: self.sortBy)    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSeeAll.isHidden = true
        endOfPage.isHidden = true; NotificationCenter.default.addObserver(self, selector: #selector(loginStatus), name: NSNotification.Name("NotifyLoginStatus"), object: nil)
        print("MyBoutiquesViewController viewDidLoad");
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.setText()
        let CategoriesCollectionCellWidth = (view.frame.size.width-8) / 2
        let CategoriesCollectionViewLayout = CategoriesCollectionView.collectionViewLayout as!  UICollectionViewFlowLayout
        CategoriesCollectionViewLayout.itemSize = CGSize(width: CategoriesCollectionCellWidth, height: (CategoriesCollectionCellWidth/2)+10)
          CategoriesCollectionViewLayout.sectionInset = UIEdgeInsets(top: 2, left: 3, bottom:   2, right: 3)

        let ProductsCollectionCellWidth = (view.frame.size.width-16-5) / 2
        let ProductsCollectionViewLayout = productsCollectionView.collectionViewLayout as!  UICollectionViewFlowLayout
        ProductsCollectionViewLayout.itemSize = CGSize(width: ProductsCollectionCellWidth, height: ProductsCollectionCellWidth+130)


        CategoriesCollectionView.delegate = self
        CategoriesCollectionView.dataSource=self
        
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        
        self.GetCategories()
        self.GetProductByCategoryId(orderBy: self.orderBy, sortBy: self.sortBy)
    }
 
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
    }
    
    
//    override func viewDidLayoutSubviews() {
//
//
//        super.viewDidLayoutSubviews()
//
//        self.scrvMyBoutiques.setNeedsLayout()
//        self.scrvMyBoutiques.layoutIfNeeded()
//
//
//        scrvMyBoutiques.translatesAutoresizingMaskIntoConstraints = true
//
//        scrvMyBoutiques.contentSize = CGSize(width: scrvMyBoutiques.frame.size.width, height: categoriesCollectionUIView.frame.size.height + productsCollectionView.frame.size.height)
//
//        scrvMyBoutiques.frame = CGRect(x: scrvMyBoutiques.frame.origin.x, y: scrvMyBoutiques.frame.origin.y, width: self.view.frame.size.width, height: scrvMyBoutiques.contentSize.height)
//
//        let contentSizeHeight = [ "Height": scrvMyBoutiques.contentSize.height]
//
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTableView"), object:contentSizeHeight, userInfo: nil)
//
//    }

    @IBAction func seeAllProductsClicked(_ sender: Any) {
        let desVC = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "splitPagerProducts") as! ProductPagerViewController
        
        
        desVC.previousData = self.categories
        
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        
        if collectionView == self.CategoriesCollectionView{
            if categories.count > 0 {
                let rowsCount = ceil(CGFloat(self.categories.count) / CGFloat(2))
                let rowHeight = (((view.frame.size.width - 2) / 2) / 2) * rowsCount
                
                categoriesCollectionUIViewHeight.constant = rowHeight+45
                self.view.layoutIfNeeded()
            }
            else{
                categoriesCollectionUIViewHeight.constant = 50
                self.view.layoutIfNeeded()
            }
            return categories.count
        }else{
            if products.count > 0 {
                let cellWidth = (view.frame.size.width - 16 - 5) / 2
                let cellHeight = cellWidth + 130.0
                let rowsCount = ceil(CGFloat(self.products.count) / CGFloat(2))
                let height =  (cellHeight * rowsCount)
                productCollectionUIViewHeight.constant = height + 700
                self.view.layoutIfNeeded()
            }
            else{
                productCollectionUIViewHeight.constant = 1000
                self.view.layoutIfNeeded()
            }
            return products.count
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let labels = AppLabels()
        if collectionView == self.CategoriesCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "CategoriesCollectionViewCell", for: indexPath) as! CategoriesCollectionViewCell
            cell.catName.text = categories[indexPath.row].name
//            cell.lblOutOfStock.isHidden = true;
            if self.currentLanguage == "en" {
                cell.catName.font = UIFont(name: enMarselLanguageConstant, size: 16)!
            }
            else{
                cell.catName.font = UIFont(name: arLanguageConstant, size: 16)!
            }
           
            
            //sdImageView Changes.
            if(categories[indexPath.row].is_active!){
            let strIconImageImage:String = CATEGORY_IMAGE_URL+(Array(categories[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "thumbnail" })?.value)!
            
            let url = URL(string:strIconImageImage)
            
            cell.iconImage.sd_setImage(with: url, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
            
//            BaseManager.Manager.request(CATEGORY_IMAGE_URL+(Array(categories[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "thumbnail" })?.value)!).responseImage { response in
//                if let image = response.result.value {
//                    cell.iconImage.image = image
//                }
//                else{
//                    cell.iconImage.image = UIImage(named: "ImagePlaceholder")
//                }
//            }
            }
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "celebProduct", for: indexPath) as! CartItemCollectionViewCell
            cell.reviews.isHidden = true
                cell.price.text = "\(products[indexPath.row].price!) JOD"
                cell.label.text = products[indexPath.row].name
                cell.viewOuterBorder.layer.borderColor = UIColor.quiticPink.cgColor
                cell.viewOuterBorder.layer.borderWidth = 1.0
            
                cell.lblOutOfStock.text = ""
            cell.reviews.text = ""
//            cell.isHidden = true
            //Disable section start
            for cartItem in cartItems {
                if cartItem.id == products[indexPath.row].id!
                {
                    print("deselect at \(cartItem.id) == \(products[indexPath.row].id!)")
                    products[indexPath.row].isAddedToCart = true
                }
            }

             //add product avalilable count
            if (Array(products[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "product_count" })?.value) != nil
            {
                cell.productCount.isHidden = true
               
                cell.productCount.text = Array(products[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "product_count" })?.value
            }
            else
            {
                cell.productCount.isHidden = true
            }
            
            
            if products[indexPath.row].isAddedToCart {
                cell.addToCartBtn.backgroundColor = UIColor.darkGray
                cell.addToCartBtn.isEnabled = !products[indexPath.row].isAddedToCart
                cell.checkedBtnOutlet.isHidden = false
            }
            else{
                cell.addToCartBtn.backgroundColor = UIColor.black
                cell.addToCartBtn.isEnabled = true
                cell.checkedBtnOutlet.isHidden = true
            }
            
            if((Array(products[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "is_new" })) != nil)
            {
                if ((Array(products[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "is_new" })?.value)!) != "0"
                {
                    cell.imgNewTag.isHidden = false
                }
                else
                {
                    cell.imgNewTag.isHidden = true
                }
            }
            
            if ((Array(products[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "quantity" })?.value)!) != "0"
            {
                if(!products[indexPath.row].isAddedToCart)
                {
                    cell.addToCartBtn.backgroundColor = UIColor.black
                }
                
                if self.currentLanguage == "en"
                {
                    cell.addToCartBtn.setTitle("ADD TO CART", for: .normal)
                }
                else
                {
                    cell.addToCartBtn.setTitle("أضف إلى السلة", for: .normal)
                }
            }
            else
            {
                cell.addToCartBtn.backgroundColor = UIColor.black
                
                if self.currentLanguage == "en"
                {
                   //edit
                    cell.lblOutOfStock.isHidden = true;
                    cell.reviews.isHidden=false;
//                    cell.lblOutOfStock.text = "OUT OF STOCK"
                   //edit
                    cell.reviews.text = "Sold Out"

                    cell.addToCartBtn.setTitle("Notify Me", for: .normal)
                }
                else
                {
                   //end
                   //edit
                    cell.lblOutOfStock.isHidden = true;
                    cell.reviews.isHidden=false;
                    
//                    cell.lblOutOfStock.text = ""
                   //edit
                    cell.reviews.text = "إنتهى من المخزن"

                    cell.addToCartBtn.setTitle("اعلمني", for: .normal)
                }
            }
            
            //Disable section end
            if currentLanguage == "en"{
                cell.label.textAlignment = .left
                
                cell.label.font = UIFont(name: enLanguageConstant, size: 13)!
                cell.price.font = UIFont(name: enLanguageConstant, size: 13)!
                cell.reviews.font = UIFont(name: enLanguageConstant, size: 10)!
                cell.addToCartBtn.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
                cell.reviews.text = "Sold Out"
                cell.imgNewTag.image = UIImage(named:"newTag")
            }
            else{
                cell.label.textAlignment = .right
                
                cell.label.font = UIFont(name: arLanguageConstant, size: 13)!
                cell.price.font = UIFont(name: enLanguageConstant, size: 13)!
                cell.reviews.font = UIFont(name: arLanguageConstant, size: 10)!
                cell.addToCartBtn.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
                cell.reviews.text = "نفذت"
                cell.imgNewTag.image = UIImage(named:"newTagAr")
            }

            if products[indexPath.row].avg_rating_percent! > 0 {
                cell.ratingcosmos.rating = Double(((products[indexPath.row].avg_rating_percent!*(5 - 1)) / 100)+1)
            }
            else {
                cell.ratingcosmos.rating = 0
            }
           
            //sdImageView Changes.
            let strIconImageImage:String = PRODUCT_IMAGE_URL+(Array(products[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!
            
            let url = URL(string:strIconImageImage)
            
            cell.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
        
//            BaseManager.Manager.request(PRODUCT_IMAGE_URL+(Array(products[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!).responseImage { response in
//                if let image = response.result.value {
//                    cell.imageView.image = image
//                }
//                else{
//                    cell.imageView.image = UIImage(named: "ImagePlaceholder")
//                }
//            }
             //cell.addToCartBtn.setTitle(labels.ADDTOCART, for: .normal)

            cell.wishButton.setImage(UIImage(named: "heartEmpty"), for: .normal)
            
            if products[indexPath.row].isWish
            {
                cell.wishButton.setImage(UIImage(named: "favor"), for: .normal)
            }
            else
            {
                cell.wishButton.setImage(UIImage(named: "heartEmpty"), for: .normal)
            }
            
//            let myColor = UIColor.quiticPink
//            cell.imageSectionView.layer.borderWidth = 0.5
//            cell.imageSectionView.layer.borderColor = myColor.cgColor
            cell.cellDelegate=self
            cell.cellCartDelegate = self
            cell.cellCheckedBtnDelegate = self
            cell.index = indexPath
            
            //set brand name into product list screen. 25/06/2019
            if (products[indexPath.row].custom_attributes != nil)
            {
                for custom_attribute in products[indexPath.row].custom_attributes!
                {
                    if custom_attribute.attribute_code == "brands"
                    {
                        cell.lblBrandName.text = custom_attribute.value
                    }
//                    else if custom_attribute.attribute_code == "is_wishlist"
//                    {
//                        if custom_attribute.value == "1"
//                        {
//                            cell.wishButton.setImage(UIImage(named: "favor"), for: .normal)
//                        }
//                        else
//                        {
//                            cell.wishButton.setImage(UIImage(named: "heartEmpty"), for: .normal)
//                        }
//                    }
                }
            }
            

            return cell
            
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.CategoriesCollectionView{
            if(categories[indexPath.row].is_active!){
            
//            let desVC = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "splitPagerProducts") as! ProductPagerViewController
//
//            desVC.previousData = self.categories
//            desVC.selectedName = self.categories[indexPath.row].name!
//            desVC.selectedId = self.categories[indexPath.row].id!
//            desVC.allId = self.celebId
//            desVC.setTitle = "\(self.celebName) Products"
//            self.navigationController?.pushViewController(desVC, animated: true)
//
//
            let categoryPager = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "CategoryContainerViewController") as! CategoryContainerViewController
            categoryPager.previousData = self.categories
            categoryPager.selectedName = self.categories[indexPath.row].name!
            categoryPager.selectedId = self.categories[indexPath.row].id!
            categoryPager.allId = self.celebId
            categoryPager.selectedIndex = indexPath.row
            categoryPager.celebName = self.celebName
            categoryPager.celebBanner = self.celebBanner
            categoryPager.celebId = self.celebId
            // categoryPager.setTitle = "\(self.celebName) Products"
            self.navigationController?.pushViewController(categoryPager, animated: true)
        }else{
            let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desVC = mainStoryBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
            if products[indexPath.row].avg_rating_percent! > 0 {
                desVC.customRate = Double(((products[indexPath.row].avg_rating_percent!*(5 - 1)) / 100)+1)
                
            }
            else {
                desVC.customRate = Double(0)
            }
            let url = URL(string:(PRODUCT_IMAGE_URL+(Array(products[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!))
            
            desVC.productItem = self.products[indexPath.row]
            desVC.productImageValue = url
            desVC.productImageStringValue = PRODUCT_IMAGE_URL+(Array(products[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!
            desVC.productNameString = self.products[indexPath.row].name!
            
            
            self.navigationController?.pushViewController(desVC, animated: true)
        }
    }
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == productsCollectionView{
            if self.pageNo < self.totalPages && (indexPath.row + 1) == self.pageNo*self.productPageSize{
                self.pageNo += 1
                self.GetProductByCategoryId(orderBy: self.orderBy, sortBy: self.sortBy)
            }
            
            
            if(indexPath.row ==  products.count-1){
                //Last cell was drawn
                self.endOfPage.isHidden = true
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

         if collectionView == self.productsCollectionView{

//            var cellSize: CGSize = collectionView.bounds.size
//            cellSize.width = ((productsCollectionView.frame.size.width/2) - 8)
//
//            if AppDelegate.isIPhone5W()
//            {
//                cellSize.height = cellSize.width * 2.3
//            }
//            else if AppDelegate.isIPhone6W()
//            {
//                cellSize.height = cellSize.width * 1.974522293
//            }
//            else if AppDelegate.isIPhone6PlusW()
//            {
//                cellSize.height = cellSize.width * 1.9
//            }
            var cellSize: CGSize = collectionView.bounds.size
            cellSize.width = ((productsCollectionView.frame.size.width/2) - 8)
            cellSize.height = (view.frame.size.width / 2)+70
            return cellSize
        }
        
        let CategoriesCollectionCellWidth = (view.frame.size.width-8) / 2
        let CategoriesCollectionViewLayout = CategoriesCollectionView.collectionViewLayout as!  UICollectionViewFlowLayout
        CategoriesCollectionViewLayout.itemSize = CGSize(width: CategoriesCollectionCellWidth, height: (CategoriesCollectionCellWidth/2)+10)
        
        return CGSize(width: CategoriesCollectionCellWidth, height: (CategoriesCollectionCellWidth/2)+10)
    }

    func GetCategories(pageSize:Int = 15,currentPage:Int = 1,fieldValue:Int = 2) {
        
        self.CategoriesCollectionView.isHidden = true
        
        celebritiesManager.GetCelebritiesRequest(ApiURL : baseManager.ApiPathBuilder(apiPath: "categories/list", orderBy: "DESC", pageSize: pageSize, currentPage: currentPage, sortBy: "", conditionType: "", field: "parent_id", fieldValue: fieldValue)){ (data, error) in
            
            if error == nil {
                
                var tempCategories: [Items] = []
                for item in (data?.items!)!{
                    if(item.is_active!){
                    if item.id != Constant_Brands_Id && item.id != Constant_Trending_Now_Id && item.id != Constant_Special_Collection_Id && item.id != Constant_Celebrities_Id{
                        tempCategories.append(item)
                    }
                }
                self.categories = CommonManager.shared.removeNullElement(items : tempCategories,attributeName : "thumbnail")
                self.CategoriesCollectionView.reloadData()
                self.CategoriesCollectionView.isHidden = false
                }}
            else{
                print(error!)
            }
        }
    }
    
    func GetProductByCategoryId(orderBy :String , sortBy : String){
        
        var categoryIdArray: [Int] = []
        if self.celebId != 0 {
            categoryIdArray.append(self.celebId)
        }
        
        if self.pageNo == 0{
            self.productsCollectionView.isHidden = true
        }
        else{
            self.productsPaginatingActivity.isHidden = false
        }
        
        self.productManager.GetProductsRequestByCategoryId(pageSize: self.productPageSize, catId: categoryIdArray, pageNo: self.pageNo, arithmaticOperator: "and", orderBy: orderBy, sortBy: sortBy, celebId:String(self.celebId)) {(dataFetched, error) in
            
            if error == nil{
                if(self.pageNo == 1){
                    self.totalPages = ((dataFetched?.total_count!)! + self.productPageSize - 1) / self.productPageSize
                }
                var productItems: [Items] = []
                productItems = CommonManager.shared.removeNullElement(items : (dataFetched?.items!)!,attributeName : "image")
                if productItems.count > 0 {
                    for item in productItems{
                        self.products.append(item)
                    }
                }
                CommonManager.shared.fetchFromCoreData(completion: { (data) in
                    self.cartItems = data
                    self.productsCollectionView.reloadData()
                    self.productsCollectionView.isHidden = false
                })
                
                self.productsCollectionView.isHidden = false
                self.productsPaginatingActivity.isHidden = true
            }
            else{
                
                self.productsCollectionView.isHidden = false
                self.productsPaginatingActivity.isHidden = true
                print(error!)
            }
        }
    }
}

extension MyBoutiquesViewController :AddToCartprotocol,AddOrRemoveFromWishListprotocol, ClickedCheckedprotocol, AddToCartPopupControllerDelegate {
    
    func checkOutAction() {
        
        self.navigationController?.tabBarController?.selectedIndex = 4
        let cartVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
    
    func clickAddToCheckedView(index: Int) {
        let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = mainStoryBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        desVC.celebID = String(self.celebId)
        if products[index].avg_rating_percent! > 0 {
            desVC.customRate = Double(((products[index].avg_rating_percent!*(5 - 1)) / 100)+1)
            
        }
        else {
            desVC.customRate = Double(0)
            
        }
        let url = URL(string:(PRODUCT_IMAGE_URL+(Array(products[index].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!))
        
        desVC.productItem = self.products[index]
        desVC.productImageValue = url
        desVC.productImageStringValue = PRODUCT_IMAGE_URL+(Array(products[index].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!
        desVC.productNameString = self.products[index].name!
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
    func clickAddToCartBtn(index: Int) {
        
        if ((Array(products[index].custom_attributes!).first(where: { $0.attribute_code! == "quantity" })?.value)!) == "0"
        {
            let notifyme = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotifyViewController") as! NotifyViewController
            
            notifyme.productId = String(products[index].id!)
            present(notifyme, animated: true)
            //return
        }
        else
        {
            let message = MDCSnackbarMessage()
            
            let url = PRODUCT_IMAGE_URL+(Array(products[index].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!
            
            CommonManager.shared.saveCartItem(id: products[index].id!, imageUrl: url, name: products[index].name!, price: products[index].price!, sku: products[index].sku, quote_id: products[index].quote_id, quantity: 0, celebId: String(self.celebId)) { (complete) in
                if complete {
                    
                    products[index].isAddedToCart = true
                    //                 self.CartItemsCollectionView.reloadData()
                    
                    let indexPath = IndexPath(row: index, section: 0)
                    
                    self.productsCollectionView.reloadItems(at: [indexPath])
                    
                    if self.currentLanguage == "en"{
                        message.text = "Item Added to Cart"
                    }
                    else{
                        message.text = "تمت الاضافة الى سلة المشتريات"
                    }
                    
                    let addTocart = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddToCartPopupController") as! AddToCartPopupController
                    addTocart.addToCartPopUpDelegate = self
                    present(addTocart, animated: true)
                    
                }else{
                    if self.currentLanguage == "en"{
                        message.text = "Error while adding to cart"
                    }
                    else{
                        message.text = "خطأ أثناء الإضافة إلى سلة التسوق"
                    }
                }
            }
            
        }

    }
    
    fileprivate  func DeleteWishListItem(itemId :String ){
        print("Delete Wish List Item: \(itemId)")
        wishManager.deleteWishList (wishlistItemId: itemId){ (wishListresponse, error) in
            
            if error == nil{
                //                self.GetWishList()
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
    
    fileprivate  func GetWishList(itemId : String , onCompleteion: @escaping (String) -> Void){
        print("Getting Products")
        var wishlistItemId = ""
        wishManager.fetchWishList { (wishListArray, error) in
            
            if wishListArray != nil{
                self.wishListArray = [WishListModel] ()
                for wish in wishListArray!{
                    self.wishListArray.append(wish)
                }
                if self.wishListArray.count>0 {
                    for wishlistItem in self.wishListArray{
                        if wishlistItem.product_id == itemId {
                            print("Item Matched: \(wishlistItem)")
                            wishlistItemId = wishlistItem.wishlist_item_id
                            onCompleteion(wishlistItemId)
                            //                            item.wishlistItemId = wishlistItem.wishlist_item_id
                        }
                    }
                }
            }
            else{
                print(error!)
            }
        }
        
    }
    
//    func clickAddOrRemoveWishBtn(index: Int) {
//
//        if  (UserDefaults.standard.string(forKey: "token") == nil) {
//            let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
//
//            self.present(loginViewController, animated: true)
//
//        }
//        if  (UserDefaults.standard.string(forKey: "token") != nil)  {
//            APIManager.shared.PostWishProduct(productId: String(products[index].id!)){(data) -> Void in
//                if data["hasError"] == false {
//                    //print(data)
//
//                    let message = MDCSnackbarMessage()
//                    message.text = "Add to wish list"
//
//                    MDCSnackbarManager.show(message)
//                }
//                else{
//                    //print(data)
//                }
//            }
//        }
//    }
    func clickAddOrRemoveWishBtn(index: Int) {
        if  (UserDefaults.standard.string(forKey: "token") == nil) {
            let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
            self.present(loginViewController, animated: true)
        }
        if  (UserDefaults.standard.string(forKey: "token") != nil && !self.products[index].isWish)  {
            APIManager.shared.PostWishProduct(productId: String(products[index].id!)){(data) -> Void in
                if data["hasError"] == false {
                    self.products[index].isWish = !self.products[index].isWish
                    let message = MDCSnackbarMessage()
                    if self.currentLanguage == "en"{
                        message.text = "Added to wish list"
                    }
                    else{
                        message.text = "أضيف لقائمة الأماني"
                    }
                    self.productsCollectionView.reloadData()
                   // MDCSnackbarManager.show(message)
                }
                else{
                }
            }
        }
        else{
            if  (UserDefaults.standard.string(forKey: "token") != nil && self.products[index].isWish)
            {
                self.DeleteWishListItem(itemId: products[index].wishlistItemId)
                self.products[index].isWish = !self.products[index].isWish
                self.productsCollectionView.reloadData()
                
//                if products[index].wishlistItemId == ""
//                {
//
//                    GetWishList(itemId: String(products[index].id!)) { (wishlistItemId) in
//                        if   wishlistItemId != ""{
//                            self.DeleteWishListItem(itemId: wishlistItemId)
//                            self.products[index].isWish = !self.products[index].isWish
//                            self.productsCollectionView.reloadData()
//
//                        }
//                    }
//                }else{
//                    DeleteWishListItem(itemId: products[index].wishlistItemId)
//                    self.products[index].isWish = !self.products[index].isWish
//                    self.productsCollectionView.reloadData()
//                }
                
            }
        }
    }

    //And finally you implement the methods you want your class to get.
    func scrollViewDidScroll(_ scrollView: UIScrollView!) {
        // This will be called every time the user scrolls the scroll view with their finger
        // so each time this is called, contentOffset should be different.
        
        
        //Additional workaround here.
    }
}


extension MyBoutiquesViewController: SJSegmentedViewControllerViewSource {
    
    func viewForSegmentControllerToObserveContentOffsetChange() -> UIView {
        
        return self.scrvMyBoutiques
    }
}
