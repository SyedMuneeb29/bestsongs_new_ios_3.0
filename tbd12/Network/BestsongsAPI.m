
////////////////////////////////////////////////////////




//
//  BestsongsAPI.m
//  Bestsongs.pk
//
//  Created by Apnaweb on 2/21/17.
//  Copyright © 2017 Bestsongs. All rights reserved.
//

#import "BestsongsAPI.h"

@interface BestsongsAPI (){
    //AFURLSessionManager *manager;
    NSURLRequest *request;
    NSURLSessionDataTask *dataTask;
}
@end

#define BASEURL @"https://bestsongs-156307.appspot.com/v1/"
#define BASEURL2 @"https://bestsongs-156307.appspot.com/v2/"
#define HOMEURL BASEURL @"featured"
#define BANNERURL @"https://bestsongs-156307.appspot.com/v1/banner"
#define BOLLYWOODURL BASEURL @"albums?cat=bollywood"

#define ARTISTURL BASEURL2 @"artists"

#define ARTISTALBUM BASEURL @"albums?artist_id="

#define MASHUPURL BASEURL2 @"albums?cat=bollywood-mashup"

#define PAKISTANIURL BASEURL @"albums?cat=pakistani"
//#define DISCOVERURL BASEURL
#define ALBUMURL BASEURL @"albums"
#define VIDEOURL BASEURL @"videos"
#define SEARCHURL @"http://api.bestsongspk.com.pk/search?ppr=1,15&sort=title&q="
#define TRACKSURL @"tracks"
#define PLAYLISTURL BASEURL @"playlists"
#define PLAYLISTTRACKSURL BASEURL @"playlistentries"
#define DISCOVERURL BASEURL2 @"albums?cat="
#define GUPSHUPURL BASEURL @"videos?cat="
#define FIREBASEDYNAMICLINKURL @"https://firebasedynamiclinks.googleapis.com/v1/shortLinks"
#define USERSURL BASEURL @"users"

@implementation BestsongsAPI

- (instancetype)init{
    if(self = [super init]){
        // If we want to initialize someting initialize here
    }
    return self;
}

// MARK: Shared Instance

+ (BestsongsAPI *)sharedInstance {
    static BestsongsAPI *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[BestsongsAPI alloc] init];
    });
    return _sharedInstance;
}


// MARK: getSearchResults

- (void)getSearchResult:(NSString *)text
              onSuccess:(void (^)(id))successBlock
              onFailure:(void (^)(NSError *))failureBlock{
    @try {
        NSString *encodedString = [text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SEARCHURL,encodedString]];
        [self fetch:URL method:@"GET" body:@"" isAuth:NO
          onSuccess:^(id responseObject) {
              successBlock(responseObject);
          } onFailure:^(NSError * error) {
              failureBlock(error);
          }];
    } @catch (NSException *exception) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
        failureBlock(error);
    } @finally {
    }
}


//- (Song *)getTrackFromJSON:(NSDictionary *)track{
//    NSNumber * ID = [self getFormattedNumber:track key:@"id"];
//    NSNumber * albumID = [self getFormattedNumber:track key:@"album_id"];
//    NSNumber * likes = [self getFormattedNumber:track key:@"likes"];
//    NSString * title = [self getFormattedString:track key:@"title" removeWhiteSpace:NO];
//    NSString * poster = [self getFormattedString:track key:@"cover_url" removeWhiteSpace:YES];
//    NSString *permalink = @"";
//    NSString * audioURL = [self getFormattedString:track key:@"audio_url" removeWhiteSpace:YES];
//    NSString * videoURL = [self convertMPDtoHLS:[self getFormattedString:track key:@"video_url" removeWhiteSpace:YES]];
//    NSString * videoPermalink = [self getFormattedString:track key:@"video_permalink" removeWhiteSpace:YES];
//    BOOL isDownload = NO;
//    BOOL isVideo = NO;
//    BOOL isLiked = NO;
//    isLiked = [[track objectForKey:@"liked"] boolValue];
//    if(audioURL.length > 0)
//        isDownload = YES;
//    if(videoURL.length > 0)
//        isVideo = YES;
//    Song *newTrack = [[Song alloc] initWithID:ID albumId:albumID likes:likes title:title albumTitle:album.Title poster:poster permalink:permalink audioURL:audioURL videoURL:videoURL videoPermalink:videoPermalink isDowload:isDownload isVideo:isVideo isLikes:isLiked];
//    return newTrack;
//}


// MARK: fetch main function



- (void)fetch:(NSURL *)URL
       method:(NSString *)method
         body:(NSString *)body
       isAuth:(BOOL)isAuth
    onSuccess:(void (^)(id))successBlock
    onFailure:(void (^)(NSError *))failureBlock

