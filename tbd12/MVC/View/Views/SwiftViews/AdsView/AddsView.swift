//
//  AddsView.swift
//  Bestsongs.pk
//
//  Created by IMac on 20/03/2018.
//  Copyright © 2018 Bestsongs. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleInteractiveMediaAds



let window  = UIApplication.shared.keyWindow

let addsPlayerHeight : CGFloat  = (window?.frame.width)! * (9 / 16)
let addsPlayerWidth : CGFloat = (window?.frame.width)!
let topCenterAnchorOfPlayer : CGFloat = ((window?.frame.height)! / 2) - (addsPlayerHeight / 2)
var addsPlayer : AVPlayer?



class AddsView : UIView,IMAAdsLoaderDelegate,IMAAdsManagerDelegate,IMAWebOpenerDelegate {
    var addHasBeenPlayed = false
    var isNotInVideoView = true
    var addManagerIsNowStarted = false
    var videoViewRequestedAdd = false
    var addIsPaused = false
    var addHasBeenCompleted = false
    static var isInActiveState = true
    var addHasBeenPresented = false
    var addHasNotAppeared = false
    var isAddAllowedToBePlayed = false
    var isWithinRegion = false
    
    var addsRequest : IMAAdsRequest!
    
    var adsLoader : IMAAdsLoader!
    var addManage :IMAAdsManager?
    
    lazy  var addsContainerView = IMAAdDisplayContainer(adContainer: addsPlayerView, companionSlots: nil)
    var playerHeadTracker = IMAAVPlayerContentPlayhead(avPlayer:addsPlayer)
    
    let addTag = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&"+"iu=/39243592/387337752&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&"+"output=vast&unviewed_position_start=1&"+"correlator=";
    
    
    public let addsPlayerView : UIView = {
        
        let view = UIView()
        view.backgroundColor = .darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let addsDisplayLabel : UILabel = {
        
        let label = UILabel()
        
        label.text = "Application will resume after watching this advertisment "
        label.textColor = .white
        label.numberOfLines = 1
        //label.font = UIFont.systemFont(ofSize: 13.7)
        label.textAlignment = NSTextAlignment.center
       label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
       
        
        let url = URL(string: "https://bestsongs-156307.appspot.com/v1/marketing/showpopupad")! //////
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let unwrappedData = data else { return }
            do {
                
                
                if let httpResponse = response as? HTTPURLResponse {
                    
                    
                   
                    if (httpResponse.statusCode != 403){
                        let str = try JSONSerialization.jsonObject(with: unwrappedData, options: .allowFragments)
                        
                        
                        
                        let adsAPIFetched = str as! [String:Bool]
                        
                        
                        self.isAddAllowedToBePlayed = adsAPIFetched["show_popup_ad"]!
                        
                        
                        self.isWithinRegion = true
                        
                        print("json error: \(adsAPIFetched["show_popup_ad"]!)")
                        
                    }
                    else {
                        
                        self.isAddAllowedToBePlayed = false
                        
                        self.isWithinRegion = false
                        
                    
                        
                        self.removeFromSuperview()
                        
                        
                    }
                    
                }
                
                
                
               
                
            } catch {
                print("json error: \(error)")
            }
        }
        
        task.resume()
        
        
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(playAdds), name: NSNotification.Name(rawValue: "addsPlaying"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(videoViewIsDisplayed), name: NSNotification.Name(rawValue: "videoViewIsDisplayed"), object: nil)
       
        NotificationCenter.default.addObserver(self, selector: #selector(videoViewIsDisappearing), name: NSNotification.Name(rawValue: "videoViewIsDisappearing"), object: nil)
        
        backgroundColor = .black
        translatesAutoresizingMaskIntoConstraints = false
        
        
        
        self.setupAddsView()
        self.setUpAdsLoader()
        self.setupAddsPlayerView()
        
        
        
    }
    
    
    
    
    func setUpAdsLoader() {
        adsLoader = IMAAdsLoader(settings: nil)
        adsLoader.delegate = self
        let adsRenderingSetting = IMAAdsRenderingSettings()
        adsRenderingSetting.bitrate = 1024
        adsRenderingSetting.mimeTypes = ["application/x-mpegURL"]
        adsRenderingSetting.webOpenerDelegate = self
        adsRenderingSetting.webOpenerPresentingController = nil
    }
    
    
    
    func setupAddsPlayerView() {
        
        
        let urlString = ""
        
        let url = URL(string:urlString)
        
        if let Url = url {
            
            addsPlayer = AVPlayer(url: Url)
            
            let addsPlayerLayer = AVPlayerLayer(player: addsPlayer)
            
            addsPlayerView.layer.addSublayer(addsPlayerLayer)
            
            addsPlayerLayer.frame = addsPlayerView.layer.bounds
            
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(note:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: addsPlayer!.currentItem)
            
        }
        
        
        
    }
    
    
    @objc func playerDidFinishPlaying(note: NSNotification){
        
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addsDidFinishPlaying"), object: nil)
        }
        
        
    }
    
