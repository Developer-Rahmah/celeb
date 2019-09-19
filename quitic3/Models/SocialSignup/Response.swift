//
//  Response.swift
//  quitic3
//
//  Created by APPLE on 01/10/2018.
//  Copyright © 2018 DOT. All rights reserved.
//

import Foundation
import ObjectMapper

class Response : Mappable {
    var lastname : String?
    var created_at : String?
    var created_in : String?
    var group_id : Int?
    var firstname : String?
    var website_id : Int?
    var disable_auto_group_change : Int?
    var updated_at : String?
    var store_id : Int?
    var email : String?
    var id : Int?
    var addresses : [String]?
    init(){
    }
   required init?(map: Map) {
    self.lastname = ""
    self.created_at = ""
    self.created_in = ""
    self.group_id = 0
    self.firstname = ""
    self.website_id = 0
    self.disable_auto_group_change = 0
    self.updated_at = ""
    self.store_id = 0
    self.email = ""
    self.id = 0
    self.addresses = [""]
    }
    
     func mapping(map: Map) {
        
        lastname <- map["lastname"]
        created_at <- map["created_at"]
        created_in <- map["created_in"]
        group_id <- map["group_id"]
        firstname <- map["firstname"]
        website_id <- map["website_id"]
        disable_auto_group_change <- map["disable_auto_group_change"]
        updated_at <- map["updated_at"]
        store_id <- map["store_id"]
        email <- map["email"]
        id <- map["id"]
        addresses <- map["addresses"]
    }
    
}

