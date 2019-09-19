//
//  ContactUsManager.swift
//  quitic3
//
//  Created by APPLE on 13/09/2018.
//  Copyright © 2018 DOT. All rights reserved.
//

import Foundation
import ANLoader
import Alamofire
import AlamofireObjectMapper
import PromiseKit
import SwiftyJSON
import MaterialComponents.MaterialSnackbar

class ContactUsManager: BaseManager {
    
    func GetContactUsRequest(fullname :String , email :String , message :String ,completion: @escaping (String,String) -> Void){
        let url = Main_URL+"contactapi.php?fullname="+fullname+"&email="+email+"&message="+message
        let encodedData = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let request = sessionManager.request(encodedData!,method: .get, encoding: URLEncoding.queryString)
        
        request.validate().responseString { (HTTPResponse) in
            print("HTTPResponse\(HTTPResponse)")
            if HTTPResponse.result.isSuccess {
                let data = HTTPResponse.result.value

                completion (data!,"")
            }
            else{
                completion("","error")
            }
        }
    }
}
