//
//  CheckoutManager.swift
//  quitic3
//
//  Created by APPLE on 8/2/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import PromiseKit
import SwiftyJSON
import ANLoader
class CheckoutManager : BaseManager{
    var cartId : String=""
    func postGuestCart(completion: @escaping (String) -> Void){
self.loader(message: "Loading")
        let path = basePath + "guest-carts/"
        let request = sessionManager.request(path,method: .post,headers: CustomerHeader)

        request.validate().responseString { (HTTPResponse) in
            if HTTPResponse.result.isSuccess {
                let data = HTTPResponse.result.value
                self.cartId = String(data!)
                completion (String(data!))
                self.disableLoader()
            }
            else{
                self.disableLoader()
                completion("nil")
            }        }
    }
    
    func postQuoteRequest(completion: @escaping (String) -> Void){
        self.loader(message: "Loading")
        let path = basePath + "carts/mine"
        if  (UserDefaults.standard.string(forKey: "token") != nil) {
            let authToken = (UserDefaults.standard.string(forKey: "token")!).replacingOccurrences(of: "\"", with: "")
            
            print("Mine Customer Token", authToken)
            customerHeaders = [
                "Authorization": "Bearer" + " " + authToken,
                "Content-Type": "application/json"
            ]
        }
        else{
            print("No custom token available")
        }
        
        let request = sessionManager.request(path,method: .post,headers: customerHeaders)
        
        request.validate().responseString { (HTTPResponse) in
            if HTTPResponse.result.isSuccess {
                let data = HTTPResponse.result.value
                print("data carts/mine", String(data!))
                
                self.cartId = String(data!)
                completion (String(data!))
                self.disableLoader()
            }
            else{
                self.disableLoader()
                completion("nil")
            }
        }
    }
    
