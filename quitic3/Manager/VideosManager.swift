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

class VideosManager : BaseManager{
    
    let productManager = ProductsManager()
    
    func GetVideos(type:Int = -1, term:Int = -1, store_id:Int = -1, pageNo:Int = 1, limit:Int = 10, completion: @escaping ((Videos)?, String?) -> Void){
        
        //        https://ecommerce.mystaging.me/blog/post/list/:type/:term/:store_id/:page/:limit
        
        //        https://ecommerce.mystaging.me/rest/V1/blog/post/list/null/null/1/1/10
        
        var url = API.baseURL.staging+"blog/post/list"
        
        if type == -1{
            url += "/null"
        }
        
        if term == -1 {
            url += "/null"
        }
        
        if store_id != -1{
            url += "/\(store_id)"
        }
        
        url += "/\(pageNo)"
        
        url += "/\(limit)"
        
        
        print("TV videos url:", url)
        
        let request = BaseManager.Manager.request(url,headers: API_Header)
        
        request.validate().responseJSON { (response) in
            
            if response.result.isSuccess {
                  print("TV videos Success:")
                let VideosObject = Videos(JSONString: JSON(response.result.value!).rawString()!)!
                
                
                    completion(VideosObject, nil)
                
//                  completion(nil, "asas")
            }
            else{
                  print("TV videos Error:")
                completion(nil, response.error?.localizedDescription)
                  print("TV videos Error:")
            }
        }
        
        
    }
    func GetCelebVideos(storeId: Int = 1, identifier: String = "", completion: @escaping ([CelebVideos]?, String?)-> Void ){
        
        let url = API.baseURL.staging+"blog/post/videosbycategory/\(storeId)/\(identifier)"
        let request = BaseManager.Manager.request(url,headers: API_Header)
        
        
        request.validate().responseJSON { (response) in
            
            if response.result.isSuccess {
                
                dump(response.result.value!)
                
                let VideoArray:[CelebVideos] = [CelebVideos](JSONString: JSON(response.result.value!).rawString()!)!
                
                dump(VideoArray)
                completion(VideoArray, nil)
            }
            else{
                completion(nil, response.error?.localizedDescription)
            }
        }
    }
    
    func GetVideosProductIds(videoId:Int = 0, completion: @escaping (([Items])?, String?) -> Void)
    {
        var products: [Items] = []
        
        let url = API.baseURL.staging+"blog/post/productslist/\(videoId)"
        let request = BaseManager.Manager.request(url,headers: API_Header)
        
        
        request.validate().responseJSON { (response) in
            
            if response.result.isSuccess {
                
                dump(response.result.value!)
                
                let VideoProductsIdArray:[VideoProductsId] = [VideoProductsId](JSONString: JSON(response.result.value!).rawString()!)!
                
                dump(VideoProductsIdArray)
                
                
                var ids: [Int] = []
                for item in VideoProductsIdArray{
                    ids.append(Int(item.related_id!)!)
                }
                
                dump(ids)
                
                self.productManager.GetRelatedProductsForVideo(fieldValues: ids, completion: { (data, error) in
                   
                    if error == nil{
                        products = (data?.items)!
                        
                        dump(products)
                        completion(products, nil)
                    }else{
                        completion(nil, response.error?.localizedDescription)
                    }
                })
                
            }
            else{
                completion(nil, response.error?.localizedDescription)
            }
        }
    }
    
}
