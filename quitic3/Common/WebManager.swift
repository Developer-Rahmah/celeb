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
class WebManager : BaseManager{
    
    
    func GetWebResponse(url: String, completion: @escaping (WebResponse?, String?) -> Void){
        
        
        
        let request = sessionManager.request(url,headers: API_Header)
        
        request.validate().responseObject { (response: DataResponse<WebResponse> ) in
            
            
            if response.result.isSuccess {
                let userinfo = response.result.value
                
                completion (userinfo, nil)
            }
            else{
                
                completion(nil, response.error?.localizedDescription)
            }
        }
    }
}
