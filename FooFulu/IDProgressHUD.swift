//
//  IDProgressHUD.swift
//  IDProgressHUD
//
//  Created by Mithlesh on 17/04/17.
//  Copyright © 2017 Mithlesh. All rights reserved.
//

import UIKit

open class IDProgressHUD : NSObject {

    /// ACProgressView reference
    var idProgressView : IDProgressView!
    
    /// Set the Hud **Shadow Color**.
    open var shadowColor : UIColor = UIColor.black

    /// Set the **Shadow Radius** of Hud View.
    open var shadowRadius : CGFloat = 10.0
    
    /// Set the **Corner Radius** of Hud View.
    open var cornerRadius : CGFloat = 5

    /// Set the **Indicator Color** of Hud View.
    open var indicatorColor : UIColor = UIColor.white
    
    /// Set the **Indicator Segment Number ** of Hud View.
    open var indicatorNumSegment : Int = 20

    /// Set the **Indicator Line Width** of Hud View.
    open var indicatorLineWidth  : CGFloat = 7

    /// Set the **Background Color** of Hud View.
    open var hudBackgroundColor : UIColor = UIColor.init(colorLiteralRed: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
    
    /// Show Dim **Background** ?
    open var enableBackground : Bool = true

    /// Set Dim **Background Color**.
    open var backgroundColor : UIColor = UIColor.black

    /// Set Dim Background Color **Opacity**.
    open var backgroundColorAlpha : CGFloat = 0.8

    /// Animation when showing HUD.
    open var showHudAnimation : IDHudShowAnimation = .growIn
    
    /// Change Animation when Dismiss HUD.
    open var dismissHudAnimation : IDHudDismissAnimation = .growOut
    
    static open let shared : IDProgressHUD = IDProgressHUD()
    
    private(set) public var isBeingShown : Bool  = false
    
    /**
     
     - Configure HUD style through out the app.
     
     - Parameter text: Set the Text in Progress label.
     - Parameter progressTextColor: Set the Text Color in Progress label.
     - Parameter hudBackgroundColor: Change the **Background Color** of Hud View.
     - Parameter shadowColor: Set the Hud **Shadow Color**.
     - Parameter shadowRadius: Set the **Shadow Radius** of Hud View.
     - Parameter cornerRadius: Set the **Corner Radius** of Hud View.
     - Parameter indicatorColor: Set the **Indicator Color** of Hud View.
     - Parameter enableBackground: Show Dim **Background**?
     - Parameter backgroundColor: Set Dim **Background Color**.
     - Parameter backgroundColorAlpha: Set Dim Background Color **Opacity**.
     - Parameter enableBlurBackground: Show **Blur Background**?
     - Parameter showHudAnimation: Animation when showing HUD.
     - Parameter dismissHudAnimation: Change Animation when Dismiss HUD.
     
     */
    //MARK:- Show HUD
    /// Display Progres HUD.
    open func showHUD() -> Void {
        if isBeingShown {
            return
        }
        self.isBeingShown = true
        idProgressView = IDProgressView()
        idProgressView.show()
    }
    
    //MARK:- Hide HUD
    /// Dismiss Progress HUD.
    open func hideHUD() -> Void {
        if !self.isBeingShown {
            return
        }
        self.isBeingShown = false
        idProgressView.hide()
    }
}
