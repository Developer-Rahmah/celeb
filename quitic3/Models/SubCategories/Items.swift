/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

class Items : Mappable {
	var name : String?
	var parent_id : Int?
	var updated_at : String?
	var is_active : Bool?
	var level : Int?
	var include_in_menu : Bool?
	var custom_attributes : [Custom_attributes]?
    
	var position : Int?
	var path : String?
	var id : Int?
	var available_sort_by : [String]?
	var created_at : String?
	var children : String?
    var price : Double?
    var sku: String = ""
    var quote_id: String = ""
    var avg_rating_percent : Int?
    var reviews : Int?
    var isWish : Bool = false
    var isAddedToCart : Bool = false
    var wishlistItemId = ""
    
    var childCategory: [Items]?
    var media_gallery_entries : [media_gallery_entries]?
    

	required init?(map: Map) {
        self.name = ""
        self.parent_id = 0
        self.updated_at = ""
        self.is_active = true
        self.level = 0
        self.include_in_menu = false
        self.custom_attributes = []
        self.position = 0
        self.path = ""
        self.id = 0
        self.available_sort_by = []
        self.created_at = ""
        self.children = ""
        self.price = 0
        self.sku = ""
        self.avg_rating_percent = 0
        self.reviews = 0
        self.isWish = false
        self.isAddedToCart = false
        self.wishlistItemId = ""
        self.media_gallery_entries = []
        
	}
    
    init() {}
    required convenience init?(_ map: Map) {
        self.init()
    }

	 func mapping(map: Map) {

		name <- map["name"]
		parent_id <- map["parent_id"]
		updated_at <- map["updated_at"]
		is_active <- map["is_active"]
		level <- map["level"]
		include_in_menu <- map["include_in_menu"]
		custom_attributes <- map["custom_attributes"]
		position <- map["position"]
		path <- map["path"]
		id <- map["id"]
		available_sort_by <- map["available_sort_by"]
		created_at <- map["created_at"]
		children <- map["children"]
        price <- map["price"]
        sku <- map["sku"]
        childCategory <- map["subcategories"]
        media_gallery_entries <- map["media_gallery_entries"]
	}

}
