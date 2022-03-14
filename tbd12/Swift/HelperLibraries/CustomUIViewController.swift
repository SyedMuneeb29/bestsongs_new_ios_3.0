//
//  CustomUIViewController.swift
//  Bsongs_v1_Muneeb
//
//  Created by Syed Muneeb Ur Rehman on 02/05/2019.
//  Copyright © 2019 Syed Muneeb Ur Rehman. All rights reserved.
//

import UIKit



protocol CustomUIViewControllerNavigationDelegate : NSObjectProtocol {
    
    @available (iOS 6.0 , *)
    func isNavigationBarTranslucent () -> Bool
    
    @available (iOS 6.0 , *)
    func navigationBarBackgroundColor () -> UIColor
    
    @available (iOS 6.0 , *)
    func setupNavigationItemTitleView (titleView : UIView)
    
    @available (iOS 6.0 , *)
    func navigationItemLeftBarButtonItems () -> [UIBarButtonItem]
    
    @available (iOS 6.0 , *)
    func navigationItemRightBarButtonItems () -> [UIBarButtonItem]
    
    
    
}


class CustomUIViewController : UIViewController {
    
    weak open var customNavigationDelegate : CustomUIViewControllerNavigationDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        
        setupNavigationBarIsTranslucent()
        setupNavigationBarBackgroundColor()
        setupItemTitleView()
        setupLeftBarButtonItems()
        setupRightBarButtonItems()
        
    }
    
}

extension CustomUIViewController {
    
    // navigation delegate methods utilization
    
    func setupNavigationBarIsTranslucent () {
        
        if let navigationBarIsTranslucent = customNavigationDelegate?.isNavigationBarTranslucent() {
            
            navigationController?.navigationBar.isTranslucent = navigationBarIsTranslucent
            
        }
        
    }
    
    func setupNavigationBarBackgroundColor () {
        
        if let navigationBarBackgroundColor = customNavigationDelegate?.navigationBarBackgroundColor() {
            
            navigationController?.navigationBar.barTintColor = navigationBarBackgroundColor
            
        }
        
    }
    
    func setupItemTitleView () {
        
        
        let navBarTitleView = UIView(frame: CGRect(x: 0, y: 0, width: self.navigationController?.navigationBar.bounds.size.width ?? 150 , height: 30))
        
        navigationItem.titleView = navBarTitleView
        
        customNavigationDelegate?.setupNavigationItemTitleView( titleView: navBarTitleView )
        
    }
    
    func setupLeftBarButtonItems () {
        
        if let navigationItemLeftBarButtonItems = customNavigationDelegate?.navigationItemLeftBarButtonItems() {
            
            navigationItem.leftBarButtonItems = navigationItemLeftBarButtonItems
            
        }
        
    }
    
    func setupRightBarButtonItems () {
        
        if let navigationItemRightBarButtonItems = customNavigationDelegate?.navigationItemRightBarButtonItems() {
            
            navigationItem.rightBarButtonItems = navigationItemRightBarButtonItems
            
        }
        
    }
    
}


extension CustomUIViewController {
    
    // utility methods
    
    
    func uiBarButtonItem (havingItemImage image : UIImage ,
                          widthOfItem width : CGFloat ,
                          heightOfItem height: CGFloat ,
                          target : Any? ,
                          action : Selector ,
                          uiControlEvents : UIControl.Event
        
        ) -> UIBarButtonItem {
    
        let uiProvider = GiveMeAUIProvider()
        
        let button = uiProvider.customUIButton(withSetting:
            GiveMeAUIProvider.SettingsForUIButton(
                buttonType: UIButton.ButtonType.system,
                setTitle: nil,
                setTitleColor: nil,
                setTitleShadowColor: nil,
                setImage: nil,
                setBackgroundImage: (image: image , state: UIControl.State.normal),
                setAttributedTitle: nil,
                tintColor: nil,
                showsTouchWhenHighlighted: false,
                adjustImageWhenHighlighted: false,
                adjustImageWhenDisabled: false,
                imageEdgeInsets: nil,
                reversesTitleShadowWhenHighlighted: false,
                titleEdgeInsets: nil,
                contentEdgeInsets: nil
            )
        )
        
        button.addTarget(target, action: action, for: uiControlEvents)
        
        let uiBarButtonItem = UIBarButtonItem(customView: button)
        uiBarButtonItem.customView?.widthAnchor.constraint(equalToConstant: width).isActive = true
        uiBarButtonItem.customView?.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        return uiBarButtonItem
        
    }
    
    
    func customPush(viewController : UIViewController ,
                    modalTransitionStyle :  UIModalTransitionStyle? ,
                    animated : Bool ,
                    completion : ( ()-> Void )? ){
        
        if let modalTransitionStyle = modalTransitionStyle {
            
            viewController.modalTransitionStyle = modalTransitionStyle
            present(viewController, animated: animated, completion: completion)
        
        }
        else {
    
            if let navigationController = navigationController {
                
                navigationController.pushViewController(viewController, animated: animated)
                
            }
        
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
