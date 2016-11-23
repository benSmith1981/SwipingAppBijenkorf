//
//  ImageLabelView.swift
//  SwipingApp
//
//  Created by Thijs Lucassen on 23-11-16.
//
//

import UIKit
import MDCSwipeToChoose

class ImagelabelView: UIView{
    var imageView: UIImageView!
    var label: UILabel!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        imageView = UIImageView()
        label = UILabel()
    }
    
    init(frame: CGRect, image: UIImage, text: String) {
        
        super.init(frame: frame)
        constructImageView(image: image)
        constructLabel(text: text)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func constructLikedViewLabel(text: String) -> Void {
        
    }
    
    func constructImageView(image:UIImage) -> Void{
        
        let topPadding: CGFloat = 30.0
        
        let frameX = CGRect(x: floor((self.bounds.width - image.size.width)/2), y: topPadding, width: image.size.width, height: image.size.height)
        
        imageView = UIImageView(frame: frameX)
        imageView.image = image
        addSubview(self.imageView)
    }
    
    func constructLabel(text:String) -> Void{
        let height:CGFloat = 18.0
        let frame2 = CGRect(x: 0, y: self.imageView.frame.maxY, width: self.bounds.width, height: height);
        self.label = UILabel(frame: frame2)
        label.text = text
        addSubview(label)
        
    }
}

