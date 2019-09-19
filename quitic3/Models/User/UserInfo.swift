/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct UserInfo : Mappable {
	var id : Int?
	var group_id : Int?
	var created_at : String?
	var updated_at : String?
	var created_in : String?
	var email : String?
	var firstname : String?
    var dob : String?
	var lastname : String?
	var store_id : Int?
	var website_id : Int?
	var addresses : [String]?
	var disable_auto_group_change : Int?
	var extension_attributes : Extension_attributes?
    var custom_attributes:[Custom_attributes]?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id <- map["id"]
		group_id <- map["group_id"]
		created_at <- map["created_at"]
		updated_at <- map["updated_at"]
		created_in <- map["created_in"]
		email <- map["email"]
		firstname <- map["firstname"]
		lastname <- map["lastname"]
		store_id <- map["store_id"]
		website_id <- map["website_id"]
		addresses <- map["addresses"]
        dob <- map["dob"]
		disable_auto_group_change <- map["disable_auto_group_change"]
		extension_attributes <- map["extension_attributes"]
        custom_attributes <- map["custom_attributes"]
	}

}


struct UserProfile:Mappable
{
    var picture_url : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        picture_url <- map["id"]
    }
    
}
