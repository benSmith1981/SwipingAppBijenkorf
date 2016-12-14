//
//  BasketWebViewController.swift
//  SwipingApp
//
//  Created by Frank Sanchez on 11/30/16.
//
//

import UIKit
import WebKit
import RealmSwift

class BasketWebViewController: UIViewController {
    let realm = try! Realm()
    lazy var realmBasketArray: Results<AddToBasketProduct> = { self.realm.objects(AddToBasketProduct.self)}()
    var allBasketProductCodes: RealmProduct!
    
    @IBOutlet weak var basketWebView: UIWebView!
    
    override func viewDidLoad() {
        getBasketProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        getBasketProducts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getBasketProducts()
    }
    
    func getBasketProducts() {
        
        var basketProductCodes: [String] = []
        
        for productCode in self.realmBasketArray {
            let productCode = productCode.productCode
            basketProductCodes.append(productCode)
        }
        
        let productCodeQuery = basketProductCodes
        let productCodeString = productCodeQuery.joined(separator: ",")
        
        let url = URL(string: "https://www.debijenkorf.nl/page/addtobasket?products=\(productCodeString)%7C1")
        
        let request = URLRequest(url: url!, cachePolicy: URLRequest.CachePolicy.reloadRevalidatingCacheData, timeoutInterval: 5.0)
        basketWebView.loadRequest(request)
        basketWebView.reload()
        basketWebView.tintColor = UIColor.red
    }
    
}
