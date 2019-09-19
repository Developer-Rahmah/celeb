//
//  AccountManager.swift
//  quitic3
//
//  Created by APPLE on 8/20/18.
//  Copyright © 2018 DOT. All rights reserved.
//


import Foundation
import Alamofire
import AlamofireObjectMapper
import PromiseKit
import SwiftyJSON
import ANLoader
class AccountManager : BaseManager{

    func PutForgetPassword(postParams:Parameters , completion: @escaping (JSON? , String?) -> Void){
       let path = basePath + "customers/password"
        let request = sessionManager.request(path, method: .put, parameters: postParams, encoding: JSONEncoding.default, headers: CustomerHeader)
        request.validate().responseJSON { (HTTPResponse)  in
            if HTTPResponse.result.isSuccess {
                let data = HTTPResponse.result.value
                completion (JSON(data), nil)
            }
            else{
                print(HTTPResponse.error?.localizedDescription)
                completion(nil , HTTPResponse.error?.localizedDescription)
            }
        }
    }
    
    // Put Customer info
    func PutCustomerInfo(postParams:Parameters , completion: @escaping (JSON? , String?) -> Void){
         self.loader(message: "loading")
        let path = basePath + "customers/me"
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
        let request = BaseManager.Manager.request(path, method: .put, parameters: postParams, encoding: JSONEncoding.default, headers: customerHeaders)
        request.validate().responseJSON { (HTTPResponse)  in
            if HTTPResponse.result.isSuccess {
                let data = HTTPResponse.result.value
                completion (JSON(data), nil)
            }
            else{
                print(HTTPResponse.error?.localizedDescription)
                completion(nil , HTTPResponse.error?.localizedDescription)
            }
             self.disableLoader()
        }
    }
    
    
    //send user profile picture
    
    func PostUserProfilePicture(imgArray:NSMutableArray , completion: @escaping (JSON? , String?) -> Void){
       // self.loader(message: "loading")

        let path = API_URL + "profileImage"
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

        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if(imgArray.count != 0)
            {
                for i in 0 ..< imgArray.count
                {
                    multipartFormData.append(UIImageJPEGRepresentation((imgArray.object(at: i) as! NSDictionary).object(forKey: "photo") as! (UIImage), 0.5)!, withName:((imgArray.object(at: i) as! NSDictionary).object(forKey: "key") as! NSString) as String , fileName: "img\(i+1).png", mimeType: "image/jpeg")
                }
            }
            else
            {
                
                
            }
        }, to:path,headers:customerHeaders)
        { (result) in
            
            switch result {
                
            case .failure(let encodingError):
                
                completion(nil , "HTTPResponse.error?.localizedDescription")
                
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure:
                    { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON
                    { response in
                        
                        let data = response.result.value
//
////                        let response = APIResponse(JSON: JSON)
//                        let data = JSON[RKeyData] as! NSDictionary
////                        Util.addEditBuilder(data: data)
//
//
//                        completion(data)
                         completion (JSON(data), nil)
                        
                }
            }
        }
        
        
        
        
    }
    
    
}
