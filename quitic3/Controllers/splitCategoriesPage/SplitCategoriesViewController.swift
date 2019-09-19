
import UIKit
import SJSegmentedScrollView


class SplitCategoriesViewController:  SJSegmentedViewController {
    
    @IBOutlet weak var categoriesActivityIndicator: UIActivityIndicatorView!
    var categoriesItems: [Items] = []
    var selectedSegment: SJSegmentTab?
    
    var segmentLoaded: Bool = false
    
    
    override func viewDidLoad() {
        
        if let storyboard = self.storyboard {

            if !self.segmentLoaded {
                self.categoriesActivityIndicator.isHidden = false
                self.GetAllCategories { (controllers) in
                    self.segmentControllers = controllers
                    
                    self.selectedSegmentViewHeight = 5.0
                    self.segmentTitleColor = .quiticPink
                    self.selectedSegmentViewColor = .quiticPink
                    self.segmentShadow = SJShadow.light()
                    self.showsHorizontalScrollIndicator = false
                    self.showsVerticalScrollIndicator = false
                    self.segmentBounces = true
                    
                    self.delegate = self
                    
                    if !self.segmentLoaded {
                        self.viewDidLoad()
                    }
                    
                    self.segmentLoaded = true
                    self.categoriesActivityIndicator.isHidden = true
                }
            }
            
            
        }
        
       // title = "Categories"
        super.viewDidLoad()
    }
    
    @IBAction func searchBtnClicked(_ sender: Any) {
        
        let desVC = UIStoryboard(name: "TVStoryboard", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
        desVC.searchType = "Categories"
        
        self.navigationController?.pushViewController(desVC, animated: true)
        
    }
    func GetAllCategories(completion: @escaping ([UIViewController]) -> ()){
        
        var controllers: [UIViewController] = []
        APIManager.shared.GetAllCategories { (items) in
            self.categoriesItems = items
            
            for category in self.categoriesItems{
                
              if category.name != "Brands" && category.name != "Celebrities" && category.name != "Tv"{
                if(category.is_active!){
                    let ProductListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
                
                    ProductListViewController.title = category.name
                    ProductListViewController.categoryId = category.id!
                    
                    controllers.append(ProductListViewController)
                }
                }
            }
            completion(controllers)
        }
    }
    
}

extension SplitCategoriesViewController: SJSegmentedViewControllerDelegate {
    
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

