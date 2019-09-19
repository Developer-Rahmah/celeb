//
//  UserDefaults.swift
//  quitic3
//
//  Created by APPLE on 7/17/18.
//  Copyright © 2018 DOT. All rights reserved.
//

//import Foundation
//class  UserData{
//    
//    //MARK: Check Login
//    func setLoggedIn(value: Bool) {
//        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
//        //synchronize()
//    }
//    
//    func isLoggedIn()-> Bool {
//        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
//    }
//    
//    //MARK: Save User Data
//    func setUserID(value: Int){
//        set(value, forKey: UserDefaultsKeys.userID.rawValue)
//        //synchronize()
//    }
//    
//    //MARK: Save User Token
//    func setToken(value: String){
//        set(value, forKey: UserDefaultsKeys.token.rawValue)
//        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
//        //synchronize()
//    }
//    
//    //MARK: Retrieve User Token
//    func getToken() -> String{
//       // return String(forKey: UserDefaultsKeys.token.rawValue)
//        return UserDefaults.standard.object(forKey: UserDefaultsKeys.token.rawValue) as! String
//    }
//    
//    func removeToken(){
//       UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.token.rawValue)
//        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
//        //set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
////         UserDefaults.standard.object(forKey: UserDefaultsKeys.token.rawValue) as! String
//    }
//}

enum UserDefaultsKeys : String {
    case isLoggedIn
    case userID
    case token
}
