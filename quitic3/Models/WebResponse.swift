/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct WebResponse : Mappable {
	var id : Int?
	var identifier : String?
	var title : String?
	var page_layout : String?
	var content_heading : String?
	var content : String?
	var creation_time : String?
	var update_time : String?
	var sort_order : String?
	var active : Bool?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id <- map["id"]
		identifier <- map["identifier"]
		title <- map["title"]
		page_layout <- map["page_layout"]
		content_heading <- map["content_heading"]
		content <- map["content"]
		creation_time <- map["creation_time"]
		update_time <- map["update_time"]
		sort_order <- map["sort_order"]
		active <- map["active"]
	}

}
