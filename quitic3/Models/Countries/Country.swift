import Foundation
import ObjectMapper

class Country : Mappable {
	var id : String?
	var two_letter_abbreviation : String?
	var three_letter_abbreviation : String?
	var full_name_locale : String?
	var full_name_english : String?
	var available_regions : [Available_regions]?

 required	init?(map: Map) {
    
    self.id = ""
    self.two_letter_abbreviation = ""
    self.three_letter_abbreviation = ""
    self.full_name_locale = ""
    self.full_name_english = ""
    self.available_regions = []
	}
    
    init(){
    }

	 func mapping(map: Map) {

		id <- map["id"]
		two_letter_abbreviation <- map["two_letter_abbreviation"]
		three_letter_abbreviation <- map["three_letter_abbreviation"]
		full_name_locale <- map["full_name_locale"]
		full_name_english <- map["full_name_english"]
		available_regions <- map["available_regions"]
	}

}

class CountryList : Mappable {
    
    var code: String?
    var lable: String?
    
    required init?(map: Map) {
        
        self.code = ""
        self.lable = ""
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        
        self.code <- map["code"]
        self.lable <- map["name"]
    }
}
