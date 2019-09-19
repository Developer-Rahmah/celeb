//
//  shopTheLookCollectionViewCell.swift
//  quitic3
//
//  Created by DOT on 8/24/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit

protocol shopTheLookBtnCLickedProtocol {
    func shopTheLookBtnClicked(index: IndexPath)
}

class shopTheLookCollectionViewCell: UICollectionViewCell {
    
    var index: IndexPath?
    var cellShopTheLookDelegate: shopTheLookBtnCLickedProtocol?
    
    @IBOutlet weak var celebImage: UIImageView!

    @IBOutlet weak var btnOutlet: UIButton!
    
    
    @IBAction func shopTheLookBtnClicked(_ sender: Any) {
        cellShopTheLookDelegate?.shopTheLookBtnClicked(index: index!)
    }
    
}
