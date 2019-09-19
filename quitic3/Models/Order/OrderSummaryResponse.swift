// To parse the JSON, add this file to your project and do:
//
//   let orderSummaryResponse = try? JSONDecoder().decode(OrderSummaryResponse.self, from: jsonData)


import Foundation
import ObjectMapper

class  OrderSummaryResponse: Mappable {
    var payment_methods : [Payment_methods]?
    var totals : Totals?
    
  required  init?(map: Map) {
    self.payment_methods = []
    self.totals = Totals()
    }
    init(){
    }
    func mapping(map: Map) {
        
        payment_methods <- map["payment_methods"]
        totals <- map["totals"]
    }
    
}

class Payment_methods : Mappable {
    var code : String?
    var title : String?
    
   required init?(map: Map) {
    self.code = ""
    self.title = ""
    }
    init(){
    }
     func mapping(map: Map) {
        
        code <- map["code"]
        title <- map["title"]
    }
    
}
class Total_segments : Mappable {
    var code : String?
    var title : String?
    var value : Int?
    
   required init?(map: Map) {
        self.code = ""
        self.title = ""
        self.value = 0
    }
    init(){
    }
     func mapping(map: Map) {
        
        code <- map["code"]
        title <- map["title"]
        value <- map["value"]
    }
    
}


class Totals : Mappable {
    var grand_total : Double?
    var base_grand_total : Int?
    var subtotal : Double?
    var base_subtotal : Int?
    var discount_amount : Double?
    var base_discount_amount : Int?
    var subtotal_with_discount : Int?
    var base_subtotal_with_discount : Int?
    var shipping_amount : Double?
    var base_shipping_amount : Int?
    var shipping_discount_amount : Int?
    var base_shipping_discount_amount : Int?
    var tax_amount : Double?
    var base_tax_amount : Int?
    var weee_tax_applied_amount : String?
    var shipping_tax_amount : Int?
    var base_shipping_tax_amount : Int?
    var subtotal_incl_tax : Int?
    var shipping_incl_tax : Int?
    var base_shipping_incl_tax : Int?
    var base_currency_code : String?
    var quote_currency_code : String?
    var items_qty : Int?
    var items : [String]?
    var total_segments : [Total_segments]?
    
   required init?(map: Map) {
        //self. = ""
    self.grand_total  = 0
    self.base_grand_total  = 0
    self.subtotal  = 0
    self.base_subtotal  = 0
    self.discount_amount  = 0
    self.base_discount_amount  = 0
    self.subtotal_with_discount  = 0
    self.base_subtotal_with_discount  = 0
    self.shipping_amount  = 0
    self.base_shipping_amount  = 0
    self.shipping_discount_amount  = 0
    self.base_shipping_discount_amount  = 0
    self.tax_amount  = 0
    self.base_tax_amount  = 0
    self.weee_tax_applied_amount = ""
    self.shipping_tax_amount  = 0
    self.base_shipping_tax_amount = 0
    self.subtotal_incl_tax  = 0
    self.shipping_incl_tax  = 0
    self.base_shipping_incl_tax = 0
    self.base_currency_code  = ""
    self.quote_currency_code = ""
    self.items_qty = 0
    self.items = []
    self.total_segments = []
    }
    init(){
    }
    
     func mapping(map: Map) {
        
        grand_total <- map["grand_total"]
        base_grand_total <- map["base_grand_total"]
        subtotal <- map["subtotal"]
        base_subtotal <- map["base_subtotal"]
        discount_amount <- map["discount_amount"]
        base_discount_amount <- map["base_discount_amount"]
        subtotal_with_discount <- map["subtotal_with_discount"]
        base_subtotal_with_discount <- map["base_subtotal_with_discount"]
        shipping_amount <- map["shipping_amount"]
        base_shipping_amount <- map["base_shipping_amount"]
        shipping_discount_amount <- map["shipping_discount_amount"]
        base_shipping_discount_amount <- map["base_shipping_discount_amount"]
        tax_amount <- map["tax_amount"]
        base_tax_amount <- map["base_tax_amount"]
        weee_tax_applied_amount <- map["weee_tax_applied_amount"]
        shipping_tax_amount <- map["shipping_tax_amount"]
        base_shipping_tax_amount <- map["base_shipping_tax_amount"]
        subtotal_incl_tax <- map["subtotal_incl_tax"]
        shipping_incl_tax <- map["shipping_incl_tax"]
        base_shipping_incl_tax <- map["base_shipping_incl_tax"]
        base_currency_code <- map["base_currency_code"]
        quote_currency_code <- map["quote_currency_code"]
        items_qty <- map["items_qty"]
        items <- map["items"]
        total_segments <- map["total_segments"]
    }
    
}
// Place Order PayLoad

//struct PlaceOrderPayLoad : Mappable {
//    var paymentMethod : PaymentMethod?
//    
//    init?(map: Map) {
//        
//    }
//    
//    mutating func mapping(map: Map) {
//        
//        paymentMethod <- map["paymentMethod"]
//    }
//    
//}
//struct PaymentMethod : Mappable {
//    var method : String?
//    
//    init?(map: Map) {
//        
//    }
//    
//    mutating func mapping(map: Map) {
//        
//        method <- map["method"]
//    }
//    
//}

