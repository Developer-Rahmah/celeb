//
//  SubCategoryViewController.swift
//  quitic3
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 DOT. All rights reserved.
//

import UIKit
import ANLoader

class SubCategoryViewController: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var tblvSubCategory: UITableView!
    
    @IBOutlet weak var viewActivity: UIActivityIndicatorView!
    //MARK:- Properties
    var previousData: [Items] = []
    var selectedName: String = ""
    var selectedId: Int = -1
    var currentLanguage = ""
    var expandedSectionHeaderNumber = -1
    var arrSubCategory = [Items]()
    var lblHeader = UILabel()
    var viewNavCenter = UIView()
    var allId: Int  = -1
    var btnSearch = UIButton()

    //MARK:- View life cycle Method
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        let testUIBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "searchIcon"), style: .plain, target: self, action: #selector(searchAction))
//        self.navigationItem.rightBarButtonItem  = testUIBarButtonItem
//
        tblvSubCategory.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        CommonManager.shared.CheckCurrentLanguage() { (complete) in
            
            if complete.count>0 {
                
                self.currentLanguage = complete[0].name!
            }
        }
//        viewNavCenter = UIView(frame: CGRect(x: 0, y: -12, width:  (self.navigationController?.navigationBar.frame.size.width)!, height: 20))
//        viewNavCenter.backgroundColor = UIColor.white
//        self.navigationController?.navigationBar.addSubview(viewNavCenter)
//
//        ///added for navigation bar setting.
//        //set large size navigation bar image.
//        imgViewNavCenter = UIImageView(image: UIImage(named: "centerHeader"))
//        imgViewNavCenter.frame = CGRect(x: view.frame.size.width / 2 - 75, y: 0, width: 150, height: 25) //
//        imgViewNavCenter.contentMode = .scaleAspectFill
//
//        //change height and width accordingly
//        self.navigationController?.navigationBar.addSubview(imgViewNavCenter)
//
//        let titleImgView = UIImageView(frame: CGRect(x: 0, y: 0, width:0, height: 0))
//        let image = UIImage(named: "")
//        titleImgView.image = image
//        navigationItem.titleView = titleImgView
        
        
        
        getSubCategoryLIst()
        
        viewNavCenter =  UIView(frame: CGRect(x: 0, y: -13, width:  (self.navigationController?.navigationBar.frame.size.width)!, height: 20))
        viewNavCenter.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.addSubview(viewNavCenter)
        
        if #available(iOS 11.0, *) {
            
            tblvSubCategory.contentInset = UIEdgeInsetsMake(1, 0, 0, 0)
        }
        
        lblHeader = UILabel.init(frame:  CGRect(x: view.frame.size.width / 2 - 75, y: -11, width: 150, height: 50)) //
        lblHeader.text = selectedName
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
        
        if self.currentLanguage == "en" {
            
            btnSearch = UIButton.init(frame:  CGRect(x: viewNavCenter.frame.size.width - 45, y: -3, width: 40, height: 40))
        }
        else
        {
            btnSearch = UIButton.init(frame:  CGRect(x: 15, y: -3, width: 40, height: 40))
        }
        
     
        btnSearch.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        btnSearch.setImage(UIImage(named: "searchIcon"), for: .normal)
        

        self.navigationController?.navigationBar.addSubview(lblHeader)
        self.navigationController?.navigationBar.addSubview(btnSearch)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if !(self.navigationController?.navigationBar.subviews.contains(viewNavCenter))! {
            
            viewNavCenter = UIView(frame: CGRect(x: 0, y: -9, width:  (self.navigationController?.navigationBar.frame.size.width)!, height: 52))
            viewNavCenter.backgroundColor = UIColor.white
            self.navigationController?.navigationBar.addSubview(viewNavCenter)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(true)
        lblHeader.removeFromSuperview()
        btnSearch.removeFromSuperview()
        viewNavCenter.removeFromSuperview()
    }
    
    //MARK:- Action Method
    @objc func searchAction() {
        
        let desVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
    @objc func sectionButtonTap(_ sender: UIButton) {
        
        let desVC = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "splitPagerProducts") as! ProductPagerViewController
        
        desVC.previousData = arrSubCategory
        desVC.selectedName = arrSubCategory[sender.tag].name!
        desVC.selectedId = arrSubCategory[sender.tag].id!
        desVC.allId = selectedId
        
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
    //MARK:- Helper Methods
    @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        
        let headerView = sender.view as! UIImageView
        let section    = headerView.tag
        
        if (self.expandedSectionHeaderNumber == -1) {
            
            self.expandedSectionHeaderNumber = section
            
            expandTableViewCell(section:section)
        } else {
            
            if expandedSectionHeaderNumber == section {
                
                collepsTableViewCell(section: section)
            } else {
                
                collepsTableViewCell(section: expandedSectionHeaderNumber)
                expandTableViewCell(section: section)
            }
        }
    }
    
    func expandTableViewCell(section:Int) {
        
        if arrSubCategory.isEmpty { return }
        
        var arrsectionRow = [IndexPath]()
        
        if let sectionRowData = arrSubCategory[section].childCategory {
            
            for i in 0 ..< sectionRowData.count {
                
                arrsectionRow.append(IndexPath(row: i, section: section))
            }
        }
        
        expandedSectionHeaderNumber = section
        
        tblvSubCategory.beginUpdates()
        tblvSubCategory.insertRows(at: arrsectionRow, with: .fade)
        tblvSubCategory.endUpdates()
    }
    
    func collepsTableViewCell(section: Int) {
        
        if arrSubCategory.isEmpty { return }
        
        var arrsectionRow = [IndexPath]()
        
        expandedSectionHeaderNumber = -1
        
        if let sectionRowData = arrSubCategory[section].childCategory {
            
            for i in 0 ..< sectionRowData.count {
                
                arrsectionRow.append(IndexPath(row: i, section: section))
            }
        }
        
        tblvSubCategory.beginUpdates()
        tblvSubCategory.deleteRows(at: arrsectionRow, with: .fade)
        tblvSubCategory.endUpdates()
        
        tblvSubCategory.reloadData()
    }
    
    //MARK:- Webservice call
    func getSubCategoryLIst() {
        
        APIManager.shared.GetSubCategoryRequest(categoryId: String(selectedId), strCurrentLanguage: currentLanguage) { (subCategoryList, error) in
            
            if error == nil {
                
                self.arrSubCategory = subCategoryList as! [Items]
                self.tblvSubCategory.reloadData()
            }
        }
    }
}

