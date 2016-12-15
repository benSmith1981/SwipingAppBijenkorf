//
//  ChooseProductView.swift
//  SwipingApp
//
//  Created by Thijs Lucassen on 23-11-16.
//
//

import Foundation
import UIKit
import MDCSwipeToChoose
var note = Notification(name: Notification.Name(rawValue: "Send"))

class ChooseProductView: MDCSwipeToChooseView {
    
    let ChooseProductViewImageLabelWidth: CGFloat = 42.0;
    var product: Product!
    var informationView: UIView!
    var topInformationView: UIView!
    var nameLabel: UILabel!
    var priceLabel: UILabel!
    var brandLabel: UILabel!
    var infoButtonImage: ImagelabelView!

    
    init(frame: CGRect, product: Product, options: MDCSwipeToChooseViewOptions) {
        
        super.init(frame: frame, options: options)
        self.product = product
        
        if let image = self.product?.productImage {
            self.imageView.image = image
        }
        
        self.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        
        self.imageView.autoresizingMask = self.autoresizingMask
         constructTopInformationView()
        
        self.imageView.autoresizingMask = self.autoresizingMask
         constructInformationView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func constructTopInformationView() -> Void {
        
        let topHeight: CGFloat = 40.0
        let topFrame: CGRect = CGRect(x: 0, y: 0, width: (self.bounds).width, height: topHeight);
        self.topInformationView = UIView(frame: topFrame)
        self.topInformationView.backgroundColor = UIColor.white
        self.topInformationView.clipsToBounds = true
        self.topInformationView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleTopMargin]
        self.addSubview(self.topInformationView)
        /*constructNameLabel()*/
        constructBrandLabel()
    }
    
    func constructInformationView() -> Void{
        let bottomHeight:CGFloat = 80.0
        let bottomFrame:CGRect = CGRect(x: 0,
                                        y: (self.bounds).height - bottomHeight,
                                        width: (self.bounds).width,
                                        height: bottomHeight);
        self.informationView = UIView(frame: bottomFrame)
        //        self.informationView.alignmentRectInsets.bottom = 4
        self.informationView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        // self.informationView.clipsToBounds = true
        self.informationView.layer.cornerRadius = 20.0
        //        self.informationView.center =
        self.informationView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleTopMargin]
        self.addSubview(self.informationView)
        constructBrandLabel()
        constructPriceLabel()
        constructInfoButton()
        constructNameLabel()
    }
    
    
    
    func constructBrandLabel() -> Void{
        let leftPadding:CGFloat = 12.0
        let topPadding:CGFloat = -10.0
        let frame:CGRect = CGRect(x: 0,
                                  y: topPadding,
                                  width: floor(self.topInformationView.frame.width),
                                  height: self.topInformationView.frame.height - topPadding)
        self.brandLabel = UILabel(frame:frame)
        self.brandLabel.baselineAdjustment = .alignCenters
        self.brandLabel.text = "\(product.productBrand)"
        self.brandLabel.textAlignment = .center
        self.brandLabel.font = UIFont(name: "ProximaNova-Bold", size: 18)
        self.brandLabel.adjustsFontSizeToFitWidth = true
        self.topInformationView .addSubview(self.brandLabel)
    }
    
    func constructInfoButton() -> Void {
        
        let button : UIButton = UIButton(type: UIButtonType.system)
        let image: UIImage = UIImage(named: "info")!
        
        let informationWidth = self.topInformationView.frame.size.width
        let informationHeigth = self.topInformationView.frame.size.height
        
//        button.frame.size = CGSize(width: 20, height: 20)
        button.frame = CGRect(x: informationWidth-50, y: informationHeigth-01, width: 20, height: 20)
        button.setImage(image, for: UIControlState())
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(notification), for: UIControlEvents.touchUpInside)
        self.informationView.addSubview(button)
    }
    func notification() {
        NotificationCenter.default.post(note)
    }
    
    
    
    func constructNameLabel() -> Void{
        let leftPadding:CGFloat = 12.0
        let topPadding:CGFloat = -24.0
        let frame:CGRect = CGRect(x: 0,
                                  y: topPadding,
                                  width: floor(self.informationView.frame.width),
                                  height: self.informationView.frame.height - topPadding)
        self.nameLabel = UILabel(frame: frame)
        self.nameLabel.baselineAdjustment = .alignCenters
        self.nameLabel.numberOfLines = 0
        self.nameLabel.text = "\(product.productName)"
        self.nameLabel.textAlignment = .center
        self.nameLabel.font = UIFont(name: "ProximaNova-Regular", size: 12)
        self.nameLabel.adjustsFontSizeToFitWidth = true
        self.informationView .addSubview(self.nameLabel)
    }
    
    func constructPriceLabel() -> Void {
        let rightPadding: CGFloat = 12.0
        let topPadding: CGFloat = 30.0
        let frame: CGRect = CGRect(x: 0, y: topPadding, width: floor(self.informationView.frame.width), height: self.informationView.frame.height - topPadding)
        let priceOfProduct = product.productPrice
        self.priceLabel = UILabel(frame: frame)
        self.priceLabel.text = String(format: "€ %.2f", priceOfProduct)
        self.priceLabel.textAlignment = .center
        self.priceLabel.font = UIFont(name: "ProximaNova-Bold", size: 18)
        self.priceLabel.adjustsFontSizeToFitWidth = true
        self.informationView .addSubview(self.priceLabel)
        
    }
    
    
    
    func buildImageLabelViewLeftOf(_ x:CGFloat, image:UIImage, text:String) -> ImagelabelView {
        let frame: CGRect = CGRect(x: x-ChooseProductViewImageLabelWidth, y: 40,
                                   width: ChooseProductViewImageLabelWidth,
                                   height: self.informationView.bounds.height)
        let view: ImagelabelView = ImagelabelView(frame: frame, image: image, text: text)
        view.autoresizingMask = UIViewAutoresizing.flexibleLeftMargin
        return view
    }
}
