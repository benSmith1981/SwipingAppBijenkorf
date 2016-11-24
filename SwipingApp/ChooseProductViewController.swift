import UIKit
import MDCSwipeToChoose
import Alamofire

class ChooseProductViewController: UIViewController, MDCSwipeToChooseDelegate {
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    
    
    var sharedWishList = WishList.sharedInstance
    let ChooseProductButtonHorizontalPadding: CGFloat = 80.0
    let ChooseProductButtonVerticalPadding: CGFloat = 20.0
    var currentProduct: Product!
    var frontCardView: ChooseProductView!
    var backCardView: ChooseProductView!
    var dict: Dictionary<String,Any>?
    var productImageURL = UIImageView()
    var allProducts: [Product] = []
//    var productCodeArray: [String] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.allProducts = defaultProduct()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.allProducts = defaultProduct()
        // Here you can init your properties
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.loadProductWith { (productList) in
            
            if self.allProducts.count > 1 {
                // Display the first ChoosePersonView in front. Users can swipe to indicate
                // whether they like or dislike the person displayed.
                self.setMyFrontCardView(self.popProductViewWithFrame(self.frontCardViewFrame())!)
                self.view.addSubview(self.frontCardView)
                
                // Display the second ChoosePersonView in back. This view controller uses
                // the MDCSwipeToChooseDelegate protocol methods to update the front and
                // back views after each user swipe.
                self.backCardView = self.popProductViewWithFrame(self.backCardViewFrame())!
                self.view.insertSubview(self.backCardView, belowSubview: self.frontCardView)
                
                // Add buttons to programmatically swipe the view left or right.
                // See the `nopeFrontCardView` and `likeFrontCardView` methods.
                self.constructNopeButton()
                self.constructLikedButton()
                
                
            }
            
            
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    func loadProductWith( completion:@escaping (_ product: [Product]) -> Void) {
        activityIndicatorView.startAnimating()
        
        if let productQuery = dict!["query"] as? String {
            
            
            Alamofire.request("https://ceres-catalog.debijenkorf.nl/catalog/navigation/show?query=\(productQuery)").responseJSON { response in
                
                if let productJSON = response.result.value {
                    
                    let jsonDict = productJSON as! Dictionary<String, Any>
                    let jsonData = jsonDict["data"] as! Dictionary<String, Any>
                    let jsonQuery = jsonData["products"] as! [[String : AnyObject]]
                    let productItem = jsonQuery[0]
                    
                    
                    for item in jsonQuery {
                        
                        // Data into object
                        
                        if let name = item["name"] as? String {
                            let brand = item["brand"] as? Dictionary<String,Any>
                            
                            if let productBrand = brand?["name"] as? String {
                                
                                
                                let sellingPrice = item["sellingPrice"] as! Dictionary<String,Any>
                                let productPrice = sellingPrice["value"] as! Double
                                
                                let currentVariantProduct = item["currentVariantProduct"] as! Dictionary<String,Any>
                                let productCode = currentVariantProduct["code"] as? String
                                if let imageURL = currentVariantProduct["images"] as? [Dictionary<String,Any>] {
                                    let imageProductURL = imageURL[0]
                                    let frontImageURL = imageProductURL["url"] as! String
                                    
                                    let httpURL = "https:\(frontImageURL)"
                                    let url = URL(string: httpURL)
                                    let data = try? Data(contentsOf: url!)
                                    
                                    var productImage : UIImage?
                                    if data != nil {
                                        productImage = UIImage(data:(data)!)
                                        
                                    }
                                    
                                    let newProduct = Product(productBrand: productBrand, productName: name, productPrice: Float(productPrice), productImage: productImage!, productCode: productCode!)
                                    
                                    self.allProducts.append(newProduct)
                                    //print(self.allProducts)
                                    print(productCode)
                                    print(self.allProducts.count)
                                    
                                }
                            }
                            
                        }
                        
                    }
                    completion(self.allProducts)
                }
                
            }
            
        }
        
    }
    
    func stopSpinning(sender: AnyObject) {
        activityIndicatorView.stopAnimating()
    }
    
    func suportedInterfaceOrientations() -> UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.portrait
    }
    
    
    // This is called when a user didn't fully swipe left or right.
    func viewDidCancelSwipe(_ view: UIView) -> Void{
        
        print("You couldn't decide on \(self.currentProduct.productName)");
    }
    
