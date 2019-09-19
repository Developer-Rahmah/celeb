//
//  ProductsManager.swift
//  quitic3
//
//  Created by DOT on 8/8/18.
//  Copyright © 2018 DOT. All rights reserved.
//


import Foundation
import Alamofire
import AlamofireObjectMapper
import PromiseKit
import SwiftyJSON
import ANLoader

class ProductsManager : BaseManager{
   var wishListArray  = [WishListModel] ()
    let wishManager = WishListManager()
    
    
    func GetProductsRequestByCategoryId(pageSize:Int, catId:[Int], pageNo:Int, arithmaticOperator:String, orderBy:String , sortBy:String, lowerPrice: Int? = -1, upperPrice:Int? = -1,productsCount :Int = 0,celebId:String, completion: @escaping ((SubCategories)?, String?) -> Void){
        
       self.wishListArray = [WishListModel] ()
        
        var url = ""
        var productsCount = productsCount
        
//        upperPrice = 0
        url = ProductApiPathBuilder(apiPath: "products", orderBy: orderBy, pageSize: pageSize, currentPage: pageNo, sortBy: sortBy, conditionType: "eq", field: "category_id", fieldValue: catId, arithmaticOperator: arithmaticOperator, lowerPrice: lowerPrice, upperPrice: upperPrice,celebId:celebId)
        
        let request = sessionManager.request(url,headers: API_Header)
        
        request.validate().responseObject { (response: DataResponse<SubCategories> ) in
            
            if response.result.isSuccess {
                
                let comments = response.result.value
//               self.GetWishList()
                

//                self.wishManager.fetchWishList {
//                    (wishListArray, error) in
//
//                    if wishListArray != nil {
//
//                        self.wishListArray = [WishListModel] ()
//
//                        for wish in wishListArray!{
//
//                            self.wishListArray.append(wish)
//                        }
//                    }
//                    else{
//
//                        print(error!)
//                    }
//
                    for item in (comments?.items!)!
                    {
                        for custom_attribute in item.custom_attributes!
                        {
                            if custom_attribute.attribute_code == "is_wishlist"
                            {
                                if custom_attribute.value != ""
                                {
                                    item.isWish = true
                                    item.wishlistItemId = custom_attribute.value!
                                }
                                else
                                {
                                    item.isWish = false
                                    item.wishlistItemId = ""
                                }
                            }
                        }
                        
                        
//                        self.GetProductsDetail(productId: item.id!, completion: { (productReview, error) in
//
//                            if error == nil && productReview != nil && (productReview?.count)!>0 && productReview![0].avg_rating_percent != nil {
//
//                                item.avg_rating_percent = Int(productReview![0].avg_rating_percent!)
//                            }
//
//                            if error == nil && (productReview?.count)!>0 && (productReview![0].reviews?.count)! > 0 {
//
//                                item.reviews = productReview![0].reviews?.count
//                            }
//                            //                            productsCount++
//                            productsCount = productsCount+1
//                            print("productsCount++ =\(productsCount)")
//                            print("(comments?.items?.count)! ==  productsCount =\(productsCount)")
//
//                            if (comments?.items?.count)! ==  productsCount {
//
//                                completion (comments, nil)
//                            }
//                        })
//
//                        if self.wishListArray.count>0 {
//
//                            for wishlistItem in self.wishListArray{
//
//                                if wishlistItem.product_id == String(item.id!) {
//
//                                    item.isWish = true
//                                    item.wishlistItemId = wishlistItem.wishlist_item_id
//                                }
//                            }
//                        } else {
//
//                            item.isWish = false
//                        }
                    }
//                }
                  completion (comments, nil)
                
            } else {
                
               completion(nil, response.error?.localizedDescription)
            }
        }
    }
    func GetProductsDetail(productId: Int, completion: @escaping (([ProductReview])?, String?) -> Void){
        let url = "\(API.baseURL.staging)review/reviews/\(productId)"
        let request = sessionManager.request(url,headers: API_Header)
        
        request.validate().responseArray { (response: DataResponse<[ProductReview]> ) in
            if response.result.isSuccess {
                let comments = response.result.value
                completion (comments, nil)
            }
            else{
                completion(nil, response.error?.localizedDescription)
            }
        }
    }
    func GetProductsSearch(pageSize: Int, searchTerm: String, pageNo: Int, arithmaticOperator: String, completion: @escaping ((SubCategories)?, String?) -> Void){
        var url = ""
        url = ProductApiPathBuilder(apiPath: "products", orderBy: "DESC", pageSize: pageSize, currentPage: pageNo, sortBy: "created_at", conditionType: "like", field: "name", fieldValue: [], arithmaticOperator: arithmaticOperator, searchTerm: searchTerm, celebId: "")
        let request = sessionManager.request(url,headers: API_Header)
        request.validate().responseObject { (response: DataResponse<SubCategories> ) in
            if response.result.isSuccess {
                let comments = response.result.value
                completion (comments, nil)
            }
            else{
                completion(nil, response.error?.localizedDescription)
            }
        }
    }
    
