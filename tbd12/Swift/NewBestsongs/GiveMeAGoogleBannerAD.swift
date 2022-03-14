//
//  GiveMeAGoogleBannerAD.swift
//  Bestsongs.pk
//
//  Created by IMac on 27/02/2019.
//  Copyright © 2019 Bestsongs. All rights reserved.
//



import UIKit
import GoogleMobileAds


@objcMembers class GiveMeABannerDisplayAd : NSObject , GADBannerViewDelegate {
    
    
    private struct MessageBox {
        static let AdUnitError = " Message : GiveMeABannerDisplayAd : Ad unit Id Is not placed before setting up banner view"
        static let AdViewDidReceiveError = " Message : GiveMeABannerDisplayAd : AdView Did Receive Error"
        static let AdViewDidReceiveAd = " Message : GiveMeABannerDisplayAd : AdView Did Successfuly Receive Ad"
        static let AdViewWillPresentScreen = " Message : GiveMeABannerDisplayAd : AdView is Presenting its Screen "
        static let AdViewWillDismissScreen = " Message : GiveMeABannerDisplayAd : AdView will dismiss its screen"
        static let AdViewDidDismissScreen = " Message : GiveMeABannerDisplayAd : AdView did Dismiss Its Screen "
        static let AdViewWillLeaveApplication = " Message : GiveMeABannerDisplayAd : AdView Will leave application to display its Ads"
    }
    
    
    
    
    
    
    
    public let sizePortraitBanner = kGADAdSizeSmartBannerPortrait
    public let sizeLandscapeBanner = kGADAdSizeSmartBannerLandscape
    
    
    public func gievMeABannerView (withAdUnitId adUnitId : String , andAdSize adSize : GADAdSize , rootVC : UIViewController ,  delegate : GADBannerViewDelegate ) -> GADBannerView {
        
        let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        
        bannerView.delegate = delegate
        bannerView.rootViewController = rootVC
        
        
        bannerView.adUnitID = "ca-app-pub-5377163247466568/5772542955" //adUnitId
        //bannerView.delegate = self
        
        
        bannerView.clipsToBounds = true
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        
        print ("Muneeb 11 ")
        return bannerView
        
    }
    
    
    public func loadAd (bannerView : GADBannerView) {
        
        let adRequest = GADRequest()
        adRequest.testDevices = [ "b69bd3c76f13059c77473030b45a9c66" ]
        bannerView.load(adRequest)
        
        
    }
    
    
    
    // MARK: Delegates For AdBannerView
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        
        print("\(MessageBox.AdViewDidReceiveAd)")
        
        
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("\(MessageBox.AdViewDidReceiveError)  Error: \(error.code) " )
        
        if error.code != 1 {
            
            let adRequest = GADRequest()
            bannerView.load(adRequest)
            loadAd (bannerView : bannerView)
            
        }
        
        

        
    }
    
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("\(MessageBox.AdViewWillPresentScreen)")
        
        
        
    }
    
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("\(MessageBox.AdViewWillDismissScreen)")
        
        
    }
    
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("\(MessageBox.AdViewDidDismissScreen)")
        
        
    }
    
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("\(MessageBox.AdViewWillLeaveApplication)")
        
        
    }
    
    
    
    
}
