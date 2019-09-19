import Foundation
import ObjectMapper

class Videos : Mappable {
    var posts : [Post]?
    var total_number : Int?
    var current_page : Int?
    var last_page : Int?
    
    required init?(map: Map) {
        posts = []
        total_number = 0
        current_page = 0
        last_page = 0
    }
    init(){
    }
    
    func mapping(map: Map) {
        posts <- map["posts"]
        total_number <- map["total_number"]
        current_page <- map["current_page"]
        last_page <- map["last_page"]
    }
    
}
