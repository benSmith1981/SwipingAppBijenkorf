
import UIKit
import MDCSwipeToChoose
import Alamofire
import RealmSwift

class ChooseProductViewController: UIViewController, MDCSwipeToChooseDelegate {
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBAction func unwindToSwipe(segue:UIStoryboardSegue) {
    }
    
    // MARK - Properties
    
    let realm = try! Realm()
    lazy var realmProductArray: Results<RealmProduct> = { self.realm.objects(RealmProduct.self) }()
    var sharedWishList = WishList.sharedInstance
    let ChooseProductButtonHorizontalPadding: CGFloat = 80.0
    let ChooseProductButtonVerticalPadding: CGFloat = 20.0
    var currentProduct: Product!
    var frontCardView: ChooseProductView!
    var backCardView: ChooseProductView!
    var dict: Dictionary<String,Any>?
    var nextPageURL: String?
    var productImageURL = UIImageView()
    var allProducts: [Product] = []
    var colorArray: [String] = []
    var productCodeArray: [String] = []
   
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
       // noMoreProducts.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(infoButton), name: note.name, object: nil)
        
        self.activityIndicatorView.startAnimating()
        
        let firstQuery = DataManager.sharedInstance.getFirstProductQuery(dict: dict!)
        
        DataManager.sharedInstance.loadProductWith(query: firstQuery) { (productList, nextPageURL) in
            
            for everyItem in productList {
                self.allProducts.append(everyItem)
            }
            
            // FIXME: what happens if we TWICE get no data from the datamanager???
            
            //If there is no query what do we do
            
            let nextQuery = self.encodedNextQuery(query: nextPageURL)
            self.nextPageURL = nextQuery
            self.createCardsFromProductList()
            
            return
        }
        
        self.activityIndicatorView.stopAnimating()
        self.activityIndicatorView.hidesWhenStopped = true
        print("Realm config \(Realm.Configuration.defaultConfiguration)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setScreenName(name: navigationItem.title!)
    }
    
    func stopSpinning(sender: AnyObject) {
        activityIndicatorView.stopAnimating()
    }
    
    func suportedInterfaceOrientations() -> UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.portrait
    }
    
    // This is called when a user didn't fully swipe left or right.
    func viewDidCancelSwipe(_ view: UIView) -> Void{

    }
    
    // This is called then a user swipes the view fully left or right.
    func view(_ view: UIView, wasChosenWith: MDCSwipeDirection) -> Void{
        
        // MDCSwipeToChooseView shows "NOPE" on swipes to the left,
        // and "LIKED" on swipes to the right.
        
        if(wasChosenWith == MDCSwipeDirection.left) {
            
            let seenProductCode = currentProduct.productCode
            
            try! realm.write() {
                
                let seenProduct = SeenProduct()
                seenProduct.productCode = seenProductCode
                realm.add(seenProduct)
            }
            
        } else {
            
            let newProductCode = currentProduct.productCode

            self.sharedWishList.addNewProductCode(productCode: newProductCode)
            
            try! realm.write() {
                let realmURL = URL(string: currentProduct.productImageString)
                let realmImage = NSData(contentsOf: realmURL!)
                
                let newRealmProduct = RealmProduct()
                newRealmProduct.productCode = self.currentProduct.productCode
                newRealmProduct.productName = self.currentProduct.productName
                newRealmProduct.productBrand = self.currentProduct.productBrand
                newRealmProduct.productImage = realmImage!
                newRealmProduct.productPrice = Double(self.currentProduct.productPrice)
                let newProductColor = Color()
                newProductColor.productColor = self.currentProduct.productColor
                let newProductBrand = Brand()
                newProductBrand.productBrand = self.currentProduct.productBrand
                let basketProductCode = BasketProduct()
                basketProductCode.productCode = self.currentProduct.productCode
                
                newRealmProduct.color.append(newProductColor)
                newRealmProduct.brand.append(newProductBrand)
                newRealmProduct.basketProducts.append(basketProductCode)
                realm.add(newRealmProduct)
            }
            
            let seenProductCode = currentProduct.productCode
            
            try! realm.write() {
                let seenProduct = SeenProduct()
                seenProduct.productCode = seenProductCode
                realm.add(seenProduct)
            }
        }
        
        if(self.backCardView != nil) {
            self.setMyFrontCardView(self.backCardView)
        }
        
        backCardView = self.popProductViewWithFrame(self.backCardViewFrame())
        if(backCardView != nil) {
            self.backCardView.alpha = 0.0
            self.view.insertSubview(self.backCardView, belowSubview: self.frontCardView)
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.backCardView.alpha = 1.0
                },completion:nil)
        }
    }
    
    // MARK - Set Cards
    
    func setMyFrontCardView(_ frontCardView:ChooseProductView) -> Void{
        
        self.frontCardView = frontCardView
        self.currentProduct = frontCardView.product
    }
    
    func popProductViewWithFrame(_ frame: CGRect) -> ChooseProductView?{
        if(self.allProducts.count == 0){
            return nil
        }
        
        let options: MDCSwipeToChooseViewOptions = MDCSwipeToChooseViewOptions()
        options.delegate = self
        options.threshold = 160.0
        options.likedText = "Top"
        options.nopeText = "Flop"
        options.likedColor = UIColor.green
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
    
    func createCardsFromProductList() {
        
        self.setMyFrontCardView(self.popProductViewWithFrame(self.frontCardViewFrame())!)
        self.view.addSubview(self.frontCardView)
        if let productView = self.popProductViewWithFrame(self.backCardViewFrame()) {
            self.backCardView = productView
            self.view.insertSubview(self.backCardView, belowSubview: self.frontCardView)
            self.constructNopeButton()
            self.constructLikedButton()
        }
    }
    
    
    // MARK - Misc
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "swipeToDetail"{
            let _productCode = currentProduct.productCode
            let detailViewController = segue.destination as! DetailViewController
            
            detailViewController.currentProductCode = _productCode
        }
    }
    
    func defaultProduct() -> [Product]{
        return allProducts
    }
    
    func infoButton() {
        print("You pressed the info button")
        performSegue(withIdentifier: "swipeToDetail", sender: self)
    }
    
    func encodedNextQuery(query: String) -> String {
        let encodedURL = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let encodedURLMinusEqual = encodedURL?.replacingOccurrences(of: "=", with: "%3D")
        let encodedURLMinusAnd = encodedURLMinusEqual?.replacingOccurrences(of: "&", with: "%26")
        return encodedURLMinusAnd!
    }
}
