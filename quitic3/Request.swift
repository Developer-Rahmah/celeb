import UIKit
import Alamofire
import AlamofireObjectMapper
import PromiseKit
import SwiftyJSON

//TODO: This class uses our test integration server; please adapt it to use your own backend API.
class Request: NSObject {
    
    // Test merchant server domain
  //  static let serverDomain = "http://52.59.56.185:80"
    
    static let serverDomain = "https://celebritiescart.com"
    
    static func requestCheckoutID(amount: Double,paymentCode:String,merchantTransactionId:String , currency: String, completion: @escaping (String?) -> Void) {
        let parameters: [String:String] = [
            "amount": String(format: "%.2f", amount),
            "currency": currency,
            // Store notificationUrl on your server to change it any time without updating the app.
            "notificationUrl": serverDomain + "/notification",
            "paymentType": "DB",
            //"testMode": "INTERNAL",
            "paymentCode": paymentCode,
            "merchantTransactionId":merchantTransactionId
        ]
        var parametersString = ""
        for (key, value) in parameters {
            parametersString += key + "=" + value + "&"
        }
        parametersString.remove(at: parametersString.index(before: parametersString.endIndex))
        
        let url = serverDomain + "/rest/V1/hyperpay/token?" + parametersString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        //let request = NSURLRequest(url: URL(string: url)!)
        
        
        
        let request = BaseManager.Manager.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: CustomerHeader)
        request.validate().responseJSON { (HTTPResponse)  in
            // dump(HTTPResponse)
            if HTTPResponse.result.isSuccess {
                let data = HTTPResponse.result.value
                completion (data as! String)
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
        
        
        
//        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
//
//             let data = data.result.value
//
//            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                let checkoutID = json?["checkoutId"] as? String
//                completion(checkoutID)
//            } else {
//                completion(nil)
//            }
//            }.resume()
    
    }
    
    static func requestPaymentStatus(resourcePath: String,paymentCode: String, completion: @escaping (Array<Any>) -> Void) {
        let url = serverDomain + "/rest/V1/hyperpay" + "/status?resourcePath=" + resourcePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! + "&paymentCode=" + paymentCode.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
      //  let request = NSURLRequest(url: URL(string: url)!)
        
        
        
        let request = BaseManager.Manager.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: CustomerHeader)
        request.validate().responseJSON { (HTTPResponse)  in
            // dump(HTTPResponse)
            if HTTPResponse.result.isSuccess {
                let data = HTTPResponse.result.value
                completion (data as! Array)
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
        
        
        
        
        
//
//        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
//
//            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                let transactionStatus = json?["paymentResult"] as? String
//                completion(transactionStatus == "OK")
//            } else {
//                completion(false)
//            }
//            }.resume()
    }
}
