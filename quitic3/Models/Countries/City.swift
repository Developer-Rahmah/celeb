//
//  City.swift
//  quitic3
//
//  Created by Admin on 02/04/19.
//  Copyright © 2019 DOT. All rights reserved.
//

import Foundation
import ObjectMapper

class Cities: Mappable {
    
    var code: String?
    var name: String?
    
    required init?(map: Map) {
        
        self.code = ""
        self.name = ""
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        
        self.code <- map["code"]
        self.name <- map["name"]
    }
}

