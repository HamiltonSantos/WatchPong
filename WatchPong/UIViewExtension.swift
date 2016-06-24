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
            
            return UIColor(CGColor: layer.borderColor!)
            
        }
        
        set {
            
            layer.borderColor = newValue.CGColor
            
        }
        
    }

}

extension UIView {

    func startBlinking() {
        
        self.alpha = 1
        UIView.animateWithDuration(1, delay: 0.0, options: .Repeat, animations: {
            
            self.alpha = 0
            
            }, completion: nil)
        
    }
    
    func stopBlinking() {
        
         layer.removeAllAnimations()
        
    }
    
    func setupViewFromNibWithName(nibName: String) {

        let view = loadViewFromNib(nibName)
        addSubview(view)
        fitSubview(view)

    }

    func loadViewFromNib(nibName: String) -> UIView {

        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil).first as! UIView

        return view
        
    }

    func fitSubview(subview: UIView) {

        fitSubviewHorizontally(subview)
        fitSubviewVertically(subview)

    }

    func fitSubviewHorizontally(subview: UIView) {

        subview.translatesAutoresizingMaskIntoConstraints = false

        var horizontalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|[subview]|",
            options: .DirectionLeadingToTrailing,
            metrics: nil,
            views: ["subview": subview]
        )

        addConstraints(horizontalConstraint)

    }

    func fitSubviewVertically(subview: UIView) {

        subview.translatesAutoresizingMaskIntoConstraints = false

        var verticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:|[subview]|",
            options: .DirectionLeadingToTrailing,
            metrics: nil,
            views: ["subview": subview]
        )

        addConstraints(verticalConstraint)
        
    }
    
    func convertViewToImage() -> UIImage {
        
        UIGraphicsBeginImageContext(self.bounds.size)
        self.drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    
        return image
    }
    
    func toImage() -> UIImage {
        
        var image: UIImage
        UIGraphicsBeginImageContextWithOptions(self.frame.size, true, 2.0)
        var context = UIGraphicsGetCurrentContext()
        self.layer.renderInContext(context!);
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
        
    }
    
    func imageWithView() -> UIImage {

        UIGraphicsBeginImageContextWithOptions(bounds.size, opaque, 0.0)
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
        
        
    }
    
    func fadeIn(duration: NSTimeInterval = 0.5, completion: (Void -> Void)? = .None) {
        
        UIView.animateWithDuration(duration, animations: {
            
            self.alpha = 1
            
            }, completion: { _ in
                
                completion?()
                
            }
        )
        
    }
    
    func fadeOut(duration: NSTimeInterval = 0.5, completion: (Void -> Void)? = .None) {
        
        UIView.animateWithDuration(duration, animations: {
            
            self.alpha = 0
            
            }, completion: { _ in
                
                completion?()
                
            }
        )
        
    }
    

}