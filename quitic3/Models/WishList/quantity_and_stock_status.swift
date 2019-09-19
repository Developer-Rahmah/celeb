//
//  qtyStockStatus.swift
//  quitic3
//
//  Created by ZWT on 4/15/19.
//  Copyright © 2019 DOT. All rights reserved.
//

import Foundation
import ObjectMapper

struct quantity_and_stock_status : Mappable {
    var is_in_stock : Bool?
    var qty : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        is_in_stock <- map["is_in_stock"]
        qty <- map["qty"]
    }
    
}