{
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        @try {
            
            
            if(isAuth)
            {
                
                
                if([[BaseController sharedInstance] checkIsUserLogin])
                    
                {
                    FIRUser *user = [FIRAuth auth].currentUser;
                    
                    
                    [user getIDTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
                        
                        if(!error)
                        {
                            
                            if(token != nil)
                            {
                                
                                NSLog(@"token ::: %@",token);
                                NSLog(@"token ended ");
                                
                                
                                
                                AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                                
                                NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:method URLString:[NSString stringWithFormat:@"%@",URL] parameters:nil error:nil];
                                
                                req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
                                
                                [req setValue:token forHTTPHeaderField:@"Authorization"];
                                
                                [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                                
                                if(![body isEqualToString:@""])
                                    [req setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
                                
                                [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
                                  {
                                      
                                      NSLog(@"%ld", error.code);
                                      
                                      if (!error)
                                      {
                                          successBlock(responseObject);
                                      } else
                                      {
                                          
                                          switch (error.code)
                                          {
                                              case 500:
                                              {
                                                  
                                                  NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Try again later..." };
                                                  NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:500 userInfo:userInfo];
                                                  failureBlock(error);
                                                  break;
                                              }
                                                  //                                            case 502:{
                                                  //                                                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Internet is working slower.. Try again later..." };
                                                  //                                                NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:502 userInfo:userInfo];
                                                  //                                                failureBlock(error);
                                                  //                                                break;
                                                  //                                            }
                                                  //                                            case 503:{
                                                  //                                                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Internet is working slower.. Try again later..." };
                                                  //                                                NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:503 userInfo:userInfo];
                                                  //                                                failureBlock(error);
                                                  //                                                break;
                                                  //                                            }
                                                  //                                            case 504:{
                                                  //                                                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Internet is working slower.. Try again later..." };
                                                  //                                                NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:504 userInfo:userInfo];
                                                  //                                                failureBlock(error);
                                                  //                                                break;
                                                  //                                            }
                                              case 404:
                                              {
                                                  NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Nothing Found.. Try again later..." };
                                                  NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:404 userInfo:userInfo];
                                                  failureBlock(error);
                                                  break;
                                              }
                                              case 403:
                                              {
                                                  
                                                  
                                                  
                                                  NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Content is only available in Pakistan " };
                                                  NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:403 userInfo:userInfo];
                                                  failureBlock(error);
                                                  break;
                                              }
                                              case 409:
                                              {
                                                  NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Content is only available in Pakistan " };
                                                  NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-1011 userInfo:userInfo];
                                                  failureBlock(error);
                                                  break;
                                              }
                                              default:
                                              {
                                                  
                                                  if ([responseObject isKindOfClass:[NSDictionary class]])
                                                  {
                                                      
                                                      
                                                      NSDictionary *res = [responseObject valueForKeyPath:@"error"];
                                                      NSNumber *statusCode = [res objectForKey:@"code"];
                                                      if ([statusCode intValue] == 409) {
                                                          NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Track Already Exists in Playlist." };
                                                          NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:409 userInfo:userInfo];
                                                          failureBlock(error);
                                                          break;
                                                      }
                                                  }
                                                  else
                                                  {
                                                      
                                                      NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Something went wrong please try again" };
                                                      NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:500 userInfo:userInfo];
                                                      failureBlock(error);
                                                      break;
                                                  }
                                              }
                                          }
                                          //                                        if(error.code == 500){
                                          //                                            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Internet is working slower.. Try again later..." };
                                          //                                            NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:101 userInfo:userInfo];
                                          //                                            failureBlock(error);
                                          //                                        } else {
                                          //                                            failureBlock(error);
                                          //                                        }
                                          
                                      }
                                  }] resume];
                            } else
                            {
                                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Invalid Login Details... Try Again..." };
                                NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
                                failureBlock(error);
                            }
                        } else
                            failureBlock(error);
                    }];
                } else
                {
                    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Please login First" };
                    NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
                    failureBlock(error);
                }
            } else
            {//check
                AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:method URLString:[NSString stringWithFormat:@"%@",URL] parameters:nil error:nil];
                req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
                [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                if(![body isEqualToString:@""])
                    [req setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
                if([[BaseController sharedInstance] checkIsUserLogin]){
                    FIRUser *user = [FIRAuth auth].currentUser;
                    [user getIDTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
                        if(!error){
                            if(token != nil)
                                
                                
                                
                                [req setValue:token forHTTPHeaderField:@"Authorization"];
                        }
                    }];
                }
                [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                    
                    
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                    NSInteger statusCode = httpResponse.statusCode;
                    
                    
                    
                    
                    NSLog(@"%ld", error.code);
                    if (!error) {
                        successBlock(responseObject);
                        /*if ([responseObject isKindOfClass:[NSDictionary class]]) {
                         successBlock(responseObject);
                         } else
                         failureBlock(error);*/
                    } else
                    {
                        
                        
                        switch (statusCode)
                        {
                                
                                
                            case 500:{
                                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Try again later..." };
                                NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:500 userInfo:userInfo];
                                failureBlock(error);
                                break;
                            }
                                //                            case 502:{
                                //                                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Internet is working slower.. Try again later..." };
                                //                                NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:502 userInfo:userInfo];
                                //                                failureBlock(error);
                                //                                break;
                                //                            }
                                //                            case 503:{
                                //                                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Internet is working slower.. Try again later..." };
                                //                                NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:503 userInfo:userInfo];
                                //                                failureBlock(error);
                                //                                break;
                                //                            }
                                //                            case 504:{
                                //                                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Internet is working slower.. Try again later..." };
                                //                                NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:504 userInfo:userInfo];
                                //                                failureBlock(error);
                                //                                break;
                                //                            }
                            case 404:{
                                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Nothing Found.. Try again later..." };
                                NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:404 userInfo:userInfo];
                                failureBlock(error);
                                break;
                            }
                            case 403:
                            {
                                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Content is only available in Pakistan " };
                                NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:403 userInfo:userInfo];
                                failureBlock(error);
                                break;
                            }
                                //                            case 18446744073709550605:
                                //                            {
                                //                                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Content is only available in Pakistan " };
                                //                                NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:403 userInfo:userInfo];
                                //                                failureBlock(error);
                                //                                break;
                                //                            }
                                //
                                
                            case 409:
                            {
                                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Content is only available in Pakistan " };
                                NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-1011 userInfo:userInfo];
                                failureBlock(error);
                                break;
                            }
                                //                            case -1011:{
                                //                                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Content is not available in your region..." };
                                //                                NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:403 userInfo:userInfo];
                                //                                failureBlock(error);
                                //                                break;
                                //                            }
                            default:{
                                
                                
                                failureBlock(error);
                                
                                
                                
                                
                                //                                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Something went wrong..." };
                                //                                NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:500 userInfo:userInfo];
                                //                                failureBlock(error);
                                
                                break;
                            }
                                
                        }
                        //                        if(error.code == 500){
                        //                            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Internet is working slower.. Try again later..." };
                        //                            NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:500 userInfo:userInfo];
                        //                            failureBlock(error);
                        //                        } else {
                        ////                            failureBlock(error);
                        //                        }
                    }
                }] resume];
            }
        }
        @catch (NSException *exception) {
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
            NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
            failureBlock(error);
        }
    });
}








// MARK: Miscellaneous

- (void)showLoading {
    if(![SVProgressHUD isVisible]){
        [[BaseController sharedInstance] setupLoading];
        [SVProgressHUD show];
    }
}

