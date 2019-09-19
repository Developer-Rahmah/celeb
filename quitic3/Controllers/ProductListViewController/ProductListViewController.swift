//
//  ProductListViewController.swift
//  quitic3
//
//  Created by DOT on 8/4/18.
//  Copyright Â© 2018 DOT. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialSnackbar
import Localize_Swift
import XLPagerTabStrip
import SJSegmentedScrollView
import SDWebImage


class ProductListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, IndicatorInfoProvider {
    
    var cartItems: [CartItem] = []
    
    var lastContentOffset: CGFloat = 0
    
    @IBOutlet weak var endOfPageAndicator: UIActivityIndicatorView!
    @IBOutlet weak var endOfPageLabel: UILabel!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    @IBOutlet weak var paginatingActivityIndicator: UIView!
    @IBOutlet weak var mainActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var filterBarView: UIView!
    @IBOutlet weak var filterPanelBtn: UIButton!
    @IBOutlet weak var pricePanelBtn: UIButton!
    
    weak var parentController : UIViewController?
    
    @objc func setText() {
        
        print("Product List Set Text")
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
        if self.currentLanguage == "en"{
//            btnCancellbl.title = "Cancel"
            print("Product List Set Text EN")
            pricePanelBtn.setTitle("", for: .normal)
            self.filterPanelBtn.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
            
//            self.navigationItem.title = "Shop"
//            self.title = "Shop"
        }
        else{
//            btnCancellbl.title = "إلغاء"
            print("Product List Set Text AR")
            pricePanelBtn.setTitle("", for: .normal)
            
            self.filterPanelBtn.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            
//            self.navigationItem.title = "Shop"
//            self.title = "متجر"
        }
    }
    
    var products: [Items] = []
    var wishListArray = [WishListModel] ()
    var subCategories  = SubCategories()
    var categoryId = 0
    var productPageSize = 10
    var totalPages = 1
    var pageNo = 1
    var sortBy = "created_at"
    var orderBy = "DESC"
    var lowerPrice: Int = -1
    var greaterPrice: Int = -1
    var currentLanguage = ""
    var categoryIdArray: [Int] = []
    var setTitle: String = ""
    var celebId:String = ""
    var lblHeader = UILabel()
    var viewNavCenter = UIView()
    var isBoolViewHeader:Bool = false
    
    let manager = ProductsManager()
    let wishManager = WishListManager()
    
    @objc func loginStatus(){
        print("is change loginStatus")
        products = [Items]()
        self.GetProductByCategoryId(orderBy: self.orderBy, sortBy: self.sortBy)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem()
        
        backButton.title = "" //in your case it will be empty or you can put the title of your choice
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.setText()
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(loginStatus), name: NSNotification.Name("NotifyLoginStatus"), object: nil)
        
        if self.currentLanguage == "en"{
            self.filterPanelBtn.setTitle("Newest", for: .normal)
             self.endOfPageLabel.font = UIFont.init(name: enLanguageConstant, size: 17)

            self.endOfPageLabel.text = "You recached at end of the product list."

        }
        else{
            self.filterPanelBtn.setTitle("أحدث", for: .normal)
            self.endOfPageLabel.text = "لقد وصلت الى نهاية الصفحة."
            self.endOfPageLabel.font = UIFont.init(name: arLanguageConstant, size: 17)

        }
        
        self.filterBarView.isHidden = false
        
        self.mainActivityIndicator.isHidden = true
//        self.paginatingActivityIndicator.isHidden = true
        
        self.endOfPageAndicator.isHidden = true
        self.endOfPageLabel.isHidden = true
        
        self.productsCollectionView.delegate = self
        self.productsCollectionView.dataSource = self
        
       // let ProductsCollectionCellWidth = (view.frame.size.width-16-20) / 2
        let ProductsCollectionViewLayout = productsCollectionView.collectionViewLayout as!  UICollectionViewFlowLayout
        
