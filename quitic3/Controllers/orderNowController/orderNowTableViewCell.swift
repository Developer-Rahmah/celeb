//
//  orderNowTableViewCell.swift
//  quitic3
//
//  Created by DOT on 8/8/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit

class orderNowTableViewCell: UITableViewCell {

    @IBOutlet weak var productTitleLbl: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productPriceLbl: UILabel!
    @IBOutlet weak var productQuantityLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    
    @IBOutlet weak var lblproductTotalLable: UILabel!
    @IBOutlet weak var lblproductQuantitylable: UILabel!
    @IBOutlet weak var lblproductPriceLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
