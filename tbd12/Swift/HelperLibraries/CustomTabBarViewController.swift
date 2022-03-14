//
//  CustomTabBarViewController.swift
//  Bsongs_v1_Muneeb
//
//  Created by Suunnoo Team on 5/1/19.
//  Copyright © 2019 Syed Muneeb Ur Rehman. All rights reserved.
//

import UIKit


@objc protocol CustomTabBarControllerDelegate : NSObjectProtocol {
    
    @available(iOS 6.0 , *)
    @objc optional func optionalMethod()
    
    @available(iOS 6.0 , *)
    func isTabBarTranslucent () -> Bool
    
    @available(iOS 6.0 , *)
    func tabBarBackgroundColor () -> UIColor
    
    @available(iOS 6.0 , *)
    func tabBarFroegroundColor () -> UIColor
    
    @available(iOS 6.0 , *)
    func tabBarItemsImageInsets () -> UIEdgeInsets
    
    @available(iOS 6.0 , *)
    func tabBarViewControllers () -> [UIViewController]

}

class CustomTabBarController : UITabBarController {

    weak open var customDelegate : CustomTabBarControllerDelegate?
   
 
    override func viewWillAppear(_ animated: Bool) {
        
        setupIsTabBarTranslucent()
        setupTabBarBackgroundColor()
        setupTabBarForegroundColor()
        setupTabBarImageInsets()
        setupTabBarViewControllers()
        
    }
    
    
}

extension CustomTabBarController {
    
    // delegate methods utilizations
    
    func setupIsTabBarTranslucent () {
        
        if let isTabBarTranslucent = customDelegate?.isTabBarTranslucent() {
            
            tabBar.isTranslucent = isTabBarTranslucent
            
        }else{
            
            tabBar.isTranslucent = false
        }
        
    }
    
    func setupTabBarBackgroundColor () {
        
        if let tabBarBackgroundColor = customDelegate?.tabBarBackgroundColor() {
            
            tabBar.barTintColor = tabBarBackgroundColor
            
        }else {
            
            tabBar.barTintColor = .red
            
        }
        
        
        
        
    }
    
    func setupTabBarForegroundColor () {
        
        if let tabBarForegroundColor = customDelegate?.tabBarFroegroundColor() {
            
            tabBar.tintColor = tabBarForegroundColor
            
        }else {
            
            tabBar.tintColor = .green
            
        }
        
        
    }
    
    func setupTabBarImageInsets () {
        
        if let tabBarItemsImageInsets = customDelegate?.tabBarItemsImageInsets() {
            
            guard let tabBarItems = tabBar.items else { return }
            
            for tabItem in tabBarItems {
                tabItem.imageInsets = tabBarItemsImageInsets
            }
            
        }else {
            
            guard let tabBarItems = tabBar.items else { return }
            
            for tabItem in tabBarItems {
                tabItem.imageInsets = UIEdgeInsets(top: 0, left: 2, bottom: -2, right: -2)
            }
            
        }
        
    }
    
    func setupTabBarViewControllers () {
        
        if let tabBarViewControllers = customDelegate?.tabBarViewControllers() {
            
            viewControllers = tabBarViewControllers
            
        }else {
            
            let homeViewController = tabBarUIViewController(
                havingViewController: UIViewController() ,
                withTabBarTitle: "Home" ,
                tabBarImage: (UIImage(named: "home")?.image(withTintColor: .white))! ,
                AndTabBarSelectedImage: (UIImage(named: "home")?.image(withTintColor: .green))!
            )
            
            let artistViewController = tabBarUIViewControllerAsANavBar(
                havingViewController: UIViewController(),
                withTabBarTitle: "Artists",
                tabBarImage: (UIImage(named: "artist")?.image(withTintColor: .white))! ,
                AndTabBarSelectedImage: (UIImage(named: "artist")?.image(withTintColor: .green))!
            )
      
            viewControllers = [
                homeViewController ,
                artistViewController ,
            ]

            
        }
        
        
        
    }
    
    
    
    
}


extension CustomTabBarController {
    
    // utility func
    
    public func tabBarUIViewController ( havingViewController viewController : UIViewController  ,
                                       withTabBarTitle title : String ,
                                       tabBarImage image : UIImage ,
                                       AndTabBarSelectedImage selectedImage : UIImage ) -> UIViewController {
        
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        viewController.tabBarItem.selectedImage = selectedImage.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
      
        
        return viewController
        
        
    }
    
    
    public func tabBarUIViewControllerAsANavBar ( havingViewController viewController : UIViewController  ,
                                                withTabBarTitle title : String ,
                                                tabBarImage image : UIImage ,
                                                AndTabBarSelectedImage selectedImage : UIImage ) -> UINavigationController {
        
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        viewController.tabBarItem.selectedImage = selectedImage.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        let navBarController = UINavigationController(rootViewController: viewController)
        
        return navBarController
        
        
    }
    
   
    
    
    
}





