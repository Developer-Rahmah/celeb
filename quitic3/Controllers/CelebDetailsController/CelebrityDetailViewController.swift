//
//  CelebrityDetailViewController.swift
//  quitic3
//
//  Created by APPLE on 03/10/2018.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit
import GSKStretchyHeaderView
import Localize_Swift
import SDWebImage

class CelebrityDetailViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    var currentLanguage = ""
    var celebName = "";
    var celebId: Int = 0;
    var celebBanner: String = ""
    var labels = AppLabels()
    var lblHeader = UILabel()
    var viewNavCenter = UIView()
    var boolLoadFirst:Bool = false
    
    @IBOutlet weak var scrvCelebrity: UIScrollView!
    
    @objc func setText(){
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                labels = AppLabels()
                self.currentLanguage = complete[0].name!
                //title = self.celebName
            }
        }
    }

    let cellReuseIdentifier = "cell"
    @IBOutlet var tableView: UITableView!
    var stretchyHeaderView: GSKStretchyHeaderView!
    var segmentIndex: Int = 0
    var headerview : TopHeaderView? = nil
    var celebItem = Items();
    let infoVC = UIStoryboard(name: "Main", bundle: nil)
        .instantiateViewController(withIdentifier: "MyBoutiquesViewController") as! MyBoutiquesViewController
    
    
    
    let MyVideosinfoVC = UIStoryboard(name: "Main", bundle: nil)
        .instantiateViewController(withIdentifier: "MyVideosViewController") as! MyVideosViewController
    let socialInfoVC = UIStoryboard(name: "LoginStoryboard", bundle: nil)
        .instantiateViewController(withIdentifier: "SocialViewController") as! SocialViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.setText()
        
        infoVC.celebName = self.celebName
        infoVC.celebBanner = self.celebBanner
    

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        viewNavCenter = UIView(frame: CGRect(x: 0, y: -13, width:  (self.navigationController?.navigationBar.frame.size.width)!, height: 20))
        viewNavCenter.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.addSubview(viewNavCenter)

        lblHeader = UILabel.init(frame:  CGRect(x: 50, y: -7, width: self.view.frame.width - 100, height: 50))
//        lblHeader.text = self.celebName
        lblHeader.text = self.celebName

        //lblHeader.font = UIFont.init(name: headerFont, size: 30)
        lblHeader.textAlignment = .center
        lblHeader.textColor = UIColor.init(red: 251, green: 96, blue: 127)
        
        if self.currentLanguage == "en"
        {
            lblHeader.font = UIFont.init(name: enMarselLanguageConstant, size: 23)
        }
        else
        {
            lblHeader.font = UIFont.init(name: arLanguageConstant, size: 23)
        }

      
        
        self.navigationController?.navigationBar.addSubview(lblHeader)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableViews), name: NSNotification.Name(rawValue: "reloadTableView"), object: nil)
//
        
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
            let url = URL(string:celebBanner)
            
            self.headerview?.celebImage.sd_setImage(with: url, placeholderImage: UIImage(named: "ImagePlaceholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
            
//            BaseManager.Manager.request(self.self.celebBanner).responseImage { response in
//                if let image = response.result.value {
//                    self.headerview?.celebImage.image = image
//                }
//                else{
//                    self.headerview?.celebImage.image = UIImage(named: "ImagePlaceholder")
//                }
//            }
        }
        headerview?.segmentTab?.selectedSegmentIndex = 0
        headerview?.segmentTab?.backgroundColor = .clear
        headerview?.segmentTab?.tintColor = .clear
        headerview?.segmentTab?.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont(name: enLanguageConstant, size: 18),
            NSAttributedStringKey.foregroundColor: UIColor.lightGray
            ], for: .normal)
        
        headerview?.segmentTab?.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont(name: enLanguageConstant, size: 18),
            NSAttributedStringKey.foregroundColor: UIColor.quiticPink
            ], for: .selected)
        
        headerview?.changeSegmentActionDelegate = self
        // headerview?.segmentTab?.headerViewOffsetHeight = 0.0
        
        tableView.addSubview(view!)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        print("celebrity Item from home: ", self.celebItem)
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        lblHeader.removeFromSuperview()
        viewNavCenter.removeFromSuperview()
        
       // NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "reloadTableView"), object: nil)
    }
