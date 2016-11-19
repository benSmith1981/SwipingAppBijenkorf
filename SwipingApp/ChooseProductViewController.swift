////
////  ChooseProductViewController.swift
////  SwipingApp
////
////  Created by Thijs Lucassen on 18-11-16.
////
////
//
//import UIKit
//
//class ChooseProductViewController: UIViewController, MDCSwipeToChooseDelegate {
//    
//    var allProducts: [Product] = []
//    let ChooseProductButtonHorizontalPadding: CGFloat = 80.0
//    let ChooseProductButtonVerticalPadding: CGFloat = 20.0
//    var currentProduct: Product!
//    var frontCardView: ChooseProductView!
//    var backCardView: ChooseProductView!
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.allProducts = defaultProduct()
//    }
//
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        self.allProducts = defaultProduct()
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.setMyFrontCardView(self.popProductViewWithFrame(frontCardViewFrame())!)
//        self.view.addSubview(self.frontCardView)
//        
//        self.backCardView = self.popProductViewWithFrame(backCardViewFrame())!
//        self.view.insertSubview(self.backCardView, belowSubview: self.frontCardView)
//        
//        constructNopeButton()
//        constructLikedButton()
//    }
//    
//    func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//        return UIInterfaceOrientationMask.portrait
//    }
//    
//    func ViewDidCancelSwipe(_ view: UIView) -> Void {
//        print("You couldn't decide on \(self.currentProduct.name)")
//    }
//    
//    func view(_ view: UIView, wasChosenWithDirection: MDCSwipeDirection) -> Void {
//        
//        if(wasChosenWithDirection == MDCSwipeDirection.Left) {
//            print("You noped: \(self.currentProduct.name)")
//        } else {
//            print("You liked: \(self.currentProduct.name)")
//        }
//        if(self.backCardView != nil) {
//            self.setMyFrontCardView(self.backCardView)
//        }
//        backCardView = self.popProductViewWithFrame(self.backCardViewFrame())
//        
//        if(backCardView != nil) {
//            self.backCardView.alpha = 0.0
//            self.view.insertSubview(self.backCardView, belowSubview: self.frontCardView)
//            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
//                self.backCardView.alpha = 1.0
//                }, completion: nil)
//        }
//    }
//    
//    func setMyFrontCardView(_ frontCardView: ChooseProductView) -> Void {
//        self.frontCardView = frontCardView
//        self.currentProduct = frontCardView.product
//        
//    }
//    
//    func defaultProduct() -> [Product] {
//        return [Product(productBrand: "Product", productName: UIImage(named: "Product"), productPrice: 10.0, productImage: "Brand")]
//    }
//    
//    func popProductViewWithFrame(_ frame: CGRect) -> ChooseProductView? {
//        
//        if(self.allProducts.count == 0) {
//            return nil
//        }
//        
//        let options: MDCSwipeToChooseViewOptions = MDCSwipeToChooseViewOptions()
//        options.delegate = self
//        options.onPan = { state -> Void in
//            if(self.backCardView != nil) {
//                let frame: CGRect = self.frontCardViewFrame()
//                self.backCardView.frame = CGRectMake(frame.origin.x, frame.origin.y-(state.thresholdRatio * 10.0), frame, frame)
//            }
//    }
//        
//        let productView: ChooseProductView = ChooseProductView(frame: frame, product: self.allProducts[0], options: options)
//        self.allProducts.remove(at: 0)
//        return productView
//        
//    }
//
//
//    func frontCardViewFrame() -> CGRect {
//        let horizontalPadding: CGFloat = 20.0
//        let topPadding: CGFloat = 60.0
//        let bottomPadding: CGFloat = 200.0
//        return CGRect(x: horizontalPadding, y: topPadding, width: (self.view.frame).width - (horizontalPadding * 2), height: (self.view.frame).height - bottomPadding)
//    }
//
//    func backCardViewFrame() -> CGRect {
//        let frontFrame: CGRect = frontCardViewFrame()
//        return CGRect(x: frontFrame.origin.x, y: frontFrame.origin.y, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
