//
//  DesignableTextField.swift
//  quitic3
//
//  Created by DOT on 7/16/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
@IBDesignable
class DesignableTextField: UITextField {

    @IBInspectable  var leftImage: UIImage?{
        didSet{
            updateView()
        }
    }

    func updateView(){
        if let image = leftImage {
            leftViewMode = .always
            let imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 20, height: 20))
            imageView.image = image
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            view.addSubview(imageView)
            
            leftView = imageView
        }
        else{
            leftViewMode = .never
            
        }
    }

}
