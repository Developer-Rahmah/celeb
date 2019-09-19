import Foundation
import ObjectMapper

class VideoProductsId : Mappable {
    var post_id : String?
    var related_id : String?
    var position : String?
    
    required init?(map: Map) {
        post_id = ""
        related_id = ""
        position = ""
    }
    init(){
    }
    
    func mapping(map: Map) {
        post_id <- map["post_id"]
        related_id <- map["related_id"]
        position <- map["position"]
    }
    
}
