//
//  APIManager.swift
//  quitic3
//
//  Created by APPLE on 7/16/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import SwiftyJSON
import ANLoader
import AlamofireObjectMapper
import ObjectMapper

import ObjectMapper

class APIManager :BaseManager {
    
    static let shared = APIManager()
    override init() {
        super.init()
        //        GetProducts_ENDPOINT = API_URL+"products?searchCriteria[filterGroups][0][filters][0][field]=category_id&searchCriteria[filterGroups][0][filters][0][value]=2&searchCriteria[filterGroups][0][filters][0][conditionType]=eq&searchCriteria[sortOrders][0][field]=created_at&searchCriteria[sortOrders][0][direction]=DESC&searchCriteria[pageSize]=10&searchCriteria[currentPage]=1";
        
    }
    func PostLoginRequest(data: LoginForm, onCompleteion: @escaping (JSON) -> Void) {
        
        self.loader(message: "Loading")
        
        
        var jsonObject: [String: Any] = [
            "hasError": false,
            "response": JSON.null
        ]
        
        BaseManager.Manager.request(loginURL, method:.post, parameters:data.dictionaryRepresentation,encoding: JSONEncoding.default)
            .validate()
            .validate(contentType: ["application/json"])
            .responseString { response in
                
                switch response.result {
                case .success(let response):
                    let data = JSON(response)
                    jsonObject["response"] = data
                    onCompleteion(JSON(jsonObject))
                    ANLoader.hide()
                    self.disableLoader()
                case .failure(let error):
                    //                let data = JSON(response.result)
                    jsonObject["hasError"] = true
                    jsonObject["response"] = JSON(error)
                    onCompleteion(JSON(jsonObject))
                    self.disableLoader()
                }
        }
    }
    
    func SignUpRequest(data: UserForm, onCompleteion: @escaping (JSON) -> Void){
        
        self.loader(message: "Loading")
        
        var jsonObject: [String: Any] = [
            "hasError": false,
            "response": JSON.null
        ]
        
        dump(data.dictionaryRepresentation)
        
        BaseManager.Manager.request(SignUpURL, method:.post, parameters:data.dictionaryRepresentation,encoding: JSONEncoding.default)
            .validate()
            .validate(contentType: ["application/json"])
            .responseJSON { HTTPResponse in
                
                
                switch HTTPResponse.result {
                case .success(let response):
                    jsonObject["response"] = JSON(response)
                    onCompleteion(JSON(jsonObject))
                    self.disableLoader()
                case .failure(let error):
                    print(error)
                    jsonObject["hasError"] = true
                    jsonObject["response"] = JSON(HTTPResponse.data!)
                    onCompleteion(JSON(jsonObject))
                    
                    self.disableLoader()
                }
        }
        
    }
    
    func SocialSignUpRequest(data: SocialUserForm, onCompleteion: @escaping (String) -> Void){
        
        self.loader(message: "Loading")
        
        BaseManager.Manager.request(SignUpURL, method:.post, parameters:data.dictionaryRepresentation,encoding: JSONEncoding.default)
            .validate()
            .validate(contentType: ["application/json"])
            .responseObject { (response: DataResponse<Response> ) in
                if response.result.isSuccess {
                    let data = response.result.value
                    onCompleteion (String((data?.id)!))
                    self.disableLoader()
                }
                else{
                    onCompleteion("")
                    self.disableLoader()
                }
        }
        
    }
    
    func GetCelebritiesRequest(onCompleteion: @escaping ([Items]) -> Void){
        //          self.loader(message: "Loading")
        var jsonObject: [String: Any] = [
            "hasError": false,
            "response": JSON.null
        ]
        
        let headers: HTTPHeaders = API_Header
        //        let GetCelebrities:String = API_URL+"categories/list?searchCriteria[filterGroups][0][filters][0][field]=parent_id&searchCriteria[filterGroups][0][filters][0][value]=48";
        let path = ApiPathBuilder(apiPath: "categories/list", orderBy:"DESC", pageSize: 50, currentPage: 1, sortBy: "created_at", conditionType: "eq", field: "parent_id", fieldValue: 48)
        BaseManager.Manager.request(path , headers: headers)
            .validate()
            .validate(contentType: ["application/json"])
            .responseJSON { HTTPResponse in
                
                switch HTTPResponse.result {
                case .success(let response):
                    let allCategories = AllCategories(JSONString: JSON(response).rawString()!)!
                    jsonObject["response"] = JSON(response)
                    onCompleteion(allCategories.items!)
                case .failure(let error):
                    jsonObject["hasError"] = true
                    jsonObject["response"] = JSON(HTTPResponse.data!)
                    //                    self.disableLoader()
                    onCompleteion([])
                }
        }
        
    }
    