    //////////////////////////////////////////////
    
    func requestAds() {
        // Create ad display container for ad rendering.
        let adDisplayContainer = IMAAdDisplayContainer(adContainer: self.addsPlayerView, companionSlots: nil)
        // Create an ad request with our ad tag, display container, and optional user context.
        let request = IMAAdsRequest(
            adTagUrl: self.addTag,
            adDisplayContainer: adDisplayContainer,
            contentPlayhead: self.playerHeadTracker,
            userContext: nil)
        
        self.adsLoader.requestAds(with: request)
    }
    
    
    
    func adsLoader(_ loader: IMAAdsLoader!, adsLoadedWith adsLoadedData: IMAAdsLoadedData!) {
        addManage = adsLoadedData.adsManager
        addManage?.delegate = self
        
        addManage?.initialize(with: IMAAdsRenderingSettings())
        
    }
    
    func adsLoader(_ loader: IMAAdsLoader!, failedWith adErrorData: IMAAdLoadingErrorData!) {
        
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        
        addManage?.destroy()
        
        setupAddsPlayerView()
        
        
        requestAds()
        
    }
    
    func adsManager(_ adsManager: IMAAdsManager!, didReceive event: IMAAdEvent!) { // muneeb
        if event.type == IMAAdEventType.LOADED{
            
            if(!addHasBeenCompleted){
                
                let state = UIApplication.shared.applicationState
                
                if (state.rawValue != 1 && state.rawValue != 2){
                    
                    self.addManage?.start()
                    
                    self.addManagerIsNowStarted = true
                    
                }
            }
            
        }

        if event.type == IMAAdEventType.STARTED {
            print("Abipause")

            self.addManage?.pause()
            self.addIsPaused = true




        }

        if event.type == IMAAdEventType.PAUSE {

            if (addHasBeenPlayed && addIsPaused  && isNotInVideoView && AddsView.isInActiveState && !addHasBeenCompleted){

                NotificationCenter.default.addObserver(self, selector: #selector(pauseAddNowInNonActiveState), name: UIApplication.willResignActiveNotification , object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(resumeAddNowInActiveState), name: UIApplication.didBecomeActiveNotification , object: nil)


                self.addManage?.resume()
                self.alpha = 1.0



            }

            if (!addHasBeenPlayed && isNotInVideoView && !addHasBeenCompleted && AddsView.isInActiveState ){ //

                NotificationCenter.default.addObserver(self, selector: #selector(pauseAddNowInNonActiveState), name: UIApplication.willResignActiveNotification , object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(pauseAddNowInNonActiveState), name: UIApplication.didEnterBackgroundNotification , object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(resumeAddNowInActiveState), name: UIApplication.didBecomeActiveNotification , object: nil)


                print("Abdkhega")
                nowShowAdds()

            }

        }



        if event.type == IMAAdEventType.RESUME {

            print("Abchlega")
         }
     }
    
    func adsManager(_ adsManager: IMAAdsManager!, didReceive error: IMAAdError!) {
        
        addManage?.destroy()
        requestAds()
        
    }
    
    func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!) {
        
    }
    
    
    
    
    
    func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!) {
        
        alpha = 0
        
        self.addHasBeenCompleted = true
        
        NotificationCenter.default.post(name: NSNotification.Name("autoPlayerAddHasNowFinishedRunning"), object: nil)

        self.removeFromSuperview()
        
    }
    
    
    
    
    
    func setupAddsView() {
        
        addSubview(addsPlayerView)
        addsPlayerView.topAnchor.constraint(equalTo: self.topAnchor, constant: topCenterAnchorOfPlayer).isActive = true
        addsPlayerView.widthAnchor.constraint(equalToConstant: addsPlayerWidth ).isActive = true
        addsPlayerView.heightAnchor.constraint(equalToConstant: addsPlayerHeight).isActive = true
        
        
        addSubview(addsDisplayLabel)
        addsDisplayLabel.bottomAnchor.constraint(equalTo: addsPlayerView.topAnchor, constant: -45).isActive = true
        addsDisplayLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        addsDisplayLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        addsDisplayLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        
        
        setupAddsPlayerView()
    }
    
    
    
