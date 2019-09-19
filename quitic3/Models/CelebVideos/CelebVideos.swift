import Foundation
import ObjectMapper

class CelebVideos : Mappable {
    var category_id : String?
    var identifier : String?
    var post_id : String?
    var views_count : String?
    var title : String?
    var short_content : String?
    var featured_img : String?
    
    required init?(map: Map) {
        category_id = ""
        identifier = ""
        post_id = ""
        views_count = ""
        title = ""
        short_content = ""
        featured_img = ""
    }
    init(){
    }
    
    func mapping(map: Map) {
        category_id <- map["category_id"]
        identifier <- map["identifier"]
        post_id <- map["post_id"]
        views_count <- map["views_count"]
        title <- map["title"]
        short_content <- map["short_content"]
        featured_img <- map["featured_img"]
    }
    
}
