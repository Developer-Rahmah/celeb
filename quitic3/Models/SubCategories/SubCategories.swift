//
//  SubCategories.swift
//  quitic3
//
//  Created by DOT on 7/24/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import Foundation
import ObjectMapper

class SubCategories : Mappable {
    var items : [Items]?
    var search_criteria : Search_criteria?
    var total_count : Int?
    
   required init?(map: Map) {
    items = []
    search_criteria = Search_criteria()
    total_count = 0
    }
    
    init (){
        items = []
        search_criteria = Search_criteria()
        total_count = 0
    }
    
     func mapping(map: Map) {
        
        items <- map["items"]
        search_criteria <- map["search_criteria"]
        total_count <- map["total_count"]
    }
    
}
