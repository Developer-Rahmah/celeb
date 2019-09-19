//
//  BrandDetailHeaderViewController.swift
//  quitic3
//
//  Created by ZWT on 5/2/19.
//  Copyright © 2019 DOT. All rights reserved.
//

import UIKit
import SDWebImage

class BrandDetailHeaderViewController: UIViewController {
    
    var celebName = ""
    var celebBannerUrl: String = ""
    var currentLanguage: String = "en"
    
    @IBOutlet weak var lblCelebName: UILabel!
    @IBOutlet weak var celebBanner: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblCelebName.text = celebName
        
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
            
            if self.currentLanguage == "en"{
                self.lblCelebName.font = UIFont(name: headerFont, size: 24)!
            }
            else{
                self.lblCelebName.font = UIFont(name: arLanguageConstant, size: 24)!
            }
        }
        
        if celebBannerUrl != ""{
            //            self.celebBanner.af_setImage(withURL: URL(string: self.celebBannerUrl)! , placeholderImage: UIImage(named: "ImagePlaceholder"), filter:nil, imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: true, completion: nil)
            
            
            //sdImageView Changes.
            let url = URL(string:celebBannerUrl)
            
            self.celebBanner.sd_setImage(with: url, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
            
//            BaseManager.Manager.request(self.celebBannerUrl).responseImage { response in
//                if let image = response.result.value {
//                    self.celebBanner.image = image
//                }
//                else{
//                    self.celebBanner.image = UIImage(named: "ImagePlaceholder")
//                }
//            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
