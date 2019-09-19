//
//  WishListTranslate.swift
//  quitic3
//
//  Created by APPLE on 7/31/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import Foundation
//WishListTranslate
import ObjectMapper
struct Json4Swift_Base : Mappable {
    //MARK: properties
    var product_id : String?
    var qty : Int?
    var added_at : String?
    var wishlist_item_id : String?
    var description : String?
    var store_id : String?
    var wishlist_id : String?
    var product : Product?
   
    
    //initialize
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        print("map")
        print(map["product_id"])
        product_id <- map["product_id"]
        qty <- map["qty"]
        added_at <- map["added_at"]
        wishlist_item_id <- map["wishlist_item_id"]
        description <- map["description"]
        store_id <- map["store_id"]
        wishlist_id <- map["wishlist_id"]
        product <- map["product"]
    }
    
}
