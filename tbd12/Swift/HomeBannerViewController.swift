//
//  HomeBannerViewController.swift
//  tbd12
//
//  Created by Muneeb ur Rehman on 20/02/2022.
//

import UIKit
import GoogleMobileAds
import LNPopupController


@objc class HomeBannerViewController: UIViewController {
    
    var aView : UIView!
    var bannerDisplayMachine :  GiveMeABannerDisplayAd!
    var bannerView : GADBannerView!
    var adHeight : CGFloat!
    
  
    
    weak var tabBarOBJC : UITabBarController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        // if (tabbarController.popupPresentationState != LNPopupPresentationStateTransitioning) {
        
        
    }
    
    
    @objc func addNotifiers () {
        
        
        NotificationCenter.default.addObserver( self , selector: #selector(addHomeAd) , name: NSNotification.Name(rawValue: "showHomeAdd" ) , object: nil )
        
        NotificationCenter.default.addObserver( self , selector: #selector(removeHomeAd) , name: NSNotification.Name(rawValue: "hideHomeAdd" ) , object: nil )
        
        
    }

    
    
    @objc func addHomeAd () {
        
        
        let screenRect = UIScreen.main.bounds//[[UIScreen mainScreen] bounds];
        let screenWidth = screenRect.size.width;
        let screenHeight = screenRect.size.height;
        
        
        
        if (self.tabBarOBJC?.popupPresentationState == LNPopupPresentationState.closed ) {
 
            let tabbarheight = tabBarOBJC?.tabBar.frame.size.height ?? 50
            
            if ( UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad ) {
                
                aView = UIView(frame: CGRect(x: 0 ,
                                             y: screenHeight - 90 - tabbarheight - 40,
                                             width: screenWidth ,
                                             height: 90 ))
                
            }else {
                
                aView = UIView(frame: CGRect(x: 0 ,
                                             y: screenHeight - adHeight - tabbarheight - 40,
                                             width: screenWidth ,
                                             height: 50 ))
                
            }
            
            
            
            
            
        }else {
            
            let tabbarheight = tabBarOBJC?.tabBar.frame.size.height ?? 50
            
            if ( UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad ) {
                
                aView = UIView(frame: CGRect(x: 0 ,
                                             y: screenHeight - 90 - tabbarheight  ,
                                             width: screenWidth ,
                                             height: 90 ))
                
                
            }else {
                
                aView = UIView(frame: CGRect(x: 0 ,
                                             y: screenHeight - adHeight - tabbarheight ,
                                             width: screenWidth ,
                                             height: 50 ))
                
            }

            

        }

        aView.backgroundColor = UIColor.clear
//        bannerDisplayMachine.loadAd(bannerView: bannerView)
        aView.addSubview(bannerView)
        
        UIApplication.shared.keyWindow?.addSubview(aView)
        
        
    }
    
    
    @objc func removeHomeAd () {
        
        if aView != nil {
            aView.removeFromSuperview()
        }
        
    }
    
    
    @objc func runrun ( tabBar : UITabBarController , tabBarHeight height : CGFloat ) {
        
        bannerDisplayMachine = GiveMeABannerDisplayAd()
        
        bannerView = bannerDisplayMachine.gievMeABannerView(
            withAdUnitId: "/21792359936/Mobile_Leaderboard_App_320x50" ,
            andAdSize: bannerDisplayMachine.sizePortraitBanner ,
            rootVC: self ,
            delegate: bannerDisplayMachine
        )
        
        adHeight = height
        
        tabBarOBJC = tabBar
        

//        bannerDisplayMachine.loadAd(bannerView: bannerView)
//        aView.addSubview(bannerView)
//
//        UIApplication.shared.keyWindow?.addSubview(aView)

        
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
