//
//  BrandManager.swift
//  quitic3
//
//  Created by APPLE on 8/8/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import PromiseKit
import SwiftyJSON
class BrandManager : BaseManager{
    
    //let GetBrands_ENDPOINT = API_URL+"categories/list?searchCriteria[filterGroups][0][filters][0][field]=parent_id&searchCriteria[filterGroups][0][filters][0][value]=29";
    
    func GetBrandsRequest(brandType:String,completion: @escaping (SubCategories?, String?) -> Void){


        let path = BrandApiPathBuilder(apiPath: "categories/list", orderBy: "DESC", pageSize: 10, currentPage: 1, sortBy: "created_at", conditionType: "eq", field: "parent_id", fieldValue: 29, brandType: brandType)

        let request = sessionManager.request(path,headers: API_Header)
        request.validate().responseObject { (response: DataResponse<SubCategories> ) in
            if response.result.isSuccess
            {
                let brands = response.result.value
                completion (brands, nil)
            }
            else{
                completion(nil, response.error?.localizedDescription)
            }
        }
    }
}
