//
//  CartItemCollectionViewCell.swift
//  quitic3
//
//  Created by DOT on 7/13/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialSnackbar

protocol AddOrRemoveFromWishListprotocol {
    func clickAddOrRemoveWishBtn(index : Int)
    
}

protocol AddToCartprotocol {
    func clickAddToCartBtn(index : Int)
}

protocol ClickedCheckedprotocol {
    func clickAddToCheckedView(index : Int)
}

class CartItemCollectionViewCell: UICollectionViewCell {
    
    var cellDelegate :AddOrRemoveFromWishListprotocol?
    var cellCartDelegate:AddToCartprotocol?
    var cellCheckedBtnDelegate: ClickedCheckedprotocol?
    var index: IndexPath?
    
    
    var currentLanguage = ""
 
    
    
    @IBAction func AddToCart(_ sender: Any) {
        cellCartDelegate?.clickAddToCartBtn(index: (index?.row)!)
    }
    @IBOutlet weak var lblBrandName: UILabel!
    @IBOutlet weak var imageSectionView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var wishButton: UIButton!
    @IBOutlet weak var imgNewTag: UIImageView!
    @IBOutlet weak var reviews: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var productCount: UILabel!
    @IBOutlet weak var checkedBtnOutlet: UIButton!
    @IBOutlet weak var ratingcosmos: CosmosView!
    
    @IBOutlet weak var lblOutOfStock: UILabel!
    
    @IBOutlet weak var viewOuterBorder: UIView!
    
    @IBAction func AddOrRemoveFromWishList(_ sender: Any) {
        cellDelegate?.clickAddOrRemoveWishBtn(index: (index?.row)!)
    }
    
    @IBAction func checkedBtnClicked(_ sender: Any) {
        cellCheckedBtnDelegate?.clickAddToCheckedView(index: (index?.row)!)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews()
    {
        
        super.layoutSubviews()
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        if currentLanguage == "en"{
           print("test")
        }
        else{
//            let maximumLabelSize: CGSize = CGSize(width: 300, height: 5)
//            let expectedLabelSize: CGSize = self.reviews.sizeThatFits(maximumLabelSize)
//            var newFrame: CGRect = self.reviews.frame
//            // resizing the frame to calculated size
//            newFrame.size.height = expectedLabelSize.height
//            // put calculated frame into UILabel frame
//            self.reviews.frame = newFrame
            
            
            let maxHeight = CGFloat.infinity
            let rect = self.reviews.attributedText?.boundingRect(with: CGSize(width: 10, height: 25),options: .usesLineFragmentOrigin, context: nil)
            var frame = self.reviews.frame
            frame.size.height = 25
            frame.size.width = 30

            self.reviews.frame = frame
        }
    }
    
    
    
    }
    
}
