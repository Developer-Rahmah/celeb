//
//  CommonManger.swift
//  quitic3
//
//  Created by APPLE on 7/24/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Localize_Swift

class CommonManager {
       var currentLanguage = ""
    static let shared = CommonManager()
    init() {
        self.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
    }
    
    func removeNullElement(items:[Items],attributeName:String) -> [Items] {
        var list:[Items] = items
        var tempList:[Items] = []
       
        for (index,element) in Array(items.enumerated())
        {
            
            if element.custom_attributes?.first(where: { $0.attribute_code! == attributeName }) != nil
            {
                 if(element.is_active!){
                tempList.insert(list[index], at: tempList.endIndex)
                }}
        }
        return tempList
    }
    
    
    func removeNullElementDetail(items:[ProductDetail],attributeName:String) -> [ProductDetail] {
        var list:[ProductDetail] = items
        var tempList:[ProductDetail] = []
        for (index,element) in Array(items.enumerated()){
            if element.custom_attributes?.first(where: { $0.attribute_code! == attributeName }) != nil{
                tempList.insert(list[index], at: tempList.endIndex)
            }
        }
        return tempList
    }
    
    
    func removeNullElementSubVideos(items:[ItemsVideoList],attributeNames:[String]) -> [ItemsVideoList] {
        var list:[ItemsVideoList] = items
        var tempList:[ItemsVideoList] = []
        
        var index = 0
        for item in list{
            var check = 0
            if (item.custom_attributes != nil) {
                for attribute in attributeNames{
                    for custom_attribute in item.custom_attributes!{
                        if custom_attribute.attribute_code == attribute {
                            check += 1
                        }
                    }
                }
            }
            if check == attributeNames.count {
                tempList.insert(list[index], at: tempList.endIndex)
            }
            index = index + 1
        }
        
        return tempList
    }
    
