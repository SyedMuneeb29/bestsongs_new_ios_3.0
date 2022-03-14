//
//  VideoViewModel.swift
//  VideoCollectionViews
//
//  Created by Syed Muneeb Ur Rehman on 28/05/2019.
//  Copyright © 2019 Syed Muneeb Ur Rehman. All rights reserved.
//

import Foundation


@objc class VideoView : NSObject , Decodable {
    
    @objc var coverUrl : String
    @objc var id : Int
    @objc var title : String
    @objc var type : String
    
}




@objc class VideoUrl : NSObject , Decodable {
    
    @objc var videoUrl : String?

}



@objc class UsersVideoLikeDislike : NSObject , Decodable {
    
    @objc var disliked : Bool
    @objc var liked : Bool
    
    override init() {
        self.disliked = false
        self.liked = false
    }
    
    
}


@objc class VideoLikesDislikes : NSObject ,Decodable {
    
    @objc var disliked : Bool
    @objc var dislikes : Int
    @objc var liked : Bool
    @objc var likes : Int
    
    
    override init() {
        self.disliked = false
        self.liked = false
        self.dislikes = 0
        self.likes = 0
    }
    
    
    
    
    
}