- (void)hideLoading {
    if([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
}
- (NSNumber *)getFormattedNumber:(NSDictionary *)data key:(NSString *)key{
    NSNumber *formattedNumber = 0;
    @try{
        if([data objectForKey:key])
            formattedNumber = [data objectForKey:key] == NULL ? [NSNumber numberWithInt:0] : @([[data objectForKey:key] integerValue]);
    } @catch (NSException *exception){
        formattedNumber = 0;
    } @finally{
        return formattedNumber;
    }
}

- (BOOL)getFormattedBool:(NSDictionary *)data key:(NSString *)key{
    BOOL formattedBool = NO;
    @try{
        if([data objectForKey:key])
            formattedBool = [[data objectForKey:key] boolValue];
    } @catch (NSException *exception){
        formattedBool = NO;
    } @finally{
        return formattedBool;
    }
}

- (NSString *)getFormattedString:(NSDictionary *)data key:(NSString *)key removeWhiteSpace:(BOOL)removeWhiteSpace{
    NSString *formattedString = @"";
    @try{
        if([data objectForKey:key])
            formattedString = [data objectForKey:key] == NULL ? @"" : [NSString stringWithFormat:@"%@", [data objectForKey:key]];
        if(removeWhiteSpace){
            formattedString = [formattedString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        }
    } @catch (NSException *exception){
        formattedString = @"";
    } @finally{
        return formattedString;
    }
}

- (NSString *)convertMPDtoHLS:(NSString *)link{
    NSString *hls = @"";
    @try{
        if(![link isEqualToString:@""]){
            hls = [link stringByReplacingOccurrencesOfString:@".mpd" withString:@".m3u8"];
        }
    } @catch (NSException *exception){
        hls = @"";
    } @finally{
        return hls;
    }
}


// MARK: home coursel fetch methods ::::::::::



- (NSMutableArray *)getBannersArrayFromJSON:(NSDictionary *)bannersArray{
    NSMutableArray * banners = [[NSMutableArray alloc] init];
    for (NSDictionary *singleBanner in bannersArray)
        [banners addObject:[self getBannerFromJSON:singleBanner]];
    return banners;
}

- (Banner *)getBannerFromJSON:(NSDictionary *)banner{
    NSNumber * ID = [self getFormattedNumber:banner key:@"id"];
    NSNumber * albumID = [self getFormattedNumber:banner key:@"album_id"];
    NSString * title = [self getFormattedString:banner key:@"name" removeWhiteSpace:NO];
    NSString * poster = [self getFormattedString:banner key:@"image" removeWhiteSpace:YES];
    NSString * year = [self getFormattedString:banner key:@"year" removeWhiteSpace:NO];
    NSString * type = [self getFormattedString:banner key:@"type" removeWhiteSpace:NO];
    NSString * videoURL = [self convertMPDtoHLS:[self getFormattedString:banner key:@"mpd_url" removeWhiteSpace:YES]];
    NSString * permalink = [self getFormattedString:banner key:@"share_url" removeWhiteSpace:YES];
    Banner *newBanner = [[Banner alloc] initWithID:ID albumId:albumID title:title poster:poster year:year type:type videoURL:videoURL permalink:permalink];
    return newBanner;
}

- (NSMutableArray *)getAlbumsArrayFromJSON:(NSDictionary *)albumsArray{
    NSMutableArray * albums = [[NSMutableArray alloc] init];
    for (NSDictionary *singleAlbum in albumsArray)
        [albums addObject:[self getAlbumFromJSON:singleAlbum]];
    return albums;
}

- (Album *)getAlbumFromJSON:(NSDictionary *)album{
    NSNumber * ID = ID = [self getFormattedNumber:album key:@"id"];
    
    NSString * title = @"";
    
    if([album objectForKey:@"title"])
    {
        title = [self getFormattedString:album key:@"title" removeWhiteSpace:NO];
    }
    
    NSString * poster = @"";
    
    if([album objectForKey:@"cover_url"])
    {
        
        poster = [self getFormattedString:album key:@"cover_url" removeWhiteSpace:YES];
        
    }
    
    NSString * permalink = @"";
    if([album objectForKey:@"permalink"])
        permalink = [self getFormattedString:album key:@"permalink" removeWhiteSpace:YES];
    else if ([album objectForKey:@"share_url"])
        permalink = [self getFormattedString:album key:@"share_url" removeWhiteSpace:YES];
    Album *newAlbum = [[Album alloc] initWithID:ID title:title poster:poster permalink:permalink];
    return newAlbum;
}

- (NSMutableArray *)getArtistsArrayFromJSON:(NSDictionary *)artistArray{
    NSMutableArray *artists = [[NSMutableArray alloc] init];
    for (NSDictionary *singleArtist in artistArray) {
        [artists addObject:[self getArtistFromJSON:singleArtist]];
    }
    return artists;
}

- (Artist *)getArtistFromJSON:(NSDictionary *)artist{
    NSNumber * ID = [self getFormattedNumber:artist key:@"id"];
    NSString * name = @"";
    if([artist objectForKey:@"name"])
        name = [self getFormattedString:artist key:@"name" removeWhiteSpace:NO];
    else if ([artist objectForKey:@"title"])
        name = [self getFormattedString:artist key:@"title" removeWhiteSpace:NO];
    NSString * poster = [self getFormattedString:artist key:@"cover_url" removeWhiteSpace:YES];
    Artist *newArtist = [[Artist alloc] initWithID:ID name:name poster:poster];
    return newArtist;
}



- (NSMutableArray *)getVideosArrayFromJSON:(NSDictionary *)videosArray{
    NSMutableArray * videos = [[NSMutableArray alloc] init];
    for (NSDictionary *singleVideo in videosArray)
        [videos addObject:[self getVideoFromJSON:singleVideo]];
    return videos;
}

- (Video *)getVideoFromJSON:(NSDictionary *)video
{
    NSNumber * ID = [self getFormattedNumber:video key:@"id"];;
    NSString * title = [self getFormattedString:video key:@"title" removeWhiteSpace:NO];
    NSString * albumName = [self getFormattedString:video key:@"album_title" removeWhiteSpace:NO];
    NSString * poster = [self getFormattedString:video key:@"cover_url" removeWhiteSpace:YES];
    NSString * permalink = [self getFormattedString:video key:@"permalink" removeWhiteSpace:YES];
    NSString * albumPermalink = [self getFormattedString:video key:@"album_permalink" removeWhiteSpace:YES];
    // NSString * videoUrl = [self getFormattedString:video key:@"video_url" removeWhiteSpace:YES];
    
    if(![albumPermalink isEqualToString:@""]){
        NSArray *myArray = [albumPermalink componentsSeparatedByString:@"songs/"];
        albumPermalink = myArray[1];
        if(![permalink isEqualToString:@""]){
            permalink = [NSString stringWithFormat:@"%@?album=%@",permalink,albumPermalink];
        }
    }
    
    //    if (videoUrl != nil || [videoUrl isEqualToString:@""]  ) {
    //
    //        videoUrl = @"https://bsongs-data.sgp1.cdn.digitaloceanspaces.com/encode/bollywood-gupshup/2019/making-of-wrong-no-2/making-of-wrong-no-2.m3u8" ;
    //
    //    }else {
    //
    //         videoUrl = [self convertMPDtoHLS:[self getFormattedString:video key:@"video_url" removeWhiteSpace:YES]];
    //    }
    //
    //
    //    if ([permalink isEqualToString:@""] || permalink == nil ) {
    //
    //        permalink = @"https://bestsongs.pk/videos/882960/" ;
    //
    //    }
    
    NSString * videoURL = [self convertMPDtoHLS:[self getFormattedString:video key:@"video_url" removeWhiteSpace:YES]];
    
    
    Video *newVideo = [[Video alloc] initWithID:ID title:title videoURL:videoURL albumName:albumName poster:poster permalink:permalink];
    
    return newVideo;
}

- (NSMutableArray *)getTracksArrayFromJSON:(NSDictionary *)tracksArray{
    NSMutableArray * tracks = [[NSMutableArray alloc] init];
    //for (NSDictionary *singleTrack in tracksArray)
    return tracks;
}

- (NSMutableArray *)getTracksArrayFromJSON:(NSDictionary *)tracksArray album:(Album *)album{
    NSMutableArray * tracks = [[NSMutableArray alloc] init];
    for (NSDictionary *singleTrack in tracksArray){
        [tracks addObject:[self getTrackFromJSON:singleTrack album:album]];
    }
    return tracks;
}

- (Song *)getTrackFromJSON:(NSDictionary *)track album:(Album *)album{
    NSNumber * ID = [self getFormattedNumber:track key:@"id"];
    NSNumber * albumID = [self getFormattedNumber:track key:@"album_id"];
    NSString * albumTitle = [self getFormattedString:track key:@"album_title" removeWhiteSpace:NO];
    albumTitle = [albumTitle isEqualToString:@""] ? album.Title : albumTitle;
    NSNumber * likes = [self getFormattedNumber:track key:@"likes"];
    NSString * title = [self getFormattedString:track key:@"title" removeWhiteSpace:NO];
    NSString * poster = [self getFormattedString:track key:@"cover_url" removeWhiteSpace:YES];
    poster = [poster isEqualToString:@""] ? album.Poster : poster;
    NSString * audioURL = [self getFormattedString:track key:@"audio_url" removeWhiteSpace:YES];
    NSString *permalink = album.Permalink;
    if(audioURL.length > 0){
        permalink = [audioURL lastPathComponent];
        if([permalink rangeOfString:@".mp3" options:NSCaseInsensitiveSearch].location != NSNotFound){
            NSArray *myArray = [permalink componentsSeparatedByString:@".mp3"];
            permalink = myArray[0];
        }
    }
    NSString * videoURL = [self convertMPDtoHLS:[self getFormattedString:track key:@"video_url" removeWhiteSpace:YES]];
    NSString * videoPermalink = [self getFormattedString:track key:@"video_permalink" removeWhiteSpace:YES];
    
    if(![album.Permalink isEqualToString:@""]){
        
        NSArray *myArray = [album.Permalink componentsSeparatedByString:@"songs/"];
        NSString * albumPermalink = myArray[1];
        if(![videoPermalink isEqualToString:@""]){
            videoPermalink = [NSString stringWithFormat:@"%@?album=%@",videoPermalink,albumPermalink];
        }
    }
    BOOL isDownload = NO;
    BOOL isVideo = NO;
    BOOL isLiked = [self getFormattedBool:track key:@"liked"];
    if(audioURL.length > 0)
        isDownload = YES;
    if(videoURL.length > 0)
        isVideo = YES;
    Song *newTrack = [[Song alloc] initWithID:ID albumId:albumID likes:likes title:title albumTitle:albumTitle poster:poster permalink:permalink audioURL:audioURL videoURL:videoURL videoPermalink:videoPermalink isDowload:isDownload isVideo:isVideo isLikes:isLiked];
    return newTrack;
}




- (NSMutableArray *)getPlaylistsArrayFromJSON:(NSDictionary *)playlistsArray{
    
    //    [self showLoading];
    
    NSMutableArray *playlists = [[NSMutableArray alloc] init];
    for (NSDictionary *singlePlaylist in playlistsArray){
        [playlists addObject:[self getPlaylistFromJSON:singlePlaylist]];
    }
    
    //    [self hideLoading];
    
    return playlists;
    
    
}

- (Playlist *)getPlaylistFromJSON:(NSDictionary *)playlist{
    
    //    [self showLoading];
    
    NSNumber * ID = [NSNumber numberWithInteger:0];
    NSNumber * bestsongID = [self getFormattedNumber:playlist key:@"id"];
    NSNumber * totalTracks = [self getFormattedNumber:playlist key:@"tracks_count"];
    NSNumber * currentRevision = [self getFormattedNumber:playlist key:@"currentrevision"];
    NSString * title = [self getFormattedString:playlist key:@"title" removeWhiteSpace:NO];
    Playlist *newPlaylist = [[Playlist alloc] initWithID:ID bestsongID:bestsongID totalTracks:totalTracks currentRevision:currentRevision title:title];
    
    //    [self hideLoading];
    
    return newPlaylist;
}


// MARK: create share link && create user



- (void)createUser:(User *)user
         onSuccess:(void (^)(id))successBlock
         onFailure:(void (^)(NSError *))failureBlock{
    @try {
        NSError *writeError = nil;
        NSDictionary *body = @{@"user": @{@"uid":user.UserID , @"name":user.Name , @"dob":user.DOB , @"gender":user.Gender , @"email":user.Email , @"phone" : @{@"no" : user.PhoneNo , @"type" : user.PhoneType }}};
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error: &writeError];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSURL *URL = [NSURL URLWithString:USERSURL];
        [self fetch:URL method:@"POST" body:jsonString isAuth:YES
          onSuccess:^(id responseObject) {
              successBlock(responseObject);
          } onFailure:^(NSError * error) {
              failureBlock(error);
          }];
        
    } @catch (NSException *exception) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
        failureBlock(error);
    } @finally {
    }
}

- (void)createShareLink:(NSString *)title
                message:(NSString *)message
              posterURL:(NSString *)posterURL
                   link:(NSString *)link
              onSuccess:(void (^)(id))successBlock
              onFailure:(void (^)(NSError *))failureBlock{
    @try {
        NSError *writeError = nil;
        NSString *apiKey = @"AIzaSyCrH9Jv2jgmyFXfIAgPsWwXHX2De5geSiA";
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?key=%@",FIREBASEDYNAMICLINKURL,apiKey]];
        NSString *dynamicLinkDomain = @"e644q.app.goo.gl";
        
        NSString *androidPackageName = @"pk.bestsongs.android";
        NSString *iosBundleId = @"pk.bestsongs.Bestsongs-pk";
        NSString *iosStoreID = @"1145380246";
        NSString *iosScheme = @"dlscheme";
        
        NSDictionary *body = @{@"dynamicLinkInfo": @{@"dynamicLinkDomain":dynamicLinkDomain , @"link":link , @"androidInfo" : @{@"androidPackageName" : androidPackageName , @"androidFallbackLink" : link }, @"iosInfo" : @{@"iosBundleId":iosBundleId , @"iosFallbackLink" : link , @"iosCustomScheme": iosScheme , @"iosIpadFallbackLink" : link , @"iosIpadBundleId" : iosBundleId , @"iosAppStoreId" : iosStoreID} , @"socialMetaTagInfo" : @{@"socialTitle" : title , @"socialDescription" : message , @"socialImageLink" : posterURL }}, @"suffix" : @{@"option" : @"SHORT"}};
        
        /*
         NSDictionary *body = @{@"dynamicLinkInfo": @{@"dynamicLinkDomain":dynamicLinkDomain , @"link":link , @"androidInfo" : @{@"androidPackageName" : androidPackageName , @"androidFallbackLink" : link }, @"iosInfo" : @{@"iosBundleId":iosBundleId , @"iosFallbackLink" : link , @"iosCustomScheme": iosScheme , @"iosIpadFallbackLink" : link , @"iosIpadBundleId" : iosBundleId} , @"socialMetaTagInfo" : @{@"socialTitle" : title , @"socialDescription" : message , @"socialImageLink" : posterURL }}, @"suffix" : @{@"option" : @"SHORT"}};
         */
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error: &writeError];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [self fetch:URL method:@"POST" body:jsonString isAuth:NO
          onSuccess:^(id responseObject) {
              successBlock(responseObject);
          } onFailure:^(NSError * error) {
              failureBlock(error);
          }];
    } @catch (NSException *exception) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
        failureBlock(error);
    } @finally {
    }
}

