//
//  Media_Gallery.swift
//  quitic3
//
//  Created by ZWT on 6/11/19.
//  Copyright © 2019 DOT. All rights reserved.
//

import Foundation
import ObjectMapper

struct media_gallery_entries : Mappable {
    var file : String?
    var types : [String]?
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        file <- map["file"]
        types <- map["types"]
    }
    
}
