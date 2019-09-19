//
//  ProductReview.swift
//  quitic3
//
//  Created by APPLE on 8/24/18.
//  Copyright © 2018 DOT. All rights reserved.
//


import Foundation
import ObjectMapper

class ProductReview : Mappable {
    var avg_rating_percent : String?
    var count : Int?
    var reviews : [Reviews]?
    
   required init?(map: Map) {
    self.avg_rating_percent = ""
    self.count = 0
    self.reviews = []
    }
    
     func mapping(map: Map) {
        
        avg_rating_percent <- map["avg_rating_percent"]
        count <- map["count"]
        reviews <- map["reviews"]
    }
}
