//
//  HomeViewController.swift
//  quitic3
//
//  Created by DOT on 7/10/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import ImageSlideshow
import SideMenu
import AlamofireImage
import MaterialComponents.MaterialSnackbar
import Localize_Swift
import Alamofire
import AlamofireObjectMapper
import PromiseKit
import SwiftyJSON
import ANLoader
import LGSideMenuController
import CoreData
import FSPagerView
import UserNotifications
import SDWebImage

class HomeViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        
        if pagerView == pagerSliderOutlet
        {
            return self.firstBanner.count
        }
        else if pagerView == pagerSliderBottom
        {
            return self.secondBanner.count
        }
        
        return 0
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        if pagerView == pagerSliderOutlet
        {
            if firstBanner.count > 0
            {
                let strBannerUrl:String = firstBanner[index].banner!
                
                //sdImageView Changes.
                let url = URL(string:strBannerUrl)
                
                cell.imageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
                
//
//                BaseManager.Manager.request(strBannerUrl).responseImage { response in
//                    if let image = response.result.value {
//                        cell.imageView?.image = image
//                    }
//                    else{
//                        cell.imageView?.image = UIImage(named: "ImagePlaceholder")
//                    }
//                }
//                cell.imageView?.image = UIImage(named: "ImagePlaceholder")
                return cell
            }
        }
        else if pagerView == pagerSliderBottom
        {
            if secondBanner.count > 0
            {
                let strBannerUrl:String = secondBanner[index].banner!
                
                //sdImageView Changes.
                let url = URL(string:strBannerUrl)
                
                cell.imageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
                
//                BaseManager.Manager.request(strBannerUrl).responseImage { response in
//                    if let image = response.result.value {
//                        cell.imageView?.image = image
//                    }
//                    else{
//                        cell.imageView?.image = UIImage(named: "ImagePlaceholder")
//                    }
//                }
//                cell.imageView?.image = UIImage(named: "ImagePlaceholder")
                return cell
            }
        }
    
        return cell
    }
    
    var cartItems: [CartItem] = []
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var celebritiesFirstCollectionView: UICollectionView!
    @IBOutlet weak var celebritiesSecondCollectionView: UICollectionView!
    @IBOutlet weak var CartItemsCollectionView: UICollectionView!
    @IBOutlet weak var BrandsCollectionView: UICollectionView!
	@IBOutlet weak var featuredCollectionView: UICollectionView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var VideoCollectionSection: UICollectionView!
    @IBOutlet weak var shopTheLookCollectionView: UICollectionView!
    
    //For Translate Labels Start
    
    @IBOutlet weak var lblMyBoutiquePick: UILabel!
    @IBOutlet weak var lblCelebrities: UILabel!
    @IBOutlet weak var lblFeaturedBrands: UILabel!
    
    @IBOutlet weak var lblSeeAllProducts: UIButton!
    @IBOutlet weak var lblSeeAllCelebrities: UIButton!
    @IBOutlet weak var lblSeeAllFeaturedBrands: UIButton!
    @IBOutlet weak var lblSeeAllPick: UIButton!
    @IBOutlet weak var lblSeeAllExclusiveBrands: UIButton!
    @IBOutlet weak var lblSeeAllCategories: UIButton!
    @IBOutlet weak var lblSeeAllVideoTutorials: UIButton!
    @IBOutlet weak var lblSeeAllShopTheLook: UIButton!
    @IBOutlet weak var lblShoptheLook: UILabel!
    @IBOutlet weak var lblVideoTutorial: UILabel!
    @IBOutlet weak var lblCelebritiesCartPicks: UILabel!
    @IBOutlet weak var lblAllCategories: UILabel!
    @IBOutlet weak var lblExclusiveBrands: UILabel!
    @IBOutlet weak var trendingBtn: UIButton!
    @IBOutlet weak var newProductBtn: UIButton!
    @IBOutlet weak var poster1Btn: UIButton!
    @IBOutlet weak var poster2Btn: UIButton!
    
    @IBOutlet weak var mainSlider1Height: NSLayoutConstraint!
    
    @IBOutlet weak var lblNoShopLookFound: UILabel!
    @IBOutlet weak var lblNoVideoFound: UILabel!
    var imgViewNavCenter = UIImageView()
    var viewNavCenter = UIView()
    var firstBanner  = [Banners] ()
    var secondBanner  = [Banners] ()
    var allBanners = [Banners] ()
    
    @IBOutlet weak var viewCelebFirstSlider: UIView!
    @IBOutlet weak var viewCelebSecondSlider: UIView!
    
    @IBOutlet weak var viewCartItems: UIView!
    @IBOutlet weak var pagerSliderOutlet: FSPagerView! {
        didSet {
            self.pagerSliderOutlet.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    
    @IBOutlet weak var pagerSliderMid: FSPagerView! {
        didSet {
            self.pagerSliderMid.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    
    
    @IBOutlet weak var pagerSliderBottom: FSPagerView! {
        didSet {
            self.pagerSliderBottom.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int){
        
//        print("store_id"+firstBanner[index].store_id! ?? nil)

        if pagerView == pagerSliderOutlet{
            print("pagerSliderOutlet clicked")
            if firstBanner[index].banner_type == "category"
            {
                if firstBanner[index].children_count == 0
                {
                    let desVC = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "splitPagerProducts") as! ProductPagerViewController
                    
                    //desVC.previousData = self.categoriesCollectionlist
                    desVC.selectedName = firstBanner[index].banner_text!
                    desVC.selectedId = Int(firstBanner[index].id!)!
                    
                    self.navigationController?.pushViewController(desVC, animated: true)
                }
                else
                {
                    let subCategoryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
    
                    //subCategoryVC.previousData = self.categoriesCollectionlist
                    subCategoryVC.selectedName = firstBanner[index].banner_text!
                    subCategoryVC.selectedId = Int(firstBanner[index].id!)!
                    
                    self.navigationController?.pushViewController(subCategoryVC, animated: true)
                }
            }
            else if firstBanner[index].banner_type == "brand"
            {
                let brandMainContainer = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "BrandMainContainerViewController") as! BrandMainContainerViewController
                
                brandMainContainer.selectedName = firstBanner[index].banner_text!
                brandMainContainer.selectedId = Int(firstBanner[index].link_id!) ?? -1
                brandMainContainer.allId = Constant_Brands_Id
                brandMainContainer.celebName = self.firstBanner[index].banner_text!
                brandMainContainer.celebBanner = firstBanner[index].banner!
                
                if(brandMainContainer.selectedId != -1)
                {
                    self.navigationController?.pushViewController(brandMainContainer, animated: true)
                }
                
            }
            else if firstBanner[index].banner_type == "product"
            {
                let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let desVC = mainStoryBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
                
                desVC.productId = Int(firstBanner[index].link_id!)!
                desVC.productNameString = firstBanner[index].banner_text!
                desVC.productImageStringValue = firstBanner[index].banner!
                self.navigationController?.pushViewController(desVC, animated: true)
            }

        }
        else if pagerView == pagerSliderMid
        {
            print("pagerSliderMid clicked")
        }
        else
        {
            if secondBanner[index].banner_type == "category"
            {
                if secondBanner[index].children_count == 0
                {
                    let desVC = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "splitPagerProducts") as! ProductPagerViewController
                    
                    //desVC.previousData = self.categoriesCollectionlist
                    desVC.selectedName = secondBanner[index].banner_text!
                    desVC.selectedId = Int(secondBanner[index].id!)!
                    
                    self.navigationController?.pushViewController(desVC, animated: true)
                }
                else
                {
                    let subCategoryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
                    
                    //subCategoryVC.previousData = self.categoriesCollectionlist
                    subCategoryVC.selectedName = secondBanner[index].banner_text!
                    subCategoryVC.selectedId = Int(secondBanner[index].id!)!
                    self.navigationController?.pushViewController(subCategoryVC, animated: true)
                }
            }
            else if secondBanner[index].banner_type == "brand"
            {
                let brandMainContainer = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "BrandMainContainerViewController") as! BrandMainContainerViewController
                
                // brandMainContainer.previousData = self.brandsArray
                brandMainContainer.selectedName = secondBanner[index].banner_text!
                brandMainContainer.selectedId = Int(secondBanner[index].link_id!) ?? -1
                brandMainContainer.allId = Constant_Brands_Id
                brandMainContainer.celebName = self.secondBanner[index].banner_text!
                brandMainContainer.celebBanner = secondBanner[index].banner!
                
                if(brandMainContainer.selectedId != -1)
                {
                    self.navigationController?.pushViewController(brandMainContainer, animated: true)
                }
                
            }
            else if secondBanner[index].banner_type == "product"
            {
                let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let desVC = mainStoryBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
                
                desVC.productId = Int(secondBanner[index].link_id!)!
                desVC.productNameString = self.secondBanner[index].banner_text!
                desVC.productImageStringValue = self.secondBanner[index].banner!
                self.navigationController?.pushViewController(desVC, animated: true)
            }
        }
    }
    
    var sortBy = "created_at"
    var orderBy = "DESC"
    var currentLanguage = ""
    
     var wishListArray  = [WishListModel] ()
    //For Translate Labels End
    
    @objc func setText(){
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
    
        self.lblNoVideoFound.isHidden = true
        self.lblNoVideoFound.layer.borderColor = UIColor.black.cgColor
        self.lblNoVideoFound.layer.borderWidth = 1.0
        
        self.lblNoShopLookFound.isHidden = true
        self.lblNoShopLookFound.layer.borderColor = UIColor.black.cgColor
        self.lblNoShopLookFound.layer.borderWidth = 1.0
        
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        style.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        
        let labels = AppLabels()
		let titleEdgeInsets: CGFloat = 10.0
        lblSeeAllCelebrities.setTitle(labels.SEEALL, for: .normal)
        lblSeeAllProducts.setTitle(labels.SEEALL, for: .normal)
        lblSeeAllFeaturedBrands.setTitle(labels.SEEALL, for: .normal)
        lblSeeAllPick.setTitle(labels.SEEALL, for: .normal)
        lblSeeAllExclusiveBrands.setTitle(labels.SEEALL, for: .normal)
        lblSeeAllCategories.setTitle(labels.SEEALL, for: .normal)
        lblSeeAllVideoTutorials.setTitle(labels.SEEALL, for: .normal)
        lblSeeAllShopTheLook.setTitle(labels.SEEALL, for: .normal)

        
        if self.currentLanguage == "en"{
           // self.title = "Home"
            
            UserDefaults.standard.set("0", forKey: "arLanguage")
            UserDefaults.standard.set("0", forKey: "tabcount")
            UserDefaults.standard.synchronize()
            
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: enLanguageConstant, size: 10)!], for: .normal)
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: enLanguageConstant, size: 10)!], for: .selected)
            
            
            
            let titleAttributes: [NSAttributedStringKey : Any] = [
                NSAttributedStringKey.font : UIFont(name: enLanguageConstant, size: 37)!,
                NSAttributedStringKey.foregroundColor: UIColor.black,
                NSAttributedStringKey.paragraphStyle : style
            ]
            
            let specialTitleAttributes: [NSAttributedStringKey : Any] = [
                NSAttributedStringKey.font : UIFont(name: enLanguageConstant, size: 30)!,
                NSAttributedStringKey.foregroundColor: UIColor.white,
                NSAttributedStringKey.paragraphStyle : style
            ]
            
            self.tabBarController?.tabBar.items?[0].title = "Home"
            self.tabBarController?.tabBar.items?[1].title = "Wishlist"
            self.tabBarController?.tabBar.items?[2].title = "Celebrities"
            self.tabBarController?.tabBar.items?[3].title = "Categories"
            self.tabBarController?.tabBar.items?[4].title = "Cart"
            lblSeeAllCelebrities.titleLabel?.font = UIFont(name: enMarselLanguageConstant, size: 15)!
            lblSeeAllProducts.titleLabel?.font = UIFont(name: enMarselLanguageConstant, size: 17)!
            lblSeeAllPick.titleLabel?.font = UIFont(name: enMarselLanguageConstant, size: 17)!
            lblSeeAllExclusiveBrands.titleLabel?.font = UIFont(name: enMarselLanguageConstant, size: 15)!
            lblSeeAllCategories.titleLabel?.font = UIFont(name: enMarselLanguageConstant, size: 15)!
            lblSeeAllVideoTutorials.titleLabel?.font = UIFont(name: enMarselLanguageConstant, size: 15)!
            lblSeeAllShopTheLook.titleLabel?.font = UIFont(name: enMarselLanguageConstant, size: 15)!
            lblSeeAllFeaturedBrands.titleLabel!.font = UIFont(name: enMarselLanguageConstant, size: 15)!
            
            lblMyBoutiquePick.text = "My Boutique Pick"
            lblMyBoutiquePick.font = UIFont(name: enMarselLanguageConstant, size: 17)!
            
            lblCelebrities.text = "Celebrities"
            lblCelebrities.font = UIFont(name: enMarselLanguageConstant, size: 17)!
            
            lblFeaturedBrands.text = "Featured Brands"
            lblFeaturedBrands.font = UIFont(name: enMarselLanguageConstant, size: 17)!
            
            lblShoptheLook.text = "Shop The Look"
            lblShoptheLook.font = UIFont(name: enMarselLanguageConstant, size: 17)!
            
            lblVideoTutorial.text = "Video Tutorials"
            lblVideoTutorial.font = UIFont(name: enMarselLanguageConstant, size: 17)!
            
            lblAllCategories.text = "Shop By Category"
            lblAllCategories.font = UIFont(name: enMarselLanguageConstant, size: 17)!
            
            lblExclusiveBrands.text = "Exclusive Brands"
            lblExclusiveBrands.font = UIFont(name: enMarselLanguageConstant, size: 17)!
            
            lblCelebritiesCartPicks.text = "Celebraties Cart Picks"
            lblCelebritiesCartPicks.font = UIFont(name: enMarselLanguageConstant, size: 17)!
            
            