    // Get Brands
    func GetBrandsRequest(onCompleteion: @escaping ([Items]) -> Void){
        var jsonObject: [String: Any] = [
            "hasError": false,
            "response": JSON.null
        ]
        
        let headers: HTTPHeaders = API_Header
        let path = ApiPathBuilder(apiPath: "categories/list", orderBy:"DESC", pageSize: 50, currentPage: 1, sortBy: "created_at", conditionType: "eq", field: "parent_id", fieldValue: 29)
        BaseManager.Manager.request(path, headers: headers)
            .validate()
            .validate(contentType: ["application/json"])
            .responseJSON { HTTPResponse in
                
                switch HTTPResponse.result {
                case .success(let response):
                    let brands = SubCategories(JSONString: JSON(response).rawString()!)!
                    onCompleteion(brands.items!)
                case .failure(let error):
                    
                    jsonObject["hasError"] = true
                    jsonObject["response"] = JSON(HTTPResponse.data!)
                    onCompleteion([])
                }
        }
        
    }
    //End Brands
    
    
    //Start Products
    func GetProductsRequest(pageSize:Int, onCompleteion: @escaping ([Items]) -> Void){
        //        self.loader(message: "Loading")
        var jsonObject: [String: Any] = [
            "hasError": false,
            "response": JSON.null
        ]
        
        let headers: HTTPHeaders = API_Header
        
        BaseManager.Manager.request(ApiPathBuilder(apiPath: "products", orderBy:"DESC", pageSize: pageSize, currentPage: 1, sortBy: "created_at", conditionType: "eq", field: "category_id", fieldValue: 2), headers: headers)
            .validate()
            .validate(contentType: ["application/json"])
            .responseJSON { HTTPResponse in
                
                switch HTTPResponse.result {
                case .success(let response):
                    let brands = SubCategories(JSONString: JSON(response).rawString()!)!
                    //                    self.disableLoader()
                    
                    onCompleteion(brands.items!)
                case .failure(let error):
                    jsonObject["hasError"] = true
                    jsonObject["response"] = JSON(HTTPResponse.data!)
                    //                    self.disableLoader()
                    onCompleteion([])
                }
        }
        
    }
    //End Products
    
    
    func GetAllCategories(onCompleteion: @escaping ([Items]) -> Void){
        
        var jsonObject: [String: Any] = [
            "hasError": false,
            "response": JSON.null
        ]
        let headers: HTTPHeaders = API_Header
        let path = ApiPathBuilder(apiPath: "categories/list", orderBy:"DESC", pageSize: 10, currentPage: 1, sortBy: "created_at", conditionType: "eq", field: "parent_id", fieldValue: 2)
        BaseManager.Manager.request(path, headers: headers)
            .validate()
            .validate(contentType: ["application/json"])
            .responseJSON { HTTPResponse in
                
                switch HTTPResponse.result {
                case .success(let response):
                    let allCategories = SubCategories(JSONString: JSON(response).rawString()!)!
                    jsonObject["response"] = JSON(response)
                    onCompleteion(allCategories.items!)
                    
                case .failure(let error):
                    jsonObject["hasError"] = true
                    jsonObject["response"] = JSON(HTTPResponse.data!)
                    onCompleteion([])
                }
        }
        
    }
    //POST Wish Product Start
    func PostWishProduct(productId: String, onCompleteion: @escaping (JSON) -> Void){
        print(UserDefaults.standard.string(forKey: "token")!)
        if  (UserDefaults.standard.string(forKey: "token") != nil) {
            let authToken = (UserDefaults.standard.string(forKey: "token")!).replacingOccurrences(of: "\"", with: "")
            customerHeaders = [
                "Authorization": "Bearer" + " " + authToken,
                "Content-Type": "application/json"
            ]
        }
        
        self.loader(message: "Loading")
        
        var jsonObject: [String: Any] = [
            "hasError": false,
            "response": JSON.null
        ]
        print(PostWishURL+"/"+productId)
        BaseManager.Manager.request(PostWishURL+"/"+productId,method: .post,headers: customerHeaders)
            .validate()
            .validate(contentType: ["application/json"])
            .responseJSON { HTTPResponse in
                
                print(HTTPResponse)
                switch HTTPResponse.result {
                case .success(let response):
                    jsonObject["response"] = JSON(response)
                    onCompleteion(JSON(jsonObject))
                    self.disableLoader()
                case .failure(let error):
                    print(error)
                    jsonObject["hasError"] = true
                    jsonObject["response"] = JSON(HTTPResponse.data!)
                    onCompleteion(JSON(jsonObject))
                    self.disableLoader()
                }
        }
        
    }
    
    
    //POST Wish Product END
    
