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
class UserManager : BaseManager{
    
    
    func GetUserRequest(token: String?, completion: @escaping (UserInfo?, String?) -> Void){
        
        let url = API.baseURL.staging+"customers/me"
        
        if (token != nil) {
            customerHeaders = [
                "Authorization": "Bearer" + " " + token!.replacingOccurrences(of: "\"", with: ""),
                "Content-Type": "application/json"
            ]
        }
        else{
            print("GetUserRequest token is nil :p")
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
        }
        
       // print("token: \(token!)")
        print("authToken: \(authToken)")
        print("custom header: \(customerHeaders)")
        
        let request = BaseManager.Manager.request(url,headers: customerHeaders)
        
        request.validate().responseObject { (response: DataResponse<UserInfo> ) in
            
            
            if response.result.isSuccess {
                let userinfo = response.result.value
                
                completion (userinfo, nil)
            }
            else{
                
                completion(nil, response.error?.localizedDescription)
            }
        }
    }
    
    // send NotifyInfo
    func SendNotifyInfo(productId: String,phoneNumber:String , completion: @escaping (String) -> Void){
        
        self.loader(message: "loading")
    
        
//        let path = Main_URL + "webapi/notify/notify?product_id=" + productId + "&phone_number=" + phoneNumber
        
        let path = basePath + "notifyUser"
        
        
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
        
        let postParams = ["product_id":productId,
                          "phone_number":phoneNumber]
    
        
        let request = sessionManager.request(path, method: .post, parameters: postParams, encoding: JSONEncoding.default, headers: customerHeaders)
        request.validate().responseJSON { (HTTPResponse) in
            if HTTPResponse.result.isSuccess {
                let data = HTTPResponse.result.value
                
                let dictNotifyme:NSDictionary = data as! NSDictionary
                completion (dictNotifyme.object(forKey: "message") as! String)
                self.disableLoader()
            }
            else{
                
                self.disableLoader()
                print("postPaymentInformation:\(HTTPResponse.error?.localizedDescription)")
                print("what error is")
                dump(JSON(HTTPResponse))
                completion("")
            }
            if (HTTPResponse.error != nil) {
                dump(JSON(HTTPResponse))
            }
        }
        
        
        
//
//       // let request = sessionManager.request(path,method: .delete,headers: customerHeaders)
//
//
//        let request = BaseManager.Manager.request(path, method: .post, parameters: postParams, encoding: JSONEncoding.default, headers: customerHeaders)
//        request.validate().responseJSON { (response: DataResponse<NotifyMe>)  in
//            if HTTPResponse.result.isSuccess {
//                let data = HTTPResponse.result.value
//                completion (data, nil)
//            }
//            else{
//                print(HTTPResponse.error?.localizedDescription)
//                completion(nil , HTTPResponse.error?.localizedDescription)
//            }
//            self.disableLoader()
//        }
//
//
//
        
        
//        request.validate().responseArray { (response: DataResponse<[NotifyMe]> ) in
//            if response.result.isSuccess {
//                let data = response.result.value
//                self.disableLoader()
//                completion (data, nil)
//            }
//            else{
//                self.disableLoader()
//                completion(nil, response.error?.localizedDescription)
//            }
//        }
//
//
//
//        let request = BaseManager.Manager.request(path,headers: customerHeaders)
//
//        request.validate().responseObject { (response: DataResponse<NotifyMe> ) in
//
//
//            if response.result.isSuccess {
//                let notify = response.result.value
//
//                completion (notify, nil)
//            }
//            else{
//
//                completion(nil, response.error?.localizedDescription)
//            }
//
//            self.disableLoader()
//        }
    }
    
    
    
    
}
