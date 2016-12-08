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
    lazy var realmProductArrayToBasket: Results<RealmBasketProduct> = { self.realm.objects(RealmBasketProduct.self)}()
    var allProductCodesToBasket: RealmBasketProduct!
    
    @IBOutlet weak var basketWebView: UIWebView!
    
    override func viewDidLoad() {
        let url = URL(string: "https://www.debijenkorf.nl/action/ViewCartPost-ViewCart")
        
        let request = URLRequest(url: url!)
        basketWebView.loadRequest(request)
        basketWebView.reload()
        basketWebView.tintColor = UIColor.red

        
        
    }

}
