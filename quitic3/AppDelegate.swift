//
//  AppDelegate.swift
//  quitic3
//
//  Created by DOT on 7/10/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import CoreData
import DropDown
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import Localize_Swift
import Alamofire
import AlamofireObjectMapper
import PromiseKit
import SwiftyJSON
import MaterialComponents.MaterialSnackbar
import IQKeyboardManagerSwift

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate{
    
    var window: UIWindow?
    var view = UIView()
    var currentLanguage: String = "en"
    var socialAccountManager = SocialAccountManager()
    var userManager = UserManager()
    let barButtonAperaince = UIBarButtonItem.appearance();
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Global Navigation Bar
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor.init(red: 251, green: 96, blue: 127)
        //        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -20.0), for: .default)
        //        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -80.0), for: .default)
        
        UIBarButtonItem.appearance().setTitlePositionAdjustment(.init(horizontal: 0, vertical: -20), for: .default)
        
        DropDown.startListeningToKeyboard()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.layoutIfNeededOnUpdate = true
        
        //Google Login
        FirebaseApp.configure()
        
        //        let navigationFont = UIFont(name: "Belleza", size: 23)!
        
        //        let navigationFontAttributes = [NSAttributedStringKey.font: navigationFont]
        //        UINavigationBar.appearance().titleTextAttributes = navigationFontAttributes
        //        UIBarButtonItem.appearance().setTitleTextAttributes(navigationFontAttributes, for: .normal)
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white]
        
        //    let backButton = UIImage(named: "back")
        //        let backButtonImage = backButton?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 10)
        //        barButtonAperaince.setBackButtonBackgroundImage(backButtonImage, for: .normal, barMetrics: .default)
        //
        //
        //        let button = UIImage(named: "back")
        //
        
        //Facebook Login
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        self.checkLanguage()
        
        
        
        return true
    }
    
    
    //    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    //        if url.scheme?.caseInsensitiveCompare("com.celebritiescart.www") == .orderedSame {
    //            // send notification to get payment status
    //            return true
    //        }
    //        return false
    //    }
    
    func checkLanguage(){
        
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
                
            }
            
            if self.currentLanguage == "en"{
                CommonManager.shared.saveCoreDataLanguage(lang: Languages.en.rawValue) { (complete) in
                    if complete {
                        UIView.appearance().semanticContentAttribute = .forceLeftToRight
                        LanguageManger.shared.setLanguage(language: Languages.en)
                        
                        let windows = UIApplication.shared.windows
                        for window in windows {
                            for view in window.subviews {
                                view.removeFromSuperview()
                                window.addSubview(view)
                            }
                        }
                        let menuLeftNavigationController = UISideMenuNavigationController()
                        menuLeftNavigationController.leftSide = true
                        
                        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Montserrat-Regular", size: 10)!], for: .normal)
                        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Montserrat-Regular", size: 10)!], for: .selected)
                        
                        NotificationCenter.default.post(name: Notification.Name(LCLLanguageChangeNotification), object: nil)
                        
                        print("Languages.en saved")
                    }
                    else{
                        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: arLanguageConstant, size: 10)!], for: .normal)
                        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: arLanguageConstant, size: 10)!], for: .selected)
                    }
                }
                
                
            }
            else{
                print("Setting language arabic from language controller")
                CommonManager.shared.saveCoreDataLanguage(lang: Languages.ar.rawValue)
                { (complete) in
                    if complete {
                        LanguageManger.shared.setLanguage(language: Languages.ar)
                        
                        let windows = UIApplication.shared.windows
                        for window in windows {
                            for view in window.subviews {
                                view.removeFromSuperview()
                                window.addSubview(view)
                            }
                        }
                        
                        NotificationCenter.default.post(name: Notification.Name(LCLLanguageChangeNotification), object: nil)
                        
                        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "GEFlow", size: 10)!], for: .normal)
                        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "GEFlow", size: 10)!], for: .selected)
                        
                        print("Languages.ar saved")
                    }else{
                        print("Languages.ar not saved")
                    }
                }
                
            }
        }
        
        
        
    }
    
    
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool
    {
        
        NotificationCenter.default.post(name:Notification.Name(rawValue: Config.asyncPaymentCompletedNotificationKey), object: nil, userInfo: nil)
        
        
        //        if url.scheme?.caseInsensitiveCompare("com.celebritiescart.www.payments") == .orderedSame
        //        {
        //            let s = UIStoryboard(name: "Main", bundle: nil)
        //            let vc = s.instantiateViewController(withIdentifier: "ConfirmOrderViewController") as! ConfirmOrderViewController
        //            vc.stringPassed = "Your order no is: \(Constant_OrderId)"
        //            self.window?.rootViewController?.present(vc, animated: true, completion: nil)
        //            return true
        //        }
        
        
        ApplicationDelegate.shared.application(application, open: url, sourceApplication: (options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String) , annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEvents.activateApp()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "quitic3")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

//extension UINavigationBar {
//
//    override open func sizeThatFits(_ size: CGSize) -> CGSize {
//        return CGSize(width: UIScreen.main.bounds.size.width, height: 180.0)
//    }
//
//}
//extension UITopBar {
//    override func sizeThatFits(size: CGSize) -> CGSize {
//        var sizeThatFits = super.sizeThatFits(size)
//        sizeThatFits.height = 38
//
//        return sizeThatFits
//    }
//}
