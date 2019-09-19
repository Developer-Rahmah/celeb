//
//  API.swift
//  quitic3
//
//  Created by APPLE on 8/1/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import Foundation
internal struct API {
    //https://ecommerce.mystaging.me/rest/V1/directory/countries
    internal struct baseURL {
//        static let dev = "https://ecommerce.mystaging.me/rest/V1/"
//        static let dev_ae = "https://ecommerce.mystaging.me/rest/ae/V1/"
//        static let staging = "https://ecommerce.mystaging.me/rest/V1/"
//        static let staging_ae = "https://ecommerce.mystaging.me/rest/ae/V1/"
        
        static let dev = Main_URL+"rest/V1/"
        static let dev_ae = Main_URL+"rest/ae/V1/"
        static let staging = Main_URL+"rest/V1/"
        static let staging_ae = Main_URL+"rest/ae/V1/"
        
        static let production = ""
    }
    // static let apiKey = "----"
}
