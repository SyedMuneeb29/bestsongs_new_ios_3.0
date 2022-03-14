//
//  GiveMeAnIMASDKVideoAdPlayer.swift
//  Bestsongs.pk
//
//  Created by IMac on 27/02/2019.
//  Copyright © 2019 Bestsongs. All rights reserved.
//


import UIKit
import AVFoundation
import GoogleInteractiveMediaAds



@objcMembers class GiveMeAnIMASDKVideoAdPlayer : UIView , IMAAdsLoaderDelegate , IMAAdsManagerDelegate {
    
    
    
    public var closureToBeExecutedWhenAdHasBeenCompleted : (() -> ())?
    public var closureWhenAdIsPaused : (() -> ())?
    public var closureWhenAdIsResumed : (() -> ())?
    public var closureWhenAdIsAboutToRun : ( () -> () )?
    
    public func integrateAndPlayAds (OnVideoView videoView : UIView ,
                                     playersContentPlayHead : IMAAVPlayerContentPlayhead? ,
                                     isVideoViewAnAVPlayer : Bool ,
                                     withAdTagUrl adTag : String ,
                                     andProvideClosureToBeExecutedWhenAdFinishedRunnind closure : ( () -> () )? ) {
        
        
        
        self.videoView = videoView
        self.adTagUrl = adTag
        self.closureToBeExecutedWhenAdHasBeenCompleted = closure
        if let contentPlayHead = playersContentPlayHead { self.playerContentPlayhead = contentPlayHead }
        
        if !isVideoViewAnAVPlayer { } // setupAVPlayer(forPlayerItem: <#T##AVPlayerItem#>) }
        setupAdsLoader()
        requestForAds()
        
    }
    
    public func pauseAds () {
        guard let manager = adsManager else {return}
        manager.pause()
    }
    
    public func resumeAds () {
        guard let manager = adsManager else {return}
        manager.resume()
    }
    
    public func muteAds () {
        guard let manager = adsManager else {return}
        manager.volume = 0
        
    }
    
    public func unmuteAds () {
        guard let manager = adsManager else {return}
        manager.volume = 1
        
    }
    
    
    private struct MessageBox {
        static let Message_adsLoadedSuccess = " MESSAGE - SUCCESS : ADS HAS BEEN LOADED  "
        static let Message_adsLoadedError = " MESSAGE - FAILED : AD FAILED TO LOAD WITH ERROR  "
        static let Message_adManagerError = " MESSAGE - FAILED : AD MANAGER DID RECEIVE ERROR  "
        static let Message_adsManagerSuccess = " MESSAGE - SUCCESS : AD MANAGER DID RECEIVE EVENT  "
        static let Message_adsManagerContentPaused = " MESSAGE : AD MANAGER CONTENT HAS BEEN PAUSED  "
        static let Message_adsManagerContentResumed = " MESSAGE : AD MANAGER CONTENT HAS BEEN RESUMED  "
        static let Messgae_adEventLoaded = " MESSAGE : AD LOADED"
        static let Messgae_adEventPaused = " MESSAGE : AD PAUSED"
        static let Messgae_adEventResumed = " MESSAGE : AD RESUMED"
        static let Messgae_adEventStarted = " MESSAGE : AD STARTED"
        static let Messgae_adEventStreamLoaded = " MESSAGE : AD STREAM LOADED"
        static let Messgae_adEventStreamStarted = " MESSAGE : AD STREAM STARTED"
        static let Messgae_adEventSkipped = " MESSAGE : AD SKIPPED"
        static let Messgae_adEventComplete = " MESSAGE : AD COMPLETE"
        static let Messgae_adEventClicked = " MESSAGE : AD CLICKED"
        static let Messgae_adEventTapped = " MESSAGE : AD TAPPED"
        
    }
    
   
    
    private var videoView : UIView?
    private var adTagUrl =
        "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&" +
            "iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&" +
            "output=vast&unviewed_position_start=1&" +
    "cust_params=deployment%3Ddevsite%26sample_ct%3Dlinear&correlator=" ;
    
    
    
    private var adsLoader : IMAAdsLoader!
    private var adsManager : IMAAdsManager!
    
    private var avPlayer : AVPlayer?
    private var playerContentPlayhead : IMAAVPlayerContentPlayhead?
    
    
    
    
    // MARK: ADDS SETUP CREATION AND LOADING
    
    
    private func setupAVPlayer (forPlayerItem playerItem : AVPlayerItem) {
        
        avPlayer = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: avPlayer)
        
