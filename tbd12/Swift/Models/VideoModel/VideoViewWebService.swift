//
//  VideoViewWebService.swift
//  VideoCollectionViews
//
//  Created by Syed Muneeb Ur Rehman on 28/05/2019.
//  Copyright © 2019 Syed Muneeb Ur Rehman. All rights reserved.
//

import Foundation
import Firebase



@objc class VideoWebService : NSObject {
    
    var webService : GiveMeAWebService!
    
    static var CategoryId : Int = 72
    static var PageNo : Int = 1
    
    
    @objc enum VideoType : Int {
        case Evergreen
        case Trailers
        case TopVideos
        case Tracks
        case Gupshup
    }
    
    
    
    @objc func fetchVideos ( videoType type: VideoType) -> NSMutableArray? {
        
        webService = GiveMeAWebService()
        
        generateCategoryAndPageNumber(type: type)
        
        let videoViews = webService.serviceGET(url:URL(string:"https://api-v2-dot-bestsongs-156307.appspot.com/api/v1/videos?cat_id=\(VideoWebService.CategoryId)&page=\(VideoWebService.PageNo)")! ,
                                               modelsDataType: [VideoView]() )
        
        
        var videos = NSMutableArray()
        
        if let videoViews = videoViews {
            for videoView in videoViews  {
                videos.add(videoView)
            }
        }
        
        
        return videos
        
    }
    
    
    @objc func fetchVideoUrl (forVideoWithId videoId : Int , andType type : String) -> String? {
        
        webService = GiveMeAWebService()
        
        let videoUrl = webService.serviceGET(url: URL(string: "https://api-v2-dot-bestsongs-156307.appspot.com/api/v1/video/\(videoId)/video_url?type=\(type)")!, modelsDataType: VideoUrl() )
        
        return videoUrl?.videoUrl
        
    }
    
    
    func generateCategoryAndPageNumber ( type : VideoType )  {
        
        switch type {
        case .Evergreen :
            VideoWebService.CategoryId = 67
            if VideoWebService.PageNo >= 2 {
                
                VideoWebService.PageNo = 1
                
            }else {
                
                VideoWebService.PageNo = VideoWebService.PageNo + 1
                
            }
            
        case .Trailers :
            VideoWebService.CategoryId = 72
            if VideoWebService.PageNo >= 7 {
                
                VideoWebService.PageNo = 1
                
            }else {
                
                VideoWebService.PageNo = VideoWebService.PageNo + 1
                
            }
            
        case .TopVideos :
            VideoWebService.CategoryId = 73
            if VideoWebService.PageNo >= 11 {
                
                VideoWebService.PageNo = 1
                
            }else {
                
                VideoWebService.PageNo = VideoWebService.PageNo + 1
                
            }
            
        case .Tracks :
            VideoWebService.CategoryId = 73
            if VideoWebService.PageNo >= 11 {
                
                VideoWebService.PageNo = 1
                
            }else {
                
                VideoWebService.PageNo = VideoWebService.PageNo + 1
                
            }
            
        case .Gupshup :
            VideoWebService.CategoryId = 74
            if VideoWebService.PageNo >= 6 {
                
                VideoWebService.PageNo = 1
                
            }else {
                
                VideoWebService.PageNo = VideoWebService.PageNo + 1
                
            }
            
            
        }
        
        
        
    }
    
    
    @objc func fetchVideoLikesAndDislikes (
        videoId id : Int ,
        videoType type : String ) -> VideoLikesDislikes? {
        
        webService = GiveMeAWebService()
        
        let trackUrl = webService.serviceGET( url:URL(string:"https://api-v2-dot-bestsongs-156307.appspot.com/api/v1/video/\(id)?type=\(type)")! ,
            modelsDataType: VideoLikesDislikes()
        )
        
       // print(trackUrl)
        return trackUrl
    
        
    }
    
    
    @objc func fetchVideoLikesAndDislikes (
        videoId id : Int ,
        videoType type : String ,
        userToken token : String? ) -> VideoLikesDislikes? {
        
        
        webService = GiveMeAWebService()
        
        
        if let token = token {
            
            var bearerToken = "Bearer "
            
            bearerToken = bearerToken + token
            
            
            let trackUrl = webService.serviceGET2(url: URL(string:"https://api-v2-dot-bestsongs-156307.appspot.com/api/v1/video/\(id)?type=\(type)")!, modelsDataType: VideoLikesDislikes(), headersValue: ["Content-Type" : "application/json" , "Authorization" : bearerToken ])
            
            // print(trackUrl)
            return trackUrl
            
            
        }else {
            
            let trackUrl = webService.serviceGET( url:URL(string:"https://api-v2-dot-bestsongs-156307.appspot.com/api/v1/video/\(id)?type=\(type)")! ,
                                                  modelsDataType: VideoLikesDislikes()
            )
            
            // print(trackUrl)
            return trackUrl
            
            
        }
        
        
       
        
    }
    
    
    @objc func performLikeOrDislikeForVideo (
        havingVideoId id : Int ,
        videoType type : String ,
        andvideoAction action : String ,
        userToken token : String ) -> UsersVideoLikeDislike? {
        
        var bearerToken = "Bearer "
        
        bearerToken = bearerToken + token
        
        webService = GiveMeAWebService()

        let trackUrl = webService.servicePost(
            url: URL(string: "https://api-v2-dot-bestsongs-156307.appspot.com/api/v1/video/\(id)/ld?type=\(type)&action=\(action)")! ,
            postBody: nil ,
            headersValues: ["Content-Type" : "application/json" ,
                            "Authorization" : bearerToken
                            ] ,
            modelsDataType: UsersVideoLikeDislike()
        )
        
        
        
        return trackUrl
        
        
        
    }
    
    
    
