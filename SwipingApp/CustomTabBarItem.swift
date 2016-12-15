//
//  CustomTabBarItem.swift
//  SwipingApp
//
//  Created by Frank Sanchez on 12/10/16.
//
//
import Foundation
import UIKit

class CustomTabBarItem: UIView {
    
    var iconView: UIImageView!
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(_ item: UITabBarItem) {
        
        item.badgeValue = "2"

        
        guard let image = item.image else {
            fatalError("add images to tabbar items")
        }
        
        
        // create imageView centered within a container
        iconView = UIImageView(frame: CGRect(x: (self.frame.width-image.size.width)/2, y: (self.frame.height-image.size
            .height)/2, width: self.frame.width, height: self.frame.height))
        
        iconView.image = image
        iconView.sizeToFit()
        iconView.tintColor = UIColor.lightGray
        self.addSubview(iconView)
    }
    
}