        if AppDelegate.isIPhone5W()
        {
           ProductsCollectionViewLayout.itemSize = CGSize(width: 140, height: 254)
        }
        else if AppDelegate.isIPhone6W()
        {
           ProductsCollectionViewLayout.itemSize = CGSize(width: 165.0, height: 254)
        }
        else if AppDelegate.isIPhone6PlusW()
        {
            ProductsCollectionViewLayout.itemSize = CGSize(width: 180.0, height: 254)
        }
        else
        {
            ProductsCollectionViewLayout.itemSize = CGSize(width: 200.0, height: 254)
        }
        
//        self.wishManager.fetchWishList {
//            (wishListArray, error) in
//
//            if wishListArray != nil {
//
//                self.wishListArray = [WishListModel] ()
//
//                for wish in wishListArray!{
//
//                    self.wishListArray.append(wish)
//                }
//            }
//            else{
//
//                print(error!)
//            }
//        }
//
        self.GetProductByCategoryId(orderBy: self.orderBy, sortBy: self.sortBy)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        if isBoolViewHeader == true
        {
            viewNavCenter = UIView(frame: CGRect(x: 0, y: -13, width:  (self.navigationController?.navigationBar.frame.size.width)!, height: 20))
            viewNavCenter.backgroundColor = UIColor.white
            self.navigationController?.navigationBar.addSubview(viewNavCenter)
            
            lblHeader = UILabel.init(frame:  CGRect(x: 30, y: -11, width: viewNavCenter.frame.size.width - 60, height: 50))
            
            lblHeader.text = setTitle
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
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        if isBoolViewHeader == true
        {
            viewNavCenter.removeFromSuperview()
            lblHeader.removeFromSuperview()
        }
    }
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo(title: self.setTitle)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.products.count
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productListCell", for: indexPath) as! CartItemCollectionViewCell
        
        //        cell.imageView.image = UIImage(named: "perfume")
//        let maxSize = CGSize(width: 83, height: 40)
//        let size =  cell.lblOutOfStock.sizeThatFits(maxSize)
//        cell.lblOutOfStock.frame = CGRect(origin: CGPoint(x: 70, y: 20), size: size)
//        cell.lblOutOfStock.sizeToFit()

        cell.lblOutOfStock.text = ""
        cell.reviews.text = ""

        cell.lblOutOfStock.isHidden = true
          cell.reviews.isHidden = true
        cell.label.text = self.products[indexPath.item].name
        cell.price.text = "\(String(describing: self.products[indexPath.item].price!)) JOD"
        cell.viewOuterBorder.layer.borderColor = UIColor.quiticPink.cgColor
        cell.viewOuterBorder.layer.borderWidth = 1.0
        
        cell.productCount.isHidden = true
        
        //Disable section start
        for cartItem in cartItems
        {
            if cartItem.id == products[indexPath.row].id!
            {
                print("deselect at \(cartItem.id) == \(products[indexPath.row].id!)")
                products[indexPath.row].isAddedToCart = true
            }
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
                cell.lblOutOfStock.isHidden = true;
                cell.reviews.isHidden = false

//                cell.lblOutOfStock.text = "OUT OF STOCK"
                            cell.reviews.text = "Sold Out"

                cell.addToCartBtn.setTitle("Notify Me", for: .normal)
            }
            else
            {
                
                cell.lblOutOfStock.isHidden = true;
                cell.reviews.isHidden = false

                cell.reviews.text = "إنتهى من المخزن"
                cell.addToCartBtn.setTitle("اعلمني", for: .normal)
            }
        }
        
        //check for only celebrity view product count.
        if let viewControllers = self.navigationController?.viewControllers {
            for vc in viewControllers {
                if vc.isKind(of: CelebContainerViewController.classForCoder()) {
                   
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
                    
                }
            }
        }

