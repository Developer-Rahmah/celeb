//
//  WishListResponse.swift
//  quitic3
//
//  Created by APPLE on 8/1/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import Foundation
import ObjectMapper

class WishListResponse : Mappable {
    var message : String?
    var status : Bool?
    
   required init?(map: Map) {
        self.message=""
        self.status=false
    }
    
     func mapping(map: Map) {
        
        message <- map["message"]
        status <- map["status"]
    }
    
}
