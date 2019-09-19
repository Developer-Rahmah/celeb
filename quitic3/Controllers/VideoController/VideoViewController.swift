//
//  VideoViewController.swift
//  quitic3
//
//  Created by DOT on 7/30/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import WebKit
import MaterialComponents.MaterialSnackbar
import Localize_Swift
import SDWebImage

class VideoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, WKNavigationDelegate {
    
    
    @IBOutlet weak var player: WKWebView!
    
    @IBOutlet weak var Activity: UIActivityIndicatorView!
    
    @IBOutlet weak var productActivityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var productCollectionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var videoProductsCollectionView: UICollectionView!
    
    let videoManager = VideosManager()
    
    var videoId: Int = 0
    var videoTitle: String = ""
    var url: String = ""
    var cartItems: [CartItem] = []
    
    var lblHeader = UILabel()
    let labels = AppLabels()
    var viewNavCenter = UIView()
    var celebId:String = ""
    let wishManager = WishListManager()
    var wishListArray = [WishListModel] ()
    
    
    let array:[String] = ["perfume", "perfume", "perfume", "perfume", "perfume", "perfume"]
    var products:[Items] = []
    var currentLanguage = "en"
    override func viewDidAppear(_ animated: Bool) {
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem()
        backButton.title = "" //in your case it will be empty or you can put the title of your choice
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
        
        if currentLanguage == "en"{
//            self.title = "Videos"
           // self.title = self.videoTitle
        }
        else{
//            self.title = "أشرطة فيديو"
            //self.title = self.videoTitle
        }
        
        
        print(url)
        
        let videoUrl: URL = URL(string:url)!//URL.init(string: url)
        let request = URLRequest(url: videoUrl)
        self.player.load(request)

        self.player.addSubview(self.Activity)
        self.Activity.startAnimating()
        self.player.navigationDelegate = self
        self.Activity.hidesWhenStopped = true
        
        videoProductsCollectionView.delegate = self
        videoProductsCollectionView.dataSource = self
        
        let productCollectionWidth = (view.frame.size.width-16-10) / 2
        let productCollectionViewLayout = videoProductsCollectionView.collectionViewLayout as!  UICollectionViewFlowLayout
        productCollectionViewLayout.itemSize = CGSize(width: productCollectionWidth, height: productCollectionWidth+130)
        
        if self.videoId != 0{
            self.getVideoProducts(videoId: self.videoId)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewNavCenter = UIView(frame: CGRect(x: 0, y: -13, width:  (self.navigationController?.navigationBar.frame.size.width)!, height: 20))
        viewNavCenter.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.addSubview(viewNavCenter)
        
        lblHeader = UILabel.init(frame:  CGRect(x: 50, y: -11, width: self.view.frame.width - 100, height: 50))
                
        //lblHeader.font = UIFont.init(name: headerFont, size: 30)
        lblHeader.textAlignment = .center
        lblHeader.textColor = UIColor.init(red: 251, green: 96, blue: 127)

        
        lblHeader.text = self.videoTitle
        lblHeader.font = UIFont.init(name: enMarselLanguageConstant, size: 23)
    
        self.navigationController?.navigationBar.addSubview(lblHeader)
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        lblHeader.removeFromSuperview()
        viewNavCenter.removeFromSuperview()
    }
    

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.Activity.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.Activity.stopAnimating()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.products.count > 0 {
            print("height yeah \(self.products.count) | \(CGFloat(self.products.count))")
            
            let cellWidth = (view.frame.size.width-16-10) / 2
            let cellHeight = cellWidth + 130
            let rowsCount = ceil(CGFloat(self.products.count) / CGFloat(2))
            let height =  (cellHeight * rowsCount)
            
            
            print("if product player height final \(height)")
            productCollectionHeight.constant = height + 50
            self.view.layoutIfNeeded()
        }
        else{
            productCollectionHeight.constant = 345
            self.view.layoutIfNeeded()
            
            print("else product player height final 345")
        }
        
        
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "videoProducts", for: indexPath) as! CartItemCollectionViewCell
        
        cell.viewOuterBorder.layer.borderColor = UIColor.quiticPink.cgColor
        cell.viewOuterBorder.layer.borderWidth = 1.0