//        //add product avalilable count
//        cell.productCount.text = Array(self.products[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "quantity" })?.value
        
        if currentLanguage == "en"{
            cell.label.textAlignment = .left
            
            cell.label.font = UIFont(name: enLanguageConstant, size: 13)!
            cell.price.font = UIFont(name: enLanguageConstant, size: 13)!
            cell.reviews.font = UIFont(name: enLanguageConstant, size: 10)!
            cell.addToCartBtn.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
            cell.reviews.text = "SOLD OUT"
//                        cell.reviews.text = "\(products[indexPath.row].reviews!) SOLD OUT"
//cell.lblBrandName.font = UIFont(name: enLanguageConstant, size: 15)!
            cell.imgNewTag.image = UIImage(named:"newTag")
        }
        else{
            cell.label.textAlignment = .right
            
            cell.label.font = UIFont(name: arLanguageConstant, size: 13)!
//            cell.price.font = UIFont(name: arLanguageConstant, size: 13)!
            cell.price.font = UIFont(name: enLanguageConstant, size: 13)!

            cell.reviews.font = UIFont(name: arLanguageConstant, size: 10)!
            cell.addToCartBtn.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            cell.reviews.text = "نفذت"
            cell.imgNewTag.image = UIImage(named:"newTagAr")
        }
        
        for cartItem in cartItems {
            if cartItem.id == products[indexPath.row].id!
            {
                print("deselect at \(cartItem.id) == \(products[indexPath.row].id!)")
                products[indexPath.row].isAddedToCart = true
            }
        }
        
//        let url = URL(string:(PRODUCT_IMAGE_URL+(Array(products[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!))
//        
//        cell.imageView.af_setImage(withURL: url!, placeholderImage: UIImage(named: "ImagePlaceholder"), filter:nil, imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: true, completion: nil)
        
