import UIKit
import MDCSwipeToChoose
import Alamofire
import RealmSwift


class ChooseProductViewController: UIViewController, MDCSwipeToChooseDelegate {
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    let realm = try! Realm()
    lazy var realmProductArray: Results<RealmProduct> = { self.realm.objects(RealmProduct.self) }()
    var allProductCodes: RealmProduct!
    
    var sharedWishList = WishList.sharedInstance
    var preferredProductList = PreferredProductList.sharedInstance
    let ChooseProductButtonHorizontalPadding: CGFloat = 80.0
    let ChooseProductButtonVerticalPadding: CGFloat = 20.0
    var currentProduct: Product!
    var frontCardView: ChooseProductView!
    var backCardView: ChooseProductView!
    var dict: Dictionary<String,Any>?
    var productImageURL = UIImageView()
    var allProducts: [Product] = []
    var preferredProduct: [PreferredProduct] = []
    var currentPreferredProduct = PreferredProduct.self
    var productCodeToPass: String!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.allProducts = defaultProduct()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.allProducts = defaultProduct()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(infoButton), name: note.name, object: nil)
        
        self.loadProductWith { (productList) in
            
            if self.allProducts.count > 1 {
                self.setMyFrontCardView(self.popProductViewWithFrame(self.frontCardViewFrame())!)
                self.view.addSubview(self.frontCardView)
                
                self.backCardView = self.popProductViewWithFrame(self.backCardViewFrame())!
                self.view.insertSubview(self.backCardView, belowSubview: self.frontCardView)
                
                self.constructNopeButton()
                self.constructLikedButton()
            }
        }
        print("Realm config \(Realm.Configuration.defaultConfiguration)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setScreenName(name: navigationItem.title!)
    }
    
    
    func loadProductWith( completion:@escaping (_ product: [Product]) -> Void) {
        activityIndicatorView.startAnimating()
        
        //var imageURLString: [String] = []
        var imageURLArray: [UIImage] = []
        
        let productCategory = dict?["name"] as? String
        print("Categorie \(productCategory)")
        
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
                                var productColor = " "
                                let currentVariantProduct = item["currentVariantProduct"] as! Dictionary<String,Any>
                                let productCode = currentVariantProduct["code"] as? String
                                if let color = currentVariantProduct["color"] as? String {
                                    productColor = color }
                                else {
                                    productColor = "onbekend" }
                                if let imageURL = currentVariantProduct["images"] as? [Dictionary<String,Any>] {
                                    let imageProductURL = imageURL[0]
                                    let frontImageURL = imageProductURL["url"] as! String
                                    
                                    let httpURL = "https:\(frontImageURL)"
                                    let url = URL(string: httpURL)
                                    let data = try? Data(contentsOf: url!)
                                    
                                    let defaultString = httpURL
                                    let webListerString = httpURL.replacingOccurrences(of: "default", with: "web_lister_2x")
                                    
                                    let urlString = String(webListerString)
                                    
                                    
                                    var productImage : UIImage?
                                    if data != nil {
                                        productImage = UIImage(data:(data)!)
                                        
                                        //imageURLString.append(urlString!)
                                        imageURLArray.append(productImage!)
                                    }
                                    
//                                    let detailProductImages = imageURLArray
                                    let productImageString = urlString
                                    
                                    let newProduct = Product(productBrand: productBrand, productName: name, productPrice: Float(productPrice), productImage: productImage!, productCode: productCode!, productColor: productColor, productCategory: productCategory!, productImageString: productImageString!)
                                    
                                    self.allProducts.append(newProduct)
                                    
                                    let newPreferredProduct = PreferredProduct(preferredProductColor: productColor, preferredProductCategory: productCategory!)
                                
                                    self.preferredProduct.append(newPreferredProduct)
                                    
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
            let productColor = currentProduct.productColor
            let productCat = currentProduct.productCategory
            let preferredProduct = PreferredProduct(preferredProductColor: productColor, preferredProductCategory: productCat)
            print("You liked product: \(self.currentProduct.productCode)")
            print("Color is \(self.currentProduct.productColor)")
            print("Category is \(self.currentProduct.productCategory)")
            self.sharedWishList.addNewProductCode(productCode: newProductCode)
            self.preferredProductList.addNewPreferredProduct(newPreferredProduct: preferredProduct)
            print(sharedWishList.productCodeArray)
            print(preferredProductList.preferredProductArray)
            
            try! realm.write() {
                
                let realmURL = URL(string: currentProduct.productImageString)
                let realmImage = NSData(contentsOf: realmURL!)
                
                let newRealmProduct = RealmProduct()
                newRealmProduct.productCode = self.currentProduct.productCode
                newRealmProduct.productName = self.currentProduct.productName
                newRealmProduct.productBrand = self.currentProduct.productBrand
                newRealmProduct.productImage = realmImage!
                newRealmProduct.productCategory = self.currentProduct.productCategory
                newRealmProduct.productPrice = Double(self.currentProduct.productPrice)
                realm.add(newRealmProduct)
                self.allProductCodes = newRealmProduct
                
                
            }
            
            for count in preferredProductList.preferredProductArray {

//                if count.preferredProductColor >= 5 {
//                    print("Your favourite color is \(productColor)")
//                }
                print(count.preferredProductCategory)

            }

            
            for count in preferredProductList.preferredProductArray {
                print(count.preferredProductColor)
            }
            
        }
        
//        func notifyUser() {
//            
//            let preferredArray = preferredProductList.preferredProductArray
//            var counts: [String] = []
//            
//            for item in preferredArray {
//                counts[item] = (counts[item] ?? 0) + 1
//            }
//            
//            print(counts)
//            
//            for (key, value) in counts {
//                print("\(key) occurs \(value) time(s)")
//            }
//        }
        
        
        
        
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
        return allProducts
    }
    
    func popProductViewWithFrame(_ frame: CGRect) -> ChooseProductView?{
        if(self.allProducts.count == 0){
            return nil;
        }
        
        let options: MDCSwipeToChooseViewOptions = MDCSwipeToChooseViewOptions()
        options.delegate = self
        options.threshold = 160.0
        options.likedText = "Top"
        options.likedColor = UIColor.green
        options.likedRotationAngle = 0
        options.onPan = { state -> Void in
            if(self.backCardView != nil){
                let frame: CGRect = self.frontCardViewFrame()
                self.backCardView.frame = CGRect(x: frame.origin.x, y: frame.origin.y-((state?.thresholdRatio)! * 10.0), width: frame.width, height: frame.height)
            }
        }
        
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
    
    //    func constructUndoButton() -> Void{
    //        let button:UIButton = UIButton(type: UIButtonType.system)
    //        let image:UIImage = UIImage(named:"undo")!
    //        button.frame = CGRect(x: 150, y: 445, width: (image.size.width), height: (image.size.height))
    //        button.setImage(image, for: UIControlState())
    //        button.tintColor = UIColor.darkGray
    //        self.view.addSubview(button)
    //
    //
    //    }
    
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
    func infoButton() {
        print("You pressed the info button")
        performSegue(withIdentifier: "swipeToDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "swipeToDetail"{
            let _productCode = currentProduct.productCode
            let detailViewController = segue.destination as! DetailViewController
            
            detailViewController.currentProductCode = _productCode
            
        }
    }
}
