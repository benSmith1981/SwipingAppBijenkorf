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

class ChooseProductView: MDCSwipeToChooseView {
    
    let ChooseProductViewImageLabelWidth: CGFloat = 42.0;
    var product: Product!
    var informationView: UIView!
    var topInformationView: UIView!
    var nameLabel: UILabel!
    var priceLabel: UILabel!
    var brandLabel: UILabel!
    var infoLabelView:ImagelabelView!
    //    var interestsImageLabelView: ImagelabelView!
    //    var friendsImageLabelView: ImagelabelView!
    
    init(frame: CGRect, product: Product, options: MDCSwipeToChooseViewOptions) {
        
        super.init(frame: frame, options: options)
        self.product = product
        
        if let image = self.product?.productImage {
            self.imageView.image = image
        }
        
        self.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        //        UIViewAutoresizing.flexibleBottomMargin
        
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
        constructNameLabel()
        //        constructInfoLabelView()
    }
    
    func constructInformationView() -> Void{
        let bottomHeight:CGFloat = 80.0
        let bottomFrame:CGRect = CGRect(x: 0,
                                        y: (self.bounds).height - bottomHeight,
                                        width: (self.bounds).width,
                                        height: bottomHeight);
        self.informationView = UIView(frame: bottomFrame)
        self.informationView.backgroundColor = UIColor.white
        self.informationView.clipsToBounds = true
        self.informationView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleTopMargin]
        self.addSubview(self.informationView)
        constructBrandLabel()
        constructPriceLabel()
        //        constructCameraImageLabelView()
    }
    
    func constructNameLabel() -> Void{
        let leftPadding:CGFloat = 12.0
        let topPadding:CGFloat = 10.0
        let frame:CGRect = CGRect(x: leftPadding,
                                  y: topPadding,
                                  width: floor(self.topInformationView.frame.width),
                                  height: self.topInformationView.frame.height - topPadding)
        self.nameLabel = UILabel(frame: frame)
        self.nameLabel.baselineAdjustment = .alignCenters
        self.nameLabel.text = "\(product.productName)"
        self.nameLabel.textAlignment = .center
        self.nameLabel.font = UIFont(name: "Proxima-Nova-Regular.otf", size: 18)
        self.topInformationView .addSubview(self.nameLabel)
    }
    
    func constructBrandLabel() -> Void{
        let leftPadding:CGFloat = 12.0
        let topPadding:CGFloat = 8.0
        let frame:CGRect = CGRect(x: leftPadding,
                                  y: topPadding,
                                  width: floor(self.informationView.frame.width),
                                  height: self.informationView.frame.height - topPadding)
        self.brandLabel = UILabel(frame:frame)
        self.brandLabel.baselineAdjustment = .alignCenters
        self.brandLabel.text = "\(product.productBrand)"
        self.brandLabel.textAlignment = .center
        self.informationView .addSubview(self.brandLabel)
    }
    
    func constructPriceLabel() -> Void {
        let rightPadding: CGFloat = 12.0
        let topPadding: CGFloat = 38.0
        let frame: CGRect = CGRect(x: rightPadding, y: topPadding, width: floor(self.informationView.frame.width), height: self.informationView.frame.height - topPadding)
        let priceOfProduct = product.productPrice
        self.priceLabel = UILabel(frame: frame)
        self.priceLabel.text = String(format: "€ %.2f", priceOfProduct)
        self.priceLabel.textAlignment = .center
        self.informationView .addSubview(self.priceLabel)
        
    }
    
    //    func constructInfoLabelView() -> Void{
    //        var rightPadding:CGFloat = 10.0
    //        let image: UIImage = UIImage(named: "info")!
    ////        self.infoLabelView = image
    //        self.infoLabelView = buildImageLabelViewLeftOf(self.topInformationView.bounds.width, image:image, text: "")
    //        self.topInformationView .addSubview(self.infoLabelView)
    //    }
    
    
    func buildImageLabelViewLeftOf(_ x:CGFloat, image:UIImage, text:String) -> ImagelabelView {
        let frame: CGRect = CGRect(x: x-ChooseProductViewImageLabelWidth, y: 0,
                                   width: ChooseProductViewImageLabelWidth,
                                   height: self.informationView.bounds.height)
        let view: ImagelabelView = ImagelabelView(frame: frame, image: image, text: text)
        view.autoresizingMask = UIViewAutoresizing.flexibleLeftMargin
        return view
    }
}

