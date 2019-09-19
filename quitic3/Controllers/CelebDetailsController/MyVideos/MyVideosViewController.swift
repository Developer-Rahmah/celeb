//
//  MyVideosViewController.swift
//  quitic3
//
//  Created by DOT on 7/18/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import Localize_Swift
import SJSegmentedScrollView
import SDWebImage

class MyVideosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var currentLanguage = ""
    @objc func setText(){
        let labels = AppLabels()
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
        lblCelebriticlbl.text = labels.CELEBRITYPICKS
        btnSeeAll.setTitle(labels.SEEALL, for: .normal)
        if self.currentLanguage == "en"{
            
            lblCelebriticlbl.font = UIFont(name: enLanguageConstant, size: 17)!
            btnSeeAll.titleLabel?.font = UIFont(name: enLanguageConstant, size: 17)!
            
            self.btnSeeAll.setImage(UIImage(named: "rightArrow"), for: .normal)
            self.btnSeeAll.semanticContentAttribute = .forceRightToLeft
            self.btnSeeAll.contentHorizontalAlignment = .right
            self.btnSeeAll.titleEdgeInsets.right = 10.0
        }
        else{
            
            lblCelebriticlbl.font = UIFont(name: arLanguageConstant, size: 17)!
            btnSeeAll.titleLabel?.font = UIFont(name: arLanguageConstant, size: 17)!
            
            self.btnSeeAll.setImage(UIImage(named: "leftArrow"), for: .normal)
            self.btnSeeAll.semanticContentAttribute = .forceLeftToRight
            self.btnSeeAll.contentHorizontalAlignment = .left
            self.btnSeeAll.titleEdgeInsets.left = 10.0
        }
    }
    @IBOutlet weak var btnSeeAll: UIButton!
    
    @IBOutlet weak var lblCelebriticlbl: UILabel!
    @IBOutlet weak var videosCollection: UICollectionView!
    @IBOutlet weak var scrvMyVideos: UIScrollView!
    
    var celebItem: Any = {}
    var videos:[CelebVideos] = []
    let videosManager = VideosManager()
    var celebId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.setText()
        let videosCollectionWidth = (view.frame.size.width-16-10) / 2
        let videosCollectionViewLayout = videosCollection.collectionViewLayout as!  UICollectionViewFlowLayout
        videosCollectionViewLayout.itemSize = CGSize(width: videosCollectionWidth, height: videosCollectionWidth)
        videosCollection.delegate = self
        videosCollection.dataSource = self
        
        if celebId != 0{
            let url_key : String = (Array((self.celebItem as! Items).custom_attributes!).first(where: { $0.attribute_code! == "url_key" })?.value)!
            if url_key != "" {
                if self.currentLanguage == "en"{
                    self.GetVideos(storeId: 1, identifier: url_key)
                }else{
                    self.GetVideos(storeId: 2, identifier: url_key)
                }
            }
        }
    }

    
    @IBAction func seeAllVideosClicked(_ sender: Any) {
        let TVViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TVViewController") as! TVViewController
        self.navigationController?.pushViewController(TVViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CelebVideosCell", for: indexPath) as! TVSubCollectionViewCell
        
        cell.title.text = self.videos[indexPath.row].title
        
        if currentLanguage == "en"{
            cell.title.textAlignment = .left
            cell.title.font = UIFont(name: enLanguageConstant, size: 13)!
        }
        else{
            cell.title.textAlignment = .right
            cell.title.font = UIFont(name: arLanguageConstant, size: 13)!
        }
        
        //let url = "\(CELEB_VIDEOS_IMAGE_URL)\(self.videos[indexPath.row].featured_img!)"
        
        
        //sdImageView Changes.
        let strThumNailImage:String = "\(CELEB_VIDEOS_IMAGE_URL)\(self.videos[indexPath.row].featured_img!)"
        
        let url = URL(string:strThumNailImage)
        
        cell.thumbNailI!.sd_setImage(with: url, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
        
//        BaseManager.Manager.request(url).responseImage { response in
//            if let image = response.result.value {
//                cell.thumbNailI.image = image
//            }
//            else{
//                cell.thumbNailI.image = UIImage(named: "ImagePlaceholder")
//            }
//        }
//
        var tempUrl = "https://www.youtube.com/embed/"
        if self.videos[indexPath.row].short_content != nil{
            tempUrl +=  "\(String(describing: (self.videos[indexPath.row].short_content)!))"
        }
        else{
            tempUrl += "NpG8iaM0Sfs"
        }
        cell.playBtnDelegate=self
        cell.index = indexPath
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = mainStoryBoard.instantiateViewController(withIdentifier: "VideoDetailsViewController") as! VideoViewController
        
        desVC.videoTitle = self.videos[indexPath.row].title!
        desVC.videoId = Int(self.videos[indexPath.row].post_id!)!
        
        let url = self.videos[indexPath.row].short_content

        print("url: \(String(describing: url))")
        
        desVC.url = "https://www.youtube.com/embed/NpG8iaM0Sfs"

        var tempUrl = "https://www.youtube.com/embed/"
        
        if self.videos[indexPath.row].short_content != nil
        {
            tempUrl +=  "\(String(describing: (self.videos[indexPath.row].short_content)!))"
        }
        else{
            tempUrl += "NpG8iaM0Sfs"
        }
        
        desVC.url = tempUrl
        
        self.navigationController?.pushViewController(desVC, animated: true)
        
    }
    
    
    func GetVideos(storeId: Int, identifier: String){
        self.videosCollection.isHidden = true
        
        self.videosManager.GetCelebVideos(storeId: storeId, identifier: identifier) { (data, error) in
            if error == nil{
                self.videos = data!
                self.videosCollection.reloadData()
                self.videosCollection.isHidden = false
            }else{
                print(error!)
                self.videosCollection.isHidden = false
            }
        }
    }
}

extension MyVideosViewController : playBtnProtocol{
    func playBtn(index: IndexPath) {
        let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = mainStoryBoard.instantiateViewController(withIdentifier: "VideoDetailsViewController") as! VideoViewController
        
        let url = self.videos[index.row].short_content
        
        desVC.videoTitle = self.videos[index.row].title!
        
        print("url: \(String(describing: url))")
        
        desVC.url = "https://www.youtube.com/embed/NpG8iaM0Sfs"
        
        desVC.videoId = Int(self.videos[index.row].post_id!)!
        
        
        var tempUrl = "https://www.youtube.com/embed/"
        
        if self.videos[index.row].short_content != nil{
            tempUrl +=  "\(String(describing: (self.videos[index.row].short_content)!))"
        }
        else{
            tempUrl += "NpG8iaM0Sfs"
        }
        
        desVC.url = tempUrl
        
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
}



extension MyVideosViewController: SJSegmentedViewControllerViewSource {
    
    func viewForSegmentControllerToObserveContentOffsetChange() -> UIView {
        
        return self.scrvMyVideos
    }
}
