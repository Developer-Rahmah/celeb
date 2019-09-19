//
//  BannersData.swift
//  quitic3
//
//  Created by ZWT on 5/1/19.
//  Copyright © 2019 DOT. All rights reserved.
//

import Foundation
import ObjectMapper


class BannersData : Mappable
{
    var Banners:[Banners]?
    
    required init?(map: Map) {
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        Banners <- map[""]
    }
}
