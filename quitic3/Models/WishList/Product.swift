//
//  Product.swift
//  quitic3
//
//  Created by APPLE on 7/31/18.
//  Copyright © 2018 DOT. All rights reserved.
//


import Foundation
import ObjectMapper

class Product : Mappable {
    var small_image : String?
    var name : String?
    var updated_at : String?
    var thumbnail : String?
    var has_options : String?
    var visibility : String?
    var price : String?
    var sku : String?
    var attribute_set_id : String?
    var min_price : String?
    var entity_id : String?
    var request_path : String?
    var type_id : String?
    var required_options : String?
    var tier_price : String?
    var minimal_price : String?
    var tax_class_id : String?
    var final_price : String?
    var created_at : String?
    var max_price : String?
    var quantity_and_stock_status : quantity_and_stock_status?
    
   required init?(map: Map) {
     self.small_image = ""
     self.name  = ""
     self.updated_at = ""
     self.thumbnail = ""
     self.has_options = ""
     self.visibility = ""
     self.price = ""
     self.sku = ""
     self.attribute_set_id = ""
     self.min_price = ""
     self.entity_id = ""
     self.request_path = ""
     self.type_id = ""
     self.required_options = ""
     self.tier_price = ""
     self.minimal_price = ""
     self.tax_class_id = ""
     self.final_price = ""
     self.created_at = ""
     self.max_price = ""
    }
    
     func mapping(map: Map) {
        
        small_image <- map["small_image"]
        name <- map["name"]
        updated_at <- map["updated_at"]
        thumbnail <- map["thumbnail"]
        has_options <- map["has_options"]
        visibility <- map["visibility"]
        price <- map["price"]
        sku <- map["sku"]
        attribute_set_id <- map["attribute_set_id"]
        min_price <- map["min_price"]
        entity_id <- map["entity_id"]
        request_path <- map["request_path"]
        type_id <- map["type_id"]
        required_options <- map["required_options"]
        tier_price <- map["tier_price"]
        minimal_price <- map["minimal_price"]
        tax_class_id <- map["tax_class_id"]
        final_price <- map["final_price"]
        created_at <- map["created_at"]
        max_price <- map["max_price"]
        quantity_and_stock_status <- map["quantity_and_stock_status"]
    }
    
}

