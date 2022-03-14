//
//  AppAPIConstants.swift
//  Bsongs_v1_Muneeb
//
//  Created by Syed Muneeb Ur Rehman on 09/05/2019.
//  Copyright © 2019 Syed Muneeb Ur Rehman. All rights reserved.
//

import Foundation

struct ThemeApiConstants {
    
    
    // Bsongs
    
    static let BSongsDomainAPIConstant : String = "https://api-v2-dot-bestsongs-156307.appspot.com/"
    static let BSongsVersionAPIConstant : String = "api/v1/"
    
    
    static let HomeSliderAPIConstant = URL(string: BSongsDomainAPIConstant + BSongsVersionAPIConstant + "banners" )!
    static let HomeCarouselAPIConstant = URL(string: BSongsDomainAPIConstant + BSongsVersionAPIConstant + "featured" )!
    
    
    
    // Suunnoo
    
    
    static let DomainAPIConstant : String = "http://127.0.0.1:5000/"
    static let VersionAPIConstant : String = "api/v1/"
    
    
    static let BannerAPIConstant = URL(string: DomainAPIConstant + VersionAPIConstant + "banners" )!
    
    static let HomeAPIConstant = URL(string: DomainAPIConstant + VersionAPIConstant + "home" )!
    
    static let AlbumAPIConstant : String = DomainAPIConstant + VersionAPIConstant + "album/"
    
    static let ArtistAPIConstant : String = DomainAPIConstant + VersionAPIConstant + "artist/"
    
    static let TrackAPIConstant : String = DomainAPIConstant + VersionAPIConstant + "track/"
    
    static let SearchAPIConstant = URL(string: DomainAPIConstant + VersionAPIConstant + "search/Test" )!
    
    
    
    
}
