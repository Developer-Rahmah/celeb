//
//  ShopByCategoryViewController.swift
//  quitic3
//
//  Created by DOT on 8/3/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit

class ShopByCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var catTableView: UITableView!
    var categoriesItems: [Items] = []
    var imgViewNavCenter = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.catTableView.delegate = self
        self.catTableView.dataSource = self
        
        self.getCelebrities()
        
        //title = "Shop By Categories"
        
       // self.navigationItem.title = "Shop By Categories"
        
        let testUIBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "searchIcon"), style: .plain, target: self, action: #selector(searchAction))
        self.navigationItem.rightBarButtonItem  = testUIBarButtonItem
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        ///added for navigation bar setting.
        //set large size navigation bar image.
        imgViewNavCenter = UIImageView(image: UIImage(named: "centerHeader"))
        imgViewNavCenter.frame = CGRect(x: view.frame.size.width / 2 - 75, y: -9, width: 150, height: 50) //
        
        //change height and width accordingly
        self.navigationController?.navigationBar.addSubview(imgViewNavCenter)
        
        let titleImgView = UIImageView(frame: CGRect(x: 0, y: 0, width:0, height: 0))
        let image = UIImage(named: "")
        titleImgView.image = image
        navigationItem.titleView = titleImgView
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        imgViewNavCenter.removeFromSuperview()
    }
    
    @objc func searchAction(){
        print("search Action")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopByCategoryTableViewCell", for: indexPath) as! ShopByCategoryTableViewCell
        
        
        //        cell.productImage.image = UIImage(named: "ImagePlaceholder")
        
        //        cell.categoryImage.af_setImage(withURL: URL(string: self.categoriesItems[indexPath.row].imageUrl!)!, placeholderImage: UIImage(named: "ImagePlaceholder"), filter:nil, imageTransition: .crossDissolve(0), runImageTransitionIfCached: true, completion: nil)
        
        
        cell.categoryLabel.text = self.categoriesItems[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let desVC = storyboard?.instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
        desVC.categoryId = self.categoriesItems[indexPath.row].id!
        
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
    func getCelebrities(){
        self.catTableView.isHidden = true
        APIManager.shared.GetAllCategories { (items) in
//            self.categoriesItems = items
            for item in items{
                if(item.is_active!){
                   self.categoriesItems.append(item)
                }
            }
           
            
            self.catTableView.reloadData()
            
            self.catTableView.isHidden = false
        }
    }
    
}