//            trendingBtn.titleLabel?.font = UIFont(name: "Belleza-Regular", 10)
//            trendingBtn.setAttributedTitle(NSMutableAttributedString(string: "Trending \n Now", attributes: titleAttributes), for: .normal)
//            let width = view.frame.size.width/2
//            let height = view.frame.size.height / 5
//
//            trendingBtn.frame
//                = CGRect(x: 0, y: 0, width: 1000, height: 500)
            trendingBtn.setImage(UIImage(named: "trending"), for: UIControlState.normal)

//            newProductBtn.setAttributedTitle(NSAttributedString(string: "New \n Arrivals", attributes: titleAttributes), for: .normal)
            
            newProductBtn.setImage(UIImage(named: "newPro"), for: UIControlState.normal)
            
            
//            poster1Btn.setAttributedTitle(NSAttributedString(string: "Special\nCollection", attributes: specialTitleAttributes), for: .normal)
//
           
               poster1Btn.setImage(UIImage(named: "poster1"), for: UIControlState.normal)
            
//            poster2Btn.setAttributedTitle(NSAttributedString(string: "All Brands", attributes: specialTitleAttributes), for: .normal)
//
           
            poster2Btn.setImage(UIImage(named: "poster2"), for: UIControlState.normal)
            self.lblSeeAllProducts.semanticContentAttribute = .forceRightToLeft
            self.lblSeeAllProducts.contentHorizontalAlignment = .right
            
//            self.lblSeeAllCelebrities.setImage(UIImage(named: "rightArrow"), for: .normal)
            self.lblSeeAllCelebrities.semanticContentAttribute = .forceRightToLeft
            self.lblSeeAllCelebrities.contentHorizontalAlignment = .right
         //   self.lblSeeAllCelebrities.titleEdgeInsets.right = titleEdgeInsets
            
            self.lblSeeAllFeaturedBrands.semanticContentAttribute = .forceRightToLeft
            self.lblSeeAllFeaturedBrands.contentHorizontalAlignment = .right
            //self.lblSeeAllFeaturedBrands.titleEdgeInsets.left = titleEdgeInsets
            
            
           // self.lblSeeAllPick.setImage(UIImage(named: "rightArrow"), for: .normal)
            self.lblSeeAllPick.semanticContentAttribute = .forceRightToLeft
            self.lblSeeAllPick.contentHorizontalAlignment = .right
          //  self.lblSeeAllPick.titleEdgeInsets.right = titleEdgeInsets
            
          //  self.lblSeeAllExclusiveBrands.setImage(UIImage(named: "rightArrow"), for: .normal)
            self.lblSeeAllExclusiveBrands.semanticContentAttribute = .forceRightToLeft
            self.lblSeeAllExclusiveBrands.contentHorizontalAlignment = .right
          //  self.lblSeeAllExclusiveBrands.titleEdgeInsets.right = titleEdgeInsets
            
           // self.lblSeeAllCategories.setImage(UIImage(named: "rightArrow"), for: .normal)
            self.lblSeeAllCategories.semanticContentAttribute = .forceRightToLeft
            self.lblSeeAllCategories.contentHorizontalAlignment = .right
         //   self.lblSeeAllCategories.titleEdgeInsets.right = titleEdgeInsets
            
          //  self.lblSeeAllVideoTutorials.setImage(UIImage(named: "rightArrow"), for: .normal)
            self.lblSeeAllVideoTutorials.semanticContentAttribute = .forceRightToLeft
            self.lblSeeAllVideoTutorials.contentHorizontalAlignment = .right
          //  self.lblSeeAllVideoTutorials.titleEdgeInsets.right = titleEdgeInsets
            
          //  self.lblSeeAllShopTheLook.setImage(UIImage(named: "rightArrow"), for: .normal)
            self.lblSeeAllShopTheLook.semanticContentAttribute = .forceRightToLeft
            self.lblSeeAllShopTheLook.contentHorizontalAlignment = .right
           // self.lblSeeAllShopTheLook.titleEdgeInsets.right = titleEdgeInsets
            
            lblNoVideoFound.font = UIFont(name: enLanguageConstant, size: 30)!
            lblNoVideoFound.text = "Coming soon"
            
            lblNoShopLookFound.font = UIFont(name: enLanguageConstant, size: 30)!
            lblNoShopLookFound.text = "Coming soon"
            
            self.GetVideos(store_id: 1)
        }
        else{
            UserDefaults.standard.set("1", forKey: "arLanguage")
            UserDefaults.standard.set("0", forKey: "tabcount")
            UserDefaults.standard.synchronize()
            
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: arLanguageConstant, size: 10)!], for: .normal)
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: arLanguageConstant, size: 10)!], for: .selected)
            
            
            
            let titleAttributes: [NSAttributedStringKey : Any] = [
                NSAttributedStringKey.font : UIFont(name: arLanguageConstant, size: 37)!,
                NSAttributedStringKey.foregroundColor: UIColor.black,
                NSAttributedStringKey.paragraphStyle : style
            ]
            
            let specialTitleAttributes: [NSAttributedStringKey : Any] = [
                NSAttributedStringKey.font : UIFont(name: arLanguageConstant, size: 30)!,
                NSAttributedStringKey.foregroundColor: UIColor.white,
                NSAttributedStringKey.paragraphStyle : style
            ]
            
           // self.title = "الصفحة الرئيسية"
            
            self.tabBarController?.tabBar.items?[0].title = "الصفحة الرئيسية"
            self.tabBarController?.tabBar.items?[1].title = "مفضلتي"
            self.tabBarController?.tabBar.items?[2].title = " المشاهير"
            self.tabBarController?.tabBar.items?[3].title = "الأقسام"
            self.tabBarController?.tabBar.items?[4].title = "سلة المشتريات"
            
            lblMyBoutiquePick.text = "بلدي البوتيكات بيك"
            lblMyBoutiquePick.font = UIFont(name: arLanguageConstant, size: 17)!
            
            lblCelebrities.text =  "المشاهير"
            lblCelebrities.font = UIFont(name: arLanguageConstant, size: 17)!
            lblSeeAllCelebrities.titleLabel?.font = UIFont(name: arLanguageConstant, size: 15)!
            lblSeeAllProducts.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            lblSeeAllPick.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            lblSeeAllExclusiveBrands.titleLabel?.font = UIFont(name: arLanguageConstant, size: 15)!
            lblSeeAllCategories.titleLabel?.font = UIFont(name: arLanguageConstant, size: 15)!
            lblSeeAllVideoTutorials.titleLabel?.font = UIFont(name: arLanguageConstant, size: 15)!
            lblSeeAllShopTheLook.titleLabel?.font = UIFont(name: arLanguageConstant, size: 15)!
            lblSeeAllFeaturedBrands.titleLabel!.font = UIFont(name: arLanguageConstant, size: 15)!
            
            //lblShoptheLook.text = "تسوق من النظرة"
            lblShoptheLook.text = "تسوقي من مجموعة"
            lblShoptheLook.font = UIFont(name: arLanguageConstant, size: 17)!
            
            lblVideoTutorial.text = "فيديوهات تعليمية"
            lblVideoTutorial.font = UIFont(name: arLanguageConstant, size: 17)!
            
            lblAllCategories.text = "جميع الأقسام"
            lblAllCategories.font = UIFont(name: arLanguageConstant, size: 17)!
            
            lblExclusiveBrands.text = "العلامات التجارية الحصرية"
            lblExclusiveBrands.font = UIFont(name: arLanguageConstant, size: 17)!
            
            //lblFeaturedBrands.text = "ماركات مميزة"
            lblFeaturedBrands.text = "العلامات التجارية المميزة"
            lblFeaturedBrands.font = UIFont(name: arLanguageConstant, size: 17)!
            
           // lblCelebritiesCartPicks.text = "احتفالات سلة التسوق"
            
            lblCelebritiesCartPicks.text = "مختارات Celebrities Cart"
            lblCelebritiesCartPicks.font = UIFont(name: arLanguageConstant, size: 17)!
            
//            trendingBtn.setAttributedTitle(NSAttributedString(string: "أحدث الصيحات", attributes: titleAttributes), for: .normal)
//
//            let image = UIImage(named: "newproductsar") as UIImage?
//
//            trendingBtn.setImage(image, for: .normal)
            
            
            trendingBtn.setImage(UIImage(named: "newproductsar"), for: UIControlState.normal)

            
            
            
//            trendingBtn.setImage(UIImage(named: "newproductsar"), for: UIControlState.normal)

            
//            newProductBtn.setAttributedTitle(NSAttributedString(string: "وصل حديثاً", attributes: titleAttributes), for: .normal)
           
            newProductBtn.setImage(UIImage(named: "newarives"), for: UIControlState.normal)
           
//            poster1Btn.setAttributedTitle(NSAttributedString(string: "مجموعة خاصة", attributes: specialTitleAttributes), for: .normal)
            poster1Btn.setImage(UIImage(named: "specailcollectionar"), for: UIControlState.normal)
            
            
