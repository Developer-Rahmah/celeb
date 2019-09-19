import Foundation
import ObjectMapper

class Post : Mappable {
    var post_id: String?
    var title : String?
    var meta_description : String?
    var identifier : String?
    var content : String?
    var creation_time : String?
    var update_time : String?
    var featured_img : String?
    var author_id : String?
    var store_id : String?
    var filtered_content : String?
    var featured_image : String?
    var og_description : String?
    var short_content: String?
    
    
    required    init?(map: Map) {
        post_id = ""
        title = ""
        meta_description = ""
        identifier = ""
        content = ""
        creation_time = ""
        update_time = ""
        featured_img = ""
        author_id = ""
        store_id = ""
        filtered_content = ""
        featured_image = ""
        og_description = ""
        short_content = ""
    }
    init(){
    }
    
    func mapping(map: Map) {
        
        post_id <- map["post_id"]
        title <- map["title"]
        meta_description <- map["meta_description"]
        identifier <- map["identifier"]
        content <- map["content"]
        creation_time <- map["creation_time"]
        update_time <- map["update_time"]
        featured_img <- map["featured_img"]
        author_id <- map["author_id"]
        store_id <- map["store_id"]
        filtered_content <- map["filtered_content"]
        featured_image <- map["featured_image"]
        og_description <- map["og_description"]
        short_content <- map["short_content"]
        
    }
    
}