    public func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
        let dispatchTime = DispatchTime.now() + seconds
        dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
    }
    
    public enum DispatchLevel {
        case main, userInteractive, userInitiated, utility, background
        var dispatchQueue: DispatchQueue {
            switch self {
            case .main:                 return DispatchQueue.main
            case .userInteractive:      return DispatchQueue.global(qos: .userInteractive)
            case .userInitiated:        return DispatchQueue.global(qos: .userInitiated)
            case .utility:              return DispatchQueue.global(qos: .utility)
            case .background:           return DispatchQueue.global(qos: .background)
            }
        }
    }
    
    
    @objc func nowShowAdds () {
        
        print("muneeb :: \(self.isAddAllowedToBePlayed)");
        
        if( ( self.isAddAllowedToBePlayed ) && self.isWithinRegion ) {
         
        if (!self.addHasBeenPlayed){
       
            self.delay(bySeconds: 10, dispatchLevel: .background) {
        
            self.delay(bySeconds: 0, dispatchLevel: .main) {
                
                
                if (!self.addHasBeenPlayed){
                
                let window = UIApplication.shared.keyWindow
                
                    window?.bringSubviewToFront(self)
            
            
                    UIView.animate(withDuration: 3, delay:4, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                
                        UIView.animate(withDuration: 3, delay: 0.5, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                    
                    NotificationCenter.default.post(name: NSNotification.Name("stopSongAddsPlaying"), object: nil)
                    if( self.isNotInVideoView && AddsView.isInActiveState){
                        self.alpha = 1.0
                        self.addHasBeenPresented = true
                    }
                }, completion: { (asd) in
                    
                    if( self.isNotInVideoView && AddsView.isInActiveState ){
                        
                        
                        let state = UIApplication.shared.applicationState
                        
                        if state == .background {
                            
                            self.alpha = 0.0
                            self.addManage?.pause()
                            
                        }
                        else if state == .active {
                            
                            self.addManage?.resume()
                            
                            
                            NotificationCenter.default.post(name: NSNotification.Name("autoPlayerAddIsNowRunning"), object: nil)
                            
                            
                            UIView.animate(withDuration: 2, animations: {
                                self.alpha = 1.0
                            }, completion: { (asd) in
                                
                            })
                            
                            
                            
                            
                            self.addHasBeenPlayed = true
                        }
                        
                    }
                })
                
                
            }) { (sda) in
               
            }
            
                }  // will work if ad has not been played
                
                } //  delay close
            
            } //  delay close
            
        } // will work if ad has not been played
            
        }
 
    }
    
    
    
    
    @objc func videoViewIsDisplayed () {
        
        self.isNotInVideoView = false
        self.alpha = 0
        
          if (addManagerIsNowStarted) {
            self.addManage?.pause() }
   
    }
    
    @objc func videoViewIsDisappearing () {
        
        self.isNotInVideoView = true
        
        if (addManagerIsNowStarted && AddsView.isInActiveState) {
            nowShowAdds()
        }else {
            self.requestAds()
            self.videoViewRequestedAdd = true
        }
        
    }
    
    @objc func resumeAddNowInActiveState() {
        
        AddsView.isInActiveState = true

        if(addHasBeenCompleted)
        {
           
            self.addManage?.pause()
            self.alpha = 0
            
//            if  let tagOfAddsView = self.viewWithTag(100){
//
//                tagOfAddsView.removeFromSuperview() }
            
            NotificationCenter.default.post(name: NSNotification.Name("autoPlayerAddHasNowFinishedRunning"), object: nil)
            
            self.removeFromSuperview()
            
        }
        
        
        if(addHasNotAppeared)
        {
            
            self.addManage?.pause()
            self.alpha = 0
            
            
            
            NotificationCenter.default.post(name: NSNotification.Name("autoPlayerAddHasNowFinishedRunning"), object: nil)
            
        }
        
        

//        if(addHasBeenPlayed && !addHasBeenCompleted && addManagerIsNowStarted )
//        {
//             self.addManage?.resume()
//        }
//
//        if(addHasBeenPresented && !addHasBeenCompleted && addManagerIsNowStarted )
//        {
//            self.addManage?.resume()
//        }
//
        
    }
    @objc func pauseAddNowInNonActiveState() {
        
        AddsView.isInActiveState = false

        if(addHasBeenPlayed && !addHasBeenCompleted && addManagerIsNowStarted)
        {
            self.addManage?.pause()
            self.addHasBeenCompleted = true
        }
        
        if(!addHasBeenCompleted && addManagerIsNowStarted)
        {
            
            self.addManage?.pause()
            
            if(self.alpha == 1){
                 self.addHasBeenCompleted = true
                 addHasNotAppeared = false
                
                
            }else{
                 addHasNotAppeared = true
            }
            
           
        }
        
        
    }
    
    
    @objc func playAdds () {
        
        if (isNotInVideoView && !videoViewRequestedAdd ) {
           self.requestAds()
            
        }
    }
    
    

  
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
