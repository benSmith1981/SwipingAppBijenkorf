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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager.sharedInstance.productDetailsFromProductsCodeAPI()
        
        NotificationCenter.default.addObserver(forName: notificationDetail, object: nil, queue: nil) { (notification) in
            let detailObject = notification.object as! [DetailProduct]
            self.detailProductArray = detailObject
            
            let priceOfProduct = self.detailProductArray[0].productPrice
            
            self.detailProductNameLabel.text = self.detailProductArray[0].productName
            self.detailProductDescriptionView.text = self.detailProductArray[0].detailProductDescription
            self.detailProductBrandLabel.text = self.detailProductArray[0].productBrand
            self.detailProductImageView.image = self.detailProductArray[0].productImage
            self.detailProductPriceLabel.text = String(format: "€ %.2f", priceOfProduct)
            
            
        }
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
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
