//
//  GiveMeACustomNativeAd.swift
//  Bestsongs.pk
//
//  Created by Syed Muneeb Ur Rehman on 17/06/2019.
//  Copyright © 2019 Bestsongs. All rights reserved.
//


//
//  GiveMeACustomNativeAd.swift
//  AdsProject
//
//  Created by Syed Muneeb Ur Rehman on 25/05/2019.
//  Copyright © 2019 Syed Muneeb Ur Rehman. All rights reserved.
//

import UIKit
import GoogleMobileAds

@objc class GiveMeACustomNativeAd : NSObject   {
    
    var adUnitId : String!
    var adTemplateId : String!
    var key : String!
    var adImage : UIImage!
    
    
  @objc var closureToBeExecutedWhenImageIsFetched : ( (UIImage) -> () )?
    
    
    var adsLoader : GADAdLoader!
    var nativeCustomTemplateAd : GADNativeCustomTemplateAd!
    
    
  @objc func setupCustomNativeAd (viewController : UIViewController ,
                              havingAdUnitId adUnitId : String ,
                              adTemplateId : String ,
                              adKey : String
        ) {
        
        key = adKey
        self.adTemplateId = adTemplateId
        adsLoader = GADAdLoader(
            adUnitID: adUnitId ,
            rootViewController: viewController ,
            adTypes: [GADAdLoaderAdType.nativeCustomTemplate] ,
            options: nil
        )
        adsLoader.delegate = self
        adsLoader.load( GADRequest() )
        
    }
    
    
    
    
}

extension GiveMeACustomNativeAd : GADNativeCustomTemplateAdLoaderDelegate {
    
    func nativeCustomTemplateIDs(for adLoader: GADAdLoader) -> [String] {
        return [adTemplateId]
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeCustomTemplateAd: GADNativeCustomTemplateAd) {
        
        self.nativeCustomTemplateAd = nativeCustomTemplateAd
        
        // """""""" FOr IMage :
        
        let ads = self.nativeCustomTemplateAd.image(forKey: key )
        adImage = ads?.image
        
        if let closure = closureToBeExecutedWhenImageIsFetched {
            closure(adImage)
        }
        
        
        print("keys",self.nativeCustomTemplateAd.availableAssetKeys)
        
        //        imageView.image = ads?.image
        //        imageView.backgroundColor = .red
        //        imageView.contentMode = .scaleAspectFill
        
        
        
        // """"""""" For Video :
        //   let controller = self.nativeCustomTemplateAd.videoController
        
        //        let ads = self.nativeCustomTemplateAd.mediaView
        //
        //        mediaView.addSubview(ads!)
        //        ads?.frame = CGRect(x: 0,
        //                            y: 0,
        //                            width: mediaView.frame.width ,
        //                            height: mediaView.frame.height
        //        )
        //
        //        print("keys",self.nativeCustomTemplateAd.availableAssetKeys)
        //
        //
        //
        //
        //        controller.play()
        
        
        
        
        
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        
    }
    
    
    
    
    
}
