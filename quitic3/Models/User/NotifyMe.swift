//
//  NotifyMe.swift
//  quitic3
//
//  Created by ZWT on 5/15/19.
//  Copyright © 2019 DOT. All rights reserved.
//

import Foundation

import ObjectMapper

struct NotifyMe : Mappable
{
    var msg : String?
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        
        msg <- map["message"]
    }
}

