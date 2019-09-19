//
//  CartTableViewCell.swift
//  quitic3
//
//  Created by APPLE on 7/19/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit

protocol deleteItemProtocol {
    func deleteItemBtn(index: IndexPath)
}

protocol addQuantityBtnProtocol {
    func addQuantityBtnButton(index: IndexPath)
}

protocol subtractQuantityProtocol {
    func subtractQuantityBtn(index: IndexPath)
}

class CartTableViewCell: UITableViewCell {

    var deleteItemDelegate: deleteItemProtocol?
    var addQuantityDelegate: addQuantityBtnProtocol?
    var subtractQuantityDelegate: subtractQuantityProtocol?
    
    var index: IndexPath?
    
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    
    
    
    @IBAction func deleteItem(_ sender: Any) {
        deleteItemDelegate?.deleteItemBtn(index: (index)!)
    }
    
    
    @IBAction func addQuantityBtn(_ sender: Any) {
        addQuantityDelegate?.addQuantityBtnButton(index: (index)!)
    }
    
    
    @IBAction func subtractQuantity(_ sender: Any) {
        subtractQuantityDelegate?.subtractQuantityBtn(index: (index)!)
    }
    
    
}
