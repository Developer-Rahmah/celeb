//
//  SocialOneViewController.swift
//  quitic3
//
//  Created by ZWT on 4/19/19.
//  Copyright © 2019 DOT. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class SocialOneViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblSocial: UITableView!
    
    @IBOutlet weak var snapChatImage: UIImageView!
    
//    @IBOutlet weak var instagramOutlet: UIButton!
//
//    @IBOutlet weak var twitterOutlet: UIButton!
//
//    @IBOutlet weak var faceBookOutlet: UIButton!
    
    var alertTitle:String = "Alert"
    var alertMessage:String = "Link not found."
    var alertOkButton: String = "Ok"
    
    var currentLanguage: String = "en"
    var celebItem: Any = {}
    
    
    @objc func setText(){
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        
        self.setText()
        
//        self.instagramOutlet.contentMode = .scaleAspectFit
//        self.instagramOutlet.contentHorizontalAlignment = .fill;
//        self.instagramOutlet.contentVerticalAlignment = .fill;
//
//        self.twitterOutlet.contentMode = .scaleAspectFit
//        self.twitterOutlet.contentHorizontalAlignment = .fill;
//        self.twitterOutlet.contentVerticalAlignment = .fill;
//
//        self.faceBookOutlet.contentMode = .scaleAspectFit
//        self.faceBookOutlet.contentHorizontalAlignment = .fill;
//        self.faceBookOutlet.contentVerticalAlignment = .fill;
        
      //  let tapRec = UITapGestureRecognizer()
      //  tapRec.addTarget(self, action: "tappedView")
       // snapChatImage.addGestureRecognizer(tapRec)
        
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
                
                if self.currentLanguage == "en"{
                    alertTitle = "Alert"
                    alertMessage = "Link not found."
                    alertOkButton = "Ok"
                }
                else{
                    alertTitle = "محزر"
                    alertMessage = "الرابط غير موجود"
                    alertOkButton = "اوافق"
                }
            }
        }
    }
    
    
    
    @objc func tappedView(){
        let snapChatUrl = (Array((celebItem as! Items).custom_attributes!).first(where: { $0.attribute_code! == "snapchat" })?.value)!
        if snapChatUrl == "#"{
            let alert = UIAlertController(title: self.alertTitle, message: self.alertMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: self.alertOkButton, style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                    
                }}))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        
        let Username = snapChatUrl.replacingOccurrences(of: "https://www.snapchat.com/add/", with: "")
        let appURL = URL(string: "snapchat://add/\(Username)")!
        
        let application = UIApplication.shared
        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            // if Instagram app is not installed, open URL inside Safari
            let webURL = URL(string: snapChatUrl)!
            application.open(webURL)
        }
    }
    
    @IBAction func instagramClicked(_ sender: Any) {
        print("instagram clicked")
        let instagramUrl = (Array((celebItem as! Items).custom_attributes!).first(where: { $0.attribute_code! == "instagram" })?.value)!
        if instagramUrl == "#"{
            let alert = UIAlertController(title: self.alertTitle, message: self.alertMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: self.alertOkButton, style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                    
                }}))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        let replaceUrl = instagramUrl.replacingOccurrences(of: "https://www.instagram.com/", with: "")
        let Username = replaceUrl.split(separator: "/")[0]
        let appURL = URL(string: "instagram://user?username=\(Username)")!
        let application = UIApplication.shared
        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            // if Instagram app is not installed, open URL inside Safari
            let webURL = URL(string: instagramUrl)!
            application.open(webURL)
        }
    }
    
    
    @IBAction func twitterClicked(_ sender: Any) {
        let twitterUrl = (Array((celebItem as! Items).custom_attributes!).first(where: { $0.attribute_code! == "twitter" })?.value)!
        if twitterUrl == "#"{
            let alert = UIAlertController(title: self.alertTitle, message: self.alertMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: self.alertOkButton, style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                    
                }}))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        let replaceUrl = twitterUrl.replacingOccurrences(of: "https://twitter.com/", with: "")
        
        let Username = replaceUrl.split(separator: "?")[0]
        
        let appURL = URL(string: "twitter://user?screen_name=\(Username)")!
        
        let application = UIApplication.shared
        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            // if Instagram app is not installed, open URL inside Safari
            let webURL = URL(string: twitterUrl)!
            application.open(webURL)
        }
        
    }
    
    
    @IBAction func facebookClicked(_ sender: Any) {
        let facebookUrl = (Array((celebItem as! Items).custom_attributes!).first(where: { $0.attribute_code! == "facebook" })?.value)!
        if facebookUrl == "#"{
            let alert = UIAlertController(title: self.alertTitle, message: self.alertMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: self.alertOkButton, style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                    
                }}))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        let replaceUrl = facebookUrl.replacingOccurrences(of: "https://www.facebook.com/", with: "")
        let Username = replaceUrl.split(separator: "/")[0]
        let appURL = URL(string: "fb://profile/\(Username)")!
        let application = UIApplication.shared
        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            // if Instagram app is not installed, open URL inside Safari
            let webURL = URL(string: facebookUrl)!
            application.open(webURL)
        }
    }
    

    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0
        {
            // create a new cell if needed or reuse an old one
            let firstCell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "firstCell") as UITableViewCell!
            
            
            return firstCell
        }
        else if indexPath.row == 1
        {
            
            // create a new cell if needed or reuse an old one
            let secondCell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "secondCell") as UITableViewCell!
            
            
            return secondCell
        }
        else if indexPath.row == 2
        {
            
            // create a new cell if needed or reuse an old one
            let thirdCell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "thirdCell") as UITableViewCell!
            
            
            let btnSnapChat:UIButton = thirdCell.viewWithTag(101) as! UIButton
            let btnInsta:UIButton = thirdCell.viewWithTag(102) as! UIButton
            let btnTwitter:UIButton = thirdCell.viewWithTag(103) as! UIButton
            let btnFacebook:UIButton = thirdCell.viewWithTag(104) as! UIButton
            
            
            btnSnapChat.addTarget(self, action:  #selector(tappedView), for: .touchUpInside)
            btnInsta.addTarget(self, action: #selector(instagramClicked(_:)), for: .touchUpInside)
            btnTwitter.addTarget(self, action: #selector(twitterClicked(_:)), for: .touchUpInside)
            btnFacebook.addTarget(self, action: #selector(facebookClicked(_:)), for: .touchUpInside)
            
            
            return thirdCell
            
        }
        
        // create a new cell if needed or reuse an old one
        let forthCell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "forthCell") as UITableViewCell!
        
        
        return forthCell
        
        
       
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0 || indexPath.row == 1
        {
           return 170
        }
        else
        {
           return 260
        }
    }
    
}

extension SocialOneViewController: SJSegmentedViewControllerViewSource {
    
    func viewForSegmentControllerToObserveContentOffsetChange() -> UIView {
        
        return self.tblSocial
    }
}