//- (void)createShareLink1:(NSString *)title
//                message:(NSString *)message
//              posterURL:(NSString *)posterURL
//                   link:(NSString *)link
//              onSuccess:(void (^)(id))successBlock
//              onFailure:(void (^)(NSError *))failureBlock{
//    @try {
//        NSError *writeError = nil;
//        NSString *apiKey = @"AIzaSyCrH9Jv2jgmyFXfIAgPsWwXHX2De5geSiA";
//        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?key=%@",FIREBASEDYNAMICLINKURL,apiKey]];
//        NSString *dynamicLinkDomain = @"e644q.app.goo.gl";
//
//        NSString *androidPackageName = @"pk.bestsongs.android";
//        NSString *iosBundleId = @"pk.bestsongs.Bestsongs-pk";
//        NSString *iosStoreID = @"1145380246";
//        NSString *iosScheme = @"dlscheme";
//
//        NSDictionary *body = @{@"dynamicLinkInfo": @{@"dynamicLinkDomain":dynamicLinkDomain , @"link":link , @"androidInfo" : @{@"androidPackageName" : androidPackageName , @"androidFallbackLink" : link }, @"iosInfo" : @{@"iosBundleId":iosBundleId , @"iosFallbackLink" : link , @"iosCustomScheme": iosScheme , @"iosIpadFallbackLink" : link , @"iosIpadBundleId" : iosBundleId , @"iosAppStoreId" : iosStoreID} , @"socialMetaTagInfo" : @{@"socialTitle" : title , @"socialDescription" : message , @"socialImageLink" : posterURL }}, @"suffix" : @{@"option" : @"SHORT"}};
//
//        /*
//         NSDictionary *body = @{@"dynamicLinkInfo": @{@"dynamicLinkDomain":dynamicLinkDomain , @"link":link , @"androidInfo" : @{@"androidPackageName" : androidPackageName , @"androidFallbackLink" : link }, @"iosInfo" : @{@"iosBundleId":iosBundleId , @"iosFallbackLink" : link , @"iosCustomScheme": iosScheme , @"iosIpadFallbackLink" : link , @"iosIpadBundleId" : iosBundleId} , @"socialMetaTagInfo" : @{@"socialTitle" : title , @"socialDescription" : message , @"socialImageLink" : posterURL }}, @"suffix" : @{@"option" : @"SHORT"}};
//         */
//
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error: &writeError];
//        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        [self fetch:URL method:@"POST" body:jsonString isAuth:NO
//          onSuccess:^(id responseObject) {
//              successBlock(responseObject);
//          } onFailure:^(NSError * error) {
//              failureBlock(error);
//          }];
//    } @catch (NSException *exception) {
//        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
//        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
//        failureBlock(error);
//    } @finally {
//    }
//}





