//
//  Constants.swift
//  quitic3
//
//  Created by APPLE on 7/16/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import Foundation
import ANLoader

let appDelegate = UIApplication.shared.delegate as? AppDelegate

var Constant_Fashions_Id: Int = 3
var Constant_Trending_Now_Id: Int = 18
var Constant_Special_Collection_Id: Int = 19
var Constant_Makeup_Id: Int = 25
var Constant_Skin_Care_Id: Int = 26
var Constant_Body_Bath_Id: Int = 27
var Constant_Haircare_Id: Int = 28
var Constant_Brands_Id: Int = 29
var Constant_Fragrances_Id: Int = 44
var Constant_Fashion_Tech_Id: Int = 46
var Constant_Celebrities_Id: Int = 48
var Constant_Tv_Id: Int = 52
var Constant_OrderId:String = ""


// Before shaid bhai path
//let API_URL_ar = "https://ecommerce.mystaging.me/rest/ae/V1/"
//let API_URL="https://ecommerce.mystaging.me/rest/V1/";

//Base Urls
//let Main_URL = "https://ecommerce.mystaging.me/"
//let Main_URL = "http://boutiqa.mystaging.me/"
//let Main_URL = "http://siteproofs.net/magento2/osama/boutiqa/"
let Main_URL = "https://celebritiescart.com/" //"http://siteproofs.net/magento2/osama/boutiqa/" //"https://celebritiescart.com/"
let API_URL_ar = Main_URL+"rest/ae/V1/"
let API_URL = Main_URL+"rest/V1/"
let AlomaFireUrl = "boutiqa.mystaging.me"
//let AlomaFireUrl = "ecommerce.mystaging.me"



//let API_URL_ar = "https://ecommerce.mystaging.me/ae/"
//let API_URL = "https://ecommerce.mystaging.me/";

let loginURL = API_URL+"integration/customer/token";

                      //https://ecommerce.mystaging.me/pub/media/catalog/category/
let CATEGORY_IMAGE_URL = Main_URL+"pub/media/catalog/category/";
let PRODUCT_IMAGE_URL = Main_URL+"pub/media/catalog/product/";
let CELEB_VIDEOS_IMAGE_URL = Main_URL+"pub/media/"

//let CATEGORY_IMAGE_URL = API_URL+"pub/media/catalog/category/";
//let PRODUCT_IMAGE_URL = API_URL+"pub/media/catalog/product/";
//let CELEB_VIDEOS_IMAGE_URL = API_URL+"pub/media/"

//let enLanguageConstant = "Belleza-Regular";

let enLanguageConstant = "MarselisSerifOT";
let enMarselLanguageConstant = "MarselisSerifOT";

let enBoldLanguageConstant = "Montserrat-SemiBold"
let arLanguageConstant = "GEFlow";
let headerFont = "Baskerville"
let MontserratExtraBold = "Montserrat-ExtraBold";

let SignUpURL=API_URL+"customers";
let PostWishURL = API_URL+"wishlist/add";
let GetWishURL = API_URL+"wishlist/items";
let DELETEWishURL = API_URL+"wishlist/items";

let GetCelebrities:String = API_URL+"categories/list?searchCriteria[filterGroups][0][filters][0][field]=parent_id&searchCriteria[filterGroups][0][filters][0][value]=48";

let GetBrands_ENDPOINT = API_URL+"categories/list?searchCriteria[filterGroups][0][filters][0][field]=parent_id&searchCriteria[filterGroups][0][filters][0][value]=29";

let GetProducts_ENDPOINT = API_URL+"products?searchCriteria[filterGroups][0][filters][0][field]=category_id&searchCriteria[filterGroups][0][filters][0][value]=2&searchCriteria[filterGroups][0][filters][0][conditionType]=eq&searchCriteria[sortOrders][0][field]=created_at&searchCriteria[sortOrders][0][direction]=DESC&searchCriteria[pageSize]=10&searchCriteria[currentPage]=1";

let GetCategories_ENDPOINT = API_URL+"categories/list?searchCriteria[filterGroups][0][filters][0][field]=parent_id&searchCriteria[filterGroups][0][filters][0][value]=2";

let GetSubVideo_ENDPOINT = API_URL+"products?searchCriteria[filterGroups][0][filters][0][field]=category_id&searchCriteria[filterGroups][0][filters][0][value]=52&searchCriteria[filterGroups][0][filters][0][conditionType]=eq&searchCriteria[sortOrders][0][field]=created_at&searchCriteria[sortOrders][0][direction]=DESC&searchCriteria[pageSize]=10&searchCriteria[currentPage]=1"

let GetCountries_ENDPOINT = API_URL+"directory/countries"

// Before Shaid Bhai
//let API_Header = [
//    "Authorization": "Bearer e3v4ar3wyo93ieyt87qpp38t5g6nr2ba",
//    "Content-Type": "application/json"
//]
//let CustomerHeader = [
//    "Authorization": "Bearer e3v4ar3wyo93ieyt87qpp38t5g6nr2ba",
//    "Content-Type": "application/json"
//]

let API_Header = [
    "Authorization": "Bearer pjixt6t2ya3es6eeot4nd7tce6d33vd1",
    "Content-Type": "application/json"
]
let CustomerHeader = [
    "Authorization": "Bearer pjixt6t2ya3es6eeot4nd7tce6d33vd1",
    "Content-Type": "application/json"
]

// LOCALIZ

var ENMYBOUTIQUES = "mmmm"
var ENVIDEOS = "Videos"
var ENSOCIALMEDIA = "Social Media"
var ARMYBOUTIQUES = "ماي بوتيك"
var ARVIDEOS =  "الفيديوهات"
var ARSOCIALMEDIA  = "مواقع التواصل الاجتماعي"