    // This is called then a user swipes the view fully left or right.
    func view(_ view: UIView, wasChosenWith: MDCSwipeDirection) -> Void{
        
        // MDCSwipeToChooseView shows "NOPE" on swipes to the left,
        // and "LIKED" on swipes to the right.
        
        if(wasChosenWith == MDCSwipeDirection.left){
            print("You didn't like: \(self.currentProduct.productName)")
            
        }
        else {
            let newProductCode = currentProduct.productCode
            print("You liked product: \(self.currentProduct.productCode)")
            self.sharedWishList.addNewProductCode(productCode: newProductCode)
            print(sharedWishList.productCodeArray)
        }
        
        // MDCSwipeToChooseView removes the view from the view hierarchy
        // after it is swiped (this behavior can be customized via the
        // MDCSwipeOptions class). Since the front card view is gone, we
        // move the back card to the front, and create a new back card.
        
        //        if(self.backCardView != nil) {
        //            self.frontCardView = self.backCardView
        //        }
        
        //       self.frontCardView = self.backCardView
        //
        //        if(self.backCardView != nil) {
        //
        //            self.backCardView = self.frontCardView
        //
        //        if self.backCardView == self.popProductViewWithFrame(self.backCardViewFrame()) {
        //
        //            self.backCardView.alpha = 0.5
        //            popProductViewWithFrame(self.backCardViewFrame())?.insertSubview(self.backCardView, belowSubview: self.frontCardView)
        //            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
        //                self.backCardView.alpha = 1.0
        //                }, completion: nil)
        //            }
        
        // Correct Swiping Code
        if(self.backCardView != nil) {
            self.setMyFrontCardView(self.backCardView)
        }
        
        backCardView = self.popProductViewWithFrame(self.backCardViewFrame())
        //if(true){
        // Fade the back card into view.
        if(backCardView != nil) {
            self.backCardView.alpha = 0.0
            self.view.insertSubview(self.backCardView, belowSubview: self.frontCardView)
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.backCardView.alpha = 1.0
                },completion:nil)
        }
    }
    
    func setMyFrontCardView(_ frontCardView:ChooseProductView) -> Void{
        
        // Keep track of the person currently being chosen.
        // Quick and dirty, just for the purposes of this sample app.
        self.frontCardView = frontCardView
        self.currentProduct = frontCardView.product
        
    }
    
    func defaultProduct() -> [Product]{
        // It would be trivial to download these from a web service
        // as needed, but for the purposes of this sample app we'll
        // simply store them in memory.
        //        return [Product(productBrand: "Merk1", productName: "Pump1", productPrice: 120.0, productImage: UIImage(named: "finn")!, productCode: "1"), Product(productBrand: "Merk2", productName: "Pump2", productPrice: 130.0, productImage: UIImage(named: "jake")!, productCode: "2"), Product(productBrand: "Merk3", productName: "Pump3", productPrice: 140.0, productImage: UIImage(named: "fiona")!, productCode: "3"), Product(productBrand: "Merk4", productName: "Pump4", productPrice: 150.0, productImage: UIImage(named: "prince")!, productCode: "4")]
        return allProducts
    }
    
    func popProductViewWithFrame(_ frame: CGRect) -> ChooseProductView?{
        if(self.allProducts.count == 0){
            return nil;
        }
        
        // UIView+MDCSwipeToChoose and MDCSwipeToChooseView are heavily customizable.
        // Each take an "options" argument. Here, we specify the view controller as
        // a delegate, and provide a custom callback that moves the back card view
        // based on how far the user has panned the front card view.
        let options: MDCSwipeToChooseViewOptions = MDCSwipeToChooseViewOptions()
        options.delegate = self
        options.threshold = 160.0
        options.likedText = "Top"
        options.likedColor = UIColor.green
        options.likedRotationAngle = 0
        //options.threshold = 160.0
        options.onPan = { state -> Void in
            if(self.backCardView != nil){
                let frame: CGRect = self.frontCardViewFrame()
                self.backCardView.frame = CGRect(x: frame.origin.x, y: frame.origin.y-((state?.thresholdRatio)! * 10.0), width: frame.width, height: frame.height)
            }
        }
        
        // Create a personView with the top person in the people array, then pop
        // that person off the stack.
        
        let productView: ChooseProductView = ChooseProductView(frame: frame, product: self.allProducts[0], options: options)
        self.allProducts.remove(at: 0)
        return productView
        
    }
    
    func frontCardViewFrame() -> CGRect{
        let horizontalPadding:CGFloat = 20.0
        let topPadding:CGFloat = 80.0
        let bottomPadding:CGFloat = 220.0
        return CGRect(x: horizontalPadding,y: topPadding,width: (self.view.frame).width - (horizontalPadding * 2), height: (self.view.frame).height - bottomPadding)
    }
    
    func backCardViewFrame() ->CGRect{
        let frontFrame:CGRect = frontCardViewFrame()
        return CGRect(x: frontFrame.origin.x, y: frontFrame.origin.y + 10.0, width: frontFrame.width, height: frontFrame.height)
    }
    
    
    func constructNopeButton() -> Void{
        let button:UIButton =  UIButton(type: UIButtonType.system)
        let image:UIImage = UIImage(named:"nope")!
        button.frame = CGRect(x: ChooseProductButtonHorizontalPadding, y: (self.frontCardView.frame).maxY + ChooseProductButtonVerticalPadding, width: image.size.width, height: image.size.height)
        button.setImage(image, for: UIControlState())
        button.tintColor = UIColor(red: 247.0/255.0, green: 91.0/255.0, blue: 37.0/255.0, alpha: 1.0)
        button.addTarget(self, action: #selector(ChooseProductViewController.nopeFrontCardView), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button)
    }
    
    func constructLikedButton() -> Void{
        let button:UIButton = UIButton(type: UIButtonType.system)
        let image:UIImage = UIImage(named:"liked")!
        button.frame = CGRect(x: (self.view.frame).maxX - image.size.width - ChooseProductButtonHorizontalPadding, y: (self.frontCardView.frame).maxY + ChooseProductButtonVerticalPadding, width: image.size.width, height: image.size.height)
        button.setImage(image, for:UIControlState())
        button.tintColor = UIColor(red: 29.0/255.0, green: 245.0/255.0, blue: 106.0/255.0, alpha: 1.0)
        button.addTarget(self, action: #selector(ChooseProductViewController.likeFrontCardView), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button)
        
    }
    func nopeFrontCardView() -> Void{
        self.frontCardView.mdc_swipe(MDCSwipeDirection.left)
    }
    func likeFrontCardView() -> Void{
        self.frontCardView.mdc_swipe(MDCSwipeDirection.right)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //        let index = productCodeArray
        //        let currentArray = productCodeArray[index]
        
        if segue.identifier == "swipeToWishList" {
            
            //            var dictObj = currentArray.
            let swipeViewController = segue.destination as! WishListTableViewController
//            swipeViewController.productCodeArray = productCodeArray
            //                subCatTableViewController.title = dictObj["name"] as? String
        }
        
    }
}
