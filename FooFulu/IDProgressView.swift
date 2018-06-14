//
//  IDProgressHUD.swift
//  IDProgressHUD
//
//  Created by Mithlesh on 17/04/17.
//  Copyright © 2017 Mithlesh. All rights reserved.
//

import UIKit

class IDProgressView: UIView {

    var view:UIView!

    @IBOutlet weak var hudView: UIView!
    @IBOutlet weak var activityIndicator: InstagramActivityIndicator!
    
    //MARK:- Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
    }
    
    //MARK:- SHOW HUD
    func show(){
    
        DispatchQueue.main.async {
            let allWindows = UIApplication.shared.windows.reversed()
            for window in allWindows {
                if (window.windowLevel == UIWindowLevelNormal) {
                    window.addSubview(self.view)
                    self.view.frame = window.bounds
                    break
                }
            }
            
            //BACKGROUND ANIMATION
            if IDProgressHUD.shared.enableBackground {
                self.view.backgroundColor = self.view.backgroundColor?.withAlphaComponent(0)
                UIView.animate(withDuration: 0.30, delay: 0, options: .curveLinear, animations: {
                    self.view.backgroundColor = self.view.backgroundColor?.withAlphaComponent(IDProgressHUD.shared.backgroundColorAlpha)
                    }, completion: nil)
            }
            // HUD ANIMATION
             self.activityIndicator.startAnimating()
            switch IDProgressHUD.shared.showHudAnimation {
                
            case .growIn :
                self.growIn()
                break
            case .shrinkIn :
                self.shrinkIn()
                break
            case .bounceIn :
                self.bounceIn()
                break
            case .zoomInOut :
                self.zoomInZoomOut()
                break
            case .slideFromTop :
                self.slideFromTop()
                break
            case .bounceFromTop :
                self.bounceFromTop()
                break
            default :
                break

            }
        }
    }
    
    //MARK:- HIDE HUD
    func hide() {
        DispatchQueue.main.async {
            
            //BACKGROUND ANIMATION
            if IDProgressHUD.shared.enableBackground {
                
                self.view.backgroundColor = self.view.backgroundColor?.withAlphaComponent(IDProgressHUD.shared.backgroundColorAlpha)
                UIView.animate(withDuration: 0.30, delay: 0, options: .curveLinear, animations: {
                    self.view.backgroundColor = self.view.backgroundColor?.withAlphaComponent(0)
                    }, completion: nil)
            }

            switch IDProgressHUD.shared.dismissHudAnimation {
                
            case .growOut :
                self.growOut()
                break
            case .shrinkOut :
                self.shrinkOut()
                break
            case .fadeOut :
                self.fadeOut()
                break
            case .bounceOut :
                self.bounceOut()
                break
            case .slideToTop :
                self.slideToTop()
                break
            case .slideToBottom :
                self.slideToBottom()
                break
            case .bounceToTop :
                self.bounceToTop()
                break
            case .bounceToBottom :
                self.bounceToBottom()
                break

            default :
                self.view.removeFromSuperview()
                self.activityIndicator.stopAnimating()
                break
            }

        }
    }

}

//MARK:- Private Methods
fileprivate extension IDProgressView {

    // Loading Xib
    func xibSetup() {
        
        view = loadViewFromNib()
        view.frame = bounds
        self.addSubview(view)
        
        appeareance()
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: IDProgressView.self)
        let nib = UINib(nibName: "IDProgressView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    /// Customization HUD appeareance
    func appeareance(){
    
        self.view.backgroundColor =  IDProgressHUD.shared.enableBackground == true ? IDProgressHUD.shared.backgroundColor.withAlphaComponent(IDProgressHUD.shared.backgroundColorAlpha) : UIColor.clear
        
        self.activityIndicator.strokeColor  = IDProgressHUD.shared.indicatorColor
        self.activityIndicator.numSegments  = IDProgressHUD.shared.indicatorNumSegment
        self.activityIndicator.lineWidth    = IDProgressHUD.shared.indicatorLineWidth

    }
    
}

//MARK:- Orientation
//Window will not change Orientation when ACProgressHUD is being Shown.
extension UINavigationController {
    
    open override var shouldAutorotate: Bool {
        
        if IDProgressHUD.shared.isBeingShown {
            return false
        }else{
            return true
        }
    }
}
