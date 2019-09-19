//
//  BaseManager.swift
//  quitic3
//
//  Created by APPLE on 8/1/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire
import Localize_Swift
import ANLoader

class BaseManager: NSObject {
    
    var sessionManager: SessionManager
    var basePath: String
    var authToken : String = ""
    var currentLanguage : String?
    
    var customerHeaders:HTTPHeaders
    override init() {
        //intialiazed sessionManager
        sessionManager = BaseManager.Manager

   
        //set Base URL dev /Staging /production
        if  (UserDefaults.standard.string(forKey: "token") != nil) {
            authToken =      (UserDefaults.standard.string(forKey: "token")!).replacingOccurrences(of: "\"", with: "")
            
            
        }
        
        basePath = API.baseURL.staging
        
         customerHeaders = [
            "Authorization": "Bearer" + " " + authToken,
            "Content-Type": "application/json"
        ]
        
    }
    
    
    public static var Manager: Alamofire.SessionManager = {
        
        // Create the server trust policies
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            AlomaFireUrl: .disableEvaluation
        ]
        
        // Create custom manager
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        return manager
    }()
    func setLanguageFromCommonManager() {
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
            else{
                CommonManager.shared.saveCoreDataLanguage(lang: Languages.en.rawValue) { (complete1) in
                   
                    CommonManager.shared.CheckCurrentLanguage(){ (complete) in
                        if complete.count>0{
                            self.currentLanguage = complete[0].name!
                        }
                        else{
                           
                        }
                    }
                }
            }
        }
    }
    //let GetCategories_ENDPOINT = API_URL+"categories/list?searchCriteria[filterGroups][0][filters][0][field]=parent_id&searchCriteria[filterGroups][0][filters][0][value]=2";
    func ApiPathBuilder (apiPath :String?, orderBy : String?, pageSize : Int? , currentPage : Int?, sortBy:String? ,conditionType:String? , field : String? , fieldValue: Int?)-> String{
        
        var str = basePath
        setLanguageFromCommonManager()
        
        if(self.currentLanguage != "en"){
            str = API.baseURL.staging_ae
        }
        else{
            str = API.baseURL.staging
        }
    
        if(apiPath! != ""){
            str+=apiPath!+"?"
        }
        if(field! != ""){
            str+="searchCriteria[filterGroups][0][filters][0][field]="+field!
        }
        if(fieldValue! != 0){
            str+="&searchCriteria[filterGroups][0][filters][0][value]="+String(fieldValue!)
        }
        if(conditionType! != ""){
            str+="&searchCriteria[filterGroups][0][filters][0][conditionType]="+conditionType!
        }
//        else{
//            str+="&searchCriteria[sortOrders][0][field]=eq"
//        }
        if(sortBy! != ""){
            str+="&searchCriteria[sortOrders][0][field]="+sortBy!
        }
        else{
            str+="&searchCriteria[sortOrders][0][field]=created_at"
        }
        if(orderBy! != ""){
            str+="&searchCriteria[sortOrders][0][direction]="+orderBy!
        }
        else{
            str+="&searchCriteria[sortOrders][0][direction]=DESC"
        }
        if(pageSize! != 0){
            str+="&searchCriteria[pageSize]="+String(pageSize!)
        }
        else{
            str+="&searchCriteria[currentPage]=10"
        }
        if(currentPage! != 0){
            str+="&searchCriteria[currentPage]="+String(currentPage!)
        }
        else{
            str+="&searchCriteria[currentPage]=1"
        }
        
//        if (brandType! != "")
//        {
//            if brandType == "exclusive"
//            {
//                str+="&searchCriteria[sortOrders][0][is_exclusive]=1"
//            }
//            else
//            {
//                str+="&searchCriteria[sortOrders][0][is_featured]=1"
//            }
//        }
//
        
        return str
    }
    
    func BrandApiPathBuilder (apiPath :String?, orderBy : String?, pageSize : Int? , currentPage : Int?, sortBy:String? ,conditionType:String? , field : String? , fieldValue: Int?, brandType:String?)-> String{
        
        var str = basePath
        setLanguageFromCommonManager()
        
        if(self.currentLanguage != "en"){
            str = API.baseURL.staging_ae
        }
        else{
            str = API.baseURL.staging
        }
        
        if(apiPath! != ""){
            str+=apiPath!+"?"
        }
        if(field! != ""){
            str+="searchCriteria[filterGroups][0][filters][0][field]="+field!
        }
        if(fieldValue! != 0){
            str+="&searchCriteria[filterGroups][0][filters][0][value]="+String(fieldValue!)
        }
        if(conditionType! != ""){
            str+="&searchCriteria[filterGroups][0][filters][0][conditionType]="+conditionType!
        }
        //        else{
        //            str+="&searchCriteria[sortOrders][0][field]=eq"
        //        }
        if(sortBy! != ""){
            str+="&searchCriteria[sortOrders][0][field]="+sortBy!
        }
        else{
            str+="&searchCriteria[sortOrders][0][field]=created_at"
        }
        if(orderBy! != ""){
            str+="&searchCriteria[sortOrders][0][direction]="+orderBy!
        }
        else{
            str+="&searchCriteria[sortOrders][0][direction]=DESC"
        }
        if(pageSize! != 0){
            str+="&searchCriteria[pageSize]="+String(pageSize!)
        }
        else{
            str+="&searchCriteria[currentPage]=10"
        }
        if(currentPage! != 0){
            str+="&searchCriteria[currentPage]="+String(currentPage!)
        }
        else{
            str+="&searchCriteria[currentPage]=1"
        }
    
        if (brandType! != "")
        {
            if brandType == "exclusive"
            {
                str+="&searchCriteria[filterGroups][1][filters][0][field]=is_exclusive&searchCriteria[filterGroups][1][filters][0][value]=1&searchCriteria[filterGroups][1][filters][0][condition_type]=eq"
            }
            else
            {
                str+="&searchCriteria[filterGroups][1][filters][0][field]=is_featured&searchCriteria[filterGroups][1][filters][0][value]=1&searchCriteria[filterGroups][1][filters][0][condition_type]=eq"
            }
        }

        return str
    }
    

    
    //get banner api string prepare
    func BannerApiPathBuilder (apiPath :String?)-> String
    {
        var str = basePath
        
        setLanguageFromCommonManager()
        
        if(self.currentLanguage != "en"){
            str = API.baseURL.staging
        }
        else{
            str = API.baseURL.staging
        }
        
        if(apiPath! != ""){
            str+=apiPath!
        }
        
        return str
    }
    
  
    func ProductApiPathBuilder (apiPath :String?, orderBy : String? = "", pageSize : Int? = -1, currentPage : Int? = -1, sortBy:String? = "" ,conditionType:String? = "", field : String? = "", fieldValue: [Int]? = [], arithmaticOperator: String? = "", searchTerm: String? = "", lowerPrice: Int? = -1, upperPrice: Int? = -1, celebId:String?)-> String{
        
        var str = basePath
        var customerID = ""
        
        setLanguageFromCommonManager()
        if(self.currentLanguage != "en"){
            str = API.baseURL.staging_ae
        }
        else{
            str = API.baseURL.staging
        }
        
        
        if(apiPath! != ""){
            str+=apiPath!+"?"
        }
        
        var index = 0
        
        if searchTerm! == "" {
            if arithmaticOperator == "and"{
                for id in fieldValue!{
                    if field != "" {
                        str+="&searchCriteria[filterGroups][\(index)][filters][0][field]="+field!
                    }
                    
                    str+="&searchCriteria[filterGroups][\(index)][filters][0][value]=\(id)"
                    
                    if conditionType != "" {
                        str+="&searchCriteria[filterGroups][\(index)][filters][0][conditionType]="+conditionType!
                    }
                    
                    index += 1
                }
                
                //price range
                
                if lowerPrice != -1 {
                    str+="&searchCriteria[filterGroups][\(index)][filters][0][field]=price"
                    str+="&searchCriteria[filterGroups][\(index)][filters][0][value]=\(String(describing: lowerPrice!))"
                    str+="&searchCriteria[filterGroups][\(index)][filters][0][conditionType]=gteq"
                    
                    index += 1
                }
                
                if upperPrice != -1 {
                    str+="&searchCriteria[filterGroups][\(index)][filters][0][field]=price"
                    str+="&searchCriteria[filterGroups][\(index)][filters][0][value]=\(String(describing: upperPrice!))"
                    str+="&searchCriteria[filterGroups][\(index)][filters][0][conditionType]=lteq"
                    
                    index += 1
                }
                
            }
            else{
                for id in fieldValue!{
                    if field != ""{
                        str+="&searchCriteria[filterGroups][0][filters][\(index)][field]="+field!
                    }
                    
                    str+="&searchCriteria[filterGroups][0][filters][\(index)][value]=\(id)"
                    
                    if conditionType != ""{
                        str+="&searchCriteria[filterGroups][0][filters][\(index)][conditionType]="+conditionType!
                    }
                    
                    index += 1
                }
            }
        }else{
            
                if field != ""{
                    str+="&searchCriteria[filterGroups][0][filters][\(index)][field]="+field!
                }
            
            
                let searchEncode = searchTerm?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
            str+="&searchCriteria[filterGroups][0][filters][\(index)][value]=%25\(String(describing: searchEncode!))%25"
                
                if conditionType != ""{
                    str+="&searchCriteria[filterGroups][0][filters][\(index)][conditionType]="+conditionType!
                }
        }
        
        if  (UserDefaults.standard.string(forKey: "token") != nil)
        {
            CommonManager.shared.fetchUserCoreData{ (data) in
                if data.count > 0
                {
                    customerID = data[0].id!
                }
            }
        }
        
        str+="&customer_id="+customerID
        
        if(sortBy! != ""){
            str+="&searchCriteria[sortOrders][0][field]="+sortBy!
        }
        
        
        if(orderBy! != ""){
            str+="&searchCriteria[sortOrders][0][direction]="+orderBy!
        }
        
        
        if(pageSize! != -1){
            str+="&searchCriteria[pageSize]="+String(pageSize!)
        }
        
        if(currentPage! != -1){
            str+="&searchCriteria[currentPage]="+String(currentPage!)
        }
        
        if (celebId! != "")
        {
           str+="&celebrityId="+celebId!
        }
        
        print("product url: \(str)")
        
        return str
    }
    
    
    
    func loader(message: String){
        ANLoader.activityColor = .quiticPink
        ANLoader.pulseAnimation = false
        ANLoader.activityBackgroundColor = .clear
        ANLoader.activityTextColor = .clear
        ANLoader.showLoading("",disableUI: true)
    }
    
    func disableLoader(){
        ANLoader.hide()
    }
    
    func SetBasePath(){
        if(self.currentLanguage != "en"){
            basePath = API.baseURL.staging_ae
        }
        else{
            
            basePath = API.baseURL.staging
            
        }

    }
}

