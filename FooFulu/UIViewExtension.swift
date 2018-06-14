//
//  UIViewControllerExtension.swift
//  Tokr
//
//  Created by parvinderjit on 06/09/16.
//  Copyright © 2016 Zapbuild. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get{
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set{
            self.layer.borderColor = newValue.cgColor
        }
        
    }
    @IBInspectable var borderWidth: CGFloat {
        get{
            return layer.borderWidth
        }
        set{
            self.layer.borderWidth = newValue
            
        }
    }
    @IBInspectable var shadowColor: UIColor? {
        get{
            return UIColor(cgColor: layer.shadowColor!)
        }
        set{
            self.layer.shadowColor = newValue?.cgColor
            
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get{
            return layer.shadowOffset
        }
        set{
            self.layer.shadowOffset = newValue
            
        }
    }
    @IBInspectable var shadowRadius: CGFloat {
        get{
            return layer.shadowRadius
        }
        set{
            self.clipsToBounds = false
            self.layer.shadowRadius = newValue
            
        }
    }
    @IBInspectable var shadowOpacity: Float {
        get{
            return layer.shadowOpacity
        }
        set{
            self.layer.shadowOpacity = newValue
            
        }
    }
    
//    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
//        let border = CALayer()
//        border.backgroundColor = color.cgColor
//        border.frame = CommonUtilities.sharedInstance.CGRectMake(0,self.frame.size.height - width, self.frame.size.width, width)
//
//
//        self.layer.addSublayer(border)
//    }
//    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
//        let border = CALayer()
//        border.backgroundColor = color.cgColor
//        border.frame = CommonUtilities.sharedInstance.CGRectMake(0,0, self.frame.size.width, width)
//        self.layer.addSublayer(border)
//    }
    
//    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
//        let border = CALayer()
//        border.backgroundColor = color.CGColor
//        border.frame = CGRectMake(self.frame.size.width - width, 0, width, self.frame.size.height)
//        self.layer.addSublayer(border)
//    }
    
//    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
//        let border = CALayer()
//        border.backgroundColor = color.CGColor
//        border.frame = CGRectMake(0, self.frame.size.height - width, self.frame.size.width, width)
//        self.layer.addSublayer(border)
//    }
//    
//    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
//        let border = CALayer()
//        border.backgroundColor = color.CGColor
//        border.frame = CGRectMake(0, 0, width, self.frame.size.height)
//        self.layer.addSublayer(border)
//    }
	
	
}

extension UIViewController {
	var weakSelf:UIViewController {
		get {
			weak var _self = self
			return _self!
		}
	}
	@IBAction func dismissViewController(sender:AnyObject){
		self.dismiss(animated: true, completion: nil)
	}
}

extension UILabel {
	var substituteFontName : String {
		get { return self.font.fontName }
		set { self.font = UIFont(name: newValue, size: self.font.pointSize) }
	}
}