    fileprivate  func GetWishList(){
        wishManager.fetchWishList { (wishListArray, error) in
            if wishListArray != nil{
                self.wishListArray = [WishListModel] ()
                for wish in wishListArray!{
                    self.wishListArray.append(wish)
                }
            }
            else{
                print(error!)
            }
        }
    }
    
    
    func GetRelatedProductsForVideo(fieldValues: [Int],  completion: @escaping ((SubCategories)?, String?) -> Void){
        
        var url = ""
        
        url = ProductApiPathBuilder(apiPath: "products", conditionType: "eq", field: "entity_id", fieldValue: fieldValues, arithmaticOperator: "or", celebId: "")
        let request = sessionManager.request(url,headers: API_Header)
        
        request.validate().responseObject { (response: DataResponse<SubCategories> ) in
            if response.result.isSuccess {
                let comments = response.result.value
                
                for item in (comments?.items!)!
                {
                    for custom_attribute in item.custom_attributes!
                    {
                        if custom_attribute.attribute_code == "is_wishlist"
                        {
                            if custom_attribute.value != ""
                            {
                                item.isWish = true
                                item.wishlistItemId = custom_attribute.value!
                            }
                            else
                            {
                                item.isWish = false
                                item.wishlistItemId = ""
                            }
                        }
                    }
                }
                
                completion (comments, nil)
            }
            else{
                completion(nil, response.error?.localizedDescription)
            }
        }
    }
    
    
    func GetSingleProductRequest(id :Int, completion: @escaping ((SubCategories)?, String?) -> Void){
        self.wishListArray = [WishListModel] ()
        
        var currentLanguage:String = "en"
        var url = API_URL
        
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0
            {
                currentLanguage = complete[0].name!
            }
            
            if currentLanguage != "en"{
                url = API_URL_ar
            }
            
            url += "products?searchCriteria[filterGroups][0][filters][0][field]=entity_id&searchCriteria[filterGroups][0][filters][0][value]=\(id)&searchCriteria[filterGroups][0][filters][0][conditionType]=eq"
            
            //        upperPrice = 0
            print("Single Product Url:  \(url)")
            
            let request = sessionManager.request(url,headers: API_Header)
            request.validate().responseObject { (response: DataResponse<SubCategories> ) in
                if response.result.isSuccess {
                    let product = response.result.value
                    
                    completion (product, nil)
                }
                else{
                    completion(nil, response.error?.localizedDescription)
                }
            }
            
        }
    }
    
    func GetProductsDetailImages(strSku: String, completion: @escaping (ProductDetail?,String?) -> Void){

        var url = API_URL
        
        
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0
            {
                currentLanguage = complete[0].name!
            }
            
            if currentLanguage != "en"
            {
                url = API_URL_ar
            }
        }
        
        var customerID = ""
        
        if  (UserDefaults.standard.string(forKey: "token") != nil)
        {
            CommonManager.shared.fetchUserCoreData{ (data) in
                if data.count > 0
                {
                    customerID = data[0].id!
                }
            }
        }
        
        let urlGetDetail = "\(url)products/\(strSku)?customer_id=\(customerID)"

       // let bitMapRp = CharacterSet(bitmapRepresentation: CharacterSet.urlPathAllowed.bitmapRepresentation)
        
        let request = sessionManager.request(urlGetDetail.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)

        request.validate().responseObject { (response: DataResponse<ProductDetail> ) in

            if response.result.isSuccess
            {
                let productDetail = response.result.value

                completion (productDetail, nil)
            }
            else{

                completion(nil, response.error?.localizedDescription)
            }
        }


    }

}
