//
//  ProductDetailsViewController.swift
//  quitic3
//
//  Created by DOT on 7/20/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import WebKit
import Localize_Swift
import ANLoader
import SDWebImage

import MaterialComponents.MaterialSnackbar

class ProductDetailsViewController: UIViewController, WKNavigationDelegate, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    var productImageValue: URL?
    var productImageStringValue : String = ""
    var productNameString: String = ""
    var productItem = Items() ;
    var productPrice: String = ""
    var currentLanguage = ""
    var sortBy = "created_at"
    var orderBy = "DESC"
    var productsArray:[Items] = [Items]()
    let productsManager = ProductsManager()
    let wishManager = WishListManager()
    var cartItems: [CartItem] = []
    var productId: Int = -1
    var wishListArray  = [WishListModel] ()
    var brandsArray = [BrandCore]()
    //var selectedBrand : BrandCore? = nil
    var celebID:String = ""
    var selectedBrandID:String = ""
    var selectedBrandName:String = ""
    var selectedBrandImgURL:String = ""
    var mediaGallery:[media_gallery_entries] = []
    var productDetail  = ProductDetail()
    
    @IBOutlet weak var lblSpecification: UILabel!
    @IBOutlet weak var sku: UILabel!
    @IBOutlet weak var lblSku: UILabel!
    
    @IBOutlet weak var pcProductImages: UIPageControl!
    @IBOutlet weak var clvProductImages: UICollectionView!
    @IBOutlet weak var btnAddToCart: UIButton!
    @IBOutlet weak var btnAddToWishList: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var descriptionWebViewHeight: NSLayoutConstraint!
    @IBOutlet weak var youMayAlsoLikeLabel: UILabel!
    @IBOutlet weak var descriptionWebView: WKWebView!
    @IBOutlet weak var lblBrand: UILabel!
    @IBOutlet weak var brandSectionView: UIView!
    @IBOutlet weak var brandLabelSectionView: UIView!
    @IBOutlet weak var lblOutOfStock: UILabel!
    @IBOutlet weak var ratingStar: CosmosView!
    @IBOutlet weak var productCollectionUIViewHeight: NSLayoutConstraint!
    @IBOutlet weak var productsCollection: UICollectionView!
    
    
    var customRate:Double = 0
    var tapGesture = UITapGestureRecognizer()
    var lblHeader = UILabel()
    let labels = AppLabels()
    var viewNavCenter = UIView()
    
