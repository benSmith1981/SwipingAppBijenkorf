//
//  WishListTableViewController.swift
//  SwipingApp
//
//  Created by Thijs Lucassen on 21-11-16.
//
//

import UIKit
import UserNotifications
import RealmSwift

class WishListTableViewController: UITableViewController, UITabBarControllerDelegate {
    
    let realm = try! Realm()
    lazy var realmProductArray: Results<RealmProduct> = { self.realm.objects(RealmProduct.self) }()
    lazy var realmColorArray: Results<Color> = { self.realm.objects(Color.self) }()
    lazy var realmBrandArray: Results<Brand> = { self.realm.objects(Brand.self) }()
    lazy var realmCategoryArray: Results<Category> = { self.realm.objects(Category.self) }()
    lazy var realmBasketArray: Results<BasketProduct> = { self.realm.objects(BasketProduct.self) }()
    lazy var realmAddToBasketArray: Results<AddToBasketProduct> = { self.realm.objects(AddToBasketProduct.self) }()
    var allProductCodes: RealmProduct!
    var currentProduct: Product!
    var sharedWishList = WishList.sharedInstance
    var wishListProductArray = [WishListProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
        self.setScreenName(name: navigationItem.title!)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realmProductArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wishListCell", for: indexPath) as! CustomWishListTableViewCell
        let product = self.realmProductArray[indexPath.row]
        let priceOfProduct = product.productPrice
        let realmImage = UIImage(data: product.productImage as Data)
        
        cell.productName?.text = product.productName
        cell.productBrand?.text = product.productBrand
        cell.productPrice?.text = String(format: "€ %.2f", priceOfProduct)
        cell.imageView?.image = resizeImage(image: realmImage!, newWidth: 100)
        cell.backgroundColor = UIColor.white/*(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)*/
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?  {
        
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Verwijderen" , handler: { (action:UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            
            try! self.realm.write() {
                let item = self.realmProductArray[indexPath.row]
                self.realm.delete(item)
                let color = self.realmColorArray[indexPath.row]
                self.realm.delete(color)
                let brand = self.realmBrandArray[indexPath.row]
                self.realm.delete(brand)
                let basketProduct = self.realmBasketArray[indexPath.row]
                self.realm.delete(basketProduct)
            }
            self.tableView.reloadData()
        })
        delete.backgroundColor = UIColor.red
        
        let addToBasket = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Toevoegen" , handler: { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            
            let product = self.realmProductArray[indexPath.row]
            var basketProductCodes: [String] = []
            
            for productCode in self.realmBasketArray {
                let productCode = product.productCode
                basketProductCodes.append(productCode)
            }
            let basket = basketProductCodes[indexPath.row]
            
            try! self.realm.write() {
                
                let basketProduct = AddToBasketProduct()
                basketProduct.productCode = basket
                self.realm.add(basketProduct)
            }
            
            try! self.realm.write() {
                let item = self.realmProductArray[indexPath.row]
                self.realm.delete(item)
                let color = self.realmColorArray[indexPath.row]
                self.realm.delete(color)
                let brand = self.realmBrandArray[indexPath.row]
                self.realm.delete(brand)
                let basketProduct = self.realmBasketArray[indexPath.row]
                self.realm.delete(basketProduct)
            }
            
            self.tableView.reloadData()
        })
        addToBasket.backgroundColor = UIColor(red:0.96, green:0.66, blue:0.00, alpha:1.0)
        
        return [delete, addToBasket]
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = realmProductArray[indexPath.row]
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailViewController.currentProductCode = item.productCode
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