        //Disable section start
        for cartItem in cartItems {
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

         cell.productCount.isHidden = true
        
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
            cell.addToCartBtn.backgroundColor = UIColor.red
            
            if self.currentLanguage == "en"
            {
//                cell.addToCartBtn.setTitle("OUT OF STOCK", for: .normal)
                cell.addToCartBtn.setTitle("Sold Out", for: .normal)

            }
            else
            {
                cell.addToCartBtn.setTitle("إنتهى من المخزن", for: .normal)
            }
        }
        
//        //add product avalilable count
//        cell.productCount.text = Array(products[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "quantity" })?.value
//
        
        //Disable section end
        
        cell.label.text = self.products[indexPath.row].name
        cell.price.text = "\(self.products[indexPath.row].price!) JOD"
        
        if currentLanguage == "en"{
            cell.label.textAlignment = .left
            
            cell.label.font = UIFont(name: enLanguageConstant, size: 13)!
            cell.price.font = UIFont(name: enLanguageConstant, size: 13)!
            cell.reviews.font = UIFont(name: enLanguageConstant, size: 10)!
            cell.addToCartBtn.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
            cell.reviews.text = "\(products[indexPath.row].reviews!) Reviews"
            cell.imgNewTag.image = UIImage(named:"newTag")
        }
        else{
            cell.label.textAlignment = .right
            
            cell.label.font = UIFont(name: arLanguageConstant, size: 13)!
            cell.price.font = UIFont(name: enLanguageConstant, size: 13)!
            cell.reviews.font = UIFont(name: arLanguageConstant, size: 10)!
            cell.addToCartBtn.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            cell.reviews.text = "\(products[indexPath.row].reviews!) استعراض"
            cell.imgNewTag.image = UIImage(named:"newTagAr")
        }
        
//        let url = URL(string:(PRODUCT_IMAGE_URL+(Array(self.products[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!))
//
//        cell.imageView.af_setImage(withURL: url!, placeholderImage: UIImage(named: "ImagePlaceholder"), filter:nil, imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: true, completion: nil)
//
        
