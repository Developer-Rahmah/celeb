import UIKit

class Config: NSObject {
    
    // MARK: - The default amount and currency that are used for all payments
    static var amount: Double = 49.99
    static let currency: String = "JOD"
    
    // MARK: - The payment brands for Ready-to-use UI
    static let checkoutPaymentBrands = ["VISA", "MASTER", "PAYPAL"]
    
    // MARK: - The default payment brand for Payment Button
    static let paymentButtonBrand = "VISA"
    
    // MARK: - The card parameters for SDK & Your Own UI form
    static let cardBrand = "VISA"
    static let cardHolder = "JOHN DOE"
    static let cardNumber = "4200000000000000"
    static let cardExpiryMonth = "07"
    static let cardExpiryYear = "2021"
    static let cardCVV = "123"
    
    // MARK: - Other constants
    static let asyncPaymentCompletedNotificationKey = "AsyncPaymentCompletedNotificationKey"
    static let urlScheme = "com.celebritiescart.www.payments"
    static let mainColor: UIColor = UIColor.init(red: 251, green: 96, blue: 127, alpha: 1.0)
}
