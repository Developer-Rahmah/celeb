//
//  SearchViewController.swift
//  quitic3
//
//  Created by DOT on 8/7/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import SDWebImage

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    var mainItems: [Items] = []
    var filteredCellItems: [Items] = []
    var currentLanguage = "en"
    var searchType: String = ""
    var setTitle: String = ""
    var allId: Int = -1
    
    var categoryIdArray: [Int] = []
    var productPageSize = 10
    var totalPages = 1
    var pageNo = 1
    
    
    var productItems: [Items] = []
    var celebItems: [Items] = []
    var categoryItems: [Items] = []
    var brandsItems: [Items] = []
    
    struct searchObject {
        var name: String!
        var image: String!
        var type: String!
        var id: Int!
    }
    
    var mainSearchObject: [searchObject] = []
    var filteredSearchObject: [searchObject] = []
    
    var searchText: String = ""
    
    var showProductDetailsPageCheck: Bool = false
    
    let manager = ProductsManager()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    var imgViewNavCenter = UIImageView()
    var lblHeader = UILabel()
    var viewNavCenter = UIView()
    weak var parentController : UIViewController?
    
    
    override func viewDidLoad() {
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }

        super.viewDidLoad()
        self.activityIndicator.isHidden = true
        
//        ///added for navigation bar setting.
//        let imageView = UIImageView(image: UIImage(named: ""))
//        imageView.frame = CGRect(x: view.frame.size.width / 2 - 75, y: -20, width: 150, height: 100) //change height and width accordingly
//        self.navigationController?.navigationBar.addSubview(imageView)


        if currentLanguage == "en"{
           // title = "Search"
            
            let placeholderAppearance = UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self])
            placeholderAppearance.font = UIFont(name: enLanguageConstant, size: 14)
            
            let searchTextAppearance = UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
            searchTextAppearance.font = UIFont(name: enLanguageConstant, size: 14)
            searchTextAppearance.textAlignment = .left
        }
        else{
           // title = "بحث"
            
            let placeholderAppearance = UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self])
            placeholderAppearance.font = UIFont(name: arLanguageConstant, size: 14)
            
            let searchTextAppearance = UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
            searchTextAppearance.font = UIFont(name: arLanguageConstant, size: 14)
            
            searchTextAppearance.textAlignment = .right
        }
        
        
        self.searchBarOutlet.delegate = self
        
