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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getBasketProducts()
    }

    func getBasketProducts() {
        
        var basketProductCodes: [String] = []
        
        for productCode in self.realmBasketArray {
            var productCode = productCode.productCode
            productCode += "%7C1"
            basketProductCodes.append(productCode)
        }
        
        let productCodeQuery = basketProductCodes
        let productCodeString = productCodeQuery.joined(separator: ",")
        
        let url = URL(string: "https://www.debijenkorf.nl/page/basket?products=\(productCodeString)")
        
        let request = URLRequest(url: url!, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 5.0)
        basketWebView.loadRequest(request)
        basketWebView.tintColor = UIColor.red
    }
    
}
