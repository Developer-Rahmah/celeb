//
//  DeviceType.swift
//  quitic3
//
//  Created by ZWT on 4/9/19.
//  Copyright © 2019 DOT. All rights reserved.
//

import Foundation

extension AppDelegate {
    class func isIPhone5 () -> Bool{
        return max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) == 568.0
    }
    class func isIPhone6 () -> Bool {
        return max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) == 667.0
    }
    class func isIPhone6Plus () -> Bool {
        return max(UIScreen.main.bounds.width,UIScreen.main.bounds.height) == 736.0
    }
    class func isIPhoneX () -> Bool {
        return max(UIScreen.main.bounds.width,UIScreen.main.bounds.height) == 812.0
    }
    class func isIPad12 () -> Bool {
        return max(UIScreen.main.bounds.width,UIScreen.main.bounds.height) == 1336.0
    }
    class func isIPad10 () -> Bool {
        return max(UIScreen.main.bounds.width,UIScreen.main.bounds.height) == 834.0
    }
    class func isIPad9 () -> Bool {
        return max(UIScreen.main.bounds.width,UIScreen.main.bounds.height) == 1024.0
    }
    
    class func isIPhone5W () -> Bool{
        return max(UIScreen.main.bounds.width, UIScreen.main.bounds.width) == 320.0
    }
    class func isIPhone6W () -> Bool {
        return max(UIScreen.main.bounds.width, UIScreen.main.bounds.width) == 375.0
    }
    class func isIPhone6PlusW () -> Bool {
        return max(UIScreen.main.bounds.width,UIScreen.main.bounds.width) == 414.0
    }
    
}