        //sdImageView Changes.
        let strImage:String = PRODUCT_IMAGE_URL+(Array(self.products[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!
        
        let url = URL(string:strImage)
        
        cell.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
        
//        BaseManager.Manager.request(PRODUCT_IMAGE_URL+(Array(self.products[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!).responseImage { response in
//            if let image = response.result.value {
//                cell.imageView.image = image
//            }
//            else{
//                cell.imageView.image = UIImage(named: "ImagePlaceholder")
//            }
//        }
       
        //reviews
        
        
        if self.products[indexPath.item].avg_rating_percent! > 0 {
            
            //            cell.ratingcosmos.rating = Double((self.products[indexPath.item].avg_rating_percent!*5) / 100)
            cell.ratingcosmos.rating = Double(((self.products[indexPath.row].avg_rating_percent!*(5 - 1)) / 100)+1)
        }
        else {
            cell.ratingcosmos.rating = Double(0)
        }
        
//        let myColor = UIColor.quiticPink
//        cell.imageSectionView.layer.borderWidth = 0.5
//        cell.imageSectionView.layer.borderColor = myColor.cgColor
//
        cell.cellDelegate=self
        cell.cellCartDelegate = self
        cell.cellCheckedBtnDelegate = self
        cell.index = indexPath

    
         cell.wishButton.setImage(UIImage(named: "heartEmpty"), for: .normal)

        if self.products[indexPath.item].isWish
        {
            cell.wishButton.setImage(UIImage(named: "favor"), for: .normal)
        }
        else
        {
            cell.wishButton.setImage(UIImage(named: "heartEmpty"), for: .normal)
        }

        //set brand name into product list screen. 25/06/2019
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
        let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = mainStoryBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        
        let url = URL(string:(PRODUCT_IMAGE_URL+(Array(self.products[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!))
        
        desVC.productItem = self.products[indexPath.row]
        desVC.productImageValue = url
          desVC.productImageStringValue = PRODUCT_IMAGE_URL+(Array(self.products[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!
        desVC.productNameString = self.products[indexPath.row].name!
        
        
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize: CGSize = collectionView.bounds.size
        cellSize.width = ((videoProductsCollectionView.frame.size.width/2) - 8)
        
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
            cellSize.height = cellSize.width * 1.9
        }
        
        return cellSize
    }

    
    func getVideoProducts(videoId: Int){
        print("Getting Products for videoId: \(videoId)")
        
        self.videoProductsCollectionView.isHidden = true
        
        self.videoManager.GetVideosProductIds(videoId: videoId) { (data, error) in
            if error == nil{
                
                if(data != nil)
                {
                    self.products = CommonManager.shared.removeNullElement(items : data!, attributeName : "image")
                }
                
                CommonManager.shared.fetchFromCoreData(completion: { (data) in
                    self.cartItems = data
                    print("status cart: \(self.cartItems)")
                    self.videoProductsCollectionView.reloadData()
                    self.videoProductsCollectionView.isHidden = false
                })
            }
            else
            {
                print(error!)
            }
        }
        
        
        
    }
}
    
extension VideoViewController :AddToCartprotocol,AddOrRemoveFromWishListprotocol, ClickedCheckedprotocol, AddToCartPopupControllerDelegate {
    
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
            //return
        }
        else
        {
            let message = MDCSnackbarMessage()
            
            let url = PRODUCT_IMAGE_URL+(Array(self.products[index].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!
            
            
            CommonManager.shared.saveCartItem(id: self.products[index].id!, imageUrl: url, name: self.products[index].name!, price: self.products[index].price!, sku: self.products[index].sku, quote_id: self.products[index].quote_id, quantity: 0, celebId: celebId) { (complete) in
                if complete {
                    
                    products[index].isAddedToCart = true
                    //                 self.CartItemsCollectionView.reloadData()
                    
                    let indexPath = IndexPath(row: index, section: 0)
                    
                    self.videoProductsCollectionView.reloadItems(at: [indexPath])
                    
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
    
    func clickAddOrRemoveWishBtn(index: Int) {
        
        if  (UserDefaults.standard.string(forKey: "token") == nil) {
            let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
            
            self.present(loginViewController, animated: true)
            
        }
//        if  (UserDefaults.standard.string(forKey: "token") != nil)  {
//            APIManager.shared.PostWishProduct(productId: String(self.products[index].id!)){(data) -> Void in
//                if data["hasError"] == false {
//                    //print(data)
//
////                    let message = MDCSnackbarMessage()
////                    if self.currentLanguage == "en"{
////                        message.text = "Add to wish list"
////                    }
////                    else{
////                        message.text = "أضف إلى قائمة الامنيات"
////                    }
////
////                    MDCSnackbarManager.show(message)
//                }
//                else{
//                    //print(data)
//                }
//            }
//        }
        
        
        if  (UserDefaults.standard.string(forKey: "token") != nil && !self.products[index].isWish)
        {
            APIManager.shared.PostWishProduct(productId: String(products[index].id!)){(data) -> Void in
                if data["hasError"] == false
                {
                    self.products[index].isWish = !self.products[index].isWish
                    let message = MDCSnackbarMessage()
                    message.text = ""
                    if self.currentLanguage == "en"{
                        message.text = "Add to wish list"
                    }
                    else{
                        message.text = "أضف إلى قائمة الامنيات"
                    }
                    self.videoProductsCollectionView.reloadData()
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
                self.DeleteWishListItem(itemId: self.products[index].wishlistItemId)
                self.products[index].isWish = !self.products[index].isWish
                self.videoProductsCollectionView.reloadData()
                
//                if products[index].wishlistItemId == ""
//                {
//
//                    GetWishList(itemId: String(products[index].id!)) { (wishlistItemId) in
//                        if   wishlistItemId != ""
//                        {
//                            self.DeleteWishListItem(itemId: wishlistItemId)
//                            self.products[index].isWish = !self.products[index].isWish
//                            self.videoProductsCollectionView.reloadData()
//                        }
//                    }
//                }
//                else
//                {
//                    DeleteWishListItem(itemId: products[index].wishlistItemId)
//                    self.products[index].isWish = !self.products[index].isWish
//                    self.videoProductsCollectionView.reloadData()
//                }
                
            }
        }
    }
    
    
    fileprivate  func GetWishList(itemId : String , onCompleteion: @escaping (String) -> Void){
        print("Getting Products")
        var wishlistItemId = ""
        wishManager.fetchWishList { (wishListArray, error) in
            
            if wishListArray != nil
            {
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
}
    

