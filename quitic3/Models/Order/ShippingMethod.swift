//
//  ShippingMethod.swift
//  quitic3
//
//  Created by zealous on 27/03/19.
//  Copyright © 2019 DOT. All rights reserved.
//

import Foundation

import Foundation
import ObjectMapper


struct ShippingMethod : Mappable
{
    var methodTitle : String?
    var methodCode : String?
    var carrierCode: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        methodTitle <- map["carrier_title"]
        methodCode <- map["method_code"]
        carrierCode <- map["carrier_code"]
    }
}