//
//        BaseManager.Manager.request(PRODUCT_IMAGE_URL+(Array(products[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!).responseImage { response in
//            if let image = response.result.value {
//                cell.imageView.image = image
//            }
//            else{
//                cell.imageView.image = UIImage(named: "ImagePlaceholder")
//            }
//        }
        
        //sdImageView Changes.
        let url = URL(string:(PRODUCT_IMAGE_URL+(Array(products[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!))
//        cell.imageView.af_setImage(withURL: url!, placeholderImage: UIImage(named: "ImagePlaceholder"), filter:nil, imageTransition: .noTransition, runImageTransitionIfCached: true, completion: nil)
        
        cell.imageView!.sd_setImage(with: url, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
        
//        cell.reviews = self.products[indexPath.item].reviews
        
        if self.products[indexPath.item].avg_rating_percent! > 0 {
       
//            cell.ratingcosmos.rating = Double((self.products[indexPath.item].avg_rating_percent!*5) / 100)
         cell.ratingcosmos.rating = Double(((self.products[indexPath.item].avg_rating_percent!*(5 - 1)) / 100)+1)
        }
        else {
            cell.ratingcosmos.rating = Double(0)
        }
        
        cell.wishButton.setImage(UIImage(named: "heartEmpty"), for: .normal)
        
        if self.products[indexPath.item].isWish
        {
            cell.wishButton.setImage(UIImage(named: "favor"), for: .normal)
        }
        else
        {
            cell.wishButton.setImage(UIImage(named: "heartEmpty"), for: .normal)
        }
        
//        let myColor = UIColor.quiticPink
//        cell.imageSectionView.layer.borderWidth = 0.5
//        cell.imageSectionView.layer.borderColor = myColor.cgColor
        
        cell.cellDelegate = self
        cell.cellCartDelegate = self
        cell.cellCheckedBtnDelegate = self
        cell.index = indexPath
        
        
        
        //set brand name into product list screen. 18/06/2019
        if (products[indexPath.row].custom_attributes != nil)
        {
            for custom_attribute in products[indexPath.row].custom_attributes!
            {
                if custom_attribute.attribute_code == "brands"
                {
                    cell.lblBrandName.text = custom_attribute.value
                }
//                else if custom_attribute.attribute_code == "is_wishlist"
//                {
//                    if custom_attribute.value == "1"
//                    {
//                       cell.wishButton.setImage(UIImage(named: "favor"), for: .normal)
//                    }
//                    else
//                    {
//                        cell.wishButton.setImage(UIImage(named: "heartEmpty"), for: .normal)
//                    }
//                }
            }
        }

        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       
       
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        print("cell: \(indexPath.row)")
        if self.pageNo < self.totalPages && (indexPath.row + 1) == self.pageNo*self.productPageSize{
            self.pageNo += 1
            self.GetProductByCategoryId(orderBy: self.orderBy, sortBy: self.sortBy)
        }else  if (self.pageNo == self.totalPages){
//            let alert = UIAlertController(title: "Alert", message: "You recached at end of the product list.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                switch action.style{
//                case .default:
//                    print("default")
//                    
//                case .cancel:
//                    print("cancel")
//                    
//                case .destructive:
//                    print("destructive")
//                    
//                    
//                }}))
//            self.present(alert, animated: true, completion: nil)
            if(indexPath.row ==  products.count-1){
                //Last cell was drawn
                self.endOfPageLabel.isHidden = false

            }

        }
//        if (indexPath.row == self.products.count - 1 ) { //it's your last cell
//            //Load more data & reload your collection view
//
//        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        var cellSize: CGSize = collectionView.bounds.size
//        cellSize.width = ((productsCollectionView.frame.size.width/2) - 8)
//
//        if AppDelegate.isIPhone5W()
//        {
//            cellSize.height = cellSize.width * 2.3
//        }
//        else if AppDelegate.isIPhone6W()
//        {
//             cellSize.height = cellSize.width * 1.974522293
//        }
//        else if AppDelegate.isIPhone6PlusW()
//        {
//             cellSize.height = cellSize.width * 1.9
//        }
//
        var cellSize: CGSize = collectionView.bounds.size
               cellSize.width = ((productsCollectionView.frame.size.width/2) - 8)
         cellSize.height = 300
        
//        let width = view.frame.size.width / 2
//        return CGSize(width: width , height: width+50)
        
        
       return cellSize
    }
    
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        print("scroll:", scrollView.panGestureRecognizer.translation(in: scrollView).y)
        
//        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0{
//            self.filterBarView.isHidden = true
//        }
//        else{
//            self.filterBarView.isHidden = false
//        }
//
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset < scrollView.contentOffset.y) {
            self.filterBarView.isHidden = true
        } else if (self.lastContentOffset > scrollView.contentOffset.y) {
            self.filterBarView.isHidden = false
            self.endOfPageLabel.isHidden = true

        } else {
            self.filterBarView.isHidden = false
            self.endOfPageLabel.isHidden = true

        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.filterBarView.isHidden = false
    }
    
    @IBAction func filterPanelAppearToogle(_ sender: Any) {
        
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
        let filterPopup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "filterPanelViewController") as! filterPanelViewController
        
        filterPopup.selectedFilter = { (data) in
            if data == "created_at"
            {
                self.orderBy = "DESC"
                self.sortBy = "created_at"
                if self.currentLanguage == "en"{
                    self.filterPanelBtn.setTitle("Newest", for: .normal)
//                    lblHeader.font = UIFont.init(name: enMarselLanguageConstant, size: 23)

                    self.endOfPageLabel.text = "You recached at end of the product list."
                    
                }
                else{
                    self.filterPanelBtn.setTitle("أحدث", for: .normal)
                    self.endOfPageLabel.text = "لقد وصلت الى نهاية الصفحة."

              }
            }
            
            
            
            if data == "ASC"
            {
                self.orderBy = "ASC"
                self.sortBy = "name"
                if self.currentLanguage == "en"{
                    self.filterPanelBtn.setTitle("A-Z", for: .normal)
               }
                else{
                    
                    self.filterPanelBtn.setTitle("ا-ئ", for: .normal)
                }
            }
            
            if data == "DESC"
            {
                self.orderBy = "DESC"
                self.sortBy = "name"
                if self.currentLanguage == "en"{
                   self.filterPanelBtn.setTitle("Z-A", for: .normal)
                }
                else{
                    self.filterPanelBtn.setTitle("ئ-ا", for: .normal)
                }
            }
            if data == "PriceHtoL"
            {
                self.orderBy = "DESC"
                self.sortBy = "price"
                if self.currentLanguage == "en"{
                    self.filterPanelBtn.setTitle("Price : High - Low", for: .normal)
                }
                else{
                    self.filterPanelBtn.setTitle("السعر: مرتفع - منخفض", for: .normal)
                }
            }
            
            if data == "PriceLtoH"
            {
                self.orderBy = "ASC"
                self.sortBy = "price"
                if self.currentLanguage == "en"{
                    self.filterPanelBtn.setTitle("Price : Low - High", for: .normal)
                }
                else{
                    
                    self.filterPanelBtn.setTitle("السعر: منخفض - مرتفع", for: .normal)
                }
            }
            
            if data != ""{
                self.pageNo = 1
                self.products = []
                self.GetProductByCategoryId(orderBy: self.orderBy, sortBy: self.sortBy)
            }
            
        }

        present(filterPopup, animated: true)
    }
    
    
    
    @IBAction func pricePanelAppearToggle(_ sender: Any) {
        let priceFilterViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "priceFilterViewController") as! priceFilterViewController
        
        if self.lowerPrice != -1 {
            priceFilterViewController.setLowerValue = self.lowerPrice
        }
        
        if self.greaterPrice != -1{
            priceFilterViewController.setUpperValue = self.greaterPrice
        }
        
        priceFilterViewController.selectedPriceRange = { (lowerBound, upperBound) in
            self.lowerPrice = lowerBound
            self.greaterPrice = upperBound
            
            self.pageNo = 1
            self.products = []
            self.GetProductByCategoryId(orderBy: self.orderBy, sortBy: self.sortBy)
        }
        
        present(priceFilterViewController, animated: true)
    }
    
    func GetProductByCategoryId(orderBy:String,sortBy:String){
        
    
        if(pageNo == 1) {
            
            self.mainActivityIndicator.isHidden = false
        }
        else {
            
//            self.paginatingActivityIndicator.isHidden = false
            self.endOfPageAndicator.isHidden = false
        }
      
        //get last object from array.
        var tempCategoryIdArray: [Int] = []
        
        manager.GetProductsRequestByCategoryId(pageSize: self.productPageSize, catId: self.categoryIdArray, pageNo: self.pageNo, arithmaticOperator: "and", orderBy: orderBy, sortBy: sortBy, lowerPrice: self.lowerPrice, upperPrice: self.greaterPrice, celebId:celebId) {(subCategories, error) in
            
            if error == nil {
                
                if(self.pageNo == 1) {
                    
                    self.totalPages = ((subCategories?.total_count!)! + self.productPageSize - 1) / self.productPageSize
                }
                
                var productItems: [Items] = []
                
                productItems = CommonManager.shared.removeNullElement(items : (subCategories?.items)!,attributeName : "image")

                if productItems.count > 0
                {
                    for item in productItems
                    {
                        if(item.is_active!){
                        self.products.append(item)

                    }}
                }
                
                if self.currentLanguage == "en" {
                    
                    CommonManager.shared.noDataMessageCollectionView(collection: self.productsCollectionView, message: "No Records Found", list: self.products)
                }
                else{
                    CommonManager.shared.noDataMessageCollectionView(collection: self.productsCollectionView, message: "لا توجد سجلات", list: self.products)
                }
                
                CommonManager.shared.fetchFromCoreData(completion: { (data) in
                    self.cartItems = data
                    print("status cart: \(self.cartItems)")
                    self.productsCollectionView.reloadData()
                    self.productsCollectionView.isHidden = false
                })
                
                DispatchQueue.main.async {
                    
                    self.mainActivityIndicator.isHidden = true
//                    self.paginatingActivityIndicator.isHidden = true
                    self.endOfPageAndicator.isHidden = true
                }
            }
            else {
                
                DispatchQueue.main.async {
                    
                    self.mainActivityIndicator.isHidden = true
//                    self.paginatingActivityIndicator.isHidden = true
                    self.endOfPageAndicator.isHidden = true
                }
                
                print(error!)
            }
        }
    }
    
}