    func addLeftImageToTextFields(txtField: UITextField, txtImg: UIImage){
        txtField.leftViewMode = .always
        var imageView = UIImageView(frame: CGRect(x: 12, y: 5, width: 20, height: 20))
        
        
        self.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
                
                if self.currentLanguage != "en"{
                    imageView = UIImageView(frame: CGRect(x: 2, y: 5, width: 20, height: 20))
                }
                else{
                }
                
                
                imageView.image = txtImg
                imageView.tintColor = UIColor.textPrimaryColor
                
                let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                
                view.addSubview(imageView)
                
                txtField.leftView = view
            }
        }
    }
    
    func activityIndicatorCommon(activityIndicator: UIActivityIndicatorView, view: UIView){
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
    }
    
    func videoUrlMaker(url: String) -> String{
        let result = url.split(separator: "/")
        let lastElement = result[result.endIndex - 1].split(separator: "=")
        let id = lastElement[lastElement.endIndex - 1]
        return "https://www.youtube.com/embed/\(id)"
    }
    
    
    func saveCartItem(id: Int, imageUrl: String, name: String, price: Double, sku: String, quote_id: String, quantity: Int,celebId:String?, completion: (_ finished: Bool)->()){
        var cartItems: [CartItem] = []
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItem")
        
        var itemIndexMatched = -1
        
        do{
            cartItems = try managedContext.fetch(fetchRequest) as! [CartItem]
            var index = 0
            for cartItem in cartItems{
                if cartItem.id == id {
                    itemIndexMatched = index
                }
                index += 1
            }
        }catch{
            debugPrint("Could not fetch: \(error.localizedDescription)")
        }
        
        if itemIndexMatched == -1{
            let cartItem = CartItem(context: managedContext)
            cartItem.id = Int32(id)
            cartItem.imageUrl = imageUrl
            cartItem.name = name
            cartItem.price = price
            cartItem.sku = sku
            cartItem.quote_id = quote_id
            cartItem.quantity = 1
            cartItem.celebrityId = celebId
        
            
            do{
                try managedContext.save()
                
                
                NotificationCenter.default.post(name: Notification.Name("updateCartQuantityBadge"), object: nil)
                
                completion(true)
            } catch {
                debugPrint("Could not save:\(error.localizedDescription)")
                completion(false)
            }
        }else{
            let choosenCartItem = cartItems[itemIndexMatched]
            
            choosenCartItem.quantity += 1
            
            do{
                try managedContext.save()
                completion(true)
                
            }catch{
                completion(false)
            }
        }
        
    }
    
    func getCartQuantity(completion: (_ totalQuantity: Int)->()){
        var cartItems: [CartItem] = []
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItem")
        
        do{
            cartItems = try managedContext.fetch(fetchRequest) as! [CartItem]
            var totalQuantity: Int = 0
            for cartItem in cartItems{
                totalQuantity = totalQuantity + Int(cartItem.quantity)
            }
            
            completion(totalQuantity)
        }catch{
            completion(0)
            debugPrint("Could not fetch: \(error.localizedDescription)")
        }

    }
    
    
    // Save Address Information
    func saveAddress(region: String, region_id: String, country_id: String, postcode: String, city: String, firstname: String, lastname: String,region_code:String,street:String, email:String, telePhone:String, completion: (_ finished: Bool)->()){
        var addressInformation: [AddressInformation] = []
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AddressInformation")
        
     //   var itemIndexMatched = -1
        
        do{
            addressInformation = try managedContext.fetch(fetchRequest) as! [AddressInformation]
        }
        catch{
            debugPrint("Could not fetch: \(error.localizedDescription)")
        }
            if addressInformation.count > 0{
                let address_info = addressInformation[0]
                address_info.region = region
                address_info.region_id = region_id
                address_info.country_id = country_id
                address_info.postcode = postcode
                address_info.city = city
                address_info.firstname = firstname
                address_info.lastname = lastname
                address_info.region_code = region_code
                address_info.street = street
                address_info.email = email
                address_info.telephone = telePhone
                do{
                    try managedContext.save()
                    completion(true)
                } catch {
                    debugPrint("Could not save:\(error.localizedDescription)")
                    completion(false)
                }
            }
            else{
                let address_info = AddressInformation(context: managedContext)
                address_info.region = region
                address_info.region_id = region_id
                address_info.country_id = country_id
                address_info.postcode = postcode
                address_info.city = city
                address_info.firstname = firstname
                address_info.lastname = lastname
                address_info.region_code = region_code
                address_info.street = street
                do{
                    try managedContext.save()
                    completion(true)
                } catch {
                    debugPrint("Could not save:\(error.localizedDescription)")
                    completion(false)
                }
            }
    }
    //End Save Address Information
    
    // Save Billing Address Information
    func saveBillingAddress(region: String, region_id: String, country_id: String, postcode: String, city: String, firstname: String, lastname: String,region_code:String,street:String,sameAsShipping :Int16, email : String , telephone :String, completion: (_ finished: Bool)->()){
        var billingAddressInformation: [BillingAddress] = []
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BillingAddress")
        
        //   var itemIndexMatched = -1
        
        do{
            billingAddressInformation = try managedContext.fetch(fetchRequest) as! [BillingAddress]
        }
        catch{
            debugPrint("Could not fetch: \(error.localizedDescription)")
        }
        if billingAddressInformation.count > 0{
            let address_info = billingAddressInformation[0]
            address_info.region = region
            address_info.region_id = region_id
            address_info.country_id = country_id
            address_info.postcode = postcode
            address_info.city = city
            address_info.firstname = firstname
            address_info.lastname = lastname
            address_info.region_code = region_code
            address_info.street = street
            address_info.sameAsShipping =  sameAsShipping
            address_info.email = email
            address_info.telephone = telephone
            do{
                try managedContext.save()
                completion(true)
            } catch {
                debugPrint("Could not save:\(error.localizedDescription)")
                completion(false)
            }
        }
        else{
            let address_info = BillingAddress(context: managedContext)
            address_info.region = region
            address_info.region_id = region_id
            address_info.country_id = country_id
            address_info.postcode = postcode
            address_info.city = city
            address_info.firstname = firstname
            address_info.lastname = lastname
            address_info.region_code = region_code
            address_info.street = street
            address_info.sameAsShipping = sameAsShipping
            address_info.email = email
            address_info.telephone = telephone
            do{
                try managedContext.save()
                completion(true)
            } catch {
                debugPrint("Could not save:\(error.localizedDescription)")
                completion(false)
            }
        }
    }

    //End Save Billing Address Information
    
    // Save Language Information
    func saveCoreDataLanguage(lang: String,  completion: (_ finished: Bool)->()){
        var languageInformation: [Language] = []
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Language")
        do{
            languageInformation = try managedContext.fetch(fetchRequest) as! [Language]
        }
        catch{
            debugPrint("Could not fetch: \(error.localizedDescription)")
        }
        if languageInformation.count > 0{
            languageInformation[0].name = lang
            do{
                try managedContext.save()
                completion(true)
            } catch {
                debugPrint("Could not save:\(error.localizedDescription)")
                completion(false)
            }
        }
        else{
            let language_info = Language(context: managedContext)
            language_info.name = lang
            do{
                try managedContext.save()
                completion(true)
            } catch {
                debugPrint("Could not save:\(error.localizedDescription)")
                completion(false)
            }
        }
    }
    // End Save language Information
    //Get Current Language
    
    func CheckCurrentLanguage(completion: (_ finished: [Language])-> ()){

        var currentLanguage: [Language] = []
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Language")
        
        do{
            currentLanguage = try managedContext.fetch(fetchRequest) as! [Language]
            completion(currentLanguage)
        }catch{
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(currentLanguage)
        }
        
    }
    
    //Get Current Language
    
    func noDataMessageCollectionView(collection: UICollectionView, message: String, list: [Items]){
        
        if list.count == 0 {
            
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: collection.bounds.size.width, height: collection.bounds.size.height))
            messageLabel.text = message
            messageLabel.textColor = .black
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
              if self.currentLanguage == "en"{
                 messageLabel.font = UIFont(name: enLanguageConstant, size: 17)!
            }
              else{
               messageLabel.font = UIFont(name: arLanguageConstant, size: 17)!

            }