//  MARK: get like track && Unlike Tracks



- (void)likeTrack:(NSString *)trackID
        onSuccess:(void (^)(id))successBlock
        onFailure:(void (^)(NSError *))failureBlock{
    @try {
        NSError *writeError = nil;
        NSDictionary *body = @{@"track": trackID};
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&writeError];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?action=like",BASEURL,TRACKSURL]];
        [self fetch:URL method:@"POST" body:jsonString isAuth:YES
          onSuccess:^(id responseObject) {
              successBlock(responseObject);
          } onFailure:^(NSError * error) {
              failureBlock(error);
          }];
    } @catch (NSException *exception) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
        failureBlock(error);
    } @finally {
    }
}

- (void)unLikeTrack:(NSString *)trackID
          onSuccess:(void (^)(id))successBlock
          onFailure:(void (^)(NSError *))failureBlock{
    @try {
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@?action=like",BASEURL,TRACKSURL,trackID]];
        [self fetch:URL method:@"DELETE" body:@"" isAuth:YES
          onSuccess:^(id responseObject) {
              successBlock(responseObject);
          } onFailure:^(NSError * error) {
              failureBlock(error);
          }];
    } @catch (NSException *exception) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
        failureBlock(error);
    } @finally {
    }
}

// MARK: playlist data operations