    func postCheckoutCartItem(guestCartId :String , postParams:Parameters,celebId:String , completion: @escaping (JSON) -> Void){
        self.loader(message: "Loading")
        let path = basePath + "guest-carts/\(guestCartId.replacingOccurrences(of: "\"", with: ""))/items" + "?celebrityId=" + celebId
        let request = sessionManager.request(path, method: .post, parameters: postParams, encoding: JSONEncoding.default, headers: CustomerHeader)
        request.validate().responseJSON { (HTTPResponse) in
            if HTTPResponse.result.isSuccess {
                let data = HTTPResponse.result.value
                completion (JSON(data))
                self.disableLoader()
            }
            else{
                self.disableLoader()
               // print(HTTPResponse.error?.localizedDescription)
                completion("nil")
            }
        }
    }
    
    //
    func postPaymentInformation(postParams:Parameters , completion: @escaping (JSON) -> Void){
        self.loader(message: "Loading")
        let path = basePath + "carts/mine/payment-information"
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
        
        dump(postParams)
        
        let request = sessionManager.request(path, method: .post, parameters: postParams, encoding: JSONEncoding.default, headers: customerHeaders)
        request.validate().responseJSON { (HTTPResponse) in
            if HTTPResponse.result.isSuccess {
                let data = HTTPResponse.result.value
                completion (JSON(data))
                self.disableLoader()
            }
            else{
                self.disableLoader()
                print("postPaymentInformation:\(HTTPResponse.error?.localizedDescription)")
                print("what error is")
               dump(JSON(HTTPResponse))
                completion("nil")
            }
            if (HTTPResponse.error != nil) {
                dump(JSON(HTTPResponse))
            }
        }
    }
    
    func postPaymentInformationForGuest(postParams:Parameters , completion: @escaping (JSON) -> Void){
        self.loader(message: "Loading")
        let path = basePath + "carts/mine/payment-information"
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
        
        dump(postParams)
        
        let request = sessionManager.request(path, method: .post, parameters: postParams, encoding: JSONEncoding.default, headers: customerHeaders)
        request.validate().responseJSON { (HTTPResponse) in
            if HTTPResponse.result.isSuccess {
                let data = HTTPResponse.result.value
                completion (JSON(data))
                self.disableLoader()
            }
            else{
                self.disableLoader()
                print("postPaymentInformation:\(HTTPResponse.error?.localizedDescription)")
                print("what error is")
                dump(JSON(HTTPResponse))
                completion("nil")
            }
            if (HTTPResponse.error != nil) {
                dump(JSON(HTTPResponse))
            }
        }
    }
    
    
    //
    func postCustomerCheckoutCartItem(celebId :String , postParams:Parameters , completion: @escaping (JSON) -> Void){
        self.loader(message: "Loading")
        let path = basePath + "carts/mine/items" + "?celebrityId=" + celebId
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
                // print(HTTPResponse.error?.localizedDescription)
                completion("nil")
            }
        }
    }
    
    func postShippingInformation(guestCartId :String , postParams:Parameters , completion: @escaping (OrderSummaryResponse? , String?) -> Void){
        self.loader(message: "Loading")
        let path = basePath + "guest-carts/\(guestCartId.replacingOccurrences(of: "\"", with: ""))/shipping-information"
        print(path)
        let request = sessionManager.request(path, method: .post, parameters: postParams, encoding: JSONEncoding.default, headers: CustomerHeader)
        request.validate().responseObject { (HTTPResponse: DataResponse<OrderSummaryResponse> )  in
            if HTTPResponse.result.isSuccess {
                let data = HTTPResponse.result.value
                
                self.disableLoader()
                completion (data, nil)
            }
            else{
              //  print(HTTPResponse.error?.localizedDescription)
                
                self.disableLoader()
                completion(nil , HTTPResponse.error?.localizedDescription)
            }
        }
    }
    
    func postShippingMethods(guestCartId :String , completion: @escaping (JSON?) -> Void){
        self.loader(message: "Loading")
        let path = basePath + "guest-carts/\(guestCartId.replacingOccurrences(of: "\"", with: ""))/shipping-methods"
        let request = sessionManager.request(path, method: .get, encoding: JSONEncoding.default, headers: CustomerHeader)
        request.validate().responseJSON { (HTTPResponse) in
            if HTTPResponse.result.isSuccess {
                let data = HTTPResponse.result.value
                completion (JSON(data))
                self.disableLoader()
            }
            else{
                self.disableLoader()
                // print(HTTPResponse.error?.localizedDescription)
                completion("nil")
            }
        }
    }
    //Post Customer Shipping Information Start
    func postCustomerShippingInformation(quoteId :String , postParams:Parameters , completion: @escaping (OrderSummaryResponse? , String?) -> Void){
        self.loader(message: "Loading")
        let path = basePath + "carts/mine/shipping-information"
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
        
        print("postCustomerShippingInformation token",authToken)
        print("url path", path)
        dump(customerHeaders)
        
        let request = BaseManager.Manager.request(path, method: .post, parameters: postParams, encoding: JSONEncoding.default, headers: customerHeaders)
        request.validate().responseObject { (HTTPResponse: DataResponse<OrderSummaryResponse> )  in
            if HTTPResponse.result.isSuccess {
                let data = HTTPResponse.result.value
                
                print("shipping info start")
                dump(data)
                print("shipping info end")
                self.disableLoader()
                completion (data, nil)
            }
            else{
                //  print(HTTPResponse.error?.localizedDescription)
                print("shipping info end", HTTPResponse.error?.localizedDescription)
                self.disableLoader()
                completion(nil , HTTPResponse.error?.localizedDescription)
            }
        }
    }
    //Post Customer Shipping Information End
    
    func PutPlaceOrder(guestCartId :String , postParams:Parameters , completion: @escaping (JSON? , String?) -> Void){

        let path = basePath + "guest-carts/\(guestCartId.replacingOccurrences(of: "\"", with: ""))/order"
        let request = BaseManager.Manager.request(path, method: .put, parameters: postParams, encoding: JSONEncoding.default, headers: CustomerHeader)
        request.validate().responseJSON { (HTTPResponse)  in
           // dump(HTTPResponse)
            if HTTPResponse.result.isSuccess {
                let data = HTTPResponse.result.value
                completion (JSON(data), nil)
            }
            else{
                dump(JSON(HTTPResponse))
            }
            if (HTTPResponse.error != nil) {
                    let responseJSON = JSON(HTTPResponse)
                    
                    if let message: String = responseJSON["message"].stringValue {
                        if !message.isEmpty {
                            print(message)
                        }
                    }
            }
//            else{
//                print("what error is")
//                dump(HTTPResponse.message?.localizedDescription)
////                let error = HTTPResponse.result.value as! NSDictionary
////                let errorMessage = error.object(forKey: "message") as! String
////                print(errorMessage)
//                completion(nil , HTTPResponse.error?.localizedDescription)
//            }
        }
    }
}
