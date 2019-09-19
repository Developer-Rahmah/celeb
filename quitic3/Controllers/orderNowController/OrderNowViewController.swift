import UIKit
import CoreData
import ImageSlideshow
import SideMenu
import AlamofireImage
import MaterialComponents.MaterialSnackbar
import Localize_Swift
import Alamofire
import AlamofireObjectMapper
import PromiseKit
import SwiftyJSON
import ANLoader
import DropDown
import ObjectMapper
import SDWebImage
class OrderNowViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var guestCartId :String = ""
    var guestCartIdentity :String = ""
    var currentLanguage = ""
    
    @objc func setText(){
        let labels = AppLabels()
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
        //self.title = labels.CHECKOUT
        lblBillingAddress.text = labels.BILLINGADDRESS
        
        lblShippingAddress.text = labels.SHIPPINGADDRESS
        
        lblShippingMethodText.text = labels.SHOPINGMETHOD
        
        lblOrderNotes.text = labels.ORDERNOTES
        
        lblSubTotal.text = labels.SUBTOTal
        
        lblProducts.text = labels.PRODUCTS
        
        lblTotalText.text = labels.TOTAL
        
        lblSubTotalText.text = labels.SUBTOTal
        
        lblDiscountText.text = labels.DISCOUNT
        
        lblShippingText.text = labels.SHIPPING
        
        lblShippingMethod.text = labels.SHOPINGMETHOD
        
        lblTaxText.text = labels.TAX
        
        btnPaymentMethod.setTitle(labels.PAYMENTMETHOD, for: .normal)
        
        btnCancel.setTitle(labels.APPLY, for: .normal)
        
        btnOrderCancel.setTitle(labels.CANCEL, for: .normal)
        
        txtCouponCode.placeholder = labels.COUPONCODE
        
        orderNowBtn.setTitle(labels.ORDERNOW, for: .normal)
        if self.currentLanguage == "en"{
            lblShippingMethodText.text = "Free Shipping (Free Shipping)"
            lblBillingAddress.font = UIFont(name: enLanguageConstant, size: 17)!
            lblShippingAddress.font = UIFont(name: enLanguageConstant, size: 17)!
            lblShippingMethodText.font = UIFont(name: enLanguageConstant, size: 17)!
            lblOrderNotes.font = UIFont(name: enLanguageConstant, size: 17)!
            lblSubTotal.font = UIFont(name: enLanguageConstant, size: 17)!
            lblProducts.font = UIFont(name: enLanguageConstant, size: 17)!
            lblTotalText.font = UIFont(name: enLanguageConstant, size: 17)!
            lblSubTotalText.font = UIFont(name: enLanguageConstant, size: 17)!
            lblDiscountText.font = UIFont(name: enLanguageConstant, size: 17)!
            lblShippingText.font = UIFont(name: enLanguageConstant, size: 17)!
            lblTaxText.font = UIFont(name: enLanguageConstant, size: 17)!
            lblShippingMethod.font = UIFont(name: enLanguageConstant, size: 17)!
            btnPaymentMethod.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
            btnCancel.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
            btnOrderCancel.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
            orderNowBtn.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
            
        }
        else{
           // self.title = "الدفع"
            lblShippingMethodText.text = "شحن مجاني (شحن مجاني)"
            lblShippingMethodText.font = UIFont(name: arLanguageConstant, size: 17)!
            lblBillingAddress.font = UIFont(name: arLanguageConstant, size: 17)!
            lblShippingAddress.font = UIFont(name: arLanguageConstant, size: 17)!
            lblOrderNotes.font = UIFont(name: arLanguageConstant, size: 17)!
            lblSubTotal.font = UIFont(name: arLanguageConstant, size: 17)!
            lblProducts.font = UIFont(name: arLanguageConstant, size: 17)!
            lblShippingMethod.font = UIFont(name: arLanguageConstant, size: 17)!
            btnPaymentMethod.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            btnCancel.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            btnOrderCancel.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            orderNowBtn.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            lblTotalText.font = UIFont(name: arLanguageConstant, size: 17)!
            lblSubTotalText.font = UIFont(name: arLanguageConstant, size: 17)!
            lblDiscountText.font = UIFont(name: arLanguageConstant, size: 17)!
            lblShippingText.font = UIFont(name: arLanguageConstant, size: 17)!
            lblTaxText.font = UIFont(name: arLanguageConstant, size: 17)!
            
        }
    }
    
    @IBOutlet weak var lblBillingAddress: UILabel!
    @IBOutlet weak var lblShippingAddress: UILabel!
    
    @IBOutlet weak var lblShippingMethodText: UILabel!
    @IBOutlet weak var lblShippingMethod: UILabel!
    @IBOutlet weak var lblOrderNotes: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblProducts: UILabel!
    var totalnum = 0.0;
    
    @IBOutlet weak var lblTotalText: UILabel!
    @IBOutlet weak var lblSubTotalText: UILabel!
    @IBOutlet weak var lblDiscountText: UILabel!
    
    @IBOutlet weak var lblShippingText: UILabel!
    @IBOutlet weak var lblTaxText: UILabel!
    
    @IBOutlet weak var btnPaymentMethod: UIButton!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var btnOrderCancel: UIButton!
    
    let cartManager = CheckoutManager()
    let paymentDropDown = DropDown()
    @IBOutlet weak var productTableView: UITableView!
    var cartItems:[CartItem] = [CartItem]()
    var billingAdressItems: [BillingAddress] = []
    var adressItems: [AddressInformation] = []
    var selectedPaymentMethod = "cashondelivery"
    var paymentMethod:[Payment_methods] = []
    
    @IBOutlet weak var shippingAddressName: UILabel!
    @IBOutlet weak var shippingAddressCityState: UILabel!
    @IBOutlet weak var shippingAddressStreat: UILabel!
    
    @IBOutlet weak var billingAddressName: UILabel!
    @IBOutlet weak var billingAddressCityState: UILabel!
    
    @IBOutlet weak var billingAddressStreat: UILabel!
    @IBOutlet weak var paymentMethodDropdown: UIButton!
    
    @IBOutlet weak var orderNowBtn: UIButton!
    
    @IBOutlet weak var productsViewHeight: NSLayoutConstraint!
    
    // calculation section
    
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var tax: UILabel!
    @IBOutlet weak var shipping: UILabel!
    
    @IBOutlet weak var discount: UILabel!
    @IBOutlet weak var total: UILabel!
    
    @IBOutlet weak var txtCouponCode: UITextField!
    
    var lblHeader = UILabel()
    var viewNavCenter = UIView()
    
    @IBAction func PayMethodSelectionAction(_ sender: Any) {
        self.paymentDropDown.show()
    }
    
    @IBAction func NextToThanks(_ sender: Any) {
        
        
        if  (UserDefaults.standard.string(forKey: "token") != nil) {
            print("payment gateway here: PostPaymentInformation")
            self.PostPaymentInformation()
        }
        else{
            print("payment gateway setting: PostPaymentInformation")
            //PutPlaceOrder
            let itemParams: Parameters = [
                "paymentMethod":  [
                    "method": self.selectedPaymentMethod
                ]
            ]
            
            if self.selectedPaymentMethod == "HyperPay_Master" || self.selectedPaymentMethod == "HyperPay_Visa"{
                let HyperPayController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HyperPayViewController") as! HyperPayViewController
                
                if self.selectedPaymentMethod == "HyperPay_Master"
                {
                    HyperPayController.CardBrand = "MASTER"
                }
                
                HyperPayController.paymentCode = self.selectedPaymentMethod
                HyperPayController.guestCartIdentity = guestCartIdentity
                HyperPayController.selectedPaymentMethod = selectedPaymentMethod
                HyperPayController.isCustomer = false
                self.navigationController?.pushViewController(HyperPayController, animated: true)
                
            }
            else{
                cartManager.PutPlaceOrder(guestCartId: self.guestCartIdentity, postParams: itemParams) { (result , error) in
                    let ConfirmOrderViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConfirmOrderViewController") as! ConfirmOrderViewController
                    
                    if Localize.currentLanguage() == "en"{
                        print("result: ", result)
                        if result! != JSON.null{
                            ConfirmOrderViewController.stringPassed = "Your order no is: \(result!)"
                            self.navigationController?.pushViewController(ConfirmOrderViewController, animated: true)
                        }
                        else{
                            let message = MDCSnackbarMessage()
                            message.text = "Error occured while placing order"
                            MDCSnackbarManager.show(message)
                        }
                        
                    }
                    else{
                        if result! != JSON.null{
                            ConfirmOrderViewController.stringPassed = "\(result!)" + "طلبك لا:"
                            self.navigationController?.pushViewController(ConfirmOrderViewController, animated: true)
                        }
                        else{
                            let message = MDCSnackbarMessage()
                            message.text = "حدث خطأ أثناء تقديم الطلب"
                            MDCSnackbarManager.show(message)
                            
                        }
                        
                    }
                    
                }
            }
        }
    }
    func  updateTotal(){
        
        
        
        var totalItems: Int32 = 0
        var totalPrice: Double = 0
        for item in cartItems{
            let currentPrice = Double(item.quantity) * item.price
            totalItems += item.quantity
            totalPrice += currentPrice
        }
        
        if self.currentLanguage == "en"{
            
            self.subTotal.text = "  (\(totalItems))"
           
        }
        else{
            
            self.subTotal.text = "  (\(totalItems))"
            
        }
        
        self.subTotal.text = "\(totalPrice) JOD"
        self.totalnum = Double(totalPrice)

        NotificationCenter.default.post(name: Notification.Name("updateCartQuantityBadge"), object: nil)
    }
    
    
    override func viewDidLoad() {
        
        self.productsViewHeight.constant = 44
        
        super.viewDidLoad()
        self.subTotal.text = ""
        self.tax.text = ""
        self.shipping.text = ""
        self.discount.text = ""
        self.total.text = ""
        self.orderNowBtn.isEnabled = false
        if  (UserDefaults.standard.string(forKey: "token") != nil) {
            PostCustomerCart()
        }
        else{
            PostGuestCart()
        }
        
        ShippingAddress()
        BillingAddress()
        FetchCartItems()
        self.productTableView.delegate = self
        self.productTableView.dataSource = self
        self.paymentDropDown.anchorView = self.paymentMethodDropdown
        
        self.paymentDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("item selected :\(item)")
            self.selectedPaymentMethod = self.paymentMethod[index].code!
            print(self.selectedPaymentMethod)
            self.paymentMethodDropdown.setTitle("\(item)", for: .normal)
            self.orderNowBtn.isEnabled = true
            self.orderNowBtn.backgroundColor = UIColor.black;
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.setText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewNavCenter = UIView(frame: CGRect(x: 0, y: -13, width:  (self.navigationController?.navigationBar.frame.size.width)!, height: 20))
        viewNavCenter.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.addSubview(viewNavCenter)
        
        lblHeader = UILabel.init(frame:  CGRect(x: 50, y: -11, width: self.view.frame.width - 100, height: 50))
        //lblHeader.font = UIFont.init(name: headerFont, size: 30)
        lblHeader.textAlignment = .center
        lblHeader.textColor = UIColor.init(red: 251, green: 96, blue: 127)
        
        if self.currentLanguage == "en"
        {
            lblHeader.text = "Check Out"
            lblHeader.font = UIFont.init(name: enMarselLanguageConstant, size: 23)
            
        }
        else
        {
            lblHeader.text = "الدفع"
            lblHeader.font = UIFont.init(name: arLanguageConstant, size: 23)
        }
        
        self.navigationController?.navigationBar.addSubview(lblHeader)
        self.updateTotal();

    }
    override func viewWillDisappear(_ animated: Bool) {
        
        lblHeader.removeFromSuperview()
        viewNavCenter.removeFromSuperview()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("total products: \(self.cartItems.count)")
        self.productsViewHeight.constant = CGFloat((self.cartItems.count * 146) + 44)
        print("total products height: \(self.productsViewHeight.constant)")
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderNowTableViewCell", for: indexPath) as! orderNowTableViewCell
        cell.productTitleLbl.text = cartItems[indexPath.row].name!
        
        //sdImageView Changes.
        let strProductImage:String = cartItems[indexPath.row].imageUrl!
    
        let url = URL(string:strProductImage)
    
        cell.productImage.sd_setImage(with: url, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
        
//        BaseManager.Manager.request(cartItems[indexPath.row].imageUrl!).responseImage { response in
//            if let image = response.result.value {
//                cell.productImage.image = image
//            }
//            else{
//                cell.productImage.image = UIImage(named: "ImagePlaceholder")
//            }
//        }
        
        cell.productPriceLbl.text = "JOD \(cartItems[indexPath.row].price)"
        cell.productQuantityLbl.text = "\(cartItems[indexPath.row].quantity)"
        
        cell.totalLbl.text = "JOD \(cartItems[indexPath.row].price * Double(cartItems[indexPath.row].quantity))"
        
        print("cell height: \(cell.bounds.height)")
        
        if self.currentLanguage == "en"{
            cell.productPriceLbl.font = UIFont(name: enLanguageConstant, size: 17)!
            cell.productQuantityLbl.font = UIFont(name: enLanguageConstant, size: 17)!
            cell.lblproductPriceLable.text = "Product Price"
            cell.lblproductPriceLable.font = UIFont(name: enLanguageConstant, size: 17)!
            
            cell.lblproductQuantitylable.text = "Quantity"
            cell.lblproductQuantitylable.font = UIFont(name: enLanguageConstant, size: 17)!
            
            cell.lblproductTotalLable.text = "Total"
            cell.lblproductTotalLable.font = UIFont(name: enLanguageConstant, size: 17)!
        }
        else{
             cell.productPriceLbl.font = UIFont(name: enLanguageConstant, size: 17)!
             cell.productQuantityLbl.font = UIFont(name: enLanguageConstant, size: 17)!
            
            cell.lblproductPriceLable.text = "سعر المنتج"
            cell.lblproductPriceLable.font = UIFont(name: arLanguageConstant, size: 17)!
            
            cell.lblproductQuantitylable.text = "كمية"
            cell.lblproductQuantitylable.font = UIFont(name: arLanguageConstant, size: 17)!
            
            cell.lblproductTotalLable.text = "مجموع"
            cell.lblproductTotalLable.font = UIFont(name: arLanguageConstant, size: 17)!
        }
        
        return cell
    }
    
    func ShippingAddress() {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AddressInformation")
        
        do{
            adressItems = try managedContext.fetch(fetchRequest) as! [AddressInformation]
            shippingAddressName.text = "\(adressItems[0].firstname!) \(adressItems[0].lastname!)"
            shippingAddressCityState.text = "\(adressItems[0].region!) \(adressItems[0].city!)"
            shippingAddressStreat.text = "\(adressItems[0].street!)"
        }catch{
            debugPrint("Could not fetch: \(error.localizedDescription)")
            return
        }
    }
    
    func BillingAddress() {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BillingAddress")
        
        do{
            billingAdressItems = try managedContext.fetch(fetchRequest) as! [BillingAddress]
            billingAddressCityState.text = "\(billingAdressItems[0].region!) \(billingAdressItems[0].city!)"
            billingAddressName.text = "\(billingAdressItems[0].firstname!) \(billingAdressItems[0].lastname!)"
            billingAddressStreat.text = "\(billingAdressItems[0].street!)"
        }catch{
            debugPrint("Could not fetch: \(error.localizedDescription)")
            return
        }
    }
    //CartItem
    func FetchCartItems() {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItem")
        
        do{
            cartItems = try managedContext.fetch(fetchRequest) as! [CartItem]
            self.productTableView.reloadData()
            
        }catch{
            debugPrint("Could not fetch: \(error.localizedDescription)")
            return
        }
    }
    fileprivate  func PostGuestCart(){
        cartManager.postGuestCart(completion: { (result) in
            self.guestCartIdentity = result;
            self.PostGuestCartItem(guestCartId: result)
            //self.PostGuestShippingMethods(guestCartId: result)
        })
    }
    
    fileprivate  func PostCustomerCart(){
        cartManager.postQuoteRequest(completion: { (result) in
            //self.guestCartIdentity = result;
            self.PostCustomerCartItem(quoteId: result)
        })
    }
    
    // PostCustomerCartItem Start
    
    fileprivate  func PostCustomerCartItem(quoteId : String){
        var  cartproducts = [CartItem]()
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItem")
        do{
            cartproducts = try managedContext.fetch(fetchRequest) as! [CartItem]
            
        }catch{
            debugPrint("Could not fetch: \(error.localizedDescription)")
            return
        }
        var count = 0;
        for cartproduct in cartproducts{
            let itemParams: Parameters = [
                "cartItem":  [
                    "quote_id": quoteId.replacingOccurrences(of: "\"", with: ""),
                    "sku": cartproduct.sku!,
                    "qty": cartproduct.quantity
                    //"celebrityId":cartproduct.celebrityId!
                ]
            ]
            cartManager.postCustomerCheckoutCartItem(celebId: cartproduct.celebrityId!, postParams: itemParams) { (result) in
                count += 1
                if cartproducts.count == count
                {
                    self.PostCustomerShippingInformation(quoteId: quoteId)
                }
            }
        }
    }
    
    //Get Shipping Method
    fileprivate  func PostGuestShippingMethods(guestCartId : String)
    {
        cartManager.postShippingMethods(guestCartId:guestCartId,completion: { (result) in
            // self.guestCartIdentity = result;
            self.PostGuestCartItem(guestCartId: guestCartId)
        })
    }
    
    // PostCustomerCartItem End
    fileprivate  func PostGuestCartItem(guestCartId : String){
        var  cartproducts = [CartItem]()
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItem")
        do{
            cartproducts = try managedContext.fetch(fetchRequest) as! [CartItem]
            
        }catch{
            debugPrint("Could not fetch: \(error.localizedDescription)")
            return
        }
        var count = 0;
        for cartproduct in cartproducts{
            let itemParams: Parameters = [
                "cartItem":  [
                    "quote_id": guestCartId.replacingOccurrences(of: "\"", with: ""),
                    "sku": cartproduct.sku!,
                    "qty": cartproduct.quantity
                    //"celebrityId":cartproduct.celebrityId!
                ]
            ]
            cartManager.postCheckoutCartItem(guestCartId: guestCartId, postParams: itemParams, celebId:cartproduct.celebrityId!) { (result) in
                count += 1
                if cartproducts.count == count{
                    self.PostShippingInformation(guestCartId: guestCartId)
                }
            }
        }
    }
    //Edit flows start
    //Send payment information Start
    fileprivate  func PostPaymentInformation(){
        
        let parameters: Parameters = [
            "paymentMethod":  [
                "method": self.selectedPaymentMethod
            ]
        ]
        
        if self.selectedPaymentMethod == "HyperPay_Master" || self.selectedPaymentMethod == "HyperPay_Visa"{
            let HyperPayController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HyperPayViewController") as! HyperPayViewController
            
            if self.selectedPaymentMethod == "HyperPay_Master" {
                HyperPayController.CardBrand = "MASTER"
            }
            
            HyperPayController.paymentCode = self.selectedPaymentMethod
            HyperPayController.guestCartIdentity = guestCartIdentity
            HyperPayController.selectedPaymentMethod = selectedPaymentMethod
            self.navigationController?.pushViewController(HyperPayController, animated: true)
            
        }
        else{
            cartManager.postPaymentInformation(postParams: parameters) { (result) in
                let ConfirmOrderViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConfirmOrderViewController") as! ConfirmOrderViewController
                
                if Localize.currentLanguage() == "en"{
                    
                    if result != nil{
                        ConfirmOrderViewController.stringPassed = "Your order no is: \(result)"
                        self.navigationController?.pushViewController(ConfirmOrderViewController, animated: true)
                    }
                    else{
                        let message = MDCSnackbarMessage()
                        message.text = "Error occured while placing order"
                        MDCSnackbarManager.show(message)
                    }
                }
                else{
                    if result != JSON.null{
                        ConfirmOrderViewController.stringPassed = "\(result)" + "طلبك لا:"
                        self.navigationController?.pushViewController(ConfirmOrderViewController, animated: true)
                    }
                    else{
                        let message = MDCSnackbarMessage()
                        message.text = "حدث خطأ أثناء تقديم الطلب"
                        MDCSnackbarManager.show(message)
                    }
                }
            }
        }
    }
    //Send payment information End
    
    @IBAction func UpdateShippingInformation(_ sender: Any) {
        let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = mainStoryBoard.instantiateViewController(withIdentifier: "ShipingAddressViewController") as! ShipingAddressViewController
        
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
    @IBAction func UpdateBillingInformation(_ sender: Any) {
        let BillingAddressViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BillingAddressViewController") as! BillingAddressViewController
        self.navigationController?.pushViewController(BillingAddressViewController, animated: true)
        
    }
    
    @IBAction func UpdateShippingMethod(_ sender: Any) {
        //let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //let desVC = mainStoryBoard.instantiateViewController(withIdentifier: "ShipingAddressViewController") as! ShipingAddressViewController
        //
        //self.navigationController?.pushViewController(desVC, animated: true)
    }
    
    @IBAction func UpdateProducts(_ sender: Any) {
        let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let productsVC = mainStoryBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        
        self.navigationController?.pushViewController(productsVC, animated: true)
    }
    @IBOutlet weak var UpdateOrderNotes: UIButton!
    //Edit flows End
    
    //postShippingInformation
    fileprivate  func PostShippingInformation(guestCartId: String){
        
        let parameters: Parameters = [
            "addressInformation":  [
                "shippingAddress": [
                    "country_id": adressItems[0].country_id!,
                    "street": [
                        adressItems[0].street!
                    ],
                    "company": "abc",
                    "telephone": adressItems[0].telephone,
                    "city": adressItems[0].city,
                    "postcode": "11110",
                    "firstname": adressItems[0].firstname!,
                    "lastname":  "\u{200D}",
                    "email": adressItems[0].email,
                    "prefix": "address_",
                    "sameAsBilling": adressItems[0].sameAsBilling
                ],
                "billingAddress": [
                    "country_id": billingAdressItems[0].country_id!,
                    "street": [
                        billingAdressItems[0].street!
                    ],
                    "company": "abc",
                    "telephone": billingAdressItems[0].telephone,
                    "city": billingAdressItems[0].city,
                    "postcode": "11110",
                    "firstname": billingAdressItems[0].firstname!,
                    "lastname": "\u{200D}",
                    "email": billingAdressItems[0].email,
                    "prefix": "address_",
                ],
                "shipping_method_code": "flatrate",
                "shipping_carrier_code": "flatrate"
            ]
        ]
        cartManager.postShippingInformation(guestCartId: guestCartId, postParams: parameters) {
            (result , error) in
            if result != nil{
                self.updateTotal();

                self.total.text = "\((result?.totals?.base_currency_code!)!) \(((self.totalnum)+(result?.totals?.shipping_amount!)!))"
                self.updateTotal();

                self.tax.text = "\((result?.totals?.base_currency_code!)!) \((result?.totals?.tax_amount!)!)"
                self.shipping.text = "\((result?.totals?.base_currency_code!)!) \((result?.totals?.shipping_amount!)!)"
                self.discount.text = "\((result?.totals?.base_currency_code!)!) \((result?.totals?.discount_amount!)!)"
//                self.total.text = "\((result?.totals?.base_currency_code!)!) \((result?.totals?.grand_total!)!)"
                self.updateTotal();

                self.paymentDropDown.dataSource = [] //payment_methods
                self.paymentMethod = (result?.payment_methods!)!
                for paymentMethod in (result?.payment_methods!)!{
                    self.paymentDropDown.dataSource.append(paymentMethod.title!)
                }
                print("rahmah cartitems", result)
                self.updateTotal();

            }
                
            else {
                
            }
        }
    }
    //post shipping information end
    //Post Customer Shipping Information Start
    
    fileprivate  func PostCustomerShippingInformation(quoteId: String){
        print("PostCustomerShippingInformation", quoteId)
        
        let parameters: Parameters = [
            "addressInformation":  [
                "shippingAddress": [
                    "country_id": adressItems[0].country_id!,
                    "street": [
                        adressItems[0].street!
                    ],
                    "company": "abc",
                    "telephone": adressItems[0].telephone,
                    "city": adressItems[0].city,
                    "postcode": "11110",
                    "firstname": adressItems[0].firstname!,
                    "lastname":  "-------",
                    "email": adressItems[0].email,
                    "prefix": "address_",
                    "sameAsBilling": adressItems[0].sameAsBilling
                ],
                "billingAddress": [
                    "country_id": billingAdressItems[0].country_id!,
                    "street": [
                        billingAdressItems[0].street!
                    ],
                    "company": "abc",
                    "telephone": billingAdressItems[0].telephone,
                    "city": billingAdressItems[0].city,
                    "postcode": "11110",
                    "firstname": billingAdressItems[0].firstname!,
                    "lastname": "\u{200D}",
                    "email": billingAdressItems[0].email,
                    "prefix": "address_"
                ],
                "shipping_method_code": "flatrate",
                "shipping_carrier_code": "flatrate"
            ]
        ]
        cartManager.postCustomerShippingInformation(quoteId: quoteId, postParams: parameters) { (result , error) in
            if result != nil{
                self.updateTotal();
                
                self.total.text = "\((result?.totals?.base_currency_code!)!) \(((self.totalnum)+(result?.totals?.shipping_amount!)!))"
                self.updateTotal();

                self.tax.text = "\((result?.totals?.base_currency_code!)!) \((result?.totals?.tax_amount!)!)"
                self.shipping.text = "\((result?.totals?.base_currency_code!)!) \((result?.totals?.shipping_amount!)!)"
                self.discount.text = "\((result?.totals?.base_currency_code!)!) \((result?.totals?.discount_amount!)!)"
//                self.total.text = "\((result?.totals?.base_currency_code!)!) \((result?.totals?.grand_total!)!)"
                self.updateTotal();

                Config.amount =   (result?.totals?.grand_total!)!
                
                self.paymentDropDown.dataSource = [] //payment_methods
                self.paymentMethod = (result?.payment_methods!)!
                for paymentMethod in (result?.payment_methods!)!{
                    self.paymentDropDown.dataSource.append(paymentMethod.title!)
                }
            }
            else {
                
            }
        }
        
    }
    //Post Customer Shipping Information End
}