- (void)fetchPlaylists:(void (^)(id))successBlock
             onFailure:(void (^)(NSError *))failureBlock{
    @try {
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",PLAYLISTURL]];
        
        [self fetch:URL method:@"GET" body:@"" isAuth:YES
          onSuccess:^(id responseObject) {
              successBlock(responseObject);
          } onFailure:^(NSError * error) {
              failureBlock(error);
          }];
        
        
    } @catch (NSException *exception) {
        
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
        failureBlock(error);
        
    } @finally {
        
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:nil];
        failureBlock(error);
        
    }
}

- (void)createPlaylist:(NSString *)playlistName
             onSuccess:(void (^)(id))successBlock
             onFailure:(void (^)(NSError *))failureBlock{
    @try {
        NSError *writeError = nil;
        NSDictionary *body = @{@"playlist": @{@"title":playlistName}};
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error: &writeError];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",PLAYLISTURL]];
        [self fetch:URL method:@"POST" body:jsonString isAuth:YES
          onSuccess:^(id responseObject) {
              successBlock(responseObject);
          } onFailure:^(NSError * error) {
              failureBlock(error);
          }];
    } @catch (NSException *exception) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
        failureBlock(error);
    } @finally {
    }
}

- (void)updatePlaylist:(NSString *)bestsongID
          playlistName:(NSString *)playlistName
             onSuccess:(void (^)(id))successBlock
             onFailure:(void (^)(NSError *))failureBlock{
    @try {
        NSError *writeError = nil;
        NSDictionary *body = @{@"playlist": @{@"title":playlistName}};
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error: &writeError];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",PLAYLISTURL]];
        [self fetch:URL method:@"POST" body:jsonString isAuth:YES
          onSuccess:^(id responseObject) {
              successBlock(responseObject);
          } onFailure:^(NSError * error) {
              failureBlock(error);
          }];
    } @catch (NSException *exception) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
        failureBlock(error);
    } @finally {
    }
}

- (void)deletePlaylist:(NSString *)bestsongID
             onSuccess:(void (^)(id))successBlock
             onFailure:(void (^)(NSError *))failureBlock{
    @try {
        if ([bestsongID isEqualToString:@"0"] || bestsongID.length <= 0) {
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Playlist Cannot exists." };
            NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
            failureBlock(error);
            return;
        }
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",PLAYLISTURL,bestsongID]];
        [self fetch:URL method:@"DELETE" body:@"" isAuth:YES
          onSuccess:^(id responseObject) {
              successBlock(responseObject);
          } onFailure:^(NSError * error) {
              failureBlock(error);
          }];
    } @catch (NSException *exception) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
        failureBlock(error);
    } @finally {
    }
}

- (void)addTrackToPlaylist:(NSString *)bestsongID
                   trackID:(NSString *)trackID
                 onSuccess:(void (^)(id))successBlock
                 onFailure:(void (^)(NSError *))failureBlock{
    @try {
        NSError *writeError = nil;
        NSMutableDictionary *trackDetails = [[NSMutableDictionary alloc] init];
        [trackDetails setObject:trackID forKey:@"track"];
        NSArray *trackArray = [NSArray arrayWithObjects:trackDetails, nil];
        NSDictionary *body = @{@"playlist": bestsongID, @"playlistEntries": trackArray};
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&writeError];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",PLAYLISTTRACKSURL]];
        [self fetch:URL method:@"POST" body:jsonString isAuth:YES
          onSuccess:^(id responseObject) {
              successBlock(responseObject);
          } onFailure:^(NSError * error) {
              failureBlock(error);
          }];
    } @catch (NSException *exception) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
        failureBlock(error);
    } @finally {
    }
}

- (void)deleteTrackFromPlaylist:(NSString *)bestsongID
                        trackID:(NSString *)trackID
                      onSuccess:(void (^)(id))successBlock
                      onFailure:(void (^)(NSError *))failureBlock{
    @try {
        if ([bestsongID isEqualToString:@"0"] || bestsongID.length <= 0) {
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Playlist Cannot exists." };
            NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
            failureBlock(error);
            return;
        }
        if ([trackID isEqualToString:@"0"] || trackID.length <= 0) {
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Track Not exists." };
            NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
            failureBlock(error);
            return;
        }
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@?playlist_id=%@",BASEURL,TRACKSURL,trackID,bestsongID]];
        [self fetch:URL method:@"DELETE" body:@"" isAuth:YES
          onSuccess:^(id responseObject) {
              successBlock(responseObject);
          } onFailure:^(NSError * error) {
              failureBlock(error);
          }];
    } @catch (NSException *exception) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
        failureBlock(error);
    } @finally {
    }
}


// MARK: fetch for individual controllers ::;;


- (void)fetchPlaylistTracks:(NSString *)bestsongID
                  onSuccess:(void (^)(id))successBlock
                  onFailure:(void (^)(NSError *))failureBlock {
    @try {
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?playlist_id=%@",BASEURL,TRACKSURL,bestsongID]];
        [self fetch:URL method:@"GET" body:@"" isAuth:YES
          onSuccess:^(id responseObject) {
              successBlock(responseObject);
          } onFailure:^(NSError * error) {
              failureBlock(error);
          }];
    } @catch (NSException *exception) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
        failureBlock(error);
    } @finally {
    }
}