//
//    // MARK: - View Methods
//    @objc func reloadTableViews(notification: Notification)
//    {
//        let dict = notification.object as! NSDictionary
//
//        if intMyBoutiques == 0
//        {
//            intMyBoutiques = dict["Height"] as! Int
//        }
//
//    }


    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if segmentIndex == 0
        {
            if infoVC.scrvMyBoutiques != nil
            {
                if boolLoadFirst == false
                {
                    boolLoadFirst = true
                    return 900
                }
                else
                {
                    return infoVC.scrvMyBoutiques.contentSize.height
                }
            }
        }
        else if segmentIndex == 1
        {
            if MyVideosinfoVC.scrvMyVideos != nil
            {
                return max(MyVideosinfoVC.scrvMyVideos.contentSize.height, self.view.frame.size.height)
            }
        }
        else
        {
            return self.view.frame.size.height
        }
        
        return self.view.frame.size.height
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        if segmentIndex == 0
//        {
//            if infoVC.scrvMyBoutiques != nil
//            {
//                return 1200
//            }
//        }
//        else if segmentIndex == 1
//        {
//            if MyVideosinfoVC.scrvMyVideos != nil
//            {
//                return MyVideosinfoVC.scrvMyVideos.contentSize.height
//            }
//        }
//        else
//        {
//            return 812.0
//        }
//        
//        return 812.0
//    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // set the text from the data model
        //        cell.textLabel?.text = self.animals[indexPath.row]

        if segmentIndex == 0{
           
            infoVC.celebId = (self.celebItem as Items).id!
            infoVC.celebName = (self.celebItem as Items).name!

            cell.layoutIfNeeded()

            self.addChildViewController(infoVC)
            cell.contentView.addSubview(infoVC.view)

            infoVC.view.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addConstraint(NSLayoutConstraint(item: infoVC.view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: cell.contentView, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0))

            cell.contentView.addConstraint(NSLayoutConstraint(item: infoVC.view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: cell.contentView, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0.0))

            cell.contentView.addConstraint(NSLayoutConstraint(item: infoVC.view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: cell.contentView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0.0))

            cell.contentView.addConstraint(NSLayoutConstraint(item: infoVC.view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: cell.contentView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0))

            infoVC.didMove(toParentViewController: self)
            infoVC.view.layoutIfNeeded()
        }
        else if segmentIndex == 1{
            
            MyVideosinfoVC.celebId = (self.celebItem as Items).id!
            MyVideosinfoVC.celebItem = self.celebItem

            cell.layoutIfNeeded()

            self.addChildViewController(MyVideosinfoVC)
            cell.contentView.addSubview(MyVideosinfoVC.view)

            MyVideosinfoVC.view.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addConstraint(NSLayoutConstraint(item: MyVideosinfoVC.view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: cell.contentView, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0))

            cell.contentView.addConstraint(NSLayoutConstraint(item: MyVideosinfoVC.view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: cell.contentView, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0.0))

            cell.contentView.addConstraint(NSLayoutConstraint(item: MyVideosinfoVC.view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: cell.contentView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0.0))

            cell.contentView.addConstraint(NSLayoutConstraint(item: MyVideosinfoVC.view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: cell.contentView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0))

            MyVideosinfoVC.didMove(toParentViewController: self)
            MyVideosinfoVC.view.layoutIfNeeded()
        }
        else if segmentIndex == 2{
            
            socialInfoVC.celebItem = self.celebItem
            
            cell.layoutIfNeeded()

            self.addChildViewController(socialInfoVC)
            cell.contentView.addSubview(socialInfoVC.view)

            socialInfoVC.view.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addConstraint(NSLayoutConstraint(item: socialInfoVC.view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: cell.contentView, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0))

            cell.contentView.addConstraint(NSLayoutConstraint(item: socialInfoVC.view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: cell.contentView, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0.0))

            cell.contentView.addConstraint(NSLayoutConstraint(item: socialInfoVC.view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: cell.contentView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0.0))

            cell.contentView.addConstraint(NSLayoutConstraint(item: socialInfoVC.view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: cell.contentView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0))

            socialInfoVC.didMove(toParentViewController: self)
            socialInfoVC.view.layoutIfNeeded()
        }
    
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print()
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        print("right swipe",headerview?.segmentTab?.selectedSegmentIndex);
        if self.currentLanguage == "en"{
            if  headerview?.segmentTab?.selectedSegmentIndex != 0 {
                headerview?.segmentTab?.selectedSegmentIndex -= 1
                self.setSegmentIndex(diraction: headerview?.segmentTab?.selectedSegmentIndex ?? 0)
            }
            else if headerview?.segmentTab?.selectedSegmentIndex == 0{
                headerview?.segmentTab?.selectedSegmentIndex = 0
                self.setSegmentIndex(diraction: headerview?.segmentTab?.selectedSegmentIndex ?? 0)
            }
        }
        else{
            if  headerview?.segmentTab?.selectedSegmentIndex != 2 {
                headerview?.segmentTab?.selectedSegmentIndex += 1
                self.setSegmentIndex(diraction: headerview?.segmentTab?.selectedSegmentIndex ?? 2)
            }
            else if headerview?.segmentTab?.selectedSegmentIndex == 2{
                headerview?.segmentTab?.selectedSegmentIndex = 2
                self.setSegmentIndex(diraction: headerview?.segmentTab?.selectedSegmentIndex ?? 2)
            }
            
        }

        return UISwipeActionsConfiguration(actions: [])
    }
    
