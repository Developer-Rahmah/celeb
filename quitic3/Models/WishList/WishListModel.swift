//
//  WishListModel.swift
//  quitic3
//
//  Created by APPLE on 7/30/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import Foundation
import ObjectMapper

class WishListModel  : Mappable {
    //MARK: properties
    var product_id : String
    var qty : Int = 0
    var added_at : String
    var wishlist_item_id : String
    var description : String?
    var store_id : String
    var wishlist_id : String
    var product : Product?
    var avg_rating_percent : Int?
    var reviews : Int?
    var custom_attributes : [Custom_attributes]?
    
    
    //initialize
   required init?(map: Map) {
    self.product_id = ""
    self.qty = 0
    self.added_at = ""
    self.wishlist_item_id = ""
    self.description = ""
    self.avg_rating_percent = 0
    self.store_id = ""
    self.wishlist_id = ""
    self.reviews = 0
    self.custom_attributes = []
    //self.product = Product()
    }
    
     func mapping(map: Map) {
        product_id <- map["product_id"]
        qty <- map["qty"]
        added_at <- map["added_at"]
        wishlist_item_id <- map["wishlist_item_id"]
        description <- map["description"]
        store_id <- map["store_id"]
        wishlist_id <- map["wishlist_id"]
        product <- map["product"]
        custom_attributes <- map["custom_attributes"]
    }
    
}