    //DELETE Wish Product START
    func DeleteWishProduct(wishlistItemId:String) {
        let customerHeaders:HTTPHeaders = [
            "Authorization": "Bearer"+" " + UserDefaults.standard.string(forKey: "token")!,
            "Content-Type": "application/json"
        ]
        
        BaseManager.Manager.request(DELETEWishURL+"/"+wishlistItemId, method: .delete)
            .responseJSON { response in
                guard response.result.error == nil else {
                    if let error = response.result.error {
                    }
                    return
                }
        }
    }
    //DELETE Wish Product END
    
    //GET Wish Product START
    
    func GetWishProduct(onCompleteion: @escaping (Json4Swift_Base) -> Void){
        let customerHeaders:HTTPHeaders = [
            "Authorization": "Bearer"+" " + UserDefaults.standard.string(forKey: "token")!,
            "Content-Type": "application/json"
        ]
        //UserDefaults.standard.string(forKey: "token")
        var jsonObject: [String: Any] = [
            "hasError": false,
            "response": JSON.null
        ]
        self.loader(message: "Loading")
        
        BaseManager.Manager.request(GetWishURL, headers: customerHeaders)
            .validate()
            .validate(contentType: ["application/json"])
            .responseJSON { HTTPResponse in
                
                switch HTTPResponse.result {
                case .success(let response):
                    print(JSON(response).rawString()!)
                    let allwishProducts = Json4Swift_Base(JSONString: JSON(response).rawString()!)!
                    print(allwishProducts)
                    self.disableLoader()
                    onCompleteion(allwishProducts)
                    
                case .failure(let error):
                    jsonObject["hasError"] = true
                    jsonObject["response"] = JSON(HTTPResponse.data!)
                    self.disableLoader()
                    onCompleteion(Json4Swift_Base(JSONString: JSON(error).rawString()!)!)
                }
        }
        
    }
    //GET Wish Product END
    
    
    // Get TV Videos sub List Start
    
    func GetVideosSubListRequest(onCompleteion: @escaping ([ItemsVideoList]) -> Void){
        //        self.loader(message: "Loading")
        
        var jsonObject: [String: Any] = [
            "hasError": false,
            "response": JSON.null
        ]
        
        let headers: HTTPHeaders = API_Header
        
        BaseManager.Manager.request(GetSubVideo_ENDPOINT, headers: headers)
            .validate()
            .validate(contentType: ["application/json"])
            .responseJSON { HTTPResponse in
                
                switch HTTPResponse.result {
                case .success(let response):
                    let videos = VideoList(JSONString: JSON(response).rawString()!)!
                    onCompleteion(videos.items!)
                case .failure(let error):
                    jsonObject["hasError"] = true
                    jsonObject["response"] = JSON(HTTPResponse.data!)
                    onCompleteion([])
                }
        }
        
    }
    
    //Get Videos sub List End
    
    func GetProductsRequestByCelebrityId(pageSize:Int, celebId:Int, pageNo:Int, onCompleteion: @escaping (SubCategories) -> Void){
        
        var jsonObject: [String: Any] = [
            "hasError": false,
            "response": JSON.null
        ]
        
        let headers: HTTPHeaders = API_Header
        
        BaseManager.Manager.request(ApiPathBuilder(apiPath: "products", orderBy:"DESC", pageSize: pageSize, currentPage: pageNo, sortBy: "created_at", conditionType: "eq", field: "category_id", fieldValue: celebId), headers: headers)
            .validate()
            .validate(contentType: ["application/json"])
            .responseJSON { HTTPResponse in
                
                switch HTTPResponse.result {
                case .success(let response):
                    let subCategories = SubCategories(JSONString: JSON(response).rawString()!)!
                    
                    onCompleteion(subCategories)
                case .failure(let error):
                    jsonObject["hasError"] = true
                    jsonObject["response"] = JSON(HTTPResponse.data!)
                    
                    var subCategories = SubCategories()
                    subCategories.items = []
                    onCompleteion(subCategories)
                }
        }
        
    }
    
    func getData(apiPath :String?, orderBy : String?, pageSize : Int? , currentPage : Int?, sortBy:String? ,conditionType:String? , field : String? , fieldValue: Int?, language: String?){
        
    }
    
