//
//  SocialAccountManager.swift
//  quitic3
//
//  Created by APPLE on 9/1/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import PromiseKit
import SwiftyJSON
import ANLoader
class SocialAccountManager : BaseManager{
    
    func SignupGoogleAccount(firstname:String ,lastname:String ,email:String ,socialId:String, completion: @escaping (JSON? , String?) -> Void){
        self.loader(message: "loading")
        let path = basePath + "customers"
        let socialSignupParams: Parameters = [
            "customer":  [
                "firstname": firstname,
                "lastname":lastname,
                "email": email
            ]
        ]
        let request = sessionManager.request(path, method: .post, parameters: socialSignupParams, encoding: JSONEncoding.default)
        request.validate().responseJSON { (HTTPResponse)  in
            if HTTPResponse.result.isSuccess {
                self.disableLoader()
                let data = HTTPResponse.result.value
                completion (JSON(data), nil)
            }
            else{
                self.disableLoader()
                completion(nil , HTTPResponse.error?.localizedDescription)
            }
        }
    }
    //
    
    func SigninGoogleAccount(socialId:String ,socialType:String, completion: @escaping (JSON? , String?) -> Void){
        self.loader(message: "loading")
        let path = basePath + "integration/customer/social_token"
        let socialSignInParams: Parameters = [
            "socialId":socialId,
            "socialType": socialType
        ]

        let request = sessionManager.request(path, method: .post, parameters: socialSignInParams, encoding: JSONEncoding.default)
        request.validate().responseJSON { (HTTPResponse)  in
            if HTTPResponse.result.isSuccess {
                let data = HTTPResponse.result.value
                self.disableLoader()
                completion (JSON(data), nil)
            }
            else{
                self.disableLoader()
                completion(nil , HTTPResponse.error?.localizedDescription)
            }
        }
    }
    
    func SigninSocialAccount(socialSignInParams: String, completion: @escaping (JSON? , String?) -> Void){
        self.loader(message: "loading")
        
        let path = Main_URL + "sociallogin/login/customertoken" + socialSignInParams
        
        var headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept": "application/json"
        ]
        
        let request = sessionManager.request(path, method: .get, encoding: JSONEncoding.default, headers:headers)
        
       // let request = sessionManager.request(path, method: .post, parameters: socialSignInParams, encoding: JSONEncoding.default)//, headers:headers)
        
        request.validate().responseJSON { (HTTPResponse)  in
            if HTTPResponse.result.isSuccess {
                let data = HTTPResponse.result.value
                self.disableLoader()
                
                completion (JSON(data), nil)
            }
            else{
                self.disableLoader()
                completion(nil , HTTPResponse.error?.localizedDescription)
            }
        }
    }
    
    
    func SigninGoogleAccountWithCustomerId(socialId:String ,socialType:String ,customerId:String , completion: @escaping (JSON? , String?) -> Void){
        self.loader(message: "loading")
        let path = Main_URL+"social.php?socialId="+socialId+"&socialType="+socialType+"&customerId="+customerId
      
        let request = sessionManager.request(path, method: .post, encoding: JSONEncoding.default)
        request.validate().responseJSON { (HTTPResponse)  in
            if HTTPResponse.result.isSuccess {
                self.disableLoader()
                let data = HTTPResponse.result.value
                completion (JSON(data), nil)
            }
            else{
                self.disableLoader()
                completion(nil , HTTPResponse.error?.localizedDescription)
            }
        }
    }
}
