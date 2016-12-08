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
    lazy var realmPreferences: Results<Preferences> = { self.realm.objects(Preferences.self) }()
    var allProductCodes: RealmProduct!
    var preferences: Preferences!
    
    var sharedWishList = WishList.sharedInstance
    var wishListProductArray = [WishListProduct]()

    
    @IBAction func toggleEditingMode(_ sender: AnyObject) {
        
        if isEditing {
            sender.setTitle("Bewerk", for: .normal)
            setEditing(false, animated: true)
        } else {
            sender.setTitle("Klaar", for: .normal)
            setEditing(true, animated: true)
        }
    }

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
        cell.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let backImage = UIImageView(image: UIImage(named: "remove"))
            backImage.contentMode = .scaleAspectFit
            //remove.backgroundColor = UIColor(patternImage: backImage.image)!
            
            try! realm.write {
                let item = realmProductArray[indexPath.row]
                realm.delete(item)
                let pref = realmPreferences[indexPath.row]
                realm.delete(pref)
            }
            self.tableView.reloadData()
        }
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