//            messageLabel.font = UIFont(name: "Montserrat-Regular", size: 18)
            messageLabel.sizeToFit()
            
            collection.backgroundView = messageLabel
            
        }else{
            
            collection.backgroundView = nil
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    func saveSideMenuBadge(badgeName: String, badgeTotal: Int,  completion: (_ finished: Bool)->()){
        var sideMenuBadges: [SideMenuBadge] = []
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SideMenuBadge")
        do{
            sideMenuBadges = try managedContext.fetch(fetchRequest) as! [SideMenuBadge]
            
            var matched: Bool = false
            if sideMenuBadges.count > 0{
                for badge in sideMenuBadges{
                    if badge.name == badgeName{
                        badge.badgeTotal = Int16(badgeTotal)
                        matched = true
                    }
                }
            }
            
            if matched {
                do{
                    try managedContext.save()
                    completion(true)
                } catch {
                    debugPrint("Could not save:\(error.localizedDescription)")
                    completion(false)
                }
            }
            else{
                let newSideMenuBadge = SideMenuBadge(context: managedContext)
                newSideMenuBadge.badgeTotal = Int16(badgeTotal)
                newSideMenuBadge.name = badgeName
                
                do{
                    try managedContext.save()
                    completion(true)
                } catch {
                    debugPrint("Could not save:\(error.localizedDescription)")
                    completion(false)
                }
            }
            
            
        }
        catch{
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }
        
    }
    // End Save language Information
    //Get SideMenuBadges
    
    func getSideMenuBadge(completion: (_ finished: [SideMenuBadge])-> ()){
        
        var sideMenuBadges: [SideMenuBadge] = []
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SideMenuBadge")
        
        do{
            sideMenuBadges = try managedContext.fetch(fetchRequest) as! [SideMenuBadge]
            
            completion(sideMenuBadges)
        }catch{
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(sideMenuBadges)
        }
        
    }
    
    func fetchFromCoreData(completion: (_ complete: [CartItem]) -> ()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        var cartItems: [CartItem] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItem")
        
        
        do{
            
            cartItems = try managedContext.fetch(fetchRequest) as! [CartItem]
            print("fetching now \(cartItems.count)")
            print(cartItems)
            completion(cartItems)
        }catch{
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(cartItems)
        }
    }
    
    
    func saveCelebCoreData(celebItems: [Items], completion: (_ finished: Bool)->()){
        var celebs: [CelebCore] = []
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CelebCore")
        do{
            celebs = try managedContext.fetch(fetchRequest) as! [CelebCore]
            
            for object in celebs {
                managedContext.delete(object)
            }

            for object in celebItems {
                let newCeleb = CelebCore(context: managedContext)
                newCeleb.id = Int16(object.id!)
                newCeleb.name = object.name
                newCeleb.image = CATEGORY_IMAGE_URL+(Array(object.custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!
                
                
                if Array(object.custom_attributes!).first(where: { $0.attribute_code! == "facebook" })?.value != nil{
                    newCeleb.facebook = (Array(object.custom_attributes!).first(where: { $0.attribute_code! == "facebook" })?.value)!
                }
                else{
                    newCeleb.facebook = "#"
                }
                
                if Array(object.custom_attributes!).first(where: { $0.attribute_code! == "snapchat" })?.value != nil {
                    newCeleb.snapchat = (Array(object.custom_attributes!).first(where: { $0.attribute_code! == "snapchat" })?.value)!
                }
                else{
                    newCeleb.snapchat = "#"
                }
                
                if Array(object.custom_attributes!).first(where: { $0.attribute_code! == "twitter" })?.value != nil {
                    
                    newCeleb.twitter = (Array(object.custom_attributes!).first(where: { $0.attribute_code! == "twitter" })?.value)!
                }
                else{
                    newCeleb.twitter = "#"
                }
                
                if Array(object.custom_attributes!).first(where: { $0.attribute_code! == "instagram" })?.value != nil {
                    newCeleb.instagram = (Array(object.custom_attributes!).first(where: { $0.attribute_code! == "instagram" })?.value)!
                }
                else{
                    newCeleb.instagram = "#"
                }
                
                
            }
            
            
            do{
                try managedContext.save()
                completion(true)
            } catch {
                debugPrint("Could not save:\(error.localizedDescription)")
                completion(false)
            }
            
        }
        catch{
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }
        
    }
    
    func saveCategoryCoreData(items: [Items], completion: (_ finished: Bool)->()){
        var coreItems: [CategoryCore] = []
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoryCore")
        do{
            coreItems = try managedContext.fetch(fetchRequest) as! [CategoryCore]
            
            for object in coreItems {
                managedContext.delete(object)
            }
            
            for object in items {
                if(object.is_active!){
                let newItem = CategoryCore(context: managedContext)
                newItem.id = Int16(object.id!)
                newItem.name = object.name
                newItem.image = CATEGORY_IMAGE_URL + (Array(object.custom_attributes!).first(where: { $0.attribute_code! == "custom_image" })?.value)!
                }}
            
            
            do{
                try managedContext.save()
                completion(true)
            } catch {
                debugPrint("Could not save:\(error.localizedDescription)")
                completion(false)
            }
            
        }
        catch{
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }
        
    }
    
    func saveBrandsCoreData(items: [Items], completion: (_ finished: Bool)->()){
        var coreItems: [BrandCore] = []
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BrandCore")
        do{
            coreItems = try managedContext.fetch(fetchRequest) as! [BrandCore]
            
            for object in coreItems {
                managedContext.delete(object)
            }
            
            for object in items {
                let newItem = BrandCore(context: managedContext)
                newItem.id = Int16(object.id!)
                newItem.name = object.name
                newItem.image = CATEGORY_IMAGE_URL + (Array(object.custom_attributes!).first(where: { $0.attribute_code! == "image" })?.value)!
            }
            
            
            do{
                try managedContext.save()
                completion(true)
            } catch {
                debugPrint("Could not save:\(error.localizedDescription)")
                completion(false)
            }
            
        }
        catch{
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }
        
    }
    
    func fetchCelebCoreData(completion: (_ complete: [CelebCore]) -> ()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        var celebItems: [CelebCore] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CelebCore")
        
        
        do{
            
            celebItems = try managedContext.fetch(fetchRequest) as! [CelebCore]
            print("fetching now \(celebItems.count)")
            print(celebItems)
            completion(celebItems)
        }catch{
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(celebItems)
        }
    }
    
    func fetchBrandsCoreData(completion: (_ complete: [BrandCore]) -> ()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        var celebItems: [BrandCore] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BrandCore")
        
        
        do{
            
            celebItems = try managedContext.fetch(fetchRequest) as! [BrandCore]
            print("fetching now \(celebItems.count)")
            print(celebItems)
            completion(celebItems)
        }catch{
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(celebItems)
        }
    }
    
    func fetchCategoryCoreData(completion: (_ complete: [CategoryCore]) -> ()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        var celebItems: [CategoryCore] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoryCore")
        
        
        do{
            
            celebItems = try managedContext.fetch(fetchRequest) as! [CategoryCore]
            print("fetching now \(celebItems.count)")
            print(celebItems)
            completion(celebItems)
        }catch{
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(celebItems)
        }
    }
    
    
    func saveUserCoreData(user: UserInfo, token: String, completion: (_ finished: Bool)->()){
        var coreItems: [UserCore] = []
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserCore")
        do{
            coreItems = try managedContext.fetch(fetchRequest) as! [UserCore]
            
            for object in coreItems {
                managedContext.delete(object)
            }
            
            
            let newItem = UserCore(context: managedContext)
            
            if user.firstname != nil && user.lastname != nil
            {
                 newItem.name = "\(String(describing: user.firstname!))  \(String(describing: user.lastname!))"
            }
        
            newItem.email = user.email
            newItem.token = token
            newItem.id = String(describing: user.id!)
        
            
            if user.custom_attributes != nil
            {
                //set userprofile image.
                let arrProfilePicture:NSArray = user.custom_attributes as! NSArray
                
                if arrProfilePicture.count > 0
                {
                    let dictProfilePicture:Custom_attributes = arrProfilePicture.object(at: 0) as! Custom_attributes
                    newItem.profileImage = dictProfilePicture.value
                }
            }

            do{
                try managedContext.save()
                completion(true)
            } catch {
                debugPrint("Could not save:\(error.localizedDescription)")
                completion(false)
            }
            
        }
        catch{
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }
        
    }
    
    
    func logoutUserCoreData(completion: (_ finished: Bool)->()){
        var coreItems: [UserCore] = []
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserCore")
        do{
            coreItems = try managedContext.fetch(fetchRequest) as! [UserCore]
            
            for object in coreItems {
                managedContext.delete(object)
            }
            
            do{
                try managedContext.save()
                completion(true)
            } catch {
                debugPrint("Could not save:\(error.localizedDescription)")
                completion(false)
            }
            
        }
        catch{
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }
        
    }
    
    func fetchUserCoreData(completion: (_ complete: [UserCore]) -> ()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        var userData: [UserCore] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserCore")
        
        do{
            userData = try managedContext.fetch(fetchRequest) as! [UserCore]
            print("fetching now userdata \(userData.count)")
            print(userData)
            completion(userData)
        }catch{
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(userData)
        }
    }
}