//    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
//        self.descriptionWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, -30, 0)
//    }
    
    @IBAction func funAddToCart(_ sender: Any) {
        
        if ((Array(productDetail.custom_attributes!).first(where: { $0.attribute_code! == "quantity" })?.value)!) == "0"
        {
            return
        }
        
        let message = MDCSnackbarMessage()
        
        let url = PRODUCT_IMAGE_URL+(Array((productDetail).custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!
        
        
        CommonManager.shared.saveCartItem(id: (productDetail ).id!, imageUrl: url, name: (productDetail ).name!, price: (productDetail ).price!, sku: (productDetail ).sku, quote_id: (productDetail ).quote_id, quantity: 0, celebId: self.celebID) { (complete) in
            if complete {
                
                if self.currentLanguage == "en"{
                    message.text = "Item Added to Cart"
                    btnAddToCart.setTitle("Added To Cart", for: .normal)
                    btnAddToCart.isEnabled = false
                }
                else{
                    message.text = "تمت الاضافة الى سلة المشتريات"
                    btnAddToCart.setTitle("تمت الاضافة", for: .normal)
                    btnAddToCart.isEnabled = false
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
        
        //MDCSnackbarManager.show(message)
    }
    
    @IBAction func funAddToWishList(_ sender: Any)
    {
        if  (UserDefaults.standard.string(forKey: "token") == nil) {
            let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
            self.present(loginViewController, animated: true)
        }
        if  (UserDefaults.standard.string(forKey: "token") != nil)
        {
            print("self.productDetail.isWish: \(self.productDetail.isWish)")
            if self.productDetail.isWish
            {
                DeleteWishListItem(itemId: productDetail.wishlistItemId)
            }
            else
            {
                APIManager.shared.PostWishProduct(productId: String(productDetail.id!)){(data) -> Void in
                    if data["hasError"] == false
                    {
                        self.productDetail.isWish = true
                        let message = MDCSnackbarMessage()
                        if self.currentLanguage == "en"{
                            message.text = "Added to wish list"
                            self.btnAddToWishList.setTitle("Added", for: .normal)
                            self.btnAddToWishList.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)
                        }
                        else{
                            message.text = "أضيف لقائمة الأماني"
                            self.btnAddToWishList.setTitle("تمت الاضافة", for: .normal)
                            self.btnAddToWishList.titleLabel?.font = UIFont(name: arLanguageConstant, size: 20)
                        }
                        // MDCSnackbarManager.show(message)
                    }
                }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if self.currentLanguage == "en"{
//
//            lblBrand.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        }
//        else{
//            lblBrand.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
//
//        }
        viewNavCenter = UIView(frame: CGRect(x: 0, y:-13, width:  (self.navigationController?.navigationBar.frame.size.width)!, height: 20))
        viewNavCenter.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.addSubview(viewNavCenter)


        lblHeader = UILabel.init(frame:  CGRect(x: 50, y: -7, width: self.view.frame.width - 100, height: 50))
        
        //lblHeader.font = UIFont.init(name: headerFont, size: 30)
        lblHeader.textAlignment = .center
        lblHeader.textColor = UIColor.init(red: 251, green: 96, blue: 127)
        
        if self.currentLanguage == "en"
        {
            lblHeader.text = "Product Details"
            lblHeader.font = UIFont.init(name: enMarselLanguageConstant, size: 23)
        }
        else
        {
            lblHeader.text = "وصف المنتج"
            lblHeader.font = UIFont.init(name: arLanguageConstant, size: 23)
        }
        
        
        self.navigationController?.navigationBar.addSubview(lblHeader)
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        lblHeader.removeFromSuperview()
        viewNavCenter.removeFromSuperview()
    }

    
    @objc func moveToShop(sender:UITapGestureRecognizer) {
        
        print("tap working \(self.selectedBrandID)")
        if self.selectedBrandID != nil
        {
            let ProductListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
            var tempIds: [Int] = []
            ProductListViewController.title = self.selectedBrandName
            ProductListViewController.setTitle = self.selectedBrandName
            
            
            ProductListViewController.categoryId = Int((self.selectedBrandID))!
            
            tempIds.append(Int((self.selectedBrandID))!)
            ProductListViewController.categoryIdArray = tempIds
            
            self.navigationController?.pushViewController(ProductListViewController, animated: true)
        }
       
    }
    @objc func setText(){
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
        
        if self.currentLanguage == "en"{
            


           // self.title = "Product Details"
            
            self.brandName.font = UIFont(name: enMarselLanguageConstant, size: 17)
            self.productName.font = UIFont(name: enMarselLanguageConstant, size: 17)
               self.sku.font = UIFont(name: enMarselLanguageConstant, size: 17)
               self.lblSku.font = UIFont(name: enBoldLanguageConstant, size: 17)
            self.lblPrice.font = UIFont(name: enBoldLanguageConstant, size: 20)
            
            lblBrand.text = "Brand"
            lblBrand.font = UIFont(name: enMarselLanguageConstant, size: 17)
            
            self.productName.textAlignment = .left
            self.lblBrand.textAlignment = .left
            self.brandName.textAlignment = .left

            lblDescription.text = "Description"
            lblDescription.font = UIFont(name: enMarselLanguageConstant, size: 20)
            lblSpecification.text = "Specifications"
            lblSpecification.font = UIFont(name: enMarselLanguageConstant, size: 20)
            for cartItem in cartItems {
                if cartItem.id == (productDetail).id!
                {
                    productDetail.isAddedToCart = true;
                }
            }
            
            if productDetail.isWish{
                if self.currentLanguage == "en"{
                    btnAddToWishList.setTitle("Added", for: .normal)
                    btnAddToWishList.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)
                }
                else{
                    btnAddToWishList.setTitle("تمت الاضافة ", for: .normal)
                    btnAddToWishList.titleLabel?.font = UIFont(name: arLanguageConstant, size: 20)
                }
            }
            else{
                if self.currentLanguage == "en"{
                    btnAddToWishList.setTitle("Add To WishList", for: .normal)
                    btnAddToWishList.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)
                }
                else{
                    btnAddToWishList.setTitle("أضف إلى قائمة الامنيات", for: .normal)
                    btnAddToWishList.titleLabel?.font = UIFont(name: arLanguageConstant, size: 20)
                }
            }
            
//            if productDetail.isAddedToCart
//            {
//                if self.currentLanguage == "en"
//                {
//                    btnAddToCart.setTitle("Added To Cart", for: .normal)
//                    btnAddToCart.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)
//                }
//                else
//                {
//                    btnAddToCart.setTitle("مضافا إلى السلة", for: .normal)
//                    btnAddToCart.titleLabel?.font = UIFont(name: arLanguageConstant, size: 20)
//                }
//
//                btnAddToCart.isEnabled = false
//            }
//            else if ((Array(productDetail.custom_attributes!).first(where: { $0.attribute_code! == "quantity" })?.value)!) == "0"
//            {
//                 btnAddToCart.backgroundColor = UIColor.black
//
//                if self.currentLanguage == "en"
//                {
//                    lblOutOfStock.text = "OUT OF STOCK"
//                    btnAddToCart.setTitle("Notify Me", for: .normal)
//                }
//                else
//                {
//                    lblOutOfStock.text = "إنتهى من المخزن"
//                    btnAddToCart.setTitle("اعلمني", for: .normal)
//                }
//            }
//            else
//            {
//                if self.currentLanguage == "en"
//                {
//                    btnAddToCart.setTitle("Add To Cart", for: .normal)
//                    btnAddToCart.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)
//                }
//                else
//                {
//                    btnAddToCart.setTitle("أضف إلى السلة", for: .normal)
//                    btnAddToCart.titleLabel?.font = UIFont(name: arLanguageConstant, size: 20)
//                }
//            }

            
            self.youMayAlsoLikeLabel.text = "You May Also Like This"
            youMayAlsoLikeLabel.font = UIFont(name: enLanguageConstant, size: 21)
//            sku.font = UIFont(name: enLanguageConstant, size: 17)
//             lblSku.font = UIFont(name: enLanguageConstant, size: 17)
            
            self.youMayAlsoLikeLabel.textAlignment = .left
            
            let borderRight = CALayer()
            borderRight.backgroundColor = UIColor.productBorderColor.cgColor
            borderRight.frame = CGRect(x: self.brandLabelSectionView.frame.size.width - 2, y:  0, width: 2, height: self.brandLabelSectionView.frame.size.height)
            self.brandLabelSectionView.layer.addSublayer(borderRight)
        }
        else
        {
//            lblBrand.frame = CGRect(x: 0, y: 0, width: 100, height: 23)

            
            var message: String = ""

            //set the text and style if any.
            lblBrand.text = message
            lblBrand.numberOfLines = 0
//            var maximumLabelSize: CGSize = CGSize(width: 280, height: 9999)
//            var expectedLabelSize: CGSize = lblBrand.sizeThatFits(maximumLabelSize)
//            // create a frame that is filled with the UILabel frame data
//            var newFrame: CGRect = lblBrand.frame
//            // resizing the frame to calculated size
//            newFrame.size.height = expectedLabelSize.height
//            // put calculated frame into UILabel frame
//            lblBrand.frame = newFrame
            
            
           // self.title = "تفاصيل المنتج"
            self.productName.textAlignment = .right
            self.lblBrand.textAlignment = .right
            self.brandName.textAlignment = .right
            
            self.youMayAlsoLikeLabel.textAlignment = .right
            //self.youMayAlsoLikeLabel.text = "قد يعجبك هذا أيضًا"
            
            self.youMayAlsoLikeLabel.text = "ربما يعجبك أيضاً"
            self.youMayAlsoLikeLabel.font = UIFont(name: arLanguageConstant, size: 17)
            self.brandName.font = UIFont(name: arLanguageConstant, size: 17)
            self.productName.font = UIFont(name: arLanguageConstant, size: 17)
//            self.lblPrice.font = UIFont(name: arLanguageConstant, size: 20)
            self.lblPrice.font = UIFont(name: enBoldLanguageConstant, size: 20)

            lblBrand.text = "علامة تجارية"
            lblBrand.font = UIFont(name: arLanguageConstant, size: 17)
            
            lblDescription.text = "الوصف"
            lblDescription.font = UIFont(name: arLanguageConstant, size: 20)
            lblSpecification.text = "مواصفات"
            lblSpecification.font = UIFont(name: arLanguageConstant, size: 20)
            btnAddToCart.setTitle("أضف إلى السلة", for: .normal)
            btnAddToCart.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)
            
            btnAddToWishList.setTitle("أضف إلى قائمة الامنيات", for: .normal)
            btnAddToWishList.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)

            let borderLeft = CALayer()
            borderLeft.backgroundColor = UIColor.productBorderColor.cgColor
            borderLeft.frame = CGRect(x: 0, y:  0, width: 2, height: self.brandLabelSectionView.frame.size.height)
            self.brandLabelSectionView.layer.addSublayer(borderLeft)
        }
        self.GetProducts(orderBy: self.orderBy, sortBy: self.sortBy)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        var maximumLabelSize: CGSize = CGSize(width: 100, height: 9999)
//        var expectedLabelSize: CGSize = lblBrand.sizeThatFits(maximumLabelSize)
//        // create a frame that is filled with the UILabel frame data
//        var newFrame: CGRect = lblBrand.frame
//        // resizing the frame to calculated size
//        newFrame.size.height = expectedLabelSize.height
//        // put calculated frame into UILabel frame
//        lblBrand.frame = newFrame
//        let tap = UITapGestureRecognizer(target: self, action: #selector(moveToShop))
//        brandName.isUserInteractionEnabled = true
//        brandName.addGestureRecognizer(tap)
//
        
//        self.descriptionWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never;
//self.automaticallyAdjustsScrollViewInsets = false
//
        
//        self.descriptionWebView!.frame = CGRect(x: 0 - 8, y: 0 - 8, width: self.view.bounds.size.width + 14, height: self.view.bounds.size.height + 14)
//
//       self.descriptionWebView!.scrollView.frame = CGRect(x: 0 - 8, y: 0 - 8, width: self.view.bounds.size.width + 14, height: self.view.bounds.size.height + 14)
        
        let backButton = UIBarButtonItem()
        backButton.title = "" //in your case it will be empty or you can put the title of your choice
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        
        let borderBottom = CALayer()
        borderBottom.backgroundColor = UIColor.productBorderColor.cgColor
        borderBottom.frame = CGRect(x: 0, y:  self.brandSectionView.frame.size.height - 2, width: self.view.frame.width, height: 2)
        self.brandSectionView.layer.addSublayer(borderBottom)
        
        let borderTop = CALayer()
        borderTop.backgroundColor = UIColor.productBorderColor.cgColor
        borderTop.frame = CGRect(x: 0, y:  0, width: self.view.frame.width, height: 2)
        self.brandSectionView.layer.addSublayer(borderTop)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        ratingStar.addGestureRecognizer(tapGesture)
        ratingStar.isUserInteractionEnabled = true
        
        self.ratingStar.rating = self.customRate
        
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        descriptionWebView.navigationDelegate = self
        
//        if self.productId == -1
//        {
//            self.setProductDetails()
//        }
//        else
//        {
//            self.getSingleProduct()
//        }
        
        self.setText()
        
        let productCollectionWidth = (view.frame.size.width-16-10) / 2
        let productCollectionViewLayout = productsCollection.collectionViewLayout as!  UICollectionViewFlowLayout
        productCollectionViewLayout.itemSize = CGSize(width: productCollectionWidth, height: productCollectionWidth+130)
        
        
        productsCollection.delegate = self
        productsCollection.dataSource = self
        
        clvProductImages.isPagingEnabled = true
        pcProductImages.pageIndicatorTintColor = UIColor.gray
        pcProductImages.currentPageIndicatorTintColor = UIColor.quiticPink
        pcProductImages.numberOfPages = 1
        
        clvProductImages.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        clvProductImages.decelerationRate = UIScrollViewDecelerationRateFast

        GetProductsDetailImages()
    }
    
    func setProductDetails()
    {
        //self.brandName.text = "No"
       // self.selectedBrand.id = -1
        
//         self.getBrandName(completion: { (brand) in
//            self.brandName.text = brand.name
//            self.selectedBrand = brand
//        })
        
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
        
        if ((self.productDetail).custom_attributes != nil)
        {
            for custom_attribute in (self.productDetail).custom_attributes!
            {
                if custom_attribute.attribute_code == "brands"
                {
                    self.brandName.text = custom_attribute.value
                    selectedBrandName = custom_attribute.value!
                }
                
                if custom_attribute.attribute_code == "brand_id"
                {
                    selectedBrandID = custom_attribute.value!
                }
                
                if custom_attribute.attribute_code == "brand_image"
                {
                    selectedBrandImgURL = custom_attribute.value!
                }

                if custom_attribute.attribute_code == "is_wishlist"
                {
                    if(custom_attribute.value != "")
                    {
                        self.productItem.isWish = true
                        self.productItem.wishlistItemId = custom_attribute.value!
                        
                        self.productDetail.isWish = true
                        self.productDetail.wishlistItemId = custom_attribute.value!
                        
                        if self.currentLanguage == "en"
                        {
                            self.btnAddToWishList.setTitle("Added", for: .normal)
                            self.btnAddToWishList.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)
                        }
                        else
                        {
                            self.btnAddToWishList.setTitle("تمت الاضافة", for: .normal)
                            self.btnAddToWishList.titleLabel?.font = UIFont(name: arLanguageConstant, size: 20)
                        }

                    }
                    else
                    {
                        self.productItem.isWish = false
                        self.productItem.wishlistItemId = ""
                        
                        self.productDetail.isWish = false
                        self.productDetail.wishlistItemId = ""
                        
                        if self.currentLanguage == "en"
                        {
                            self.btnAddToWishList.setTitle("Add To WishList", for: .normal)
                            self.btnAddToWishList.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)
                        }
                        else
                        {
                            self.btnAddToWishList.setTitle("أضف إلى قائمة الامنيات", for: .normal)
                            self.btnAddToWishList.titleLabel?.font = UIFont(name: arLanguageConstant, size: 20)
                        }
                    }
                }
            }
        }
        
        productName.text = (productDetail as! ProductDetail).name
        lblPrice.text = "\((productDetail as! ProductDetail).price!) JOD"
        lblSku.text = "\((productDetail as! ProductDetail).sku)"
        //Disable section start
        for cartItem in cartItems {
            if cartItem.id == productDetail.id!
            {
                print("deselect at \(cartItem.id) == \(productDetail.id)")
                productDetail.isAddedToCart = true
            }
        }
        

        if productDetail.isAddedToCart
        {
            if self.currentLanguage == "en"
            {
                btnAddToCart.setTitle("Added To Cart", for: .normal)
                btnAddToCart.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)
            }
            else
            {
                btnAddToCart.setTitle("تمت الاضافة الى سلة المشتريات", for: .normal)
                btnAddToCart.titleLabel?.font = UIFont(name: arLanguageConstant, size: 20)
            }
            
            btnAddToCart.isEnabled = false
        }
        else if ((Array(productDetail.custom_attributes!).first(where: { $0.attribute_code! == "quantity" })?.value)!) == "0"
        {
            btnAddToCart.backgroundColor = UIColor.red
            
            if self.currentLanguage == "en"
            {
//                btnAddToCart.setTitle("OUT OF STOCK", for: .normal)
                btnAddToCart.setTitle("Sold Out", for: .normal)

            }
            else
            {
                btnAddToCart.setTitle("نفذت", for: .normal)
            }
        }
        else
        {
            if self.currentLanguage == "en"
            {
                btnAddToCart.setTitle("Add To Cart", for: .normal)
                btnAddToCart.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)
            }
            else
            {
                btnAddToCart.setTitle("أضف إلى السلة", for: .normal)
                btnAddToCart.titleLabel?.font = UIFont(name: arLanguageConstant, size: 20)
            }
        }

        
        
        productImageStringValue = PRODUCT_IMAGE_URL+(((productDetail as! ProductDetail).custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!
        
        if self.currentLanguage == "en"{
            let iframe = (productDetail as! ProductDetail).custom_attributes?.first(where: { $0.attribute_code! == "description" })?.value ?? "No description available"
            
            
            descriptionWebView.loadHTMLString("<!DOCTYPE html><html><head><meta name=\"viewport\" content=\"width=150, initial-scale=1.0\"><style>@font-face{font-family: \'Belleza\';font-weight: normal;src: url(MarselisSerifOT.otf);}</style></head><body><p style=\"font-family: 'Belleza';\"><font size=\"3\">\(iframe)</font></p></body></html>", baseURL: Bundle.main.bundleURL)
            
        }
        else{
            let iframe = (productDetail as! ProductDetail).custom_attributes?.first(where: { $0.attribute_code! == "description" })?.value ?? "لا يوجد وصف متاح"
            
            
            descriptionWebView.loadHTMLString("<!DOCTYPE html><html><head><meta name=\"viewport\" content=\"width=150, initial-scale=1.0\"><style>@font-face{font-family: \'GE Flow\';  src: local('GE Flow'), url(geflow.otf)}</style></head><body><p style=\"text-align: right; font-family: 'GE Flow';\"><font size=\"3\">\(iframe)</font></p></body></html>", baseURL: Bundle.main.bundleURL)

        }

        
        
            
//            descriptionWebView.loadHTMLString("<!DOCTYPE html><html><head><meta name=\"viewport\" content=\"width=150, initial-scale=1.0\"><style>@font-face{font-family: \'arLanguageConstant\';font-weight: normal;src: url(geflow.otf);}</style></head><body><p style=\"font-family: 'arLanguageConstant';\"><font size=\"3\">\(iframe)</font></p></body></html>", baseURL: Bundle.main.bundleURL)
//
//        }
        
            
            
            
            
//        BaseManager.Manager.request(productImageStringValue).responseImage { response in
//            if let image = response.result.value {
//                self.productImage.image = image
//            }
//            else{
//                self.productImage.image = UIImage(named: "ImagePlaceholder")
//            }
//        }
    }

    
    @IBAction func btnBrandTap(_ sender: Any)
    {
        let brandMainContainer = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "BrandMainContainerViewController") as! BrandMainContainerViewController
        
        //brandMainContainer.previousData = self.brandsArray
        
        if selectedBrandID != ""
        {
            brandMainContainer.selectedName = selectedBrandName
            brandMainContainer.selectedId = Int(selectedBrandID) ?? 0
            brandMainContainer.allId = Constant_Brands_Id
            brandMainContainer.celebName = selectedBrandName
            brandMainContainer.celebBanner = selectedBrandImgURL
            
            self.navigationController?.pushViewController(brandMainContainer, animated: true)
        }
    }
    
    // function which is triggered when handleTap is called
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("Selected Product item : Start")
        dump((productDetail as! ProductDetail))
        print("Selected Product item : END")
        if  (UserDefaults.standard.string(forKey: "token") != nil){
            let ratePopup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rateReviewViewController") as! RateReviewViewController
            
            ratePopup.productId = String((productDetail as! ProductDetail).id!)
            
//            ratePopup.url_key = (Array((productDetail as! Items).custom_attributes!).first(where: { $0.attribute_code! == "url_key" })?.value)!
            ratePopup.selectedRate = { (data) in
                self.getProuductdetail()
            }
            present(ratePopup, animated: true)
        }
        else{
            let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
            loginViewController.pushed = 1
            
            self.navigationController?.pushViewController(loginViewController, animated: true)
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish")
//        webView.scrollView.contentInset = UIEdgeInsetsMake(0,0,0,0);
       
        webView.evaluateJavaScript("document.documentElement.offsetHeight", completionHandler: { ret, _ in
            guard let height = ret as? CGFloat else { return }
            print("setting height: ", height)
            self.automaticallyAdjustsScrollViewInsets = false

//           self.descriptionWebViewHeight.constant = height
//            self.descriptionWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)

            if self.descriptionWebViewHeight.constant == 0 {
                self.descriptionWebViewHeight.constant = 50
            }
            
            
            webView.scrollView.contentInset = UIEdgeInsets(top: -10, left: 0, bottom: 7, right: 0)
            

            
//            webView.scrollView.contentInset = UIEdgeInsetsMake(0,0,0,0);

            
            
            
//            webView.frame = CGRect(x: 0 - 8, y: 0 - 8, width: self.view.bounds.size.width + 14, height: self.view.bounds.size.height )
//
//            webView.scrollView.frame = CGRect(x: 0 - 8, y: 0 - 8, width: self.view.bounds.size.width + 14, height: (self.view.bounds.size.height) )
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if self.productsArray.count > 0{
//            return 4
//        }
////        else{
//        return self.productsArray.count
//      //  }
        
        if collectionView == clvProductImages
        {
            return self.mediaGallery.count
        }
        else
        {
            return self.productsArray.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == clvProductImages
        {
            let cellImages = collectionView.dequeueReusableCell(withReuseIdentifier:  "ProductImagesCell", for: indexPath) as! UICollectionViewCell
            
            let imageProduct:UIImageView = cellImages.viewWithTag(101) as! UIImageView
            
            let mediaImages:media_gallery_entries = (self.mediaGallery[indexPath.row] as? media_gallery_entries)!
            
            //sdImageView Changes.
            productImageStringValue = PRODUCT_IMAGE_URL + mediaImages.file!

            let url = URL(string:productImageStringValue)
        
            imageProduct.sd_setImage(with: url, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
            
            
//            BaseManager.Manager.request(productImageStringValue).responseImage { response in
//                if let image = response.result.value {
//                    imageProduct.image = image
//                }
//                else{
//                    imageProduct.image = UIImage(named: "ImagePlaceholder")
//                }
//            }
//
            return cellImages
            
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "mayLikeProductCell", for: indexPath) as! CartItemCollectionViewCell
      
        //cell.imageView.image = UIImage(named: "perfume")
        cell.lblOutOfStock.text = ""
        cell.lblOutOfStock.isHidden = true
        cell.reviews.isHidden = true
        cell.viewOuterBorder.layer.borderColor = UIColor.quiticPink.cgColor
        cell.viewOuterBorder.layer.borderWidth = 1.0
        
        cell.label.text = productsArray[indexPath.row].name
        
        //Disable section start
        for cartItem in cartItems {
            if cartItem.id == productsArray[indexPath.row].id!
            {
                print("deselect at \(cartItem.id) == \(productsArray[indexPath.row].id!)")
                productsArray[indexPath.row].isAddedToCart = true
            }
        }
        
        
        if productsArray[indexPath.row].isAddedToCart {
            cell.addToCartBtn.backgroundColor = UIColor.darkGray
            cell.addToCartBtn.isEnabled = !productsArray[indexPath.row].isAddedToCart
            cell.checkedBtnOutlet.isHidden = false
        }
        else{
            cell.addToCartBtn.backgroundColor = UIColor.black
            cell.addToCartBtn.isEnabled = true
            cell.checkedBtnOutlet.isHidden = true
        }
        
        
        cell.productCount.isHidden = true
        cell.lblOutOfStock.text = ""
        cell.lblOutOfStock.isHidden = true
         cell.reviews.isHidden = true
        //        //add product avalilable count
        //        cell.productCount.text = Array(productsArray[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "quantity" })?.value
        
        if((Array(productsArray[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "is_new" })) != nil)
        {
            if ((Array(productsArray[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "is_new" })?.value)!) != "0"
            {
                cell.imgNewTag.isHidden = false
            }
            else
            {
                cell.imgNewTag.isHidden = true
            }
        }
        
        if ((Array(productsArray[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "quantity" })?.value)!) != "0"
        {
            if(!productsArray[indexPath.row].isAddedToCart)
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
//                cell.lblOutOfStock.isHidden = false
                 cell.reviews.isHidden = true
//                cell.lblOutOfStock.text = "OUT OF STOCK"
                cell.lblOutOfStock.text = "Sold Out"

                cell.addToCartBtn.setTitle("Notify Me", for: .normal)
            }
            else
            {
//                cell.lblOutOfStock.isHidden = false
                 cell.reviews.isHidden = true
                cell.lblOutOfStock.text = "نفذت"
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
//            let maximumLabelSize: CGSize = CGSize(width: 20, height: 15)
//            let expectedLabelSize: CGSize = cell.reviews.sizeThatFits(maximumLabelSize)
//            var newFrame: CGRect = cell.reviews.frame
//            // resizing the frame to calculated size
//            newFrame.size.height = expectedLabelSize.height
//            // put calculated frame into UILabel frame
//            cell.reviews.frame = newFrame
            
            cell.label.textAlignment = .right
            
            cell.label.font = UIFont(name: arLanguageConstant, size: 13)!
            cell.price.font = UIFont(name: enLanguageConstant, size: 13)!
            cell.reviews.font = UIFont(name: arLanguageConstant, size: 10)!
            cell.addToCartBtn.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            cell.reviews.text = "نفذت"
            cell.imgNewTag.image = UIImage(named:"newTagAr")
        }
        
        cell.price.text = "\(productsArray[indexPath.row].price!) JOD"
        
       
        //sdImageView Changes.
        let strImage:String = PRODUCT_IMAGE_URL+(Array(productsArray[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!
        
        let url = URL(string:strImage)
        
        cell.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
        
//        BaseManager.Manager.request(PRODUCT_IMAGE_URL+(Array(productsArray[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!).responseImage { response in
//            if let image = response.result.value {
//                cell.imageView.image = image
//            }
//            else{
//                cell.imageView.image = UIImage(named: "ImagePlaceholder")
//            }
//        }
        
        
        if self.productsArray[indexPath.row].avg_rating_percent! > 0 {
            cell.ratingcosmos.rating = Double(((self.productsArray[indexPath.row].avg_rating_percent!*(5 - 1)) / 100)+1)
        }
        else {
            cell.ratingcosmos.rating = Double(0)
        }
        
        cell.wishButton.setImage(UIImage(named: "heartEmpty"), for: .normal)
        
        if self.productsArray[indexPath.item].isWish
        {
            cell.wishButton.setImage(UIImage(named: "favor"), for: .normal)
        }
        else{
            cell.wishButton.setImage(UIImage(named: "heartEmpty"), for: .normal)
        }
        
        
        //        let myColor = UIColor.quiticPink
        //        cell.imageSectionView.layer.borderWidth = 0.5
        //        cell.imageSectionView.layer.borderColor = myColor.cgColor
        //
        cell.cellDelegate=self
        cell.cellCartDelegate = self
        cell.cellCheckedBtnDelegate = self
        cell.index = indexPath
        
        
        //set brand name into product list screen. 18/06/2019
        if (self.productsArray[indexPath.row].custom_attributes != nil)
        {
            for custom_attribute in self.productsArray[indexPath.row].custom_attributes!
            {
                if custom_attribute.attribute_code == "brands"
                {
                    cell.lblBrandName.text = custom_attribute.value

                    
                    if currentLanguage == "en"{
                       cell.lblBrandName.font = UIFont.init(name: enMarselLanguageConstant, size: 17)

                    }
                    else{
                       
                        cell.lblBrandName.font = UIFont(name: arLanguageConstant, size: 17)!
                    
                    }
                    
                    

                    
                    
                }
//                else if custom_attribute.attribute_code == "is_wishlist"
//                {
//                    if custom_attribute.value == "1"
//                    {
//                        cell.wishButton.setImage(UIImage(named: "favor"), for: .normal)
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
        
        if collectionView == clvProductImages
        {
        }
        else
        {
            let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desVC = mainStoryBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
            
            let url = URL(string:(PRODUCT_IMAGE_URL+(Array(productsArray[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!))
            
            desVC.productItem = self.productsArray[indexPath.row]
            //desVC.productPrice = "\(self.productsArray[indexPath.row].price) JOD"
            desVC.productImageValue = url
            desVC.productImageStringValue = PRODUCT_IMAGE_URL+(Array(productsArray[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!
            desVC.productNameString = self.productsArray[indexPath.row].name!
            if productsArray[indexPath.row].avg_rating_percent! > 0 {
                desVC.customRate = Double(((productsArray[indexPath.row].avg_rating_percent!*(5 - 1)) / 100)+1)
                
            }
            else {
                desVC.customRate = Double(0)
            }
            
            
            self.navigationController?.pushViewController(desVC, animated: true)
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == clvProductImages
        {
            let cellSize: CGSize = collectionView.bounds.size
            return cellSize
        }
        else
        {
            var cellSize: CGSize = collectionView.bounds.size
            cellSize.width = ((productsCollection.frame.size.width/2) - 8)
            
            
            if AppDelegate.isIPhone5W()
            {
                cellSize.height = cellSize.width * 2.3
            }
            else if AppDelegate.isIPhone6W()
            {
                cellSize.height = cellSize.width * 1.974522293
            }
            else if AppDelegate.isIPhone6PlusW()
            {
                cellSize.height = cellSize.width * 1.7594936709
            }
            
            return cellSize
        }
    }

    
    @IBAction func shareBtnClicked(_ sender: Any) {
        print("Share btn clicked")
        let shareActivityController = UIActivityViewController(activityItems: [productImageValue!], applicationActivities: nil)
        present(shareActivityController, animated: true, completion: nil)
    }
    
    
    func GetProducts(orderBy :String,sortBy:String){
        print("Getting Products")
        
        self.productsCollection.isHidden = true
        
        productsManager.GetProductsRequestByCategoryId(pageSize: 10, catId: [], pageNo: 1, arithmaticOperator: "and", orderBy: orderBy, sortBy: sortBy, celebId: "" ) {(subCategories, error) in

            if error == nil{
                self.productsArray = CommonManager.shared.removeNullElement(items : (subCategories?.items!)!,attributeName : "image")

                CommonManager.shared.fetchFromCoreData(completion: { (data) in
                    self.cartItems = data
                    print("status cart: \(self.cartItems)")
                    self.productsCollection.reloadData()
                    self.productsCollection.isHidden = false
                })
            }
            else{
                print(error!)
            }
        }
        
    }
    func getProuductdetail(){
        productsManager.GetProductsDetail(productId :(productDetail as! ProductDetail).id!, completion: { (productReview, error) in
            
            if error == nil && productReview != nil && (productReview?.count)!>0 && productReview![0].avg_rating_percent != nil {
                if  Int(productReview![0].avg_rating_percent!)! > 0 {
                    self.ratingStar.rating  = Double(((Int(productReview![0].avg_rating_percent!)!*(5 - 1)) / 100)+1)
                }
                else {
                    self.ratingStar.rating  = Double(0)
                }
            }
        })
    }
    
//
//    func getSingleProduct(){
//        ANLoader.activityColor = .quiticPink
//        ANLoader.pulseAnimation = false
//        ANLoader.activityBackgroundColor = .clear
//        ANLoader.activityTextColor = .clear
//        ANLoader.showLoading("",disableUI: true)
//
//        productsManager.GetSingleProductRequest(id: self.productId, completion: { (data, error) in
//            if error == nil{
//                if (data?.total_count)! > 0{
//                    self.productDetail = (data?.items![0])!
//                    ANLoader.hide()
//                    self.setProductDetails()
//                }
//                else
//                {
//                    ANLoader.hide()
//                    //self.setProductDetails()
//                }
//            }
//            else{
//                print(error!)
//                ANLoader.hide()
//            }
//        })
//    }

    func getBrandName(completion: (_ complete: BrandCore) -> ()){
        
        if ((self.productDetail as! Items).custom_attributes != nil)
        {
            for custom_attribute in (self.productDetail as! ProductDetail).custom_attributes!{
                
                if custom_attribute.attribute_code == "brands"
                {
                    print("custom_attribute.value!")
                    dump(custom_attribute.value!)
                    self.getDataFromCoreData(completion: { (brandItems) in
                        if brandItems.count > 0
                        {
                            print("brand:brand")
                            for brand in brandItems
                            {
                                if custom_attribute.value! == String(brand.id)
                                {
                                    completion(brand)
                                }
                            }
                            print("brand:brand")

                        }

                    })

                 //   return custom_attribute.value!
                }
            }
        }
       // return ""
    }
    func getDataFromCoreData(completion: (_ complete: [BrandCore]) -> ()){
            CommonManager.shared.fetchBrandsCoreData { (brandItems) in
                completion(brandItems)
            }
    }
    
    //Get Product Detail images.
    func GetProductsDetailImages()
    {
        ANLoader.activityColor = .quiticPink
        ANLoader.pulseAnimation = false
        ANLoader.activityBackgroundColor = .clear
        ANLoader.activityTextColor = .clear
        ANLoader.showLoading("",disableUI: true)

        productsManager.GetProductsDetailImages(strSku: productItem.sku, completion: { (productDetail, error) in

            if error == nil{

                ANLoader.hide()
                self.productDetail = productDetail!

                self.mediaGallery = (self.productDetail.media_gallery_entries!)

                var mediaGalleryLocal:[media_gallery_entries] = []

                //function for setting first image which contain image type.
                for (idx, element) in self.mediaGallery.enumerated()
                {
                    let mediaImages:media_gallery_entries = element as media_gallery_entries

                    if (mediaImages.types?.contains("image"))!
                    {
                        self.mediaGallery.swapAt(0, idx)
                    }
                }
                self.pcProductImages.numberOfPages = self.mediaGallery.count

                self.clvProductImages.reloadData()

                self.setProductDetails()
            }
            else
            {
                print(error!)
                ANLoader.hide()
            }
        })
    }
    
    // MARK: - Scrollview Delegate Methods
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let visibleRect = CGRect(origin: self.clvProductImages.contentOffset, size: self.clvProductImages.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.clvProductImages.indexPathForItem(at: visiblePoint) {
            self.pcProductImages.currentPage = visibleIndexPath.row
        }
    }
    

}


extension ProductDetailsViewController :AddToCartprotocol,AddOrRemoveFromWishListprotocol, ClickedCheckedprotocol, AddToCartPopupControllerDelegate {
    
    func checkOutAction() {
        
        self.navigationController?.tabBarController?.selectedIndex = 4
        let cartVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
    
    func clickAddToCheckedView(index: Int) {
        let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = mainStoryBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        if productsArray[index].avg_rating_percent! > 0 {
            desVC.customRate = Double(((productsArray[index].avg_rating_percent!*(5 - 1)) / 100)+1)
            
        }
        else {
            desVC.customRate = Double(0)
            
        }
        let url = URL(string:(PRODUCT_IMAGE_URL+(Array(productsArray[index].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!))
        
        desVC.productItem = self.productsArray[index]
        desVC.productImageValue = url
        desVC.productImageStringValue = PRODUCT_IMAGE_URL+(Array(productsArray[index].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!
        desVC.productNameString = self.productsArray[index].name!
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
    
    func clickAddToCartBtn(index: Int) {
        
        if ((Array(productsArray[index].custom_attributes!).first(where: { $0.attribute_code! == "quantity" })?.value)!) == "0"
        {
            let notifyme = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotifyViewController") as! NotifyViewController
            
            notifyme.productId = String(productsArray[index].id!)
            present(notifyme, animated: true)
           // return
        }
        else
        {
            let message = MDCSnackbarMessage()
            
            let url = PRODUCT_IMAGE_URL+(Array(productsArray[index].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!
            
            
            CommonManager.shared.saveCartItem(id: productsArray[index].id!, imageUrl: url, name: productsArray[index].name!, price: productsArray[index].price!, sku: productsArray[index].sku, quote_id: productsArray[index].quote_id, quantity: 0, celebId: celebID) { (complete) in
                if complete {
                    
                    productsArray[index].isAddedToCart = true
                    //                 self.CartItemsCollectionView.reloadData()
                    
                    let indexPath = IndexPath(row: index, section: 0)
                    
                    self.productsCollection.reloadItems(at: [indexPath])
                    
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
    
       //GetWishList start
    fileprivate  func GetWishList(itemId : String , onCompleteion: @escaping (String) -> Void){
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
                        }
                    }
                }
            }
            else{
                print(error!)
            }
        }
    }
 // GetWishList end
    
    
    // DeleteWishListItem start
    fileprivate  func DeleteWishListItem(itemId :String){
        print("Delete Wish List Item: \(itemId)")
        self.productDetail.isWish = false
     //   let indexPath = IndexPath(row: itemIndex, section: 0)
//        self.CartItemsCollectionView.reloadItems(at: [indexPath])
//
        wishManager.deleteWishList (wishlistItemId: itemId){ (wishListresponse, error) in
            
            if error == nil
            {
                //                self.GetWishList()
                let message = MDCSnackbarMessage()
                if self.currentLanguage == "en"{
                    message.text = "Item removed successfully"
                    self.btnAddToWishList.setTitle("Add To WishList", for: .normal)
                    self.btnAddToWishList.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)
                }
                else{
                    message.text = "تمت إزالة العنصر بنجاح"
                    
                    self.btnAddToWishList.setTitle("أضف إلى قائمة الامنيات", for: .normal)
                    self.btnAddToWishList.titleLabel?.font = UIFont(name: arLanguageConstant, size: 20)
                }
              //  MDCSnackbarManager.show(message)
            }
            else{
                print(error!)
            }
        }
    }
    // DeleteWishListItem end
    func clickAddOrRemoveWishBtn(index: Int)
    {
        if  (UserDefaults.standard.string(forKey: "token") == nil) {
            let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
            self.present(loginViewController, animated: true)
        }
        if  (UserDefaults.standard.string(forKey: "token") != nil)
        {
            print("self.productDetail.isWish: \(self.productDetail.isWish)")
            
            if self.productsArray[index].isWish
            {
                DeleteWishListItem(itemId: self.productsArray[index].wishlistItemId)
                self.productsArray[index].isWish = !self.productsArray[index].isWish
                self.productsCollection.reloadData()
            }
            else
            {
                APIManager.shared.PostWishProduct(productId: String(self.productsArray[index].id!)){(data) -> Void in
                    if data["hasError"] == false
                    {
                        self.productsArray[index].isWish = !self.productsArray[index].isWish
                        let message = MDCSnackbarMessage()
                        if self.currentLanguage == "en"{
                            message.text = "Added to wish list"
                        }
                        else{
                            message.text = "أضيف لقائمة الأماني"
                        }
                        
                        self.productsCollection.reloadData()
                        
                       // MDCSnackbarManager.show(message)
                    }
                }
            }
        }
    }

}
