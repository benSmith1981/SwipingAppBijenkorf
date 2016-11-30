//
//  BasketWebViewController.swift
//  SwipingApp
//
//  Created by Frank Sanchez on 11/30/16.
//
//

import UIKit
import WebKit
class BasketWebViewController: UIViewController {

    
    @IBOutlet weak var basketWebView: UIWebView!
    
    override func viewDidLoad() {
        let url = URL(string: "https://www.debijenkorf.nl/action/ViewCartPost-ViewCart")
        
        let request = URLRequest(url: url!)
        basketWebView.loadRequest(request)
        basketWebView.reload()
        basketWebView.tintColor = UIColor.red

        
        
    }

}
