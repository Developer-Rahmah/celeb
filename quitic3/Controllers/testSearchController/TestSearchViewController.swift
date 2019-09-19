//
//  TestSearchViewController.swift
//  quitic3
//
//  Created by DOT on 8/8/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit

class TestSearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func categoriesBtnClicked(_ sender: Any) {
        let desVC = UIStoryboard(name: "TVStoryboard", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
        desVC.searchType = "Categories"
        
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
    @IBAction func brandsBtnClicked(_ sender: Any) {
        let desVC = UIStoryboard(name: "TVStoryboard", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
        desVC.searchType = "Brands"
        
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
    
    @IBAction func celebBtnClicked(_ sender: Any) {
        let desVC = UIStoryboard(name: "TVStoryboard", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
        desVC.searchType = "Celebrities"
        
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
    
}