//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        
//         if segmentIndex == 0
//         {
//            let indexPath = IndexPath(row: 0, section: 0)
//            self.tableView.reloadRows(at: [indexPath], with: .fade)
//        }
//    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        print("left swipe : ",headerview?.segmentTab?.selectedSegmentIndex);
        if self.currentLanguage == "en"{
            if  headerview?.segmentTab?.selectedSegmentIndex != 2 {
                headerview?.segmentTab?.selectedSegmentIndex += 1
                self.setSegmentIndex(diraction: headerview?.segmentTab?.selectedSegmentIndex ?? 2)
            }
            else if headerview?.segmentTab?.selectedSegmentIndex == 2{
                headerview?.segmentTab?.selectedSegmentIndex = 2
                self.setSegmentIndex(diraction: headerview?.segmentTab?.selectedSegmentIndex ?? 2)
            }
        }else{
            if  headerview?.segmentTab?.selectedSegmentIndex != 0 {
                headerview?.segmentTab?.selectedSegmentIndex -= 1
                self.setSegmentIndex(diraction: headerview?.segmentTab?.selectedSegmentIndex ?? 0)
            }
            else if headerview?.segmentTab?.selectedSegmentIndex == 0{
                headerview?.segmentTab?.selectedSegmentIndex = 0
                self.setSegmentIndex(diraction: headerview?.segmentTab?.selectedSegmentIndex ?? 0)
            }
        }


        return UISwipeActionsConfiguration(actions: [])
    }
    
    func setSegmentIndex(diraction:Int){
        self.segmentIndex = diraction
        //when you set segment
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView!) {
        // This will be called every time the user scrolls the scroll view with their finger
        // so each time this is called, contentOffset should be different.
    
        
        //Additional workaround here.
    }
    
    
}
extension CelebrityDetailViewController :changeSegmentActionProtocol{
    func changeSegmentAction(index: Int) {
        print("changeSegmentAction",index)
        self.setSegmentIndex(diraction:index)
        
    }

}