//            poster2Btn.setAttributedTitle(NSAttributedString(string: "جميع العلامات التجارية", attributes: specialTitleAttributes), for: .normal)
//
            
            
            poster2Btn.setImage(UIImage(named: "allbrandsar"), for: UIControlState.normal)
            
            
            
          //  self.lblSeeAllCelebrities.setImage(UIImage(named: "leftArrow"), for: .normal)
            self.lblSeeAllCelebrities.semanticContentAttribute = .forceLeftToRight
            self.lblSeeAllCelebrities.contentHorizontalAlignment = .left
         //   self.lblSeeAllCelebrities.titleEdgeInsets.left = titleEdgeInsets
            
            self.lblSeeAllProducts.semanticContentAttribute = .forceLeftToRight
            self.lblSeeAllProducts.contentHorizontalAlignment = .left
         //   self.lblSeeAllProducts.titleEdgeInsets.left = titleEdgeInsets
            
            
            self.lblSeeAllFeaturedBrands.semanticContentAttribute = .forceLeftToRight
            self.lblSeeAllFeaturedBrands.contentHorizontalAlignment = .left
           // self.lblSeeAllFeaturedBrands.titleEdgeInsets.left = titleEdgeInsets
            
            
           // self.lblSeeAllPick.setImage(UIImage(named: "leftArrow"), for: .normal)
            self.lblSeeAllPick.semanticContentAttribute = .forceLeftToRight
            self.lblSeeAllPick.contentHorizontalAlignment = .left
          //  self.lblSeeAllPick.titleEdgeInsets.left = titleEdgeInsets
            
           // self.lblSeeAllExclusiveBrands.setImage(UIImage(named: "leftArrow"), for: .normal)
            self.lblSeeAllExclusiveBrands.semanticContentAttribute = .forceLeftToRight
            self.lblSeeAllExclusiveBrands.contentHorizontalAlignment = .left
         //   self.lblSeeAllExclusiveBrands.titleEdgeInsets.left = titleEdgeInsets
            
           // self.lblSeeAllCategories.setImage(UIImage(named: "leftArrow"), for: .normal)
            self.lblSeeAllCategories.semanticContentAttribute = .forceLeftToRight
            self.lblSeeAllCategories.contentHorizontalAlignment = .left
          //  self.lblSeeAllCategories.titleEdgeInsets.left = titleEdgeInsets
            
          //  self.lblSeeAllVideoTutorials.setImage(UIImage(named: "leftArrow"), for: .normal)
            self.lblSeeAllVideoTutorials.semanticContentAttribute = .forceLeftToRight
            self.lblSeeAllVideoTutorials.contentHorizontalAlignment = .left
           // self.lblSeeAllVideoTutorials.titleEdgeInsets.left = titleEdgeInsets
            
           // self.lblSeeAllShopTheLook.setImage(UIImage(named: "leftArrow"), for: .normal)
            self.lblSeeAllShopTheLook.semanticContentAttribute = .forceLeftToRight
            self.lblSeeAllShopTheLook.contentHorizontalAlignment = .left
          //  self.lblSeeAllShopTheLook.titleEdgeInsets.left = titleEdgeInsets
            
            
            lblNoVideoFound.font = UIFont(name: arLanguageConstant, size: 30)!
            lblNoVideoFound.text = "قريباً"
            
            lblNoShopLookFound.font = UIFont(name: arLanguageConstant, size: 30)!
            lblNoShopLookFound.text = "قريباً"
            
            self.GetVideos(store_id: 2)
        }
        
        self.getBanner()
        self.GetBrandsCount()
        self.GetBrands()
        self.GetFeaturedBrands()
        self.GetCelebrities()
        self.GetProducts(orderBy: self.orderBy, sortBy: self.sortBy)
        self.GetCategories()
        
    }
    
    
    
    let navBarTitleImage = UIImage(named: "MyBoutiques")
    
    var guestCartId :String = ""
    let cartManager = CheckoutManager()
    let brandManager = BrandManager()
    let celebritiesManager = CelebritiesManager()
    let productsManager = ProductsManager()
    let videosManager = VideosManager()
    let wishManager = WishListManager()
    var searchBarCheck = true
    let baseManager = BaseManager()
    let arraySample:[String] = ["celeb1", "celeb2", "celeb3", "celeb4", "celeb5", "celeb6"]
    var  array:[Items]=[Items]()
    var celebritiesFirstCollectionlist:[Items]=[Items]()
    var celebritiesSecondCollectionlist:[Items]=[Items]()
    var categoriesCollectionlist:[Items]=[Items]()
    var trendingCategoriesCollectionlist:[Items]=[Items]()
    var brandsArray:[Items] = [Items]()
    var productsArray:[Items] = [Items]()
    var celebritiesArray:[Items] = [Items]()
    var videos: [Post] = []
    
    
    var CartDataSourceArray = [Children_data]()
    
    var featuredBrandsArray:[Items] = [Items]()
    var exclusiveBrandsArray:[Items] = [Items]()
    
    @objc func loginStatus(){
        print("is changed loginStatus")
        self.productsArray = []
        self.GetProducts(orderBy: self.orderBy, sortBy: self.sortBy)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.GetProducts(orderBy: self.orderBy, sortBy: self.sortBy)
        
        
//        if !(self.navigationController?.navigationBar.subviews.contains(viewNavCenter))!
//        {
//            viewNavCenter = UIView(frame: CGRect(x: 0, y: ((self.navigationController?.navigationBar.frame.height)! - 52), width:  (self.navigationController?.navigationBar.frame.size.width)!, height: 52))
//            viewNavCenter.backgroundColor = UIColor.white
//            self.navigationController?.navigationBar.addSubview(viewNavCenter)
//
//            ///added for navigation bar setting.
//            //set large size navigation bar image.
//            imgViewNavCenter = UIImageView(image: UIImage(named: "centerHeader"))
//            imgViewNavCenter.frame = CGRect(x: view.frame.size.width / 2 - 75, y: -5, width: 150, height: 100) //
//
//            //change height and width accordingly
//            self.navigationController?.navigationBar.addSubview(imgViewNavCenter)
//
//            let titleImgView = UIImageView(frame: CGRect(x: 0, y: 0, width:0, height: 0))
//            let image = UIImage(named: "")
//            titleImgView.image = image
//            navigationItem.titleView = titleImgView
//        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        viewNavCenter = UIView(frame: CGRect(x: 0, y: -9, width:  (self.navigationController?.navigationBar.frame.size.width)!, height: 20))
        viewNavCenter.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.addSubview(viewNavCenter)

        ///added for navigation bar setting.
        //set large size navigation bar image.
        imgViewNavCenter = UIImageView(image: UIImage(named: "centerHeader"))
        imgViewNavCenter.frame = CGRect(x: view.frame.size.width / 2 - 51, y: -7, width: 103, height: 50) //
//        imgViewNavCenter.contentMode = .scaleAspectFill

        //change height and width accordingly
        self.navigationController?.navigationBar.addSubview(imgViewNavCenter)
        
        let titleImgView = UIImageView(frame: CGRect(x: 0, y: 0, width:0, height: 0))
        let image = UIImage(named: "")
        titleImgView.image = image
        navigationItem.titleView = titleImgView
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         imgViewNavCenter.removeFromSuperview()
         viewNavCenter.removeFromSuperview()
        
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
//        self.localNotification()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginStatus), name: NSNotification.Name("NotifyLoginStatus"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToBrands), name: NSNotification.Name("GoToBrands"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToShopByCategory), name: NSNotification.Name("ShopByCategory"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToVideos), name: NSNotification.Name("Videos"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ContactUS), name: NSNotification.Name("ContactUS"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(languagePopup), name: NSNotification.Name("languagePopup"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartQuantityBadge), name: NSNotification.Name("updateCartQuantityBadge"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginScreen), name: NSNotification.Name("LoginScreen"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MyAccount), name: NSNotification.Name("MyAccount"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(faqs), name: NSNotification.Name("faqs"), object: nil)
    

        CartItemsCollectionView.delegate = self
        CartItemsCollectionView.dataSource=self
        BrandsCollectionView.delegate = self
		featuredCollectionView.delegate = self
		featuredCollectionView.dataSource = self
        BrandsCollectionView.dataSource = self
        VideoCollectionSection.delegate = self
        VideoCollectionSection.dataSource = self
        shopTheLookCollectionView.delegate = self
        shopTheLookCollectionView.dataSource = self
        
        
        pagerSliderOutlet.dataSource = self
        pagerSliderOutlet.delegate = self
        pagerSliderOutlet.transformer = FSPagerViewTransformer(type: .depth)
        pagerSliderOutlet.automaticSlidingInterval = 5.0
        pagerSliderOutlet.isInfinite = true
        
        pagerSliderMid.dataSource = self
        pagerSliderMid.delegate = self
        pagerSliderMid.transformer = FSPagerViewTransformer(type: .crossFading)
        pagerSliderMid.automaticSlidingInterval = 5.0
        pagerSliderMid.isInfinite = true
        
        pagerSliderBottom.dataSource = self
        pagerSliderBottom.delegate = self
        pagerSliderBottom.transformer = FSPagerViewTransformer(type: .cubic)
        pagerSliderBottom.automaticSlidingInterval = 5.0
        pagerSliderBottom.isInfinite = true
        
        
        let titleImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        titleImageView.image = navBarTitleImage
        
//        self.navigationItem.titleView = UIImageView(image: navBarTitleImage)
        self.navigationItem.titleView = titleImageView
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        /////////////// Resizing Brands Collection//////////////////////////
        let brandsCollectionViewLayout = BrandsCollectionView.collectionViewLayout as!  UICollectionViewFlowLayout
        brandsCollectionViewLayout.itemSize = CGSize(width: 190, height: 100)
		
		let featuredCollectionViewViewLayout = featuredCollectionView.collectionViewLayout as!  UICollectionViewFlowLayout
		featuredCollectionViewViewLayout.itemSize = CGSize(width: 190, height: 100)
        
        /////////////// Resizing Celeb First Collection//////////////////////////
        
//        let celebsFirstCollectionWidth = (view.frame.size.width-16-2) / 3
//        let celebsFirstCollectionViewLayout = celebritiesFirstCollectionView.collectionViewLayout as!  UICollectionViewFlowLayout
//        celebsFirstCollectionViewLayout.itemSize = CGSize(width: celebsFirstCollectionWidth, height: celebsFirstCollectionWidth + 30)
        
        //minimize the space between cells.
        let width = (view.frame.size.width-2-1) / 3
        let layout = celebritiesFirstCollectionView.collectionViewLayout as!  UICollectionViewFlowLayout
        
        
//        if AppDelegate.isIPhone5W()
//        {
//             layout.itemSize = CGSize(width: width, height: width + 60)
//        }
//        else if AppDelegate.isIPhone6W()
//        {
//             layout.itemSize = CGSize(width: width, height: width + 48)
//        }
//        else if AppDelegate.isIPhone6PlusW()
//        {
//            layout.itemSize = CGSize(width: width, height: width + 34)
//        }
//        else
//        {
//            viewCelebFirstSlider.translatesAutoresizingMaskIntoConstraints = true
//
//            viewCelebFirstSlider.frame = CGRect(x: viewCelebFirstSlider.frame.origin.x, y: viewCelebFirstSlider.frame.origin.y + viewCelebFirstSlider.frame.size.height, width: self.view.frame.size.width, height: width + 34)
//
////            celebritiesFirstCollectionView.translatesAutoresizingMaskIntoConstraints = true
////
////            celebritiesFirstCollectionView.frame = CGRect(x: celebritiesFirstCollectionView.frame.origin.x, y: celebritiesFirstCollectionView.frame.origin.y, width: viewCelebFirstSlider.frame.size.width, height: width + 34)
////
//             layout.itemSize = CGSize(width: width, height: width + 34)
//        }
//
        
        
        /////////////// Resizing Celeb Second Collection//////////////////////////
//
//        let celebsSecondCollectionWidth = (view.frame.size.width-16-2) / 3
//        let celebsSecondCollectionViewLayout = celebritiesSecondCollectionView.collectionViewLayout as!  UICollectionViewFlowLayout
//        celebsSecondCollectionViewLayout.itemSize = CGSize(width: celebsSecondCollectionWidth, height: celebsSecondCollectionWidth + 30)
//
         //minimize the space between cells.
        let widthForSecondClv = (view.frame.size.width-2-1) / 3
        let layoutForSecondClv = celebritiesSecondCollectionView.collectionViewLayout as!  UICollectionViewFlowLayout
        
        
        if AppDelegate.isIPhone5W()
        {
             layoutForSecondClv.itemSize = CGSize(width: width, height: widthForSecondClv + 60)
        }
        else if AppDelegate.isIPhone6W()
        {
             layoutForSecondClv.itemSize = CGSize(width: width, height: widthForSecondClv + 48)
        }
        else if AppDelegate.isIPhone6PlusW()
        {
            layoutForSecondClv.itemSize = CGSize(width: width, height: widthForSecondClv + 34)
        }
        else
        {
        
            viewCelebSecondSlider.translatesAutoresizingMaskIntoConstraints = true
            
            viewCelebSecondSlider.frame = CGRect(x: viewCelebSecondSlider.frame.origin.x, y: viewCelebFirstSlider.frame.origin.y + viewCelebFirstSlider.frame.size.height, width: self.view.frame.size.width, height: 1)
            
//            celebritiesSecondCollectionView.translatesAutoresizingMaskIntoConstraints = true
//
//            celebritiesSecondCollectionView.frame = CGRect(x: viewCelebSecondSlider.frame.origin.x, y: viewCelebSecondSlider.frame.origin.y, width: viewCelebSecondSlider.frame.size.width, height: widthForSecondClv + 34)
//            celebritiesSecondCollectionView.backgroundColor = UIColor.red
//            viewCelebSecondSlider.backgroundColor = UIColor.red
            
            
             layoutForSecondClv.itemSize = CGSize(width: width, height: widthForSecondClv + 34)
        }
        
        
        /////////////// Resizing Cart Collection//////////////////////////
        
        //let cartCollectionWidth = (view.frame.size.width-16-10) / 2
        let cartCollectionViewLayout = CartItemsCollectionView.collectionViewLayout as!  UICollectionViewFlowLayout
        
        var cellSize: CGSize = CartItemsCollectionView.bounds.size
        cellSize.width = ((CartItemsCollectionView.frame.size.width/2) - 8)
        
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
        
         cartCollectionViewLayout.itemSize = cellSize
        
//        viewCartItems.translatesAutoresizingMaskIntoConstraints = true
//        viewCartItems.frame = CGRect(x: viewCartItems.frame.origin.x, y: viewCartItems.frame.origin.y, width: viewCartItems.frame.size.width, height: cellSize.height)
//    
        /////////////// Resizing Shop The Look Collection //////////////////
        
        let shopCollectionWidth = (view.frame.size.width-16-10) / 2
        let shopCollectionViewLayout = shopTheLookCollectionView.collectionViewLayout as!  UICollectionViewFlowLayout
        shopCollectionViewLayout.itemSize = CGSize(width: shopCollectionWidth, height: shopCollectionWidth+20)
        
        /////////////// Resizing Video Collection//////////////////////////
        
        let videoCollectionWidth = (view.frame.size.width-16-10) / 2
        let videoCollectionViewLayout = self.VideoCollectionSection.collectionViewLayout as!  UICollectionViewFlowLayout
        videoCollectionViewLayout.itemSize = CGSize(width: videoCollectionWidth, height: videoCollectionWidth+20)
        
        
        /////////////// Resizing Category Collection//////////////////////////
        
       // let categoriestCollectionWidth = (view.frame.size.width-16-10) / 3
        let categoriesCollectionViewLayout = self.categoriesCollectionView.collectionViewLayout as!  UICollectionViewFlowLayout
        categoriesCollectionViewLayout.itemSize = CGSize(width: 172.5, height: 90)
        
        
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuShadowOpacity = 1.0
        setText()
        self.updateCartQuantityBadge()
    }
    
    @objc func updateCartQuantityBadge(){
        if let tabItems = self.tabBarController?.tabBar.items {
            // In this case we want to modify the badge number of the third tab:
            let tabItem = tabItems[4]
            
            CommonManager.shared.getCartQuantity { (quantity) in
                tabItem.badgeValue = "\(quantity)"
                tabItem.badgeColor = UIColor.quiticPink
            }
        }
    }
    
    @objc func LoginScreen(){
        
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        
        if controllerName! as! String == "Home"{
            let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
            loginViewController.pushed = 1
            
            self.navigationController?.pushViewController(loginViewController, animated: true)
        }
        
    }
    
    @objc func MyAccount(){
        
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        
        print("Controller Name: \(String(describing: controllerName))")
        
        if controllerName! as! String == "Home"{
            let brandsViewTabController = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "MyAccountViewController") as! MyAccountViewController
            self.navigationController?.pushViewController(brandsViewTabController, animated: true)
        }
        
    }
    
    @objc func faqs(){
        
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        
        if controllerName! as! String == "Home"{
            let webViewController = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
            
            webViewController.type = "faqs"
            webViewController.pushed = true
            
            self.navigationController?.pushViewController(webViewController, animated: true)
        }
        
    }
    
    @objc func goHome() {
        
        let brandsViewTabController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavController") as! HomeNavController
        self.navigationController?.pushViewController(brandsViewTabController, animated: true)
    }
    
    @objc func goToBrands(){
        print("Home Go To Brands")
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        
        print("Controller Name: \(String(describing: controllerName))")
        
        if controllerName! as! String == "Home"{
            let brandsViewTabController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "brandsViewTabController") as! BrandsViewTabController
            self.navigationController?.pushViewController(brandsViewTabController, animated: true)
        }
        
    }
    
    @objc func ContactUS(){
        print("Contact Us page")
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        
        print("Controller Name: \(String(describing: controllerName))")
        
        if controllerName! as! String == "Home"{
            let contactUsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "contactUsViewController") as! contactUsViewController
            
            
            
            self.navigationController?.pushViewController(contactUsViewController, animated: true)
            
        }
    }
    
    @objc func languagePopup(){
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        
        print("Controller Name: \(String(describing: controllerName))")
        
        if controllerName! as! String == "Home"{
            let LanguageViewController = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
            
            
            
            self.navigationController?.pushViewController(LanguageViewController, animated: true)
            
        }
    }
    
    @objc func goToShopByCategory(){
        print("goToShopByCategory called")
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        
        print("Controller Name: \(String(describing: controllerName))")
        
        if controllerName! as! String == "Home"{

            self.tabBarController?.selectedIndex = 3
        }
        
    }
    
    @objc func goToVideos(){
        print("goToShopByCategory called")
        let controllerName = UserDefaults.standard.object(forKey: "drawer")
        
        print("Controller Name: \(String(describing: controllerName))")
        
        if controllerName! as! String == "Home"{
            let TVViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TVViewController") as! TVViewController
            self.navigationController?.pushViewController(TVViewController, animated: true)
        }
    }

    
    @IBAction func drawerMenuClicked(_ sender: Any) {
        
        print("drawer menu clicked")
        
//        let sideMenuVC = view.window?.rootViewController as! LGSideMenuController
//
        UserDefaults.standard.set("Home", forKey: "drawer")
        
        if self.currentLanguage == "en"{
            self.sideMenuController?.showLeftViewAnimated()

        }
        else{
            self.sideMenuController?.showRightViewAnimated()
        
        }
        NotificationCenter.default.post(name: Notification.Name("sideMenuBadgesUpdated"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("NotifyLoginStatus"), object: nil)
        
    }
    
    @IBAction func searchBarClicked(_ sender: Any) {
        
        let desVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
        desVC.mainItems = self.categoriesCollectionlist
        desVC.filteredCellItems = self.categoriesCollectionlist
        desVC.searchType = "Categories"
        
        if currentLanguage == "en"{
            desVC.setTitle = "Search Categories"
        }
        else{
            desVC.setTitle = "البحث عن الفئات"
        }
        
        self.navigationController?.pushViewController(desVC, animated: true)
        
    }
    
    
    @IBAction func SeeAllCelebritiesClicked(_ sender: Any) {

      self.tabBarController?.selectedIndex = 2
    }
    
    
    @IBAction func SeeAllProductsClicked(_ sender: Any) {
//        let desVC = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "splitPagerProducts") as! ProductPagerViewController
       let desVC = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "BrandContainerViewController") as! BrandContainerViewController
        desVC.data = "data"

        desVC.previousData = self.categoriesCollectionlist
        desVC.selectedName = "selectedName"
        desVC.selectedId = 173
//        desVC.allId = Constant_Brands_Id
        desVC.celebName = "Celebrities Cart"
  //desVC.celebBanner = celebBanner
        
        
//        desVC.previousData = self.categoriesCollectionlist
       self.navigationController?.pushViewController(desVC, animated: true)
    }
    
    @IBAction func SeeAllBrandsClickedexclusive(_ sender: Any) {
        
        //        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //        let newViewController = storyBoard.instantiateViewController(withIdentifier: "newViewController") as! NewViewController
        //
        //        newViewController.stringVariable = stringVariable
        //
        //        self.present(newViewController, animated: true, completion: nil)
        
        
        
        let brandsViewTabController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "brandsViewTabController") as! BrandsViewTabController
        brandsViewTabController.strBrandType = "exclusive"
        
        self.navigationController?.pushViewController(brandsViewTabController, animated: true)
        
    }
    
    @IBAction func SeeAllBrandsClicked(_ sender: Any) {

//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: "newViewController") as! NewViewController
//
//        newViewController.stringVariable = stringVariable
//
//        self.present(newViewController, animated: true, completion: nil)
        
        
        
        let brandsViewTabController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "brandsViewTabController") as! BrandsViewTabController
