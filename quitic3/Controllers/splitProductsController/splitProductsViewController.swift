
import UIKit
import SJSegmentedScrollView
import Localize_Swift


class SplitProductsViewController:  SJSegmentedViewController {
    
    var previousData: [Items] = []
    var previousType: String = ""
    var selectedName: String = ""
    var selectedId: Int = -1
    var selectedIndex: Int = -1
    var allId: Int  = -1
    var setTitle = ""
    var currentLanguage = ""
    var mainData: [Items] = []
    
    var selectedSegment: SJSegmentTab?
    
    var segmentLoaded: Bool = false
    
    
    override func viewDidLoad() {
        CommonManager.shared.CheckCurrentLanguage(){ (complete) in
            if complete.count>0{
                self.currentLanguage = complete[0].name!
            }
        }
        if let storyboard = self.storyboard {
            self.fetchControllers(type: self.previousType, data: self.previousData) { (controllers) in
                self.segmentControllers = controllers
                
                self.selectedSegmentViewHeight = 5.0
                self.headerViewHeight = 250.0
                self.segmentViewHeight = 60.0
                
                self.segmentTitleColor = .quiticPink
                self.selectedSegmentViewColor = .quiticPink
                self.segmentShadow = SJShadow.light()
                self.showsHorizontalScrollIndicator = true
                self.showsVerticalScrollIndicator = true
                self.segmentBounces = true
                self.delegate = self
            }
            
        }
        
        title = self.setTitle
        super.viewDidLoad()
        
        if(self.selectedName != "" || self.selectedId != -1){
            
            var matchedItemIndex = -1
            var iterate = 0
            for item in self.mainData{
                if item.name == self.selectedName || item.id == self.selectedId{
                    matchedItemIndex = iterate
                }
                iterate += 1
            }
            
            if(matchedItemIndex != -1){
                if self.currentLanguage == "en" {
                    self.setSegmentIndex(index: matchedItemIndex+1)
                }
                else {
                    let arIndex: Int = (self.mainData.count - matchedItemIndex)-1
                    self.setSegmentIndex(index: arIndex)
                }
                
            } 
        }
    }
    
    func setSegmentIndex(index: Int){
        self.setSelectedSegmentAt(index, animated: true)
    }
    
    @IBAction func searchBtnClicked(_ sender: Any) {
       
        self.setSelectedSegmentAt(2, animated: true)
        
//        let desVC = UIStoryboard(name: "TVStoryboard", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
//
//        desVC.searchType = "Categories"
//
//        self.navigationController?.pushViewController(desVC, animated: true)
        
    }
    
    
    func fetchControllers(type: String, data: [Items], completion: @escaping ([UIViewController]) -> ()){
        
        
            if !data.isEmpty{
                self.mainData = data
                self.settingControllers(data: data) { (controllers) in
                    completion(controllers)
                }
                
            }else{
                if type == "Brands"{
                    APIManager.shared.GetBrandsRequest { (items) in
                        self.settingControllers(data: items, completion: { (controllers) in
                            
                            self.mainData = items
                            completion(controllers)
                        })
                    }
                }
                else if type == "Celebrities"{
                    APIManager.shared.GetCelebritiesRequest { (items) in
                        self.settingControllers(data: items, completion: { (controllers) in
                            
                            self.mainData = items
                            completion(controllers)
                        })
                    }
                }
                else{
                    APIManager.shared.GetAllCategories { (items) in
                        self.settingControllers(data: items, completion: { (controllers) in
                            
                            self.mainData = items
                            completion(controllers)
                        })
                    }
                }
            }
    }
        
    
    
    func settingControllers(data: [Items],completion: @escaping ([UIViewController]) -> ()){
        var controllers: [UIViewController] = []
        
        //For All Section
        
      
        let ProductListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
        
        if self.currentLanguage  == "en"{
            ProductListViewController.title = "All"
        }
        else{
            ProductListViewController.title = "الكل"
        }
        
        
        
        if self.allId == -1{
            ProductListViewController.categoryIdArray = []
        }
        else{
            var temp: [Int] = []
            temp.append(self.allId)
            ProductListViewController.categoryIdArray = temp
        }
        
        
        controllers.append(ProductListViewController)
        
        
        for item in data{
           if item.name != "Brands" && item.name != "Celebrities" && item.name != "Tv"{
                
                var tempIds: [Int] = []
                
                let ProductListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
                
                ProductListViewController.title = item.name
                ProductListViewController.categoryId = item.id!
                
                if(self.allId != -1){
                    tempIds.append(self.allId)
                }
                
                tempIds.append(item.id!)
                
                ProductListViewController.categoryIdArray = tempIds
                
                controllers.append(ProductListViewController)
            }
        }
        
        completion(controllers)
    }
    
}


extension SplitProductsViewController: SJSegmentedViewControllerDelegate {
    
    func didMoveToPage(_ controller: UIViewController, segment: SJSegmentTab?, index: Int) {
        
        if selectedSegment != nil {
            selectedSegment?.titleColor(.lightGray)
        }
        
        if segments.count > 0 && segments.count < self.segmentControllers.count {
            
            selectedSegment = segments[index]
            selectedSegment?.titleColor(.red)
        }
    }
    
}