- (void)fetchHome:(void (^)(id))successBlock
        onFailure:(void (^)(NSError *))failureBlock{
    @try {
        NSURL *URL = [NSURL URLWithString:HOMEURL];
        [self fetch:URL method:@"GET" body:@"" isAuth:NO
          onSuccess:^(id responseObject) {
              successBlock(responseObject);
          } onFailure:^(NSError * error) {
              failureBlock(error);
          }];
    } @catch (NSException *exception) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
        failureBlock(error);
    } @finally {
    }
}

- (void)fetchBanner:(void (^)(id))successBlock
          onFailure:(void (^)(NSError *))failureBlock{
    @try {
        NSURL *URL = [NSURL URLWithString:BANNERURL];
        [self fetch:URL method:@"GET" body:@"" isAuth:NO
          onSuccess:^(id responseObject){
              successBlock(responseObject);
          } onFailure:^(NSError * error){
              failureBlock(error);
          }];
    } @catch (NSException *exception) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
        failureBlock(error);
    } @finally {
    }
}

- (void)fetchAlbumTracks:(NSNumber *)ID
               onSuccess:(void (^)(id))successBlock
               onFailure:(void (^)(NSError *))failureBlock{
    @try {
        NSLog(@" ID : %@",ID);
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",ALBUMURL,ID,TRACKSURL]];
        BOOL isAuth = [[BaseController sharedInstance] checkIsUserLogin] == YES ? YES : NO;
        [self fetch:URL method:@"GET" body:@"" isAuth:isAuth
          onSuccess:^(id responseObject) {
              successBlock(responseObject);
          } onFailure:^(NSError * error) {
              failureBlock(error);
          }];
    } @catch (NSException *exception) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
        failureBlock(error);
    } @finally {
    }
}

- (void)fetchBollywood:(NSNumber *)page
             onSuccess:(void (^)(id))successBlock
             onFailure:(void (^)(NSError *))failureBlock{
    @try {
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@&page=%@",BOLLYWOODURL,page]];
        [self fetch:URL method:@"GET" body:@"" isAuth:NO
          onSuccess:^(id responseObject) {
              successBlock(responseObject);
          } onFailure:^(NSError * error) {
              failureBlock(error);
          }];
    } @catch (NSException *exception) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
        failureBlock(error);
    } @finally {
    }
}

- (void)fetchBollywoodAlbum:(NSString *)alphabet
                       page:(NSNumber *)page
                  onSuccess:(void (^)(id))successBlock
                  onFailure:(void (^)(NSError *))failureBlock{
    @try {
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@&page=%@&alpt=%@",BOLLYWOODURL,page,alphabet]];
        [self fetch:URL method:@"GET" body:@"" isAuth:NO
          onSuccess:^(id responseObject) {
              successBlock(responseObject);
          } onFailure:^(NSError * error) {
              failureBlock(error);
          }];
    } @catch (NSException *exception) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
        failureBlock(error);
    } @finally {
    }
}

- (void)fetchArtists:(NSNumber *)page
           onSuccess:(void (^)(id))successBlock
           onFailure:(void (^)(NSError *))failureBlock{
    @try {
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?page=%@",ARTISTURL,page]];
        [self fetch:URL method:@"GET" body:@"" isAuth:NO
          onSuccess:^(id responseObject) {
              successBlock(responseObject);
          } onFailure:^(NSError * error) {
              failureBlock(error);
          }];
    } @catch (NSException *exception) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
        failureBlock(error);
    } @finally {
    }
}

- (void)fetchArtistAlphabet:(NSString *)alphabet
                       page:(NSNumber *)page
                  onSuccess:(void (^)(id))successBlock
                  onFailure:(void (^)(NSError *))failureBlock{
    @try {
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?page=%@&alpt=%@",ARTISTURL,page,alphabet]];
        [self fetch:URL method:@"GET" body:@"" isAuth:NO
          onSuccess:^(id responseObject) {
              successBlock(responseObject);
          } onFailure:^(NSError * error) {
              failureBlock(error);
          }];
    } @catch (NSException *exception) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
        failureBlock(error);
    } @finally {
    }
}

- (void)fetchArtistAlbums:(NSNumber *)ID
                     page:(NSNumber *)page
                onSuccess:(void (^)(id))successBlock
                onFailure:(void (^)(NSError *))failureBlock{
    @try {
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@&page=%@",ARTISTALBUM,ID,page]];
        [self fetch:URL method:@"GET" body:@"" isAuth:NO
          onSuccess:^(id responseObject) {
              successBlock(responseObject);
          } onFailure:^(NSError * error) {
              failureBlock(error);
          }];
    } @catch (NSException *exception) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
        failureBlock(error);
    } @finally {
    }
}

- (void)fetchMashup:(NSNumber *)page
          onSuccess:(void (^)(id))successBlock
          onFailure:(void (^)(NSError *))failureBlock{
    @try {
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@&page=%@",MASHUPURL,page]];
        [self fetch:URL method:@"GET" body:@"" isAuth:NO
          onSuccess:^(id responseObject) {
              successBlock(responseObject);
          } onFailure:^(NSError * error) {
              failureBlock(error);
          }];
    } @catch (NSException *exception) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
        failureBlock(error);
    } @finally {
    }
}

- (void)fetchPakistani:(NSNumber *)page
             onSuccess:(void (^)(id))successBlock
             onFailure:(void (^)(NSError *))failureBlock{
    @try {
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@&page=%@",PAKISTANIURL,page]];
        [self fetch:URL method:@"GET" body:@"" isAuth:NO
          onSuccess:^(id responseObject) {
              successBlock(responseObject);
          } onFailure:^(NSError * error) {
              failureBlock(error);
          }];
    } @catch (NSException *exception) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
        failureBlock(error);
    } @finally {
    }
}







