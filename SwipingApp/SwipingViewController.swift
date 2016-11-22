//
//  SwipingViewController.swift
//  SwipingApp
//
//  Created by Thijs Lucassen on 18-11-16.
//
//

import UIKit
import Alamofire
import MDCSwipeToChoose

class SwipingViewController: UIViewController, MDCSwipeToChooseDelegate {
    
    @IBOutlet var swipingView: UIView!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!

    @IBAction func likeButtonTapped(_ sender: Any) {
        
    }
    
    var dict = Dictionary<String, Any>()
    var productImageURL = UIImageView()
    var allImages: [UIImage] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func loadImageWith( completion:@escaping (_ image: [UIImage?]) -> Void) {
        
        let productQuery = dict["query"] as! String
        
        
        Alamofire.request("https://ceres-catalog.debijenkorf.nl/catalog/navigation/show?query=\(productQuery)").responseJSON { response in
            
            if let productJSON = response.result.value {
                
                let jsonDict = productJSON as! Dictionary<String, Any>
                let jsonData = jsonDict["data"] as! Dictionary<String, Any>
                let listOfProducts = jsonData["products"] as! [[String : AnyObject]]
                let productItem = listOfProducts[0]
                
                for everyItem in listOfProducts {
                    // Data into object
                    let currentVariantProduct = everyItem["currentVariantProduct"] as! Dictionary<String,Any>
                    
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
                        
                        self.allImages.append(productImage!)
                    
                    }
                }
                completion(self.allImages)
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadImageWith { (allImages) in
        
        if allImages.count > 1 {
            
            let options = MDCSwipeToChooseViewOptions()
            options.delegate = self
            options.likedText = "Like"
            options.likedColor = UIColor.green
            options.nopeText = "Hide"
            options.onPan = { state -> Void in
                if state?.thresholdRatio == 1 && state?.direction == MDCSwipeDirection.left {
                    print("Photo Deleted!")
                    
                }
                
            options.likedRotationAngle = 5
            options.nopeRotationAngle = 5
            
            }
            
            let swipingView = MDCSwipeToChooseView(frame: self.swipingView.bounds, options: options)
            

            swipingView?.imageView.image = allImages[0]
//            swipingView?.frame.origin.x = 82;
//            swipingView?.frame.origin.y = 162;
            
//            swipingView?.imageView.contentMode = .scaleAspectFit
//            view?.frame.size.height = 400;
//            view?.frame.size.width = 300;
//            view?.frame.origin.x = 82;
//            view?.frame.origin.y = 162;
//            view?.backgroundColor = .white
////            view?.frame.offsetBy(dx: 20.0, dy: 20.0);
////            view?.imageView.frame.insetBy(dx: 30, dy: 30);
////            view?.imageView.frame.size.width = 300;
//            view?.imageView.frame.size.height = 400;
            
            self.swipingView.addSubview(swipingView!)
            
            let swipingViewTwo = MDCSwipeToChooseView(frame: self.swipingView.bounds, options: options)
            swipingViewTwo?.imageView.image = allImages[1]
//            viewTwo?.imageView.contentMode = .scaleAspectFit
//            viewTwo?.frame.size.height = 400;
//            viewTwo?.frame.size.width = 300;
//            viewTwo?.frame.origin.x = 86;
//            viewTwo?.frame.origin.y = 166;
//            viewTwo?.backgroundColor = .white
////            viewTwo?.imageView.frame.size.width = 300;
//            viewTwo?.imageView.frame.size.height = 400;
//            
            self.swipingView.addSubview(swipingViewTwo!)
//            
            let swipingViewThree = MDCSwipeToChooseView(frame: self.swipingView.bounds, options: options)
            swipingViewThree?.imageView.image = allImages[2]
//            
//            viewThree?.imageView.contentMode = .scaleAspectFit
//            viewThree?.frame.size.height = 400;
//            viewThree?.frame.size.width = 300;
//            viewThree?.frame.origin.x = 90;
//            viewThree?.frame.origin.y = 170;
//            viewThree?.backgroundColor = .white
////            viewThree?.imageView.frame.size.width = 300;
//            viewThree?.imageView.frame.size.height = 400;
            self.swipingView.addSubview(swipingViewThree!)
        }
    }
        self.setScreenName(name: navigationItem.title!)
    }
    
    func viewDidCancelSwipe(_ view: UIView!) {
        print("couldn't decide, huh?")
    }
    
    func view(_ view: UIView!, shouldBeChosenWith direction: MDCSwipeDirection) -> Bool {
        if (direction == MDCSwipeDirection.left) {
            return true
        }else {
            UIView.animate(withDuration: 0.16, animations: { () -> Void in
                view.transform = CGAffineTransform.identity
                view.center = (view.superview?.center)!
            })
            return true
        }
    }
    func view(_ view: UIView!, wasChosenWith direction: MDCSwipeDirection) {
        if direction == MDCSwipeDirection.left {
            print("photo deleted!")
        }else {
            print("photo saved!")
        }
    }
    
    func buildUnlikeButton() {
        let button: UIButton = UIButton(type: UIButtonType.system) as UIButton
        let buttonImage = UIImage(named: "unlike")
        button.frame = CGRect(x: 100, y: 480, width: (buttonImage?.size.width)!, height: (buttonImage?.size.height)!)
        //        button.backgroundColor = UIColor.blue
        button.setImage(buttonImage, for: UIControlState())
        button.tintColor = UIColor(red: 247.0/255.0, green: 91.0/255.0, blue: 37.0/255.0, alpha: 1.0)
        button.addTarget(self, action: #selector(unlikeButtonPressed), for: .touchUpInside)
        self.swipingView.addSubview(button)
    }
    
    func buildlikeButton() {
        let button: UIButton = UIButton(type: UIButtonType.system) as UIButton
        let buttonImage = UIImage(named: "liked")
        button.frame = CGRect(x: 150, y: 480, width: (buttonImage?.size.width)!, height: (buttonImage?.size.height)!)
        //        button.backgroundColor = UIColor.blue
        button.setImage(buttonImage, for: UIControlState())
        button.tintColor = UIColor(red: 29.0/255.0, green: 245.0/255.0, blue: 106.0/255.0, alpha: 1.0)
        button.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
        self.swipingView.addSubview(button)
    }
    
    func unlikeButtonPressed(_ button: UIButton) {
        print("unlike!")
        
        print(self.swipingView.subviews.count)
        
        self.swipingView.subviews[self.view.subviews.count-1].mdc_swipe(MDCSwipeDirection.left)
        
        
    }
    func likeButtonPressed(_ button: UIButton) {
        print("like!")
        
        print(self.swipingView.subviews.count)
        
        self.swipingView.subviews[self.view.subviews.count-1].mdc_swipe(MDCSwipeDirection.right)
        
        
        
    }

    
}