//        brandsViewTabController.stringVariable = "exclusive"

        self.navigationController?.pushViewController(brandsViewTabController, animated: true)

    }
	
//    @IBAction func SeeAllFeaturedBrandClicked(_ sender: Any) {
//        let brandsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "brandsViewTabController") as! BrandsViewTabController
//        brandsViewController.strBrandType = "featured"
//        self.navigationController?.pushViewController(brandsViewController, animated: true)
//    }
//
//    @IBAction func SeeAllExclusiveBrandClicked(_ sender: Any) {
//        let brandsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "brandsViewTabController") as! BrandsViewTabController
//         brandsViewController.strBrandType = "exclusive"
//        self.navigationController?.pushViewController(brandsViewController, animated: true)
//    }
    @IBAction func SeeAllCategoriesClicked(_ sender: Any) {
        self.tabBarController?.selectedIndex = 3
    }
    
    @IBAction func SeeAllVideosClicked(_ sender: Any) {
        
        
        let TVViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TVViewController") as! TVViewController
        self.navigationController?.pushViewController(TVViewController, animated: true)
        
        
    }
    
    @IBAction func SeeAllShopTheLookClicked(_ sender: Any) {
        let TVViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TVViewController") as! TVViewController
        self.navigationController?.pushViewController(TVViewController, animated: true)
    }
    
    
    @IBAction func trendingNowClicked(_ sender: Any) {
        
        let ProductListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
        var tempIds: [Int] = []
        
        if self.currentLanguage == "en"{
          //  ProductListViewController.title = "Trending Now"
            ProductListViewController.setTitle = "Trending Now"
        }
        else{
          //  ProductListViewController.title = "تتجه الآن"
            ProductListViewController.setTitle = "أحدث الصيحات"
        }
        ProductListViewController.isBoolViewHeader = true
        ProductListViewController.celebId = ""
        ProductListViewController.categoryId = Constant_Trending_Now_Id
        
        tempIds.append(Constant_Trending_Now_Id)
        ProductListViewController.categoryIdArray = tempIds
        
        self.navigationController?.pushViewController(ProductListViewController, animated: true)
        
    }
    
    
    @IBAction func newProductClicked(_ sender: Any) {
        let ProductListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
        
        if self.currentLanguage == "en"{
           // ProductListViewController.title = "New Arrivals"
            ProductListViewController.setTitle = "New Arrivals"
        }
        else{
          //  ProductListViewController.title = "وصل حديثاً"
            ProductListViewController.setTitle = "وصل حديثاً"
        }

        ProductListViewController.isBoolViewHeader = true
        ProductListViewController.celebId = ""
        ProductListViewController.categoryIdArray = []
        
        self.navigationController?.pushViewController(ProductListViewController, animated: true)
    }
    
    @IBAction func posterOneClicked(_ sender: Any) {
        let ProductListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
        var tempIds: [Int] = []
        
        if self.currentLanguage == "en"{
           // ProductListViewController.title = "Special Collection"
           ProductListViewController.setTitle = "Special Collection"
        }
        else{
          //  ProductListViewController.title = "مجموعة خاصة"
            ProductListViewController.setTitle = "مجموعة خاصة"
        }
        
        ProductListViewController.isBoolViewHeader = true
        ProductListViewController.celebId = ""
        ProductListViewController.categoryId = Constant_Special_Collection_Id
        
        tempIds.append(Constant_Special_Collection_Id)
        ProductListViewController.categoryIdArray = tempIds
        
        self.navigationController?.pushViewController(ProductListViewController, animated: true)
    }
    
    
    @IBAction func posterTwoClicked(_ sender: Any) {
//        let ProductListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
//        var tempIds: [Int] = []
//
//        if self.currentLanguage == "en"{
//           // ProductListViewController.title = "Exclusive Collection"
//            ProductListViewController.setTitle = "Exclusive Collection"
//        }
//        else{
//            //ProductListViewController.title = "مجموعة حصرية"
//            ProductListViewController.setTitle = "مجموعة حصرية"
//        }
//
//        ProductListViewController.isBoolViewHeader = true
//        ProductListViewController.celebId = ""
//        ProductListViewController.categoryId = Constant_Special_Collection_Id
//
//        tempIds.append(Constant_Special_Collection_Id)
//        ProductListViewController.categoryIdArray = tempIds
//
//        self.navigationController?.pushViewController(ProductListViewController, animated: true)
        
        let brandsViewTabController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "brandsViewTabController") as! BrandsViewTabController
        self.navigationController?.pushViewController(brandsViewTabController, animated: true)
    }
    
    
    //Number of view in celebrities
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.CartItemsCollectionView{
            CommonManager.shared.noDataMessageCollectionView(collection: self.CartItemsCollectionView, message: "No Data", list: self.productsArray)
            
            return productsArray.count
        }
        if collectionView == self.shopTheLookCollectionView{

            if videos.count > 0 {
                return 2
            }
            else{
                return videos.count
            }
        }
        if (collectionView == self.BrandsCollectionView) {
            CommonManager.shared.noDataMessageCollectionView(collection: self.BrandsCollectionView, message: "No Data", list: exclusiveBrandsArray)
            return exclusiveBrandsArray.count
        }
        if (collectionView == self.featuredCollectionView)
        {
            CommonManager.shared.noDataMessageCollectionView(collection: self.featuredCollectionView, message: "No Data", list: featuredBrandsArray)
            return featuredBrandsArray.count
        }
        if collectionView == self.categoriesCollectionView{
            CommonManager.shared.noDataMessageCollectionView(collection: self.categoriesCollectionView, message: "No Data", list: self.categoriesCollectionlist)
            return categoriesCollectionlist.count
        }
        
        if collectionView == self.celebritiesFirstCollectionView{
            CommonManager.shared.noDataMessageCollectionView(collection: self.celebritiesFirstCollectionView, message: "No Data", list: self.celebritiesFirstCollectionlist)
            
            return celebritiesFirstCollectionlist.count
        }
        if collectionView == self.VideoCollectionSection{
            if self.videos.count > 2{
                return 2
            }else{
               return self.videos.count
            }
            
        }
        else{
            CommonManager.shared.noDataMessageCollectionView(collection: self.celebritiesSecondCollectionView, message: "No Data", list: self.celebritiesSecondCollectionlist)
            
            return celebritiesSecondCollectionlist.count
            
        }
    }
    

    //populate views
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.CartItemsCollectionView {
            
            print("cart index path \(indexPath)")
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "cartCell", for: indexPath) as! CartItemCollectionViewCell
            //cell.imageView.image = UIImage(named: "perfume")
            cell.reviews.isHidden = true
            cell.lblOutOfStock.text = ""
            cell.lblOutOfStock.isHidden = true
            cell.viewOuterBorder.layer.borderColor = UIColor.quiticPink.cgColor
            cell.viewOuterBorder.layer.borderWidth = 1.0
            
            cell.wishButton.setImage(UIImage(named: "heartEmpty"), for: .normal)
            
            if productsArray[indexPath.row].isWish
            {
                cell.wishButton.setImage(UIImage(named: "favor"), for: .normal)
            }
            else
            {
                cell.wishButton.setImage(UIImage(named: "heartEmpty"), for: .normal)
            }
            
            //Disable section start
            for cartItem in cartItems
            {
                if cartItem.id == productsArray[indexPath.row].id!
                {
                    print("deselect at \(cartItem.id) == \(productsArray[indexPath.row].id!)")
                    productsArray[indexPath.row].isAddedToCart = true
                }
            }
            
            if productsArray[indexPath.row].isAddedToCart
            {
                cell.addToCartBtn.backgroundColor = UIColor.darkGray
                cell.addToCartBtn.isEnabled = !productsArray[indexPath.row].isAddedToCart
                cell.checkedBtnOutlet.isHidden = false
            }
            else
            {
                cell.addToCartBtn.backgroundColor = UIColor.black
                cell.addToCartBtn.isEnabled = true
                cell.checkedBtnOutlet.isHidden = true
            }
            
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
                    cell.lblOutOfStock.isHidden = false