//        if self.mainItems.count <= 0 {
//            self.setSearchType(type: self.searchType)
//        }
//        else{
//            self.searchTableView.reloadData()
//        }
        
        self.getDataFromCoreData { (status) in
            if status {
                self.searchTableView.reloadData()
            }
        }
        
        
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        viewNavCenter = UIView(frame: CGRect(x: 0, y: -13, width:  (self.navigationController?.navigationBar.frame.size.width)!, height: 20))
        viewNavCenter.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.addSubview(viewNavCenter)

        
        lblHeader = UILabel.init(frame:  CGRect(x: view.frame.size.width / 2 - 75, y: -11, width: 150, height: 50))
        //lblHeader.font = UIFont.init(name: headerFont, size: 30)
        lblHeader.textAlignment = .center
        lblHeader.textColor = UIColor.init(red: 251, green: 96, blue: 127)
        
        
        if self.currentLanguage == "en"
        {
            lblHeader.text = "Search"
            lblHeader.font = UIFont.init(name: enMarselLanguageConstant, size: 23)
        }
        else
        {
            lblHeader.text = "بحث"
            lblHeader.font = UIFont.init(name: arLanguageConstant, size: 23)
        }
        
        self.navigationController?.navigationBar.addSubview(lblHeader)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        imgViewNavCenter.removeFromSuperview()
        viewNavCenter.removeFromSuperview()
        lblHeader.text = ""
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.filteredSearchObject.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchTableViewCell", for: indexPath) as! searchTableViewCell
        
        if self.filteredSearchObject[indexPath.row].type == "Product"{
          
        //sdImageView Changes.
        let strSearchObjImage:String = self.filteredSearchObject[indexPath.row].image
            
        let url = URL(string:strSearchObjImage)
            
        cell.cellImage.sd_setImage(with: url, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
            
            
//        BaseManager.Manager.request(self.filteredSearchObject[indexPath.row].image).responseImage { response in
//                if let image = response.result.value {
//                    cell.cellImage.image = image
//                }
//                else{
//                    cell.cellImage.image = UIImage(named: "ImagePlaceholder")
//                }
//            }
        }
        else{
            
            //sdImageView Changes.
            let strSearchObjImage:String = self.filteredSearchObject[indexPath.row].image
            
            let url = URL(string:strSearchObjImage)
            
            cell.cellImage.sd_setImage(with: url, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
            
//        BaseManager.Manager.request(self.filteredSearchObject[indexPath.row].image).responseImage { response in
//                if let image = response.result.value {
//                    cell.cellImage.image = image
//                }
//                else{
//                    cell.cellImage.image = UIImage(named: "ImagePlaceholder")
//                }
//
//            }
        }
        

        cell.cellLabel.text = self.filteredSearchObject[indexPath.row].name
        
        if self.currentLanguage == "en"{
            cell.cellLabel.font = UIFont(name: enLanguageConstant, size: 14)!
        }
        else{
            cell.cellLabel.font = UIFont(name: arLanguageConstant, size: 14)!
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.filteredSearchObject[indexPath.row].type == "Product" {
            let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desVC = mainStoryBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
            
            var matchedProduct: Items = Items()
            
            for match in self.productItems{
                if match.id == self.filteredSearchObject[indexPath.row].id{
                    matchedProduct = match
                }
            }
            
            let url = URL(string:self.filteredSearchObject[indexPath.row].image)
            
            desVC.productItem = matchedProduct
            //            desVC.productPrice = "\(self.productsArray[indexPath.row].price) JOD"
            desVC.productImageValue = url
            desVC.productImageStringValue = self.filteredSearchObject[indexPath.row].image
            desVC.productNameString = self.filteredSearchObject[indexPath.row].name!
            
            self.navigationController?.pushViewController(desVC, animated: true)
            
        }
        else{
            let desVC = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "splitPagerProducts") as! ProductPagerViewController
            
            
            if filteredSearchObject[indexPath.row].type == "Celebrity"{
                desVC.previousData = self.celebItems
                desVC.selectedName = self.filteredSearchObject[indexPath.row].name!
                desVC.selectedId = self.filteredSearchObject[indexPath.row].id!
            }
            else if filteredSearchObject[indexPath.row].type == "Brands"{
                desVC.previousData = self.brandsItems
                desVC.selectedName = self.filteredSearchObject[indexPath.row].name!
                desVC.selectedId = self.filteredSearchObject[indexPath.row].id!
            }
            else if filteredSearchObject[indexPath.row].type == "Category"{
                desVC.previousData = self.categoryItems
                desVC.selectedName = self.filteredSearchObject[indexPath.row].name!
                desVC.selectedId = self.filteredSearchObject[indexPath.row].id!
            }
            
            
           self.navigationController?.pushViewController(desVC, animated: true)
        }
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
//            self.filteredCellItems = self.mainItems
            self.filteredSearchObject =  []
            self.mainSearchObject = []
            self.getDataFromCoreData { (status) in
                self.searchTableView.reloadData()
            }
            
            
            return
        }
        
//        self.filteredCellItems = self.mainItems.filter({ (item) -> Bool in
//            guard let text = searchBar.text else { return false}
//            return (item.name?.lowercased().contains(text.lowercased()))!
//        })

        self.filteredSearchObject = self.mainSearchObject.filter({ (item) -> Bool in
            guard let text = searchBar.text else { return false}
            return (item.name?.lowercased().contains(text.lowercased()))!
        })
        
        self.searchTableView.reloadData()
    }
    
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBarOutlet.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBarOutlet.endEditing(true)
        print(searchBar.text!)
        
        self.searchText = searchBar.text!
        
        self.getProductsFromApi(term: searchBar.text!)
        
    }
    
    func getProductsFromApi(term: String){
        
        self.mainSearchObject = []
        self.filteredSearchObject = []
        
        self.activityIndicator.isHidden = false
        self.searchTableView.isHidden = true
        manager.GetProductsSearch(pageSize: self.productPageSize, searchTerm: term, pageNo: self.pageNo, arithmaticOperator: "and") {(subCategories, error) in

            if error == nil{

                dump(subCategories)

                if(self.pageNo == 1){
                    self.mainItems = []
                    self.filteredCellItems = []
                    
                    self.totalPages = ((subCategories?.total_count!)! + self.productPageSize - 1) / self.productPageSize
                }
                
                self.productItems = []

                self.productItems = CommonManager.shared.removeNullElement(items : (subCategories?.items)!,attributeName : "image")


                if self.productItems.count > 0 {
                    
                    for item in self.productItems{
                        if(item.is_active!){
                        self.mainItems.append(item)
                        self.filteredCellItems.append(item)
                        
                        var newObject = searchObject()
                        newObject.id = item.id
                        newObject.name = item.name
                        newObject.type = "Product"
                        newObject.image = PRODUCT_IMAGE_URL + (Array(item.custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!
                        
                        self.mainSearchObject.append(newObject)
                        self.filteredSearchObject.append(newObject)
                        
                        
                        }}

                }
                
                if self.searchText != ""{
                    self.getDataFromCoreData(completion: { (status) in
                        self.filteredSearchObject = self.mainSearchObject.filter({ (item) -> Bool in
                            let text = self.searchText
                            return (item.name?.lowercased().contains(text.lowercased()))!
                        })
                        
                        self.searchTableView.reloadData()
                        self.activityIndicator.isHidden = true
                        self.searchTableView.isHidden = false
                    })
                    
                }
                
                
            }
            else{
                print(error!)
                if self.searchText != ""{
                    self.getDataFromCoreData(completion: { (status) in
                        self.filteredSearchObject = self.mainSearchObject.filter({ (item) -> Bool in
                            let text = self.searchText
                            return (item.name?.lowercased().contains(text.lowercased()))!
                        })
                        
                        self.searchTableView.reloadData()
                        self.activityIndicator.isHidden = true
                        self.searchTableView.isHidden = false
                    })
                }
            }
        }
    }
    
    
    
    func getDataFromCoreData(completion: (_ complete: Bool) -> ()){
        
        
        CommonManager.shared.fetchCelebCoreData { (celebItems) in
            for object in celebItems{
                var newObject = searchObject()
                
                newObject.id = Int(object.id)
                newObject.name = object.name
                newObject.type = "Celebrity"
                newObject.image = object.image
                
                self.mainSearchObject.append(newObject)
                self.filteredSearchObject.append(newObject)
                
                let newItem: Items = Items()
                newItem.id = Int(object.id)
                newItem.name = object.name
                self.celebItems.append(newItem)
                
            }
            
            CommonManager.shared.fetchBrandsCoreData { (brandItems) in
                for object in brandItems{
                    var newObject = searchObject()
                    
                    newObject.id = Int(object.id)
                    newObject.name = object.name
                    newObject.type = "Brands"
                    newObject.image = object.image
                    
                    self.mainSearchObject.append(newObject)
                    self.filteredSearchObject.append(newObject)
                    
                    let newItem: Items = Items()
                    newItem.id = Int(object.id)
                    newItem.name = object.name
                    self.brandsItems.append(newItem)
                }
                
                CommonManager.shared.fetchCategoryCoreData { (catItems) in
                    for object in catItems{
                        var newObject = searchObject()
                        
                        newObject.id = Int(object.id)
                        newObject.name = object.name
                        newObject.type = "Category"
                        newObject.image = object.image
                        
                        self.mainSearchObject.append(newObject)
                        self.filteredSearchObject.append(newObject)
                        
                        let newItem: Items = Items()
                        newItem.id = Int(object.id)
                        newItem.name = object.name
                        self.categoryItems.append(newItem)
                        
                        completion(true)
                        
                    }
                }
            }
            
        }
    }
    
    
    
    

}
