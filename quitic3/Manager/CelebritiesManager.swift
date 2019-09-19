//
//  CelebritiesManager.swift
//  quitic3
//
//  Created by APPLE on 8/8/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import PromiseKit
import SwiftyJSON
class CelebritiesManager : BaseManager{
    
    
    func GetCelebritiesRequest(ApiURL : String , completion: @escaping (SubCategories?, String?) -> Void){
       
        print("Celeb Url: \(ApiURL)")
        
        //GetCelebrities
        let request = BaseManager.Manager.request(ApiURL,headers: API_Header)
        
        request.validate().responseObject { (response: DataResponse<SubCategories> ) in
            
            
            if response.result.isSuccess {
                let celebrities = response.result.value
            //    self.disableLoader()
                completion (celebrities, nil)
            }
            else{
             //   self.disableLoader()
                completion(nil, response.error?.localizedDescription)
            }
        }
    }
    
    //get banner api
    func GetBannersRequest(ApiURL : String , completion: @escaping ([Banners]?, String?) -> Void){
        
        print("Celeb Url: \(ApiURL)")
        
        //GetCelebrities
        let request = BaseManager.Manager.request(ApiURL,headers: API_Header)
        request.validate().responseArray { (response: DataResponse<[Banners]> ) in
            
                
                if response.result.isSuccess {
                    let Banners = response.result.value
                    //    self.disableLoader()
                    completion (Banners, nil)
                }
                else{
                    //   self.disableLoader()
                    completion(nil, response.error?.localizedDescription)
                }
        }
    }
}
