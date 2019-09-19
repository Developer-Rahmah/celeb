//
//  SegmentViewCntrl.swift
//  quitic3
//
//  Created by ZWT on 4/10/19.
//  Copyright © 2019 DOT. All rights reserved.
//

import UIKit
import SJSegmentedScrollView
import SDWebImage

class SegmentViewCntrl: UIViewController {
    
    var headerview : TopHeaderView? = nil
    var currentLanguage = ""
    var celebName = "";
    var celebId: Int = 0;
    var celebBanner: String = ""
    var labels = AppLabels()
    var lblHeader = UILabel()
    var viewNavCenter = UIView()
    var boolLoadFirst:Bool = false
    
    @IBOutlet weak var scrvSegment: UIScrollView!
    
    override func viewDidLoad() {
            if let storyboard = self.storyboard {
                let headerController = storyboard
                    .instantiateViewController(withIdentifier: "CelebDetailsHeaderViewController") as! CelebDetailsHeaderViewController
              //  headerController.celebName = self.celebName
              //  headerController.celebBannerUrl = self.celebBanner
                let firstViewController = storyboard
                    .instantiateViewController(withIdentifier: "MyBoutiquesViewController") as! MyBoutiquesViewController
              //  firstViewController.celebId = self.celebId
              //  firstViewController.celebName = self.celebName
                let secondViewController = storyboard
                    .instantiateViewController(withIdentifier: "MyVideosViewController") as! MyVideosViewController
              //  secondViewController.celebId = self.celebId
              //  secondViewController.celebItem = self.celebItem
                let thirdViewController = UIStoryboard(name: "LoginStoryboard", bundle: nil)
                    .instantiateViewController(withIdentifier: "SocialViewController") as! SocialViewController
               // thirdViewController.celebItem = self.celebItem
                

                let view = (Bundle.main.loadNibNamed("TopHeaderView", owner: self, options: nil)![0] as? TopHeaderView)
                headerview = view
                
                //        let border = CALayer()
                //        let myColor = UIColor.quiticPink
                //
                //        border.backgroundColor = myColor.cgColor
                //        border.frame = CGRect(x: 0, y: (headerview?.frame.size.height)! - 30, width: headerview!.frame.size.width, height: 30)
                //        headerview!.layer.addSublayer(border)
                //
                
                
                headerview?.celebName.text = self.celebName
                //headerview?.celebImage = self.celebBanner
                if self.celebBanner != ""{
                    //            self.celebBanner.af_setImage(withURL: URL(string: self.celebBannerUrl)! , placeholderImage: UIImage(named: "ImagePlaceholder"), filter:nil, imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: true, completion: nil)
                    
                    
                    //sdImageView Changes.
                    let strImageUrl:String = self.celebBanner
                    
                    let urlCelebImage = URL(string:strImageUrl)
                    
                    self.headerview?.celebImage.sd_setImage(with: urlCelebImage, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
                    
//                    BaseManager.Manager.request(self.self.celebBanner).responseImage { response in
//                        if let image = response.result.value {
//                            self.headerview?.celebImage.image = image
//                        }
//                        else{
//                            self.headerview?.celebImage.image = UIImage(named: "ImagePlaceholder")
//                        }
//                    }
                }
               
                scrvSegment.addSubview(headerview!)
                
        }
        
        title = "Segment"
        super.viewDidLoad()
    }
    
    func getSegmentTabWithImage(_ imageName: String) -> UIView {
        
        let view = UIImageView()
        view.frame.size.width = 100
        view.image = UIImage(named: imageName)
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .white
        return view
    }
    
}
