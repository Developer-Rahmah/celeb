//
//  TVSubCollectionViewCell.swift
//  quitic3
//
//  Created by DOT on 7/31/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit

protocol playBtnProtocol {
    func playBtn(index: IndexPath)
}

class TVSubCollectionViewCell: UICollectionViewCell {
    
    var playBtnDelegate: playBtnProtocol?
    var index: IndexPath?
    
    @IBOutlet weak var thumbNailI: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    
    @IBAction func playBtnClicked(_ sender: Any) {
        playBtnDelegate?.playBtn(index: (index)!)
    }
}
