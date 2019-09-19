//
//  WishCollectionViewCell.swift
//  quitic3
//
//  Created by APPLE on 7/27/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
protocol RemoveItemWishListProtocol {
    func clickRemoveToWishListBtn(index : Int)
    
}

class WishCollectionViewCell: UICollectionViewCell {
    var cellDelegate : RemoveItemWishListProtocol?
    var index: IndexPath?
    @IBOutlet weak var ProductName: UILabel!
    @IBOutlet weak var lblBrandName: UILabel!
    
    @IBOutlet weak var imgNewTag: UIImageView!
    @IBOutlet weak var imageSectionView: UIView!
    @IBOutlet weak var ProductImage: UIImageView!
    
    @IBOutlet weak var ratingcosmos: CosmosView!
    @IBOutlet weak var reviews: UILabel!
    
    @IBOutlet weak var PriceTag: UILabel!

    @IBOutlet weak var productCount: UILabel!
    @IBOutlet weak var RemoveProduct: UIButton!
    @IBOutlet weak var viewOuterBorder: UIView!
    @IBAction func RemoveProduct(_ sender: Any) {
        cellDelegate?.clickRemoveToWishListBtn(index: (index?.row)!)
    }
    

}
