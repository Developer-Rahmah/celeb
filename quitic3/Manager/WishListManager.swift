//
//  WishListManager.swift
//  quitic3
//
//  Created by APPLE on 8/1/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import ANLoader
import Alamofire
import AlamofireObjectMapper
let wishListAddOrRemoveNotificationID =
"com.quitic.WishListAddOrRemoveNotificationID"
class WishListManager: BaseManager {
    
    // completion handler parmaters 1: return commentsArray 2: return If error: 3: internetConnection
    
    var baseManager = BaseManager()
    
    func fetchWishList(completion: @escaping ([WishListModel]?, String?) -> Void){
        
//        self.loader(message: "loading")
        
        let path = baseManager.ApiPathBuilder(apiPath: "wishlist/items", orderBy: "DESC", pageSize: 10, currentPage: 1, sortBy: "", conditionType: "", field: "", fieldValue: 0)
        
        if  (UserDefaults.standard.string(forKey: "token") != nil) {
            
            let authToken = (UserDefaults.standard.string(forKey: "token")!).replacingOccurrences(of: "\"", with: "")
            customerHeaders = [
                "Authorization": "Bearer" + " " + authToken,
                "Content-Type": "application/json"
            ]
        }
        else{
            print("No custom token available")
        }
        
        let request = sessionManager.request(path,headers: customerHeaders)
        
        request.validate().responseArray { (response: DataResponse<[WishListModel]> ) in
            
            if response.result.isSuccess {
                var count = 0
                for item in response.result.value! {
                    
                    print(item)
                    
                    count = count + 1
                    self.GetProductsDetail(productId: Int(item.product_id)!, completion: { (productReview, error) in
                        
                        if error == nil && productReview != nil && (productReview?.count)!>0 && productReview![0].avg_rating_percent != nil {
                            item.avg_rating_percent = Int(productReview![0].avg_rating_percent!)
                        }
                        if error == nil && (productReview?.count)!>0 && (productReview![0].reviews?.count)! > 0 {
                            item.reviews = productReview![0].reviews?.count
                        }
                        //                        item.reviews = 4
                    })
                
                }
                if count >= (response.result.value?.count)!{
                    let comments = response.result.value
//                    self.disableLoader()
                    completion (comments, nil)
                }
               
            }
            else{
//                self.disableLoader()
                UserDefaults.standard.removeObject(forKey:"token")
                completion(nil, response.error?.localizedDescription)
            }
        }
        
        
    }
    
    //DELETE Wish Product START
    func deleteWishList(wishlistItemId:String,completion: @escaping ([WishListResponse]?, String?) -> Void){
        self.loader(message: "loading")
        let path = basePath + "wishlist/delete/"+wishlistItemId
        print(path)
        let request = sessionManager.request(path,method: .delete,headers: customerHeaders)
        
        request.validate().responseArray { (response: DataResponse<[WishListResponse]> ) in
            if response.result.isSuccess {
                let data = response.result.value
                self.didWishListChange()
                self.disableLoader()
                completion (data, nil)
            }
            else{
                self.disableLoader()
                completion(nil, response.error?.localizedDescription)
            }
        }
    }
    
    //DELETE Wish Product END
    
    func didWishListChange()
    {
        NotificationCenter.default.post(name: Notification.Name(rawValue: wishListAddOrRemoveNotificationID), object: self)
    }
    // GetProductsDetail
    func GetProductsDetail(productId: Int, completion: @escaping (([ProductReview])?, String?) -> Void){
        let url = "\(API.baseURL.staging)review/reviews/\(productId)"
        let request = sessionManager.request(url,headers: API_Header)
        
        request.validate().responseArray { (response: DataResponse<[ProductReview]> ) in
            if response.result.isSuccess {
                let comments = response.result.value
                print("product data")
                dump(comments)
                completion (comments, nil)
            }
            else{
                completion(nil, response.error?.localizedDescription)
            }
        }
    }

    
    
}