extension ProductListViewController :AddToCartprotocol,AddOrRemoveFromWishListprotocol, ClickedCheckedprotocol, AddToCartPopupControllerDelegate {
    
    func checkOutAction() {
        
        self.navigationController?.tabBarController?.selectedIndex = 4
        let cartVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
    
    func clickAddToCheckedView(index: Int) {
        let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = mainStoryBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
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
           // return
        }
        else
        {
            let message = MDCSnackbarMessage()
            
            let url = PRODUCT_IMAGE_URL+(Array(self.products[index].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!
            
            
            CommonManager.shared.saveCartItem(id: self.products[index].id!, imageUrl: url, name: self.products[index].name!, price: self.products[index].price!, sku: self.products[index].sku, quote_id: self.products[index].quote_id, quantity: 0, celebId: self.celebId) { (complete) in
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
                        message.text = "حدث خطأ أثناء الإضافة إلى العربة"
                    }
                    
                }
            }
        }
        
    }
    fileprivate  func DeleteWishListItem(itemId :String ){
        print("Delete Wish List Item: \(itemId)")
        wishManager.deleteWishList (wishlistItemId: itemId){ (wishListresponse, error) in
            
            if error == nil
            {
                //                self.GetWishList()
//                let message = MDCSnackbarMessage()
//                if self.currentLanguage == "en"{
//                    message.text = "Item removed successfully"
//                }
//                else{
//                    message.text = "تمت إزالة العنصر بنجاح"
//                }
//                MDCSnackbarManager.show(message)
            }
            else
            {
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
    func clickAddOrRemoveWishBtn(index: Int) {
        if  (UserDefaults.standard.string(forKey: "token") == nil) {
            let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
            self.present(loginViewController, animated: true)
        }
        
        if  (UserDefaults.standard.string(forKey: "token") != nil && !self.products[index].isWish)
        {
            APIManager.shared.PostWishProduct(productId: String(products[index].id!)){(data) -> Void in
                if data["hasError"] == false
                {
                    self.products[index].isWish = !self.products[index].isWish
                    let message = MDCSnackbarMessage()
                    message.text = ""
                    
                    if self.currentLanguage == "en"
                    {
                        message.text = "Add to wish list"
                    }
                    else
                    {
                        message.text = "أضف إلى قائمة الامنيات"
                    }
                    
                   self.productsCollectionView.reloadData()
                   // MDCSnackbarManager.show(message)
                }
                else
                {
                    
                }
            }
        }
        else{
            if  (UserDefaults.standard.string(forKey: "token") != nil && self.products[index].isWish)
            {
                DeleteWishListItem(itemId: products[index].wishlistItemId)
                self.products[index].isWish = !self.products[index].isWish
                self.productsCollectionView.reloadData()
                
//                if products[index].wishlistItemId == ""
//                {
//                    GetWishList(itemId: String(products[index].id!))
//                    { (wishlistItemId) in
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
//                   self.productsCollectionView.reloadData()
//                }
                
            }
        }
    }
}

extension ProductListViewController: SJSegmentedViewControllerViewSource {
    
    func viewForSegmentControllerToObserveContentOffsetChange() -> UIView {
        
        return productsCollectionView
    }
}