//                    cell.lblOutOfStock.text = "OUT OF STOCK"
                    cell.lblOutOfStock.text = "Sold Out"

                    cell.addToCartBtn.setTitle("Notify Me", for: .normal)
                }
                else
                {
                    cell.lblOutOfStock.isHidden = false
                    cell.lblOutOfStock.text = "إنتهى من المخزن"
                    cell.addToCartBtn.setTitle("اعلمني", for: .normal)
                }
            }
            
           

            //Disable section end
            cell.label.text = productsArray[indexPath.row].name
            
            if currentLanguage == "en"{
                cell.label.textAlignment = .left
                
                cell.label.font = UIFont(name: enMarselLanguageConstant, size: 13)!
                cell.price.font = UIFont(name: enLanguageConstant, size: 13)!
                cell.reviews.font = UIFont(name: enLanguageConstant, size: 10)!
                cell.addToCartBtn.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
                cell.reviews.text = "\(productsArray[indexPath.row].reviews!) Reviews"
                cell.imgNewTag.image = UIImage(named:"newTag")
            }
            else{
                cell.label.textAlignment = .right
                
                cell.label.font = UIFont(name: arLanguageConstant, size: 13)!
                cell.price.font = UIFont(name: enLanguageConstant, size: 13)!
                cell.reviews.font = UIFont(name: arLanguageConstant, size: 10)!
                cell.addToCartBtn.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
                cell.reviews.text = "\(productsArray[indexPath.row].reviews!) استعراض"
                cell.imgNewTag.image = UIImage(named:"newTagAr")
            }
            
            cell.price.text = "\(productsArray[indexPath.row].price!) JOD"
            
            if productsArray[indexPath.row].avg_rating_percent! > 0 {
                cell.ratingcosmos.rating = Double(((productsArray[indexPath.row].avg_rating_percent!*(5 - 1)) / 100)+1)
            }
            else {
                cell.ratingcosmos.rating = 0
            }
            cell.imageView?.image = UIImage(named: "ImagePlaceholder")
           

           
            //sdImageView Changes.
            
            let strImageUrl:String = PRODUCT_IMAGE_URL+(Array(productsArray[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!

            let url = URL(string:strImageUrl)

            cell.imageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)

//            BaseManager.Manager.request(PRODUCT_IMAGE_URL+(Array(productsArray[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!).responseImage { response in
//                if let image = response.result.value {
//                    cell.imageView.image = image
//                }
//                else{
//                    cell.imageView.image = UIImage(named: "ImagePlaceholder")
//                }
//            }
            
            cell.productCount.isHidden = true
            
//            //add product avalilable count
//            cell.productCount.text = Array(productsArray[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "quantity" })?.value
//
            
//            let myColor = UIColor.quiticPink
//            cell.imageSectionView.layer.borderWidth = 0.5
//            cell.imageSectionView.layer.borderColor = myColor.cgColor
            
            cell.cellDelegate=self //.CartItemsCollectionView
            cell.cellCartDelegate = self
            cell.cellCheckedBtnDelegate = self
            cell.index = indexPath

            //set brand name into product list screen. 25/06/2019
            if (productsArray[indexPath.row].custom_attributes != nil)
            {
                for custom_attribute in productsArray[indexPath.row].custom_attributes!
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
        if collectionView == self.shopTheLookCollectionView
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "shopTheLookHome", for: indexPath) as! shopTheLookCollectionViewCell
             print("shopTheLookHome :")
            if self.currentLanguage == "en"{
                cell.btnOutlet.setTitle("SHOP THE LOOK", for: .normal)
                cell.btnOutlet.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
            }
            else{
                cell.btnOutlet.setTitle("تسوق المظهر", for: .normal)
                cell.btnOutlet.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            }

            var url = ""
            if self.videos[indexPath.row] != nil {
                  url = self.videos[indexPath.row].featured_image!
            }
            else{
                 url = ""
            }
           // cell.celebImage?.image = UIImage(named: "ImagePlaceholder")
            
            
            //sdImageView Changes.
            let urlCeleImage = URL(string:url)
            
            cell.celebImage?.sd_setImage(with: urlCeleImage, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
            
            
//
//            BaseManager.Manager.request(url).responseImage { response in
//                if let image = response.result.value {
//                    cell.celebImage.image = image
//                }
//                else{
//                    cell.celebImage.image = UIImage(named: "ImagePlaceholder")
//                }
//            }

            cell.cellShopTheLookDelegate=self
            cell.index = indexPath
            
            return cell
        }
        else if collectionView == self.celebritiesFirstCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "celebRowFirst", for: indexPath) as! CelebRowFirstCollectionViewCell
            cell.celebName.text = celebritiesFirstCollectionlist[indexPath.row].name
            
            cell.celebName.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
            
            if self.currentLanguage == "en"{
                cell.celebName.font = UIFont(name: enMarselLanguageConstant, size: 12)!
            }
            else{
                cell.celebName.font = UIFont(name: arLanguageConstant, size: 12)!
            }
            
            
         //   cell.celebImage.image = UIImage(named: "ImagePlaceholder")
            
            //sdImageView Changes.
            let strImageUrl:String = CATEGORY_IMAGE_URL+(Array(celebritiesFirstCollectionlist[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!
            
            let urlCeleImage = URL(string:strImageUrl)
            
            cell.celebImage?.sd_setImage(with: urlCeleImage, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
            
            
            
//            BaseManager.Manager.request(CATEGORY_IMAGE_URL+(Array(celebritiesFirstCollectionlist[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!).responseImage { response in
//                if let image = response.result.value {
//                    cell.celebImage.image = image
//                }
//                else{
//                    cell.celebImage.image = UIImage(named: "ImagePlaceholder")
//                }
//            }

            print("else video section imges :\(CATEGORY_IMAGE_URL+(Array(celebritiesFirstCollectionlist[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!)")
            return cell
        }
        else if collectionView == self.categoriesCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "categoryCell", for: indexPath) as! CelebRowFirstCollectionViewCell
//            cell.celebName.text = categoriesCollectionlist[indexPath.row].name
			
            if self.currentLanguage == "en"{
               // cell.celebName.font = UIFont(name: enLanguageConstant, size: 12)!
            }
            else{
               // cell.celebName.font = UIFont(name: arLanguageConstant, size: 12)!
            }
            
            
//            let url = URL(string:(CATEGORY_IMAGE_URL+(Array(categoriesCollectionlist[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!))
//
//            cell.celebImage.af_setImage(withURL: url!, placeholderImage: UIImage(named: "ImagePlaceholder"), filter:nil, imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: true, completion: nil)
           // cell.celebImage.image = UIImage(named: "ImagePlaceholder")
            
            //sdImageView Changes.
            if(categoriesCollectionlist[indexPath.row].is_active!){
            let strImageUrl:String = CATEGORY_IMAGE_URL+(Array(categoriesCollectionlist[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "custom_image" })?.value)!
            
            let urlCeleImage = URL(string:strImageUrl)

            cell.celebImage?.sd_setImage(with: urlCeleImage, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
            
            
            }
            
//            BaseManager.Manager.request(CATEGORY_IMAGE_URL+(Array(categoriesCollectionlist[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!).responseImage { response in
//                if let image = response.result.value {
//                    cell.celebImage.image = image
//                }
//                else{
//                    cell.celebImage.image = UIImage(named: "ImagePlaceholder")
//                }
//            }
            
            return cell
        }
        else if collectionView == self.BrandsCollectionView
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "BrandsViewCell", for: indexPath) as! BrandsViewCell
            if (exclusiveBrandsArray[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value != nil{
//               let url = URL(string:(CATEGORY_IMAGE_URL+(Array(brandsArray[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!))
//
//                cell.brandImage.af_setImage(withURL: url!, placeholderImage: UIImage(named: "ImagePlaceholder"), filter:nil, imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: true, completion: nil)
               // cell.brandImage.image = UIImage(named: "ImagePlaceholder")
                
                //sdImageView Changes.
                let strImageUrl:String = CATEGORY_IMAGE_URL+(Array(exclusiveBrandsArray[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!
                
                let urlBrandImage = URL(string:strImageUrl)
                
                cell.brandImage?.sd_setImage(with: urlBrandImage, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
                
//                BaseManager.Manager.request(CATEGORY_IMAGE_URL+(Array(exclusiveBrandsArray[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!).responseImage { response in
//                    if let image = response.result.value {
//                        cell.brandImage.image = image
//                    }
//                    else{
//                        cell.brandImage.image = UIImage(named: "ImagePlaceholder")
//                    }
////                    cell.brandImage.image = UIImage(named: "ImagePlaceholder")
//                }
                
            }
            else{
                cell.isHidden=true
            }
            
            let myColor = UIColor.quiticPink
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = myColor.cgColor;
            return cell
        }
        else if collectionView == self.featuredCollectionView
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "BrandsViewCell", for: indexPath) as! BrandsViewCell
            if (featuredBrandsArray[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value != nil{
                //               let url = URL(string:(CATEGORY_IMAGE_URL+(Array(brandsArray[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!))
                //
                //                cell.brandImage.af_setImage(withURL: url!, placeholderImage: UIImage(named: "ImagePlaceholder"), filter:nil, imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: true, completion: nil)
                cell.brandImage.image = UIImage(named: "ImagePlaceholder")
                
                //sdImageView Changes.
                let strImageUrl:String = CATEGORY_IMAGE_URL+(Array(featuredBrandsArray[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!
                
                let urlBrandImage = URL(string:strImageUrl)
                
                cell.brandImage?.sd_setImage(with: urlBrandImage, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
                
//                BaseManager.Manager.request(CATEGORY_IMAGE_URL+(Array(featuredBrandsArray[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!).responseImage { response in
//                    if let image = response.result.value {
//                        cell.brandImage.image = image
//                    }
//                    else{
//                        cell.brandImage.image = UIImage(named: "ImagePlaceholder")
//                    }
//                    //                    cell.brandImage.image = UIImage(named: "ImagePlaceholder")
//                }
                
            }
            else{
                cell.isHidden=true
            }
            
            let myColor = UIColor.quiticPink
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = myColor.cgColor;
            return cell
        }
        else if collectionView == self.VideoCollectionSection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeVideosCell", for: indexPath) as! TVSubCollectionViewCell
            print("HomeVideosCell Section:")
            cell.title.text = self.videos[indexPath.row].title
            
            
            
            if self.currentLanguage == "en" {
                cell.title.textAlignment = .left
                cell.title.font = UIFont(name: enLanguageConstant, size: 13)!
            }
            else{
                cell.title.textAlignment = .right
                cell.title.font = UIFont(name: arLanguageConstant, size: 13)!
            }

//            let url = URL(string: self.videos[indexPath.row].featured_image!)
//
//            cell.thumbNailI.af_setImage(withURL: url!, placeholderImage: UIImage(named: "ImagePlaceholder"), filter:nil, imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: true, completion: nil)

          //  cell.thumbNailI.image = UIImage(named: "ImagePlaceholder")
            
            
            //sdImageView Changes.
            let strImageUrl:String = self.videos[indexPath.row].featured_image!
            
            let urlBrandImage = URL(string:strImageUrl)
            
            cell.thumbNailI?.sd_setImage(with: urlBrandImage, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)

//            BaseManager.Manager.request(self.videos[indexPath.row].featured_image!).responseImage { response in
//                if let image = response.result.value {
//                    cell.thumbNailI.image = image
//                }
//                else{
//                    cell.thumbNailI.image = UIImage(named: "ImagePlaceholder")
//                }
//
//            }


            var tempUrl = "https://www.youtube.com/embed/"

            if self.videos[indexPath.row].short_content != nil{
                tempUrl +=  "\(String(describing: (self.videos[indexPath.row].short_content)!))"
            }
            else{
                tempUrl += "NpG8iaM0Sfs"
            }
            cell.playBtnDelegate=self
            cell.index = indexPath
            
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "celebRowSecond", for: indexPath) as! CelebRowFirstCollectionViewCell
            cell.celebName.text = celebritiesSecondCollectionlist[indexPath.row].name
            
            cell.celebName.textColor = UIColor.init(red: 0, green: 0, blue:0, alpha: 1)
            
            if self.currentLanguage == "en" {
                cell.celebName.font = UIFont(name: enMarselLanguageConstant, size: 12)!
            }
            else{
                cell.celebName.font = UIFont(name: arLanguageConstant, size: 12)!
            }
            
//            let url = URL(string:(CATEGORY_IMAGE_URL+(Array(celebritiesSecondCollectionlist[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!))
//            
//            cell.celebImage.af_setImage(withURL: url!, placeholderImage: UIImage(named: "ImagePlaceholder"), filter:nil, imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: true, completion: nil)
//            
            cell.celebImage.image = UIImage(named: "ImagePlaceholder")
           
            //sdImageView Changes.
            let strImageUrl:String = CATEGORY_IMAGE_URL+(Array(celebritiesSecondCollectionlist[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!
            
            let urlCelebImage = URL(string:strImageUrl)
            
            cell.celebImage?.sd_setImage(with: urlCelebImage, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)

            
//            BaseManager.Manager.request(CATEGORY_IMAGE_URL+(Array(celebritiesSecondCollectionlist[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!).responseImage { response in
//                if let image = response.result.value {
//                    cell.celebImage.image = image
//                }
//                else{
//                    cell.celebImage.image = UIImage(named: "ImagePlaceholder")
//                }
//            }
            
//            cell.celebImage.layer.cornerRadius = 5
//            cell.celebImage.layer.masksToBounds = true
            return cell
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.CartItemsCollectionView
        {
            let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desVC = mainStoryBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
            if productsArray[indexPath.row].avg_rating_percent! > 0 {
                desVC.customRate = Double(((productsArray[indexPath.row].avg_rating_percent!*(5 - 1)) / 100)+1)
                
            }
            else {
                desVC.customRate = Double(0)
                
            }
            let url = URL(string:(PRODUCT_IMAGE_URL+(Array(productsArray[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!))
            
            desVC.productItem = self.productsArray[indexPath.row]
            desVC.productImageValue = url
            desVC.productImageStringValue = PRODUCT_IMAGE_URL+(Array(productsArray[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!
            desVC.productNameString = self.productsArray[indexPath.row].name!
            desVC.celebID = ""
            self.navigationController?.pushViewController(desVC, animated: true)
            
            
        }else if collectionView == celebritiesFirstCollectionView{
//            let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let desVC = mainStoryBoard.instantiateViewController(withIdentifier: "CelebDetailsViewController") as! CelebDetailsViewController
//
//            desVC.celebName = celebritiesFirstCollectionlist[indexPath.row].name!
//            desVC.celebId = celebritiesFirstCollectionlist[indexPath.row].id!
//            desVC.celebItem = celebritiesFirstCollectionlist[indexPath.row]
//
//            desVC.celebBanner = CATEGORY_IMAGE_URL+(Array(celebritiesFirstCollectionlist[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!
//
//
//            self.navigationController?.pushViewController(desVC, animated: true)
            
            //CelebDetailsViewController
            
            let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desVC = mainStoryBoard.instantiateViewController(withIdentifier: "CelebContainerViewController") as! CelebContainerViewController
            desVC.celebName = celebritiesFirstCollectionlist[indexPath.row].name!
            desVC.celebId = celebritiesFirstCollectionlist[indexPath.row].id!
            desVC.celebItem = celebritiesFirstCollectionlist[indexPath.row]
             desVC.celebBanner = CATEGORY_IMAGE_URL+(Array(self.celebritiesFirstCollectionlist[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!
            self.navigationController?.pushViewController(desVC, animated: true)
            
        }
        else if collectionView == celebritiesSecondCollectionView{
            let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desVC = mainStoryBoard.instantiateViewController(withIdentifier: "CelebContainerViewController") as! CelebContainerViewController
            
            desVC.celebName = celebritiesSecondCollectionlist[indexPath.row].name!
            desVC.celebId = celebritiesSecondCollectionlist[indexPath.row].id!
            desVC.celebItem = celebritiesSecondCollectionlist[indexPath.row]
            
            desVC.celebBanner = CATEGORY_IMAGE_URL+(Array(celebritiesSecondCollectionlist[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!
            
            self.navigationController?.pushViewController(desVC, animated: true)
        }
        else if collectionView == categoriesCollectionView {
            
            if self.self.categoriesCollectionlist[indexPath.row].children! == "" {
                
                let desVC = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "splitPagerProducts") as! ProductPagerViewController
                
                desVC.previousData = self.categoriesCollectionlist
                desVC.selectedName = self.categoriesCollectionlist[indexPath.row].name!
                desVC.selectedId = self.categoriesCollectionlist[indexPath.row].id!
                
                self.navigationController?.pushViewController(desVC, animated: true)
            } else {
                
                let subCategoryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
                
                subCategoryVC.previousData = self.categoriesCollectionlist
                subCategoryVC.selectedName = self.categoriesCollectionlist[indexPath.row].name!
                subCategoryVC.selectedId = self.categoriesCollectionlist[indexPath.row].id!
                
                self.navigationController?.pushViewController(subCategoryVC, animated: true)
            }
            
//            let desVC = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "splitPagerProducts") as! ProductPagerViewController
//
//            desVC.previousData = self.categoriesCollectionlist
////            desVC.previousType = self.searchType
//            desVC.selectedName = self.categoriesCollectionlist[indexPath.row].name!
//            desVC.selectedId = self.categoriesCollectionlist[indexPath.row].id!
//
//            print("search didselect \(indexPath.row)")
//            self.navigationController?.pushViewController(desVC, animated: true)
        }
		else if collectionView == BrandsCollectionView {

            let brandMainContainer = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "BrandMainContainerViewController") as! BrandMainContainerViewController
            
            brandMainContainer.previousData = self.exclusiveBrandsArray
            brandMainContainer.selectedName = self.exclusiveBrandsArray[indexPath.row].name!
            brandMainContainer.selectedId = self.exclusiveBrandsArray[indexPath.row].id!
            brandMainContainer.allId = Constant_Brands_Id
            brandMainContainer.celebName = exclusiveBrandsArray[indexPath.row].name!
            brandMainContainer.celebBanner = CATEGORY_IMAGE_URL+(Array(self.exclusiveBrandsArray[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!
            
            self.navigationController?.pushViewController(brandMainContainer, animated: true)
        }
        else if collectionView == featuredCollectionView {
        
            let brandMainContainer = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "BrandMainContainerViewController") as! BrandMainContainerViewController
            
            brandMainContainer.previousData = self.featuredBrandsArray
            brandMainContainer.selectedName = self.featuredBrandsArray[indexPath.row].name!
            brandMainContainer.selectedId = self.featuredBrandsArray[indexPath.row].id!
            brandMainContainer.allId = Constant_Brands_Id
            brandMainContainer.celebName = featuredBrandsArray[indexPath.row].name!
            brandMainContainer.celebBanner = CATEGORY_IMAGE_URL+(Array(self.featuredBrandsArray[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!
            
            self.navigationController?.pushViewController(brandMainContainer, animated: true)
            
        }
            
            
        else if collectionView == self.VideoCollectionSection{
            let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desVC = mainStoryBoard.instantiateViewController(withIdentifier: "VideoDetailsViewController") as! VideoViewController
            
            let url = self.videos[indexPath.row].short_content
            
            desVC.videoTitle = self.videos[indexPath.row].title!
            
            print("url: \(String(describing: url))")
            
            desVC.url = "https://www.youtube.com/embed/NpG8iaM0Sfs"
            
            desVC.videoId = Int(self.videos[indexPath.row].post_id!)!
            
            
            var tempUrl = "https://www.youtube.com/embed/"
            
            if self.videos[indexPath.row].short_content != nil{
                tempUrl +=  "\(String(describing: (self.videos[indexPath.row].short_content)!))"
            }
            else{
                tempUrl += "NpG8iaM0Sfs"
            }
            
            desVC.url = tempUrl
            
            self.navigationController?.pushViewController(desVC, animated: true)
        }
        else if collectionView == self.shopTheLookCollectionView
        {
            let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desVC = mainStoryBoard.instantiateViewController(withIdentifier: "VideoDetailsViewController") as! VideoViewController
            
            let url = self.videos[indexPath.row].short_content
            
            desVC.videoTitle = self.videos[indexPath.row].title!
            
            print("url: \(String(describing: url))")
            
            desVC.url = "https://www.youtube.com/embed/NpG8iaM0Sfs"
            
            desVC.videoId = Int(self.videos[indexPath.row].post_id!)!
            
            
            var tempUrl = "https://www.youtube.com/embed/"
            
            if self.videos[indexPath.row].short_content != nil{
                tempUrl +=  "\(String(describing: (self.videos[indexPath.row].short_content)!))"
            }
            else{
                tempUrl += "NpG8iaM0Sfs"
            }
            
            desVC.url = tempUrl
            
            self.navigationController?.pushViewController(desVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView == self.CartItemsCollectionView
        {
            
            
            var cellSize: CGSize = collectionView.bounds.size
            cellSize.width = ((CartItemsCollectionView.frame.size.width/2) - 8)
             cellSize.height = 300
            
//            var cellSize: CGSize = collectionView.bounds.size
//            cellSize.width = ((CartItemsCollectionView.frame.size.width/2) - 8)

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
            

            return cellSize
        }
        else if collectionView == self.categoriesCollectionView
        {
           return CGSize(width: 172.5, height: 90)

        }
        else if collectionView == self.VideoCollectionSection
        {
            let videoCollectionWidth = (view.frame.size.width-16-10) / 2
            let videoCollectionViewLayout = self.VideoCollectionSection.collectionViewLayout as!  UICollectionViewFlowLayout
            return CGSize(width: videoCollectionWidth, height: videoCollectionWidth+20)
        }
        else if collectionView == self.shopTheLookCollectionView
        {

            let shopCollectionWidth = (view.frame.size.width-16-10) / 2
            let shopCollectionViewLayout = shopTheLookCollectionView.collectionViewLayout as!  UICollectionViewFlowLayout
            return CGSize(width: shopCollectionWidth, height: shopCollectionWidth+20)

        }
        else if collectionView == self.celebritiesSecondCollectionView
        {
            let widthForSecondClv = (view.frame.size.width-2-1) / 3
            let layoutForSecondClv = celebritiesSecondCollectionView.collectionViewLayout as!  UICollectionViewFlowLayout


            if AppDelegate.isIPhone5W()
            {
                layoutForSecondClv.itemSize = CGSize(width: widthForSecondClv, height: widthForSecondClv + 60)
            }
            else if AppDelegate.isIPhone6W()
            {
                layoutForSecondClv.itemSize = CGSize(width: widthForSecondClv, height: widthForSecondClv + 48)
            }
            else if AppDelegate.isIPhone6PlusW()
            {
                layoutForSecondClv.itemSize = CGSize(width: widthForSecondClv, height: widthForSecondClv + 34)
            }
            else
            {

                viewCelebSecondSlider.translatesAutoresizingMaskIntoConstraints = true

                viewCelebSecondSlider.frame = CGRect(x: viewCelebSecondSlider.frame.origin.x, y: viewCelebFirstSlider.frame.origin.y + viewCelebFirstSlider.frame.size.height, width: self.view.frame.size.width, height:  300)

                layoutForSecondClv.itemSize = CGSize(width: widthForSecondClv, height: widthForSecondClv + 34)
            }

            return layoutForSecondClv.itemSize
        }
        else if collectionView == self.celebritiesFirstCollectionView
        {
            //minimize the space between cells.
            let width = (view.frame.size.width-2-1) / 3
            let layout = celebritiesFirstCollectionView.collectionViewLayout as!  UICollectionViewFlowLayout


            if AppDelegate.isIPhone5W()
            {
                layout.itemSize = CGSize(width: width, height: width + 60)
            }
            else if AppDelegate.isIPhone6W()
            {
                layout.itemSize = CGSize(width: width, height: width + 48)
            }
            else if AppDelegate.isIPhone6PlusW()
            {
                layout.itemSize = CGSize(width: width, height: width + 34)
            }
            else
            {
                viewCelebFirstSlider.translatesAutoresizingMaskIntoConstraints = true

                viewCelebFirstSlider.frame = CGRect(x: viewCelebFirstSlider.frame.origin.x, y: viewCelebFirstSlider.frame.origin.y + viewCelebFirstSlider.frame.size.height, width: self.view.frame.size.width, height:  1)
                layout.itemSize = CGSize(width: width, height: width + 34)
            }

            return layout.itemSize

        }
        else
        {
           return CGSize(width: 190, height: 100)
        }

    }


    
    func GetCelebrities(pageSize:Int = 10,currentPage:Int = 1,fieldValue:Int = 48){

        if currentPage == 1 {
            self.celebritiesFirstCollectionlist = []
            self.celebritiesSecondCollectionlist = []
        }
        
        self.celebritiesFirstCollectionView.isHidden = true
        self.celebritiesSecondCollectionView.isHidden = true
        self.shopTheLookCollectionView.isHidden = true
        
        let url = baseManager.ApiPathBuilder(apiPath: "categories/list", orderBy: "DESC", pageSize: pageSize, currentPage: currentPage, sortBy: "", conditionType: "", field: "parent_id", fieldValue: fieldValue)
        
        celebritiesManager.GetCelebritiesRequest(ApiURL : url){ (celebritiesArray, error) in
            if error == nil{
                
                dump(celebritiesArray)
                
                for (index,element) in Array((celebritiesArray?.items)!.enumerated()){
                    if index % 2 == 0{
                        self.celebritiesFirstCollectionlist.append(element);
                    }
                    else{
                        self.celebritiesSecondCollectionlist.append(element);
                    }
                }
                
                CommonManager.shared.saveSideMenuBadge(badgeName: "celebBadge", badgeTotal: (celebritiesArray?.total_count)!, completion: { (status) in
                    print("Side Menu Celeb saved:\(status)")
                    NotificationCenter.default.post(name: Notification.Name("sideMenuBadgesUpdated"), object: nil)
                })
                
                
                CommonManager.shared.saveCelebCoreData(celebItems: (celebritiesArray?.items)!, completion: { (status) in
                    print("Celebrities core saved: \(status)")
                })
                
                self.celebritiesFirstCollectionView.reloadData()
                self.celebritiesSecondCollectionView.reloadData()
                self.shopTheLookCollectionView.reloadData()
                self.celebritiesFirstCollectionView.isHidden = false
                self.celebritiesSecondCollectionView.isHidden = false
                self.shopTheLookCollectionView.isHidden = false
            }
            else{
                print(error!)
            }
        }
    }
    
    func GetBrandsCount(){
        self.brandsArray = []
        self.BrandsCollectionView.isHidden = true
        self.featuredCollectionView.isHidden = true
        brandManager.GetBrandsRequest(brandType: ""){ (data, error) in
            
            if error == nil{
               // self.brandsArray = CommonManager.shared.removeNullElement(items : (data?.items)!, attributeName : "image")
                
                CommonManager.shared.saveSideMenuBadge(badgeName: "brandsBadge", badgeTotal: (data?.total_count)!, completion: { (status) in
                    print("Side Menu Brands saved \((data?.total_count)!):\(status)")
                    NotificationCenter.default.post(name: Notification.Name("sideMenuBadgesUpdated"), object: nil)
                })
                
//                CommonManager.shared.saveBrandsCoreData(items: self.brandsArray, completion: { (status) in
//                    print("Brands core saved: \(status)")
//                })
            }
            else{
                print(error!)
            }
        }
    }
    
    
    func GetBrands(){
        self.exclusiveBrandsArray = []
        self.BrandsCollectionView.isHidden = true
        brandManager.GetBrandsRequest(brandType: "exclusive"){ (data, error) in
            
            if error == nil{
                self.exclusiveBrandsArray = CommonManager.shared.removeNullElement(items : (data?.items)!, attributeName : "image")
//
//                CommonManager.shared.saveSideMenuBadge(badgeName: "brandsBadge", badgeTotal: (data?.total_count)!, completion: { (status) in
//                    print("Side Menu Brands saved \((data?.total_count)!):\(status)")
//                    NotificationCenter.default.post(name: Notification.Name("sideMenuBadgesUpdated"), object: nil)
//                })
                
                CommonManager.shared.saveBrandsCoreData(items: self.exclusiveBrandsArray, completion: { (status) in
                    print("Brands core saved: \(status)")
                })
                
                self.BrandsCollectionView.reloadData()
                self.BrandsCollectionView.isHidden = false
				
            }
            else{
                print(error!)
            }
        }
    }
    
    func GetFeaturedBrands(){
        self.featuredBrandsArray = []
        self.featuredCollectionView.isHidden = true
        brandManager.GetBrandsRequest(brandType: "featured"){ (data, error) in
            
            if error == nil{
                self.featuredBrandsArray = CommonManager.shared.removeNullElement(items : (data?.items)!, attributeName : "image")
                
//                CommonManager.shared.saveSideMenuBadge(badgeName: "brandsBadge", badgeTotal: 11, completion: { (status) in
//                    print("Side Menu Brands saved \((data?.total_count)!):\(status)")
//                    NotificationCenter.default.post(name: Notification.Name("sideMenuBadgesUpdated"), object: nil)
//                })
//
                CommonManager.shared.saveBrandsCoreData(items: self.featuredBrandsArray, completion: { (status) in
                    print("Brands core saved: \(status)")
                })
                
                self.featuredCollectionView.reloadData()
                self.featuredCollectionView.isHidden = false
            }
            else{
                print(error!)
            }
        }
    }
    
    func GetProducts(orderBy :String,sortBy:String){
        self.CartItemsCollectionView.isHidden = true

        productsManager.GetProductsRequestByCategoryId(pageSize: 10, catId: [173], pageNo: 1, arithmaticOperator: "and", orderBy: orderBy, sortBy: sortBy, celebId: "" ) {(subCategories, error) in
            
            if error == nil{
                self.productsArray = CommonManager.shared.removeNullElement(items : (subCategories?.items!)!,attributeName : "image")
                
                dump(self.productsArray)
                CommonManager.shared.fetchFromCoreData(completion: { (data) in
                    self.cartItems = data
                    print("status cart: \(self.cartItems)")
                    self.CartItemsCollectionView.reloadData()
                    self.CartItemsCollectionView.isHidden = false
                })
            }
            else{
                print(error!)
            }
        }
    }
    
    
    func GetVideos(store_id: Int){
        print("VideoCollectionSection called")
        self.VideoCollectionSection.isHidden = true
        self.videosManager.GetVideos(type: -1, term: -1, store_id: store_id, pageNo: 1, limit: 10) { (data, error) in
            
            if error == nil{
                self.videos = (data?.posts)!
                
                //add no video found message
                
                if self.videos.count == 0
                {
                    self.lblSeeAllVideoTutorials.isHidden = true
                    self.lblNoVideoFound.isHidden = false
                    
                    self.lblSeeAllShopTheLook.isHidden = true
                    self.lblNoShopLookFound.isHidden = false

                }
                else
                {
                    self.lblSeeAllVideoTutorials.isHidden = false
                    self.lblNoVideoFound.isHidden = true
                    
                    self.lblSeeAllShopTheLook.isHidden = false
                    self.lblNoShopLookFound.isHidden = true

                }
                
                CommonManager.shared.saveSideMenuBadge(badgeName: "videosBadge", badgeTotal: (data?.total_number)!, completion: { (status) in
                    print("Side Menu Celeb saved:\(status)")
                    NotificationCenter.default.post(name: Notification.Name("sideMenuBadgesUpdated"), object: nil)
                })
                print("VideoCollectionSection reload")
                self.VideoCollectionSection.reloadData()
                self.VideoCollectionSection.isHidden = false
            }else{
                print(error!)
                self.VideoCollectionSection.isHidden = false
            }
        }
    }
    

    
    func GetCategories(pageSize:Int = 10,currentPage:Int = 1,fieldValue:Int = 2){
        self.categoriesCollectionView.isHidden = true
        
        self.pagerSliderOutlet.isHidden = true
        self.pagerSliderMid.isHidden = true
        self.pagerSliderBottom.isHidden = true
        
        celebritiesManager.GetCelebritiesRequest(ApiURL : baseManager.ApiPathBuilder(apiPath: "categories/list", orderBy: "DESC", pageSize: pageSize, currentPage: currentPage, sortBy: "", conditionType: "", field: "parent_id", fieldValue: fieldValue)){ (data, error) in
            if error == nil{
                
                
                var tempCategories: [Items] = []
                for item in (data?.items!)!{
                    if item.id != Constant_Brands_Id && item.id != Constant_Trending_Now_Id && item.id != Constant_Special_Collection_Id && item.id != Constant_Celebrities_Id{
                        
                        tempCategories.append(item)
                        
                    }
                }
                
                self.categoriesCollectionlist = CommonManager.shared.removeNullElement(items : tempCategories,attributeName : "custom_image")
                
                CommonManager.shared.saveCategoryCoreData(items: self.categoriesCollectionlist, completion: { (status) in
                    print("Categories core saved: \(status)")
                })
                
                
                self.trendingCategoriesCollectionlist = CommonManager.shared.removeNullElement(items : (data?.items)!,attributeName : "custom_image")
                
                CommonManager.shared.saveSideMenuBadge(badgeName: "categoryBadge", badgeTotal: self.categoriesCollectionlist.count, completion: { (status) in
                    print("Side Menu Celeb saved:\(status)")
                    NotificationCenter.default.post(name: Notification.Name("sideMenuBadgesUpdated"), object: nil)
                })
                self.categoriesCollectionView.reloadData()
                
                self.categoriesCollectionView.isHidden = false
            }
            else{
                print(error!)
            }
        }
    }
    
    //add for getting banner new api
//    func getBanner()
//    {
//        celebritiesManager.GetBannersRequest(ApiURL: baseManager.BannerApiPathBuilder(apiPath: "banners"))
//        { (data, error) in
//            if error == nil
//            {
//                self.allBanners = data as! [Banners]
//
//                //devide whole array into two object.
//                if self.allBanners.count > 0
//                {
//                    for i in 0...self.allBanners.count - 1
//                    {
//                        if i <= (self.allBanners.count/2)
//                        {
//
//
//                            self.firstBanner.append(self.allBanners[i])
//                        }
//                        else
//                        {
//                            self.secondBanner.append(self.allBanners[i])
//                        }
//                    }
//
//                    self.pagerSliderOutlet.reloadData()
//                    self.pagerSliderBottom.reloadData()
//
//                    self.pagerSliderOutlet.isHidden = false
//                    self.pagerSliderBottom.isHidden = false
//
//                }
//                print(self.allBanners)
//            }
//        }
//    }
//
    
    
    
    func getBanner()
    {
        celebritiesManager.GetBannersRequest(ApiURL: baseManager.BannerApiPathBuilder(apiPath: "banners"))
        { (data, error) in
            if error == nil
            {
                self.allBanners = data as! [Banners]
                
                //devide whole array into two object.
                if self.allBanners.count > 0
                {
                    for i in 0...self.allBanners.count - 1
                    {
//                            if i <= (self.allBanners.count/2)
//                            {
//
                                if(self.allBanners[i].banner_position == "top"){

                                self.firstBanner.append(self.allBanners[i])
                            }
                            
                            else
                            {
                                
                                self.secondBanner.append(self.allBanners[i])
                            }
                        
                    }
                    self.pagerSliderOutlet.reloadData()
                    self.pagerSliderBottom.reloadData()
                    
                    self.pagerSliderOutlet.isHidden = false
                    self.pagerSliderBottom.isHidden = false
                    
                }
                print(self.allBanners)
            }
        }
    }
    
    
    
    func localNotification(){
        let content = UNMutableNotificationContent()
        content.title = "My Boutique"
        content.body = "A bundle of products waiting for you!"
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        
        let request = UNNotificationRequest(identifier: "testidentitfier", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
}
extension HomeViewController :AddToCartprotocol,AddOrRemoveFromWishListprotocol, playBtnProtocol, shopTheLookBtnCLickedProtocol, ClickedCheckedprotocol, AddToCartPopupControllerDelegate {
    
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
    
    func shopTheLookBtnClicked(index: IndexPath) {
//
//        let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let desVC = mainStoryBoard.instantiateViewController(withIdentifier: "VideoDetailsViewController") as! VideoViewController
//
//        let url = self.videos[index.row].short_content
//
//        desVC.videoTitle = self.videos[index.row].title!
//
//        print("url: \(String(describing: url))")
//
//        desVC.url = "https://www.youtube.com/embed/NpG8iaM0Sfs"
//
//        desVC.videoId = Int(self.videos[index.row].post_id!)!
//
//
//        var tempUrl = "https://www.youtube.com/embed/"
//
//        if self.videos[index.row].short_content != nil{
//            tempUrl +=  "\(String(describing: (self.videos[index.row].short_content)!))"
//        }
//        else{
//            tempUrl += "NpG8iaM0Sfs"
//        }
//
//        desVC.url = tempUrl
//
//        self.navigationController?.pushViewController(desVC, animated: true)
        
    }
    
    func playBtn(index: IndexPath) {
        let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = mainStoryBoard.instantiateViewController(withIdentifier: "VideoDetailsViewController") as! VideoViewController
        
        let url = self.videos[index.row].short_content
        
        desVC.videoTitle = self.videos[index.row].title!
        
        print("url: \(String(describing: url))")
        
        desVC.url = "https://www.youtube.com/embed/NpG8iaM0Sfs"
        
        desVC.videoId = Int(self.videos[index.row].post_id!)!
        
        
        var tempUrl = "https://www.youtube.com/embed/"
        
        if self.videos[index.row].short_content != nil{
            tempUrl +=  "\(String(describing: (self.videos[index.row].short_content)!))"
        }
        else{
            tempUrl += "NpG8iaM0Sfs"
        }
        
        desVC.url = tempUrl
        
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
            
            CommonManager.shared.saveCartItem(id: productsArray[index].id!, imageUrl: url, name: productsArray[index].name!, price: productsArray[index].price!, sku: productsArray[index].sku, quote_id: productsArray[index].quote_id, quantity: 0, celebId: "") { (complete) in
                if complete {
                    productsArray[index].isAddedToCart = true
                    //                 self.CartItemsCollectionView.reloadData()
                    
                    let indexPath = IndexPath(row: index, section: 0)
                    
                    self.CartItemsCollectionView.reloadItems(at: [indexPath])
                    
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
        
       
      //MDCSnackbarManager.show(message)
    }
    
    func clickAddOrRemoveWishBtn(index: Int) {
        if  (UserDefaults.standard.string(forKey: "token") == nil) {
            let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
           self.present(loginViewController, animated: true)
        }
        
        if  (UserDefaults.standard.string(forKey: "token") != nil && !self.productsArray[index].isWish)  {
         
            APIManager.shared.PostWishProduct(productId: String(productsArray[index].id!)){(data) -> Void in
                if data["hasError"] == false {
                    
//                    self.productsArray[index].isWish = !self.productsArray[index].isWish
                    self.productsArray[index].isWish = true
                    //                    self.CartItemsCollectionView.reloadData()
                    let indexPath = IndexPath(row: index, section: 0)
                    self.CartItemsCollectionView.reloadItems(at: [indexPath])
                    let message = MDCSnackbarMessage()
//                    if self.currentLanguage == "en"{
//                        message.text = "Added to wish list"
//                    }
//                    else{
//                        message.text = "أضيف لقائمة الأماني"
//                    }
//                    MDCSnackbarManager.show(message)
                }
                else{
                    //print(data)
                    self.productsArray[index].isWish = false
                    //                    self.CartItemsCollectionView.reloadData()
                    let indexPath = IndexPath(row: index, section: 0)
                    self.CartItemsCollectionView.reloadItems(at: [indexPath])
                }
            }
        }
        else{
            if  (UserDefaults.standard.string(forKey: "token") != nil && self.productsArray[index].isWish)
            {
                DeleteWishListItem(itemId: productsArray[index].wishlistItemId , itemIndex: index)
                
//                if productsArray[index].wishlistItemId == ""
//                {
//
//                    GetWishList(itemId: String(productsArray[index].id!)) { (wishlistItemId) in
//                        if   wishlistItemId != ""{
//                            self.DeleteWishListItem(itemId: wishlistItemId , itemIndex: index)
//                        }
//                    }
//                }
//                else{
//                    DeleteWishListItem(itemId: productsArray[index].wishlistItemId , itemIndex: index)
//                }

            }
        }
    }
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
//                            item.wishlistItemId = wishlistItem.wishlist_item_id
                        }
                    }
                }
            }
            else{
//                UserDefaults.standard.removeObject(forKey:"token")
//                let message = MDCSnackbarMessage()
//                message.text = "Token Expired please again login for proceed"
//                MDCSnackbarManager.show(message)
//                let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
//                loginViewController.pushed = 1
//                self.navigationController?.pushViewController(loginViewController, animated: true)
                print(error!)
            }
        }
     
    }
    //fetch cart items start
    
    
    // fetch cart items end
    fileprivate  func DeleteWishListItem(itemId :String , itemIndex : Int){
        print("Delete Wish List Item: \(itemId)")
        self.productsArray[itemIndex].isWish = false
        let indexPath = IndexPath(row: itemIndex, section: 0)
        self.CartItemsCollectionView.reloadItems(at: [indexPath])
        
        wishManager.deleteWishList (wishlistItemId: itemId){ (wishListresponse, error) in
            
            if error == nil
            {
                //                self.GetWishList()
//                let message = MDCSnackbarMessage()
//                if self.currentLanguage == "en"
//                {
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
