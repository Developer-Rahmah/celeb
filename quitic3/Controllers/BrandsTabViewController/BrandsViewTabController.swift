//
//  BrandsViewController.swift
//  quitic3
//
//  Created by DOT on 7/24/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import Localize_Swift
import XLPagerTabStrip
import SDWebImage


class BrandsViewTabController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, IndicatorInfoProvider  {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "My Child title")
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var BrandsCollection: UICollectionView!
    var stringVariable = "";
    var celebritiesCollectionlist:[Items]=[Items]()
    var brandsArray  = [Items] ()
    let manager = BrandManager()
    var currentLanguage: String = "en"
    var lblHeader = UILabel()
    let labels = AppLabels()
    var strBrandType:String = ""

    let navBarTitleImage = UIImage(named: "navBarIcon")
    @objc func setText(){
        
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
        
         self.getBrands()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//  self.tabBarController?.selectedIndex = 2
        let width = (view.frame.size.width) / 3
        let layout = BrandsCollection.collectionViewLayout as!  UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        
//        var flowLayout = UICollectionViewFlowLayout()
//        let numberOfItemsPerRow = 3
//        let itemSpacing = 5.0
//        let lineSpacing = 5.0
//
        
        BrandsCollection.delegate = self
        BrandsCollection.dataSource=self
   
       // self.title = "Brands"
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //self.getBrands()
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.setText()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        lblHeader = UILabel.init(frame:  CGRect(x: 30, y: -7, width: self.view.frame.size.width - 60, height: 50))
        
        if strBrandType == "featured"
        {
            if self.currentLanguage == "en"
            {
                lblHeader.text = "Featured Brands"
            }
            else
            {
                 lblHeader.text = "ماركات مميزة"
            }
        }
        else if strBrandType == "exclusive"
        {
            if self.currentLanguage == "en"
            {
                lblHeader.text = "Exclusive Brands"
            }
            else
            {
                lblHeader.text = "العلامات التجارية الحصرية"
            }
        }
        else
        {
            lblHeader.text = labels.BRANDS
        }
        
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
   
    override func viewWillDisappear(_ animated: Bool)
    {
        lblHeader.removeFromSuperview()
    }

    
    
    @IBAction func searchBtnClicked(_ sender: Any) {
        let desVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
        desVC.mainItems = self.brandsArray
        desVC.filteredCellItems = self.brandsArray
        desVC.allId = Constant_Brands_Id
        desVC.searchType = "Brands"
        
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.brandsArray.count
    }
    
    //populate views
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "BrandsTabCollectionViewCell", for: indexPath) as! CelebTabCollectionViewCell
        
        cell.celebName.text = brandsArray[indexPath.row].name
        
        cell.layer.borderColor = UIColor.init(red: 226.0/255.0, green: 226.0/255.0, blue: 226.0/255.0, alpha: 1.0).cgColor
        cell.layer.borderWidth = 1.0
        

        if self.currentLanguage == "en"{
            cell.celebName.font = UIFont(name: enMarselLanguageConstant, size: 12)!
        }
        else{
            cell.celebName.font = UIFont(name: arLanguageConstant, size: 12)!
        }
    
        
//        let url = URL(string:(CATEGORY_IMAGE_URL+(Array(self.brandsArray[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!))
//        
//        cell.celebImage.af_setImage(withURL: url!, placeholderImage: UIImage(named: "ImagePlaceholder"), filter:nil, imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: true, completion: nil)
        
        
        //sdImageView Changes.
        let strCelebImageImage:String = CATEGORY_IMAGE_URL+(Array(self.brandsArray[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!
        
        let url = URL(string:strCelebImageImage)
        
        cell.celebImage.sd_setImage(with: url, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
        
//        BaseManager.Manager.request(CATEGORY_IMAGE_URL+(Array(self.brandsArray[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!).responseImage { response in
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
//        let desVC = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "splitPagerProducts") as! ProductPagerViewController
//
//        desVC.previousData = self.brandsArray
//        desVC.selectedName = self.brandsArray[indexPath.row].name!
//        desVC.selectedId = self.brandsArray[indexPath.row].id!
//        desVC.allId = Constant_Brands_Id
//
//        print("search didselect \(indexPath.row)")
//        self.navigationController?.pushViewController(desVC, animated: true)
//
//
        
        let brandContainer = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "BrandMainContainerViewController") as! BrandMainContainerViewController
        
        brandContainer.previousData = self.brandsArray
        brandContainer.selectedName = self.brandsArray[indexPath.row].name!
        brandContainer.selectedId = self.brandsArray[indexPath.row].id!
        brandContainer.allId = Constant_Brands_Id
        brandContainer.celebName = brandsArray[indexPath.row].name!
        brandContainer.celebBanner = CATEGORY_IMAGE_URL+(Array(self.brandsArray[indexPath.row].custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!

        
        //  categoryPager.view.frame = self.view.bounds
       // self.addChildViewController(brandContainer)
       // self.view.addSubview(brandContainer.view)
      //  brandContainer.didMove(toParentViewController: self)
        
        self.navigationController?.pushViewController(brandContainer, animated: true)
    
    }
    
    func getBrands(){
        
        print("Get Brands Tab function called");
        var a = self.strBrandType
        self.BrandsCollection.isHidden = true
        manager.GetBrandsRequest(brandType: a){ (data, error) in
            
            if error == nil
            {
                self.activityIndicator.isHidden = true
                self.brandsArray = CommonManager.shared.removeNullElement(items : (data?.items)!,attributeName : "image")
                
                            self.BrandsCollection.reloadData()
                            self.BrandsCollection.isHidden = false
            }
            else{
                print(error!)
            }
        }
    }
}
