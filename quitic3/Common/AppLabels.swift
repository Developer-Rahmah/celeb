//
//  AppLables.swift
//  quitic3
//
//  Created by APPLE on 9/11/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import Foundation
import Localize_Swift

class AppLabels {
    // HOME SECTION
    var SEEALL = ""
    var CELEBRITIES = ""
    var MYBOUTIQUEPICK = ""
    var EXCLUSIVEBRANDS = ""
    var ALLCATEGORIES = ""
    var VIDEOTUTORIALS = ""
    var SHOPTHELOOK = ""
    var HOME = ""
    var WISHLIST = ""
    var CATEGORIES = ""
    var CART = ""
    var TRENDINGNOW = ""
    var NEWPRODUCTS = ""
    var ADDTOCART = ""
    var SHOPTHELOOK_UPPER = ""
    var currentLanguage = ""
    var SHOP = ""
    var BRANDS = ""
    
    // WISHLIST SECTION
    var REMOVEPRODUCT = ""
    var REVIEWS = ""
//    var WISHLIST = "Wishlist"
    
    // Celebrities Details
    var MYBOUTIQUE = ""
    var VIDEOS = ""
    var SOCIALMEDIA = ""
    var CELEBRITYPICKS = ""
    
    // Cart
    var MYCART = ""
    var CHECKOUT = ""
    
    // CHECK OUT
    var SHIPPINGADDRESS = ""
    var BILLINGADDRESS = ""
    var SHOPINGMETHOD = ""
    var PRODUCTS = ""
    var SUBTOTal = ""
    var TAX = ""
    var SHIPPING = ""
    var DISCOUNT = ""
    var TOTAL = ""
    var CANCEL = ""
    var ORDERNOTES = ""
    var ORDERNOW = ""
    var PAYMENTMETHOD = ""
    //Order Confirmed
    var ORDERCONFIRMED = ""
    var THANKYOU = ""
    var THANKYOUMESSAGE = ""
    var CONTINUESHOPING = ""
    var COUPONCODE = ""
    var ORDERNUMBER = ""
    var APPLY = ""
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        setText()
    }
    
    @objc func setText(){
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
                HomeLableLocalize()
                WishListLableLocalize()
                CelebritiesDetailsLableLocalize()
                ProductPagerLableLocalize()
                MyCartLableLocalize()
                CheckOutLableLocalize()
                OrderConfirmedLableLocalize()
            }
        }
    }
    func OrderConfirmedLableLocalize(){
        if self.currentLanguage == "en"{
            ORDERCONFIRMED = "Order Confirmed"
            THANKYOU = "Thank You"
            THANKYOUMESSAGE = "Thank You for shopping with us!"
            CONTINUESHOPING = "Continue Shoping"
            ORDERNUMBER = "Your Order No is :"
        }
        else{
            ORDERCONFIRMED = "تم تاكيد الطلب"
            THANKYOU = "شكرا"
            THANKYOUMESSAGE = "شكرا للتسوق معنا!"
            CONTINUESHOPING = " متابعة التسوق "
            ORDERNUMBER = "رقم طلبك هو :"
        }
    }
    func CheckOutLableLocalize(){
        if self.currentLanguage == "en"{
            SHIPPINGADDRESS = "Shipping Address"
            BILLINGADDRESS = "Billing Address"
            SHOPINGMETHOD = "Shoping Method"
            PRODUCTS = "Produts"
            SUBTOTal = "Sub Total"
            TAX = "Tax"
            SHIPPING = "Shipping"
            DISCOUNT = "Discount"
            TOTAL = "Total"
            CANCEL = "Cancel"
            ORDERNOTES = "Order Notes"
            ORDERNOW = "Order Now"
            PAYMENTMETHOD = "Payment Method"
            COUPONCODE = "Coupon Code"
            APPLY = "Apply"
        }
        else{
            SHIPPINGADDRESS = "عنوان الشحن"
            BILLINGADDRESS = "عنوان الفاتورة"
            SHOPINGMETHOD = "طريقة التسوق"
            PRODUCTS = "منتجات"
            SUBTOTal = "حاصل الجمع"
            TAX = "ضريبة"
            SHIPPING = "الشحن"
            DISCOUNT = "الخصم"
            TOTAL = "مجموع"
            CANCEL = "الغاء"
            ORDERNOTES = "ملاحظات الطلب"
            ORDERNOW = "اطلب الان"
            PAYMENTMETHOD = "طريقة الدفع"
            COUPONCODE = "رمز القسيمة"
            APPLY = "تطبيق"
        }
    }
    
    func MyCartLableLocalize() {
        if self.currentLanguage == "en"{
            MYCART = "My Cart"
            CHECKOUT = "Check Out"
        }
        else{
            MYCART = "سلة المشتريات"
            CHECKOUT = "الدفع"
        }
    }
    
    func ProductPagerLableLocalize(){
        if self.currentLanguage == "en"{
            SHOP = "Shop"
        }
        else{
           SHOP = "متجر"
        }
    }
    func WishListLableLocalize(){
        if self.currentLanguage == "en"{
            REMOVEPRODUCT = "Remove Product"
            REVIEWS = "Reviews"
        }
        else{
            REMOVEPRODUCT = "إزالة المنتج"
            REVIEWS = " استعراض"
        }
    }
    
    func CelebritiesDetailsLableLocalize() {
        if self.currentLanguage == "en"{
            MYBOUTIQUE = "My Boutique"
            VIDEOS = "Videos"
            SOCIALMEDIA = "Social Media"
            CELEBRITYPICKS = "Celebrity Picks"
        }
        else{
            MYBOUTIQUE = "ماي بوتيك"
            VIDEOS = "الفيديوهات"
            SOCIALMEDIA = "مواقع التواصل الاجتماعي"
            CELEBRITYPICKS = "اختيارات المشاهير"
        }
    }
    
    func HomeLableLocalize()  {
        if self.currentLanguage == "en"{
            CELEBRITIES = "Celebrities"
            HOME = "Home"
            WISHLIST = "Wishlist"
            CATEGORIES = "Categories"
            CART = "Cart"
            SHOPTHELOOK_UPPER = "SHOP THE LOOK"
            SHOPTHELOOK = "Shop the Look"
            SEEALL = "See all"
            MYBOUTIQUEPICK = "My Boutiques Pick"
            EXCLUSIVEBRANDS = "Exclusive Brands"
            ALLCATEGORIES = "All Categories"
            VIDEOTUTORIALS = "Video Tutorials"
            TRENDINGNOW = "Trending Now"
            NEWPRODUCTS = "New Products"
            ADDTOCART = "Add to Cart"
            BRANDS = "Brands"
        }
        else{
            HOME = "الصفحة الرئيسية"
            WISHLIST = "مفضلتي"
            CELEBRITIES = " المشاهير"
            CATEGORIES = "الأقسام"
            CART = "سلة المشتريات"
            SHOPTHELOOK_UPPER = "تسوقي المظهر"
            SHOPTHELOOK = "تسوقي المظهر"
            SEEALL = "اظهار الكل"
            MYBOUTIQUEPICK = "اختيارات بوتيكاتنا"
            EXCLUSIVEBRANDS = "العلامات التجارية الحصرية"
            ALLCATEGORIES = "جميع الأقسام"
            VIDEOTUTORIALS = "فيديوهات تعليمية"
            TRENDINGNOW = "أحدث الصيحات"
            NEWPRODUCTS = "منتجات جديدة"
            ADDTOCART = "أضف إلى السلة"
            BRANDS = "العلامات التجارية"
            //BRANDS = " الحصرية"
        }
    }
}
