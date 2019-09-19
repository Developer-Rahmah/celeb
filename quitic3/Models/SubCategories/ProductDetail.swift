//
//  ProductDetail.swift
//  quitic3
//
//  Created by ZWT on 6/11/19.
//  Copyright © 2019 DOT. All rights reserved.
//

import Foundation
import ObjectMapper

class ProductDetail : Mappable
{
    var name : String?
    var parent_id : Int?
    var updated_at : String?
    var is_active : Bool?
    var level : Int?
    var include_in_menu : Bool?
    var position : Int?
    var path : String?
    var id : Int?
    var available_sort_by : [String]?
    var created_at : String?
    var children : String?
    var price : Double?
    var sku: String = ""
    var quote_id: String = ""
    var avg_rating_percent : Int?
    var reviews : Int?
    var isWish : Bool = false
    var isAddedToCart : Bool = false
    var wishlistItemId = ""
    var childCategory: [Items]?
    var media_gallery_entries : [media_gallery_entries]?
    var custom_attributes : [Custom_attributes]?

    required init?(map: Map) {
        self.name = ""
        self.parent_id = 0
        self.updated_at = ""
        self.is_active = true
        self.level = 0
        self.include_in_menu = false
        self.position = 0
        self.path = ""
        self.id = 0
        self.available_sort_by = []
        self.created_at = ""
        self.children = ""
        self.price = 0
        self.sku = ""
        self.avg_rating_percent = 0
        self.reviews = 0
        self.isWish = false
        self.isAddedToCart = false
        self.wishlistItemId = ""
        self.childCategory = []
        self.media_gallery_entries = []
        self.custom_attributes = []
    }
    
    init() {}
    required convenience init?(_ map: Map) {
        self.init()
    }
    
        func mapping(map: Map) {
        
        name <- map["name"]
        parent_id <- map["parent_id"]
        updated_at <- map["updated_at"]
        is_active <- map["is_active"]
        level <- map["level"]
        include_in_menu <- map["include_in_menu"]
        custom_attributes <- map["custom_attributes"]
        position <- map["position"]
        path <- map["path"]
        id <- map["id"]
        available_sort_by <- map["available_sort_by"]
        created_at <- map["created_at"]
        children <- map["children"]
        price <- map["price"]
        sku <- map["sku"]
        childCategory <- map["subcategories"]
        media_gallery_entries <- map["media_gallery_entries"]
        custom_attributes <- map["custom_attributes"]
        
    }
}
