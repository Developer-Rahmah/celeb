import UIKit
import ANLoader
import SDWebImage


class TVViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var videosManager  = VideosManager()
    var pageSize = 2
    var totalPages = 1
    var pageNo = 1
    var currentLanguage: String = "en"
    
    @IBOutlet weak var subCollectionHeight: NSLayoutConstraint!
    
    var subListActivityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var MainCollectionView: UICollectionView!
    
    @IBOutlet weak var subCollectionView: UICollectionView!
    
//    var subVideosArray: [ItemsVideoList] = [ItemsVideoList]()
    
    var subVideoPosts: [Post] = []
    var lblHeader = UILabel()
    var viewNavCenter = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        MainCollectionView.delegate = self
        MainCollectionView.dataSource = self
        
        subCollectionView.delegate = self
        subCollectionView.dataSource = self
        
        let mainCollectionWidth = (view.frame.size.width) / 1
        let mainCollectionViewLayout = MainCollectionView.collectionViewLayout as!  UICollectionViewFlowLayout
        mainCollectionViewLayout.itemSize = CGSize(width: mainCollectionWidth, height: mainCollectionWidth-150)
        
        
        let subCollectionWidth = (view.frame.size.width-16-10) / 2
        let subCollectionViewLayout = subCollectionView.collectionViewLayout as!  UICollectionViewFlowLayout
        subCollectionViewLayout.itemSize = CGSize(width: subCollectionWidth, height: subCollectionWidth)
        
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
                
                if self.currentLanguage == "en"{
                    self.GetSubVideos(storeId: 1)
                    //self.title = "Videos"
                }
                else{
                    self.GetSubVideos(storeId: 2)
                   // self.title = "أشرطة فيديو"
                }
                
            }
            else{
                self.GetSubVideos(storeId: 1)
            }
            
        }
        
        for constraint in self.view.constraints {
            print("constraint:", constraint.constant)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        viewNavCenter = UIView(frame: CGRect(x: 0, y: -13, width:  (self.navigationController?.navigationBar.frame.size.width)!, height: 20))
        viewNavCenter.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.addSubview(viewNavCenter)
        
        
        
        lblHeader = UILabel.init(frame:  CGRect(x: 30, y: -11, width: viewNavCenter.frame.size.width - 60, height: 50))
        
        lblHeader.font = UIFont.init(name: headerFont, size: 30)
        lblHeader.textAlignment = .center
        lblHeader.textColor = UIColor.init(red: 251, green: 96, blue: 127)
        
        if self.currentLanguage == "en"
        {
            lblHeader.text = "Videos"
            lblHeader.font = UIFont.init(name: enMarselLanguageConstant, size: 23)
        }
        else
        {
            lblHeader.text = "الفيديوهات"
            lblHeader.font = UIFont.init(name: arLanguageConstant, size: 23)
        }


        self.navigationController?.navigationBar.addSubview(lblHeader)
    }

    override func viewWillDisappear(_ animated: Bool) {
        lblHeader.removeFromSuperview()
        viewNavCenter.removeFromSuperview()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == subCollectionView{
            if self.subVideoPosts.count > 0 {
                print("height yeah \(self.subVideoPosts.count) | \(CGFloat(self.subVideoPosts.count))")
                
                let cellWidth = (view.frame.size.width-16-10) / 2
                let cellHeight = cellWidth
                let rowsCount = ceil(CGFloat(self.subVideoPosts.count) / CGFloat(2))
                let height =  (cellHeight * rowsCount)
                
                
                print("if sub collection height final \(height)")
                subCollectionHeight.constant = height + 50
                self.view.layoutIfNeeded()
            }
            else{
                subCollectionHeight.constant = 345
                self.view.layoutIfNeeded()
                
                print("else sub collection height final 1000")
            }
            
            
            return self.subVideoPosts.count
        }else{
            if self.subVideoPosts.count > 0 {
                return 1
            }
            else{
                return self.subVideoPosts.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == MainCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TVMainCollectionViewCell", for: indexPath) as! TVMainCollectionViewCell
            
            
            
            cell.videoTitle.text = self.subVideoPosts[indexPath.row].title
            
            
            if currentLanguage == "en"{
                cell.videoTitle.textAlignment = .left
                cell.videoTitle.font = UIFont(name: enLanguageConstant, size: 20)!
            }
            else{
                cell.videoTitle.textAlignment = .right
                cell.videoTitle.font = UIFont(name: arLanguageConstant, size: 20)!
            }
            
//            let url = URL(string: self.subVideoPosts[indexPath.row].featured_image!)
//
//            cell.mainImage.af_setImage(withURL: url!, placeholderImage: UIImage(named: "ImagePlaceholder"), filter:nil, imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: true, completion: nil)
            
            
            //sdImageView Changes.
            let strMainImage:String = self.subVideoPosts[indexPath.row].featured_image!
            
            let url = URL(string:strMainImage)
            
            cell.mainImage.sd_setImage(with: url, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
            
            
//            BaseManager.Manager.request( self.subVideoPosts[indexPath.row].featured_image!).responseImage { response in
//                if let image = response.result.value {
//                    cell.mainImage.image = image
//                }
//                else{
//                    cell.mainImage.image = UIImage(named: "ImagePlaceholder")
//                }
//            }
            var tempUrl = "https://www.youtube.com/embed/"
            
            if self.subVideoPosts[indexPath.row].short_content != nil{
                tempUrl +=  "\(String(describing: (self.subVideoPosts[indexPath.row].short_content)!))"
            }
            else{
                tempUrl += "NpG8iaM0Sfs"
            }
            
            print("Video Url start")
            print(tempUrl)
            print("Video Url end")
            
            
            
            return cell
            
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TVSubCollectionViewCell", for: indexPath) as! TVSubCollectionViewCell
            
            cell.title.text = self.subVideoPosts[indexPath.row].title
            
            if currentLanguage == "en"{
                cell.title.textAlignment = .left
                cell.title.font = UIFont(name: enLanguageConstant, size: 13)!
            }
            else{
                cell.title.textAlignment = .right
                cell.title.font = UIFont(name: arLanguageConstant, size: 13)!
            }
            
//            let url = URL(string: self.subVideoPosts[indexPath.row].featured_image!)
//
//            cell.thumbNailI.af_setImage(withURL: url!, placeholderImage: UIImage(named: "ImagePlaceholder"), filter:nil, imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: true, completion: nil)
            
            
            //sdImageView Changes.
            let strThaumNailImage:String = self.subVideoPosts[indexPath.row].featured_image!
            
            let url = URL(string:strThaumNailImage)
            
            cell.thumbNailI.sd_setImage(with: url, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
            
//            BaseManager.Manager.request(self.subVideoPosts[indexPath.row].featured_image!).responseImage { response in
//                if let image = response.result.value {
//                    cell.thumbNailI.image = image
//                }
//                else{
//                    cell.thumbNailI.image = UIImage(named: "ImagePlaceholder")
//                }
//            }
            
            var tempUrl = "https://www.youtube.com/embed/"
            
            if self.subVideoPosts[indexPath.row].short_content != nil{
                tempUrl +=  "\(String(describing: (self.subVideoPosts[indexPath.row].short_content)!))"
            }
            else{
                tempUrl += "NpG8iaM0Sfs"
            }
            
            print("Video Url start")
            print(tempUrl)
            print("Video Url end")
            
            cell.playBtnDelegate=self
            cell.index = indexPath
            
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == MainCollectionView{
            print("No controller available yet for this click")
            //  print(self.productsArray[indexPath.row])
            let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desVC = mainStoryBoard.instantiateViewController(withIdentifier: "VideoDetailsViewController") as! VideoViewController
            
            
            let url = self.subVideoPosts[indexPath.row].short_content
            
            desVC.videoTitle = self.subVideoPosts[indexPath.row].title!
            
            print("url: \(String(describing: url))")
            
            desVC.url = "https://www.youtube.com/embed/NpG8iaM0Sfs"
            
            dump(self.subVideoPosts[indexPath.row])
            
            desVC.videoId = Int(self.subVideoPosts[indexPath.row].post_id!)!
            
            
            
            var tempUrl = "https://www.youtube.com/embed/"
            
            if self.subVideoPosts[indexPath.row].short_content != nil{
                tempUrl +=  "\(String(describing: (self.subVideoPosts[indexPath.row].short_content)!))"
            }
            else{
                tempUrl += "NpG8iaM0Sfs"
            }
            
            desVC.url = tempUrl
            
            
            print("Video Url start")
            print(desVC.url)
            print("Video Url end")
            
            
            self.navigationController?.pushViewController(desVC, animated: true)
        }
        else{
            
            
            let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desVC = mainStoryBoard.instantiateViewController(withIdentifier: "VideoDetailsViewController") as! VideoViewController
            
            let url = self.subVideoPosts[indexPath.row].short_content
            
            desVC.videoTitle = self.subVideoPosts[indexPath.row].title!
            
            print("url: \(String(describing: url))")
            
            desVC.url = "https://www.youtube.com/embed/NpG8iaM0Sfs"
            
            dump(self.subVideoPosts[indexPath.row])
            
            desVC.videoId = Int(self.subVideoPosts[indexPath.row].post_id!)!
            
            
            
            var tempUrl = "https://www.youtube.com/embed/"
            
            if self.subVideoPosts[indexPath.row].short_content != nil{
                tempUrl +=  "\(String(describing: (self.subVideoPosts[indexPath.row].short_content)!))"
            }
            else{
                tempUrl += "NpG8iaM0Sfs"
            }
            
            desVC.url = tempUrl
            
            
            print("Video Url start")
            print(desVC.url)
            print("Video Url end")
            
            
            self.navigationController?.pushViewController(desVC, animated: true)
            
            print("end")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        print("tv cell: \(indexPath.row) ** (\(self.pageNo) < \(self.totalPages)) && (\(indexPath.row + 1) == \(self.pageNo * self.pageSize)) ")
        if self.pageNo < self.totalPages && (indexPath.row + 1) == self.pageNo * self.pageSize{
            self.pageNo += 1
            
            CommonManager.shared.CheckCurrentLanguage(){ (complete) in
                if complete.count>0{
                    self.currentLanguage = complete[0].name!
                    
                    if self.currentLanguage == "en"{
                        self.GetSubVideos(storeId: 1)
                    }
                    else{
                        self.GetSubVideos(storeId: 2)
                    }
                    
                }
                else{
                    self.GetSubVideos(storeId: 1)
                }
                
            }
        }
        
    }
    
    func GetSubVideos(storeId: Int){
        
        if(pageNo == 1){
            self.subCollectionView.isHidden = true
            self.MainCollectionView.isHidden = true
        }
        else{
            self.subCollectionView.isHidden = true
            self.MainCollectionView.isHidden = true
        }
        
        
        videosManager.GetVideos(type: -1, term: -1, store_id: storeId, pageNo: self.pageNo, limit: self.pageSize) { (data, error) in
            if error == nil{
                
                
                
                dump(self.subVideoPosts)
                
                if(self.pageNo == 1){
                    self.totalPages = ((data?.total_number)! + self.pageSize - 1) / self.pageSize
                    
                    self.subVideoPosts = (data?.posts)!
                }
                else{
                    for item in (data?.posts)!{
                        self.subVideoPosts.append(item)
                        self.subCollectionView.reloadData()
                    }
                }
                
                print("Videos Array Count \(self.subVideoPosts.count)")
                print("total pages: \(self.totalPages)");
                
                self.subCollectionView.reloadData()
                self.MainCollectionView.reloadData()
                
                self.subCollectionView.isHidden = false
                self.MainCollectionView.isHidden = false
            }else{
                print(error!)
                self.subCollectionView.isHidden = false
                self.MainCollectionView.isHidden = false
            }
        }
    }
    

}

extension TVViewController : playBtnProtocol{
    func playBtn(index: IndexPath) {
        print("Play button clicked")
        let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = mainStoryBoard.instantiateViewController(withIdentifier: "VideoDetailsViewController") as! VideoViewController
        
        let url = self.subVideoPosts[index.row].short_content
        
        desVC.videoTitle = self.subVideoPosts[index.row].title!
        
        print("url: \(String(describing: url))")
        
        desVC.url = "https://www.youtube.com/embed/NpG8iaM0Sfs"
        
        desVC.videoId = Int(self.subVideoPosts[index.row].post_id!)!
        
        
        var tempUrl = "https://www.youtube.com/embed/"
        
        if self.subVideoPosts[index.row].short_content != nil{
            tempUrl +=  "\(String(describing: (self.subVideoPosts[index.row].short_content)!))"
        }
        else{
            tempUrl += "NpG8iaM0Sfs"
        }
        
        desVC.url = tempUrl
        
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
}
