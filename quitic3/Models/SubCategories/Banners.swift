//
//  Banners.swift
//  quitic3
//
//  Created by ZWT on 5/1/19.
//  Copyright © 2019 DOT. All rights reserved.
//

import Foundation
import ObjectMapper


class Banners : Mappable
{
    var id : String?
    var banner : String?
    var banner_text: String?
    var banner_type: String?
    var banner_link_text: String?
    var link_id: String?
    var store_id: String?
    var children_count:Int?
    var banner_position: String?
    
    //initialize
    required init?(map: Map) {
        self.id = ""
        self.banner = ""
        self.banner_text = ""
        self.banner_type = ""
        self.banner_link_text = ""
        self.link_id = ""
        self.store_id = "1"
        self.children_count = 0
        self.banner_position = ""
    }

    func mapping(map: Map) {
        
        id <- map["id"]
        banner <- map["banner"]
        banner_text <- map["banner_text"]
        banner_type <- map["banner_type"]
        banner_link_text <- map["banner_link_text"]
        link_id <- map["link_id"]
       store_id <- map["store_id"]
        children_count <- map["children_count"]
        banner_position <- map["banner_position"]
    }
}