    func GetCountriesRequest(completion: @escaping (NSMutableArray, String?) -> Void){
        print("GetCountriesRequest Start")
        self.loader(message: "Loading")
        
        let countryUrl = Main_URL + "webapi/directory/countries"
        
        BaseManager.Manager.request(countryUrl, method:.get, parameters:nil,encoding: JSONEncoding.default).validate().validate(contentType: ["application/json"]).responseString { response in
            
            switch response.result {
                
            case .success( _):
                
                let result = response.result.value
                
                let data = result!.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                
                do {
                    
                    let arrCountries:NSMutableArray = []
                    
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        
                        if let jsonValue = json?["countries"] as? NSArray
                        {
                            for countryValue in jsonValue
                            {
                                let dict = countryValue as? NSDictionary
                                let country = CountryList()
                                country.code = dict!["code"] as? String
                                country.lable = dict!["lable"] as? String
                                arrCountries.add(country)
                            }
                        }
                    }
                    
                    completion(arrCountries, nil)
                    
                } catch let error as NSError {
                    
                    completion([], error.localizedDescription)
                }
                
                self.disableLoader()
            case .failure( let error):
                
                self.disableLoader()
                completion([], error.localizedDescription)
            }
        }
    }
    
    func GetCityRequest(countryCode:String, completion: @escaping (NSMutableArray, String?) -> Void){
        
        self.loader(message: "Loading")
        
        let cityUrl = Main_URL + "webapi/directory/countries" + "?countryId=" + countryCode
        
        BaseManager.Manager.request(cityUrl, method:.get, parameters:nil,encoding: JSONEncoding.default).validate().validate(contentType: ["application/json"]).responseString { response in
            
            switch response.result {
                
            case .success( _):
                
                let result = response.result.value
                
                let data = result!.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                
                do {
                    
                    let arrCities:NSMutableArray = []
                    
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        
                        if let jsonValue = json?["cities"] as? NSArray
                        {
                            for cityValue in jsonValue
                            {
                                let dict = cityValue as? NSDictionary
                                let cityModel = Cities()
                                cityModel.code = dict!["code"] as? String
                                cityModel.name = dict!["name"] as? String
                                arrCities.add(cityModel)
                            }
                        }
                    }
                    
                    completion(arrCities, nil)
                    
                } catch let error as NSError {
                    
                    completion([], error.localizedDescription)
                }
                
                self.disableLoader()
            case .failure( let error):
                
                self.disableLoader()
                completion([], error.localizedDescription)
            }
        }
    }
    
    
    func GetSubCategoryRequest(categoryId:String, strCurrentLanguage: String, completion: @escaping (NSMutableArray, String?) -> Void){
        
        var categoryUrl = ""
        
        if strCurrentLanguage == "en" {
            
            categoryUrl = API_URL + "subcategories/list" + "?categoryId=" + categoryId
        } else {
            
            categoryUrl = API_URL_ar + "subcategories/list" + "?categoryId=" + categoryId
        }
        
        BaseManager.Manager.request(categoryUrl, method:.get, parameters:nil,encoding: JSONEncoding.default).validate().validate(contentType: ["application/json"]).responseString { HTTPResponse in
            
            let arrCategory:NSMutableArray = []
            
            switch HTTPResponse.result {
                
            case .success(let response):
                
                let data = response.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
                    
                    for categoryValue in json {
                        
                        let categoryModel = Items()
                        
                        categoryModel.created_at = categoryValue["created_at"] as? String
                        categoryModel.updated_at = categoryValue["updated_at"] as? String
                        categoryModel.path = categoryValue["path"] as? String
                        categoryModel.name = categoryValue["name"] as? String
                        categoryModel.id = Int((categoryValue["id"] as? String)!)
                        
                        let arrChildCategory:NSMutableArray = []
                        
                        if let childCategories = categoryValue["subcategories"] as? [Any]  {
                            
                            for childCategoryValue in childCategories {
                                
                                let dictCategory = childCategoryValue as! [String: Any]
                                
                                let childCategoryModel = Items()
                            
                                childCategoryModel.created_at = dictCategory["created_at"] as? String
                                childCategoryModel.updated_at = dictCategory["updated_at"] as? String
                                childCategoryModel.path = dictCategory["path"] as? String
                                childCategoryModel.name = dictCategory["name"] as? String
                                childCategoryModel.id = Int((dictCategory["id"] as? String)!)
                                
                                arrChildCategory.add(childCategoryModel)
                            }
                        }
                        
                        categoryModel.childCategory = arrChildCategory as? [Items]
                        
                        arrCategory.add(categoryModel)
                    }
                    
                    completion(arrCategory, nil)
                    
                } catch let error as NSError {
                    
                    print("Failed to load: \(error.localizedDescription)")
                    completion([], nil)
                }
                
            case .failure(_):
                
                completion(arrCategory, nil)
            }
        }
    }
    
    //    func loader(message: String){
    //        ANLoader.activityColor = .quiticPink
    //        ANLoader.activityBackgroundColor = .white
    //        ANLoader.activityTextColor = .quiticPink
    //        ANLoader.showLoading(message, disableUI: true)
    //        ANLoader.showLoading()
    //    }
    //
    //    func disableLoader(){
    //        ANLoader.hide()
    //    }
    
}