        videoView?.layer.addSublayer(playerLayer)
        playerLayer.frame = (videoView?.layer.bounds)!
        
        playerContentPlayhead = IMAAVPlayerContentPlayhead(avPlayer: avPlayer!)
        
    }
    
    private func setupAdsLoader () {
        
        adsLoader = IMAAdsLoader(settings: nil)
        adsLoader.delegate = self
        
    }
    
    public func requestForAds () {
        
        let containerToDisplayAdsIn = IMAAdDisplayContainer(adContainer: videoView, companionSlots: nil)
        
        let request = IMAAdsRequest(
            adTagUrl: adTagUrl,
            adDisplayContainer: containerToDisplayAdsIn,
            contentPlayhead: playerContentPlayhead,
            userContext: nil)
        
        adsLoader.requestAds(with: request)
        
    }
    
    
    // MARK: AD LOADER DELEGATES METHODS :
    
    func adsLoader(_ loader: IMAAdsLoader!, adsLoadedWith adsLoadedData: IMAAdsLoadedData!) {
        print("\(MessageBox.Message_adsLoadedSuccess)")
        
        
        adsManager = adsLoadedData.adsManager
        adsManager.delegate = self
        
        let adsRenderingSetting = IMAAdsRenderingSettings()
        adsRenderingSetting.webOpenerPresentingController = nil
        
        adsRenderingSetting.bitrate = 1024 ;
        
        adsRenderingSetting.mimeTypes = ["application/x-mpegURL" , "video/mp4" , "video/mpeg" ]
        
        
        adsManager.initialize(with: adsRenderingSetting)
        
    }
    
    func adsLoader(_ loader: IMAAdsLoader!, failedWith adErrorData: IMAAdLoadingErrorData!) {
        print("\(MessageBox.Message_adsLoadedError ) Error : \(adErrorData) ")
        
        adsLoader = nil
        adsManager = nil
        
        setupAdsLoader()
        requestForAds()
        
    }
    
    
    // MARK: AD MANAGER DELEGATES METHODS :
    
    
    func adsManager(_ adsManager: IMAAdsManager!, didReceive error: IMAAdError!) {
        print( "\(MessageBox.Message_adManagerError) : ERROR :  \(error.message ?? "ERROR_UNKNOWN")" )
        
        
        adsLoader = nil
        
        
        setupAdsLoader()
        requestForAds()
        
    }
    
    func adsManager(_ adsManager: IMAAdsManager!, didReceive event: IMAAdEvent!) {
        print( "\(MessageBox.Message_adsManagerSuccess)" )
        
        switch event.type {
            
        case .LOADED :
            print("\(MessageBox.Messgae_adEventLoaded)")
            adsManager.start()
            adsManager.volume = 0
            
            
        case .PAUSE :
            print("\(MessageBox.Messgae_adEventPaused)")
            if let closure = closureWhenAdIsPaused{
                closure()
            }
            
            
        case .RESUME :
            print("\(MessageBox.Messgae_adEventResumed)")
            if let closure = closureWhenAdIsResumed{
                closure()
            }
            
        case .STARTED :
            print("\(MessageBox.Messgae_adEventStarted)")
            if let closure = closureWhenAdIsResumed{
                closure()
            }
            
        case .STREAM_LOADED :
            print("\(MessageBox.Messgae_adEventLoaded)")
            
        case .STREAM_STARTED :
            print("\(MessageBox.Messgae_adEventStreamStarted)")
            
        case .SKIPPED :
            print("\(MessageBox.Messgae_adEventSkipped)")
            
        case .COMPLETE :
            print("\(MessageBox.Messgae_adEventComplete)")
            if let closure = closureWhenAdIsPaused{
                closure()
            }
            
        case .CLICKED :
            print("\(MessageBox.Messgae_adEventClicked)")
            
        case .TAPPED :
            print("\(MessageBox.Messgae_adEventTapped)")
            
        default:
            print("")
            
            
        }
        
    }
    
    func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!) {
        print( "\(MessageBox.Message_adsManagerContentPaused)" )
        
        guard let closure = closureWhenAdIsAboutToRun else { return }
        
        closure()
    }
    
    func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!) {
        print( "\(MessageBox.Message_adsManagerContentResumed)" )
        
        guard let closure = closureToBeExecutedWhenAdHasBeenCompleted else { return }
        
        closure()
        
    }
    
    
}


