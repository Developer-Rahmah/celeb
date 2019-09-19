//
//  SocialSignupModel.swift
//  quitic3
//
//  Created by APPLE on 01/10/2018.
//  Copyright © 2018 DOT. All rights reserved.
//

import Foundation
import ObjectMapper

class SocialSignupModel : Mappable {
    var response : Response?
    var hasError : Bool?
    
   required init?(map: Map) {
    self.response = nil
    self.hasError = false
    }
    init(){
    }
    
     func mapping(map: Map) {
        
        response <- map["response"]
        hasError <- map["hasError"]
    }
    
}
