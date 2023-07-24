//
//  UIViewExtension.swift
//  ITSoftin
//
//  Created by Paulo Faria on 3/4/15.
//  Copyright (c) 2015 Snowman Labs. All rights reserved.
//

import UIKit

extension UIView {

    @IBInspectable var cornerRadius: CGFloat {

        get {

            return layer.cornerRadius

        }

        set {

            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0

        }
        
    }
    
    
    @IBInspectable var borderWidth: CGFloat {
        
        get {
            
            return layer.borderWidth
            
        }
        
        set {
            
            layer.borderWidth = newValue
            
        }
        
    }
    
    @IBInspectable var borderColor: UIColor {
        
        get {
            
            return UIColor(cgColor: layer.borderColor!)
            
        }
        
        set {
            
            layer.borderColor = newValue.cgColor
            
        }
        
    }

}

extension UIView {

    func startBlinking() {
        
        self.alpha = 1
        UIView.animate(withDuration: 1, delay: 0.0, options: .repeat, animations: {
            
            self.alpha = 0
            
            }, completion: nil)
        
    }
    
    func stopBlinking() {
        
         layer.removeAllAnimations()
        
    }
    
    func setupViewFromNibWithName(_ nibName: String) {

        let view = loadViewFromNib(nibName)
        addSubview(view)
        fitSubview(view)

    }

    func loadViewFromNib(_ nibName: String) -> UIView {

        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView

        return view
        
    }

    func fitSubview(_ subview: UIView) {

        fitSubviewHorizontally(subview)
        fitSubviewVertically(subview)

    }

    func fitSubviewHorizontally(_ subview: UIView) {

        subview.translatesAutoresizingMaskIntoConstraints = false

        let horizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|[subview]|",
                                                                  options: NSLayoutConstraint.FormatOptions(),
            metrics: nil,
            views: ["subview": subview]
        )

        addConstraints(horizontalConstraint)

    }

    func fitSubviewVertically(_ subview: UIView) {

        subview.translatesAutoresizingMaskIntoConstraints = false

        let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|[subview]|",
                                                                options: NSLayoutConstraint.FormatOptions(),
            metrics: nil,
            views: ["subview": subview]
        )

        addConstraints(verticalConstraint)
        
    }
    
    func convertViewToImage() -> UIImage {
        
        UIGraphicsBeginImageContext(self.bounds.size)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    
        return image!
    }
    
    func toImage() -> UIImage {
        
        var image: UIImage
        UIGraphicsBeginImageContextWithOptions(self.frame.size, true, 2.0)
        let context = UIGraphicsGetCurrentContext()
        self.layer.render(in: context!);
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
        
    }
    
    func imageWithView() -> UIImage {

        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
        
        
    }
}
