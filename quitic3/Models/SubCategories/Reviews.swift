//
//  Reviews.swift
//  quitic3
//
//  Created by APPLE on 8/24/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import Foundation
import ObjectMapper

class Reviews : Mappable {
    var review_id : String?
    var created_at : String?
    var entity_id : String?
    var entity_pk_value : String?
    var status_id : String?
    var detail_id : String?
    var title : String?
    var detail : String?
    var nickname : String?
    var customer_id : String?
    var entity_code : String?
    var rating_votes : [String]?
    
   required init?(map: Map) {
    self.review_id = ""
    self.created_at = ""
    self.entity_id = ""
    self.entity_pk_value = ""
    self.status_id = ""
    self.detail_id = ""
    self.title = ""
    self.detail = ""
    self.nickname = ""
    self.customer_id = ""
    self.entity_code = ""
    self.rating_votes = []
    }
    
     func mapping(map: Map) {
        
        review_id <- map["review_id"]
        created_at <- map["created_at"]
        entity_id <- map["entity_id"]
        entity_pk_value <- map["entity_pk_value"]
        status_id <- map["status_id"]
        detail_id <- map["detail_id"]
        title <- map["title"]
        detail <- map["detail"]
        nickname <- map["nickname"]
        customer_id <- map["customer_id"]
        entity_code <- map["entity_code"]
        rating_votes <- map["rating_votes"]
    }
}
