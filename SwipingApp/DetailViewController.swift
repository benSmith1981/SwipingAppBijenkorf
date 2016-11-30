//
//  DetailViewController.swift
//  SwipingApp
//
//  Created by Frank Sanchez on 11/29/16.
//
//

import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var detailProductNameLabel: UILabel!
    
    @IBOutlet weak var detailProductImageView: UIImageView!
 
    @IBOutlet weak var detailProductBrandLabel: UILabel!
 
    @IBOutlet weak var detailProductPriceLabel: UILabel!
 
    @IBOutlet weak var detailProductDescriptionView: UITextView!
    
    
var detailProductArray = [DetailProduct]()
    
    var detailViewProduct: DetailProduct!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DataManager.sharedInstance.productDetailsFromProductsCodeAPI()
        
        NotificationCenter.default.addObserver(forName: notificationDetail, object: nil, queue: nil) { (notification) in
            let detailObject = notification.object
            
            self.detailProductArray = detailObject as! [DetailProduct]
            
            
        }
        
//        detailProductNameLabel.text = DetailProduct
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
