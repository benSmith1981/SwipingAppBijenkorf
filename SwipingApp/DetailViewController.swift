//
//  DetailViewController.swift
//  SwipingApp
//
//  Created by Frank Sanchez on 11/29/16.
//
//

import UIKit

class DetailViewController: UIViewController, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var detailProductNameLabel: UILabel!
    @IBOutlet weak var detailProductImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var detailProductBrandLabel: UILabel!
    @IBOutlet weak var detailProductPriceLabel: UILabel!
    @IBOutlet weak var detailProductDescriptionView: UITextView!
    @IBAction func buttonTapped(_ segue: UIStoryboardSegue) {
        self.performSegue(withIdentifier: "unwindToSwipe", sender: self)
    }
    
    var detailProductArray = [UIImage]()
    var currentProductCode : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        // Safely unwrapping currentProductCode
        if let currentProductCode = self.currentProductCode {
            
            DataManager.sharedInstance.getDetailProductFromAPI(code:(currentProductCode)) { (detailProduct) in
                
                self.detailProductArray = detailProduct.detailProductImages
                let priceOfProduct = detailProduct.productPrice
                self.detailProductNameLabel.text = detailProduct.productName
                self.detailProductDescriptionView.text = detailProduct.detailProductDescription
                self.detailProductBrandLabel.text = detailProduct.productBrand
                self.detailProductImageView.image = detailProduct.productImage
                self.detailProductPriceLabel.text = String(format: "€ %.2f", priceOfProduct)
                print("Product images count \(detailProduct.detailProductImages.count)")
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.setScreenName(name: navigationItem.title!)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.detailProductArray.count == 0 {
            return 0 }
        else {
            return detailProductArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! CustomCollectionViewCell
        
        cell.detailProductImage.image = detailProductArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = detailProductImageView
        cell?.image = detailProductArray[indexPath.row]
    }
}