    @objc func performLikeOrDislikeForVideoAsync (
        havingVideoId id : Int ,
        videoType type : String ,
        andvideoAction action : String ,
        userToken token : String ,
        closure : @escaping () -> () 
        
        )  {
        
        var bearerToken = "Bearer "
        
        bearerToken = bearerToken + token

        let webService = GiveMeAWebService()

        webService.servicePostAsync(
            url: URL(string: "https://api-v2-dot-bestsongs-156307.appspot.com/api/v1/video/\(id)/ld?type=\(type)&action=\(action)")! ,
            postBody: nil,
            headersValues: [
                            "Content-Type" : "application/json" ,
                            "Authorization" : bearerToken
                           ] ,
            modelsDataType: UsersVideoLikeDislike() ) { (UsersVideoLikeDislike) in
                
                print("dataReceived")
                closure()
                
        }
        
        
        
        
        
    }
    
//    
//    @objc func performLikeOrDislikeForVideo2 (
//        havingVideoId id : Int ,
//        videoType type : String ,
//        andvideoAction action : String ,
//        userToken token : String ,
//        closure : @escaping () -> ()
//        ) -> UsersVideoLikeDislike? {
//        
//        var bearerToken = "Bearer "
//        
//        bearerToken = bearerToken + token
//        
//        webService = GiveMeAWebService()
//        
//        let trackUrl = webService!.servicePostAsync(
//            url: URL(string: "https://api-v2-dot-bestsongs-156307.appspot.com/api/v1/video/\(id)/ld?type=\(type)&action=\(action)")! ,
//            postBody: nil ,
//            headersValues: ["Content-Type" : "application/json" ,
//                            "Authorization" : bearerToken
//            ] ,
//            modelsDataType: UsersVideoLikeDislike() ,
//            closure : closure()
//        )
//        
//        
//        
//        return trackUrl
//        
//        
//        
//    }
//    
//    
//    
    
    
    
    
    
    
    
    
    
    //
    //    @objc func fetchUserLikeDislikeForVideo (forVideoId videoId : Int , andType type : String) -> UsersVideoLikeDislike? {
    //
    //        webService = GiveMeAWebService()
    //
    //
    //
    //
    //
    //        var user = FIRAuth.auth()?.currentUser
    //
    //
    //        if let user = user {
    //
    //
    //
    //
    //
    //        }else {
    //
    //
    //
    //
    //
    //
    //        }
    //
    //        user?.getTokenWithCompletion({ (token, error) in
    //
    //            if let error = error {
    //
    //
    //            }else {
    //
    //
    //
    //
    //            }
    //
    //
    //        })
    //
    ////        let usersVideoLikeDislike = webService.servicePost(
    ////            url: URL(string: "https://api-v2-dot-bestsongs-156307.appspot.com/api/v1/video/\(videoId)/ld?type=\(type)&action=dislike")!,
    ////            postBody: <#T##[String : String]?#>,
    ////            headersValues: ["Content-Type" : "application/json" ,
    ////                            "Authorization" :
    ////
    ////                            ],
    ////            modelsDataType: UsersVideoLikeDislike()
    ////        )
    ////
    ////        usersVideoLikeDislike?.disliked = !usersVideoLikeDislike!.disliked ?? false
    ////
    ////        return usersVideoLikeDislike
    //
    //    }
    //
    
    
    
}
