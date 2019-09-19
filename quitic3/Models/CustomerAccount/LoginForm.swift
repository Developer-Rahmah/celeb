//
//  LoginForm.swift
//  quitic3
//
//  Created by APPLE on 7/17/18.
//  Copyright © 2018 DOT. All rights reserved.
//


import Foundation
import ObjectMapper

struct LoginForm  {
    var email : String?
    var password: String?
    
    var dictionaryRepresentation: [String: Any] {
        return [
            "username" : email!,
            "password": password!
        ]
    }
}