- (void)fetchPakistaniAlbum:(NSString *)alphabet
                       page:(NSNumber *)page
                  onSuccess:(void (^)(id))successBlock
                  onFailure:(void (^)(NSError *))failureBlock{
    @try {
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@&page=%@&alpt=%@",PAKISTANIURL,page,alphabet]];
        [self fetch:URL method:@"GET" body:@"" isAuth:NO
          onSuccess:^(id responseObject) {
              successBlock(responseObject);
          } onFailure:^(NSError * error) {
              failureBlock(error);
          }];
    } @catch (NSException *exception) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
        failureBlock(error);
    } @finally {
    }
}

- (void)fetchDiscover:(NSString *)permalink
                 page:(NSNumber *)page
            onSuccess:(void (^)(id))successBlock
            onFailure:(void (^)(NSError *))failureBlock{
    @try {
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@&",DISCOVERURL,permalink]];
        
        if   ([permalink isEqualToString:@"balochi"])
        {
            URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@&page=%@",DISCOVERURL,permalink,page]];
            
        }
        
        if   ([permalink isEqualToString:@"sindhi"])
        {
            URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@&page=%@",DISCOVERURL,permalink,page]];
            
        }
        
        
        
        if   ([permalink isEqualToString:@"punjabi"])
        {
            URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@&page=%@",DISCOVERURL,permalink,page]];
            
        }
        
        if   ([permalink isEqualToString:@"saraiki"])
        {
            URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@&page=%@",DISCOVERURL,permalink,page]];
            
        }
        
        if   ([permalink isEqualToString:@"pashto"])
        {
            URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@&page=%@",DISCOVERURL,permalink,page]];
            
        }
        
        if([permalink isEqualToString:@"gupshups"]){
            
            URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",GUPSHUPURL,permalink]];
            
        }
        if([permalink isEqualToString:@"trailers"]){
            URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api-v2-dot-bestsongs-156307.appspot.com/api/v1/videos?cat_id=72&page=%@",page ]];
        }
        if([permalink isEqualToString:@"top_videos"]){
            
            URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api-v2-dot-bestsongs-156307.appspot.com/api/v1/videos?cat_id=73&page=%@",page ]];
            
        }
        if([permalink isEqualToString:@"evergreen"]){
            
            URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api-v2-dot-bestsongs-156307.appspot.com/api/v1/videos?cat_id=67&page=%@",page ]];
            
        }
        
        
        
        [self fetch:URL method:@"GET" body:@"" isAuth:NO
          onSuccess:^(id responseObject) {
              
              if([permalink isEqualToString:@"trailers"]){
                  
                  NSMutableArray *dataAlbums = (NSMutableArray *) responseObject ;
                  NSDictionary *dataDictionary = @{ @"videos" : dataAlbums } ;
                  
                  successBlock(dataDictionary);
                  
              }
              else if([permalink isEqualToString:@"top_videos"]){
                  
                  NSMutableArray *dataAlbums = (NSMutableArray *) responseObject ;
                  NSDictionary *dataDictionary = @{ @"videos" : dataAlbums } ;
                  successBlock(dataDictionary);
                  
              }
              else if([permalink isEqualToString:@"evergreen"]){
                  
                  NSMutableArray *dataAlbums = (NSMutableArray *) responseObject ;
                  NSDictionary *dataDictionary = @{ @"videos" : dataAlbums } ;
                  successBlock(dataDictionary);
                  
              }else {
                  
                  successBlock(responseObject);
                  
              }
              
          } onFailure:^(NSError * error) {
              failureBlock(error);
          }];
    } @catch (NSException *exception) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
        failureBlock(error);
    } @finally {
    }
}

- (void)fetchVideo:(NSString *)permalink
         onSuccess:(void (^)(id))successBlock
         onFailure:(void (^)(NSError *))failureBlock{
    @try {
        
        
        NSString *stringToBeRemovedFromPermalink = @"x&album";
        // fabric error fixed
        
        if ([permalink containsString:@"x&album"]) {
            stringToBeRemovedFromPermalink = @"x&album";
        }
        if ([permalink containsString:@"x?album"]) {
            stringToBeRemovedFromPermalink = @"x?album";
        }
        
        if ([permalink containsString:@"?album"]) {
            stringToBeRemovedFromPermalink = @"?album";
        }
        if ([permalink containsString:@"&album"]) {
            stringToBeRemovedFromPermalink = @"&album";
        }
        
        
        
        
        
        
        NSArray *tempPermaLinkArray = [permalink componentsSeparatedByString:stringToBeRemovedFromPermalink ];
        permalink = [tempPermaLinkArray objectAtIndex:0];
        
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?slug=%@",VIDEOURL,permalink]];
        NSLog(@"muneeb URL check  :: %@",URL);
        
        
        [self fetch:URL method:@"GET" body:@"" isAuth:NO
          onSuccess:^(id responseObject) {
              
              
              
              NSDictionary *dataDictionary = (NSDictionary *) responseObject;
              
              
              
              if ([dataDictionary[@"videos"] count] != 0) {
                  
                  Video *video = [self getVideoFromJSON:[dataDictionary[@"videos"] objectAtIndex:0]];
                  
                  successBlock(video);
                  
              }else {
                  
                  Video *video = nil;
                  
                  successBlock(video);
                  
              }
              
          } onFailure:^(NSError * error) {
              failureBlock(error);
          }];
    } @catch (NSException *exception) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
        failureBlock(error);
    } @finally {
    }
}

- (void)fetchAlbum:(NSString *)permalink
         onSuccess:(void (^)(id))successBlock
         onFailure:(void (^)(NSError *))failureBlock{
    @try {
        NSURL *URL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@?slug=%@",ALBUMURL,permalink]];
        //        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?slug=%@",ALBUMURL,permalink]];
        
        [self fetch:URL method:@"GET" body:@"" isAuth:NO
          onSuccess:^(id responseObject) {
              NSDictionary *dataDictionary = (NSDictionary *) responseObject;
              Album *album = [self getAlbumFromJSON:[dataDictionary[@"albums"] objectAtIndex:0]];
              successBlock(album);
          } onFailure:^(NSError * error) {
              failureBlock(error);
          }];
    } @catch (NSException *exception) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
        failureBlock(error);
    } @finally {
    }
}




@end
