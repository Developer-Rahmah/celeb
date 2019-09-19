//
//  RateReviewManager.swift
//  quitic3
//
//  Created by APPLE on 9/7/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import PromiseKit
import SwiftyJSON
import ANLoader
class RateReviewManager : BaseManager{
    
    //
    func postRateReview(postParams:Parameters , completion: @escaping (JSON) -> Void){
        self.loader(message: "Loading")
        let path = basePath + "review/mine/post"
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
        let request = sessionManager.request(path, method: .post, parameters: postParams, encoding: JSONEncoding.default, headers: customerHeaders)
        request.validate().responseJSON { (HTTPResponse) in
            if HTTPResponse.result.isSuccess {
                let data = HTTPResponse.result.value
                completion (JSON(data))
                self.disableLoader()
            }
            else{
                self.disableLoader()
                completion("nil")
            }
        }
    }
    //


}

