//
//  SubCategoriesList.swift
//  quitic3
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 DOT. All rights reserved.
//

import Foundation
import ObjectMapper

class SubCategoriesListModel : Mappable {
    
    var entity_id : String?
    var attribute_set_id : String?
    var parent_id: String?
    var created_at: String?
    var updated_at: String?
    var path: String?
    var position: String?
    var level: String?
    var children_count: String?
    var is_active: String?
    var request_path: String?
    var name: String?
    var url_key: String?
    var is_anchor: String?
    var id: String?
    var subcategories: [ChildSubCategoriesListModel]?
    
    
    required init?(map: Map) {
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        
        entity_id <- map["entity_id"]
        attribute_set_id <- map["attribute_set_id"]
        parent_id <- map["parent_id"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        path <- map["path"]
        position <- map["position"]
        level <- map["level"]
        children_count <- map["children_count"]
        is_active <- map["is_active"]
        request_path <- map["request_path"]
        name <- map["name"]
        url_key <- map["url_key"]
        is_anchor <- map["is_anchor"]
        id <- map["id"]
        subcategories <- map["subcategories"]
    }
}

class ChildSubCategoriesListModel : Mappable {
    
    var entity_id : String?
    var attribute_set_id : String?
    var parent_id: String?
    var created_at: String?
    var updated_at: String?
    var path: String?
    var position: String?
    var level: String?
    var children_count: String?
    var is_active: String?
    var request_path: String?
    var name: String?
    var url_key: String?
    var is_anchor: String?
    
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        
        entity_id <- map["entity_id"]
        attribute_set_id <- map["attribute_set_id"]
        parent_id <- map["parent_id"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        path <- map["path"]
        position <- map["position"]
        level <- map["level"]
        children_count <- map["children_count"]
        is_active <- map["is_active"]
        request_path <- map["request_path"]
        name <- map["name"]
        url_key <- map["url_key"]
        is_anchor <- map["is_anchor"]
    }
}