//MARK:- UITableViewDelegate & UITableViewDataSource Methods
extension SubCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        guard !arrSubCategory.isEmpty else { return 0 }
        
        return arrSubCategory.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if expandedSectionHeaderNumber == section {
            
            return (arrSubCategory[section].childCategory?.count)!
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return arrSubCategory[section].name
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let headerView = view as! UITableViewHeaderFooterView
        headerView.contentView.backgroundColor = UIColor.white
        headerView.textLabel?.textColor = UIColor.black
        headerView.tag = section
        
        var lblBottom = UILabel()
        var imgvDropDown = UIImageView()
        var btnSelectCategory = UIButton()
        
        if self.currentLanguage == "en" {
            
            imgvDropDown = UIImageView(frame:  CGRect(x: self.view.frame.size.width - 32, y: headerView.frame.size.height/2, width: 18, height: 18))
            imgvDropDown.tag = section
            imgvDropDown.isUserInteractionEnabled = true
            
            btnSelectCategory = UIButton(frame: CGRect(x: 0, y: 0, width: headerView.frame.size.width - 32, height:  headerView.frame.size.height))
            btnSelectCategory.tag = section
            btnSelectCategory.addTarget(self, action: #selector(SubCategoryViewController.sectionButtonTap(_:)), for: .touchUpInside)
        } else {
           
            imgvDropDown = UIImageView(frame: CGRect(x: 10, y: headerView.frame.size.height/2, width: 18, height: 18))
            imgvDropDown.tag = section
            imgvDropDown.isUserInteractionEnabled = true
            
            btnSelectCategory = UIButton(frame: CGRect(x: 28 , y: 0, width: headerView.frame.size.width - 32, height:  headerView.frame.size.height))
            btnSelectCategory.addTarget(self, action: #selector(SubCategoryViewController.sectionButtonTap(_:)), for: .touchUpInside)
        }
        
        lblBottom = UILabel(frame: CGRect.init(x: 0, y: headerView.frame.size.height - 2, width: tblvSubCategory.frame.size.width, height: 1.0))
        lblBottom.backgroundColor = UIColor.lightGray
        
        if (arrSubCategory[section].childCategory?.isEmpty)! {
            
            imgvDropDown.image = UIImage(named: "")
        } else {
            
            imgvDropDown.image = UIImage(named: "down-chevron")
        }
        
        headerView.addSubview(lblBottom)
        headerView.addSubview(imgvDropDown)
        headerView.addSubview(btnSelectCategory)
        
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(SubCategoryViewController.sectionHeaderWasTouched(_:)))
        imgvDropDown.addGestureRecognizer(headerTapGesture)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.selectionStyle = .none
        
        cell.textLabel?.textColor = UIColor.gray
        
        if let childCategory = arrSubCategory[indexPath.section].childCategory {
            
            if self.currentLanguage == "en" {
                
                cell.textLabel?.textAlignment = .left
            } else {
                
                cell.textLabel?.textAlignment = .right
            }
            
            cell.textLabel?.text = childCategory[indexPath.row].name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let desVC = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "splitPagerProducts") as! ProductPagerViewController
        
        if let categoryName = arrSubCategory[indexPath.section].childCategory {
            
            desVC.previousData = categoryName
            desVC.selectedName = categoryName[indexPath.row].name!
            desVC.selectedId = categoryName[indexPath.row].id!
            desVC.allId = selectedId
        }
        
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
