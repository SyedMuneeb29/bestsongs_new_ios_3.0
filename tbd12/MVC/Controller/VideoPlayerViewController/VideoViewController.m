


//  VideoViewController.m
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 7/26/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "VideoViewController.h"
#import "AppDelegate.h"

@import GoogleMobileAds ;
#import "tbd12-Swift.h"

@import AVFoundation;

@interface VideoViewController () <IMAWebOpenerDelegate , IMAAdsLoaderDelegate, IMAAdsManagerDelegate> {
    CGFloat marginTop;
    
    // Gesture recognizer for tap on video
    UITapGestureRecognizer *videoTapRecognizer;
    ZFPlayerModel *playerModel;
    NSString *sharingLink;
    
    // SDK
    AVPlayer *contentPlayer;
    IMAAdsLoader *adsLoader;
    IMAAVPlayerContentPlayhead *contentPlayhead;
    IMAAdsManager *adsManager;
    NSTimer *timer;
    
    VideoViewCollection *videoCollectionsView ;
    
    UIWindow *window;
    UIView *statusBarForVideoController;
    UIView *bottomCoverBarForVideoController;
    
    BOOL autoPlayerAddIsRunning;
    BOOL adsManagerIsStarted;
    BOOL shareBtnClicked;
    
    
    // muneeb :
    NSMutableArray * videos;
    
    GADBannerView *bannerView ;
    GiveMeABannerDisplayAd *bannerViewDisplayerMachine ;
    UIView *videoView;
    VideoCollectionsView *videoCollectionView ;
    
    
}
@end

#define kAnimationDuration 0.2f

@implementation VideoViewController {
@private BOOL isStatusBarHidden;
@private BOOL isFullscreen;
@private BOOL isAddCompleted;
}



#pragma mark Video Collection View Setup START:

- (void) setupVideos {
    
    VideoWebService *webService = [VideoWebService new] ;
    
    if ( [_type isEqualToString:@"trailer"] ) {
        videos = [webService fetchVideosWithVideoType:VideoTypeTrailers] ;
    }
    if ( [_type isEqualToString:@"top_video"] || [_type isEqualToString:@"top_video_chart"] ) {
        videos = [webService fetchVideosWithVideoType:VideoTypeTopVideos] ;
    }
    if ( [_type isEqualToString:@"gupshup"] ) {
        videos = [webService fetchVideosWithVideoType:VideoTypeGupshup] ;
    }
    if ( [_type isEqualToString:@"evergreen"] ) {
        videos = [webService fetchVideosWithVideoType:VideoTypeEvergreen] ;
    }
    if ( [_type isEqualToString:@"track"] ) {
        videos = [webService fetchVideosWithVideoType:VideoTypeTracks] ;
    }
    if ( [_type isEqualToString:@""] || _type == nil  ) {
        videos = [webService fetchVideosWithVideoType:VideoTypeTracks] ;
    }
    if(!self.isAlreadyPlay){
        [self setupVideoCollectionViews ];
    }

    [videoCollectionView.collectionView refreshCollectionView] ;
   
    
    
}



- (void) setupVideoCollectionViews {
    
    videoCollectionView = [VideoCollectionsView new] ;
    videoCollectionView.collectionViewsDelegate = self ;
    //asd.collectionViewsDelegate = self ;
    
    [self.videoCollectionsView addSubview:videoCollectionView];
    
    
    
    [[videoCollectionView leftAnchor] constraintEqualToAnchor:self.videoCollectionsView.leftAnchor constant:0].active = YES ;
    [[videoCollectionView rightAnchor] constraintEqualToAnchor:self.videoCollectionsView.rightAnchor constant:0].active = YES ;
    [[videoCollectionView topAnchor] constraintEqualToAnchor:self.videoCollectionsView.topAnchor constant:0].active = YES ;
    [[videoCollectionView bottomAnchor] constraintEqualToAnchor:self.videoCollectionsView.bottomAnchor constant:0].active = YES ;
    
    
}


#pragma mark Video Collection View Setup END:


#pragma mark Like Dislike Implementation START:

- (void) updateLikeDislikeButtonAndLabelOfVideo:(VideoLikesDislikes*) video {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // perform operation into main thread change user interface like setting downloaded image into imageview
        
    
    if (video.disliked) {
        
        UIImage *image = [[UIImage imageNamed:@"ic_thumb_down_white_18pt_2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        [_dislikeButton setImage:image forState:UIControlStateNormal];
        _dislikeButton.tintColor = [[BaseController sharedInstance] getDefaultColor];
        
    } else {
       
        
        UIImage *image = [[UIImage imageNamed:@"ic_thumb_down_white_18pt_2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        [_dislikeButton setImage:image forState:UIControlStateNormal];
        _dislikeButton.tintColor = [UIColor whiteColor];
        
    }
    
    if (video.liked) {
        
        UIImage *image = [[UIImage imageNamed:@"ic_thumb_up_white_18pt_2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        [_likeButton setImage:image forState:UIControlStateNormal];
        _likeButton.tintColor = [[BaseController sharedInstance] getDefaultColor];
        
    }else {
        
        UIImage *image = [[UIImage imageNamed:@"ic_thumb_up_white_18pt_2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        [_likeButton setImage:image forState:UIControlStateNormal];
        _likeButton.tintColor = [UIColor whiteColor];
        
        
    }
    
    
    
    _likes.text = [NSString stringWithFormat:@"%ld",video.likes] ;
    _dislikes.text =[NSString stringWithFormat:@"%ld",video.dislikes] ;
    
    });
}

- (void) getVideoLikesAndDislikesHavingVideoId:(NSNumber*)videoId videoType:(NSString*)type withToken:(NSString*)token {
    
      VideoWebService *webService = [VideoWebService new] ;
    
    if ( [type isEqualToString:@"track"] ) {
        
        VideoLikesDislikes *video = [webService fetchVideoLikesAndDislikesWithVideoId:[videoId integerValue] videoType:@"tracks" userToken:token ] ;
        
        
        if (video == nil) {
            video = [webService fetchVideoLikesAndDislikesWithVideoId:[videoId integerValue] videoType:@"trailers" userToken:token ] ;
            _type = @"trailer" ;
            
            if (video == nil) {
                video = [webService fetchVideoLikesAndDislikesWithVideoId:[videoId integerValue] videoType:@"gupshups" userToken:token ] ;
                _type = @"gupshup" ;
                
                if (video == nil) {
                    video = [webService fetchVideoLikesAndDislikesWithVideoId:[videoId integerValue] videoType:@"evergreen" userToken:token ] ;
                    _type = @"evergreen" ;
                    
                }
            }
        }
        
        [self updateLikeDislikeButtonAndLabelOfVideo:video ] ;
        
    }
    else if ( [type isEqualToString:@"trailer"] ) {
        
        VideoLikesDislikes *video = [webService fetchVideoLikesAndDislikesWithVideoId:[videoId integerValue] videoType:@"trailers" userToken:token ] ;
        
        
        [self updateLikeDislikeButtonAndLabelOfVideo:video ] ;
    }
    else if ( [type isEqualToString:@"top_video"] ) {
        
        VideoLikesDislikes *video = [webService fetchVideoLikesAndDislikesWithVideoId:[videoId integerValue] videoType:@"top_videos" userToken:token ] ;
        
        
        if (video == nil) {
            video = [webService fetchVideoLikesAndDislikesWithVideoId:[videoId integerValue] videoType:@"trailers" userToken:token ] ;
             _type = @"trailer" ;
            
            if (video == nil) {
                video = [webService fetchVideoLikesAndDislikesWithVideoId:[videoId integerValue] videoType:@"gupshups" userToken:token ] ;
                _type = @"gupshup" ;

                if (video == nil) {
                    video = [webService fetchVideoLikesAndDislikesWithVideoId:[videoId integerValue] videoType:@"evergreen" userToken:token ] ;
                    _type = @"evergreen" ;
                    
                }
            }
        }
        
        [self updateLikeDislikeButtonAndLabelOfVideo:video ] ;
    }
    else if ( [type isEqualToString:@"gupshup"] ) {
        
        VideoLikesDislikes *video = [webService fetchVideoLikesAndDislikesWithVideoId:[videoId integerValue] videoType:@"gupshups" userToken:token ] ;
        
        
        [self updateLikeDislikeButtonAndLabelOfVideo:video ] ;
    }
    else if ( [type isEqualToString:@"evergreen"] ) {
        
        VideoLikesDislikes *video = [webService fetchVideoLikesAndDislikesWithVideoId:[videoId integerValue] videoType:@"evergreen" userToken:token ] ;
        
        [self updateLikeDislikeButtonAndLabelOfVideo:video ] ;
    }
    
    
}

- (void) getVideoLikesAndDislikesHavingVideoId:(NSNumber*)videoId videoType:(NSString*)type  {
    
     VideoWebService *webService = [VideoWebService new] ;

    
    if ( [type isEqualToString:@"track"] ) {
        
        VideoLikesDislikes *video = [webService fetchVideoLikesAndDislikesWithVideoId: [videoId integerValue] videoType:@"tracks"] ;
        
        [self updateLikeDislikeButtonAndLabelOfVideo:video ] ;
        
    }
    else if ( [type isEqualToString:@"trailer"] ) {
        
        VideoLikesDislikes *video = [webService fetchVideoLikesAndDislikesWithVideoId: [videoId integerValue] videoType:@"trailers"] ;
        
        [self updateLikeDislikeButtonAndLabelOfVideo:video ] ;
        
    }
    else if ( [type isEqualToString:@"top_video"] ) {
        
        VideoLikesDislikes *video = [webService fetchVideoLikesAndDislikesWithVideoId:[videoId integerValue] videoType:@"top_videos"  ] ;
        
        if (video == nil) {
            video = [webService fetchVideoLikesAndDislikesWithVideoId:[videoId integerValue] videoType:@"trailers" ] ;
            _type = @"trailer" ;
            
            if (video == nil) {
                video = [webService fetchVideoLikesAndDislikesWithVideoId:[videoId integerValue] videoType:@"gupshups" ] ;
                _type = @"gupshup" ;
                
                if (video == nil) {
                    video = [webService fetchVideoLikesAndDislikesWithVideoId:[videoId integerValue] videoType:@"evergreen"  ] ;
                    _type = @"evergreen" ;
                    
                }
            }
        }
        
        
        [self updateLikeDislikeButtonAndLabelOfVideo:video ] ;
        
        
    }
    else if ( [type isEqualToString:@"gupshup"] ) {
        
        VideoLikesDislikes *video = [webService fetchVideoLikesAndDislikesWithVideoId: [videoId integerValue] videoType:@"gupshups"] ;
        
        [self updateLikeDislikeButtonAndLabelOfVideo:video ] ;
        
    }
    else if ( [type isEqualToString:@"evergreen"] ) {
        
        VideoLikesDislikes *video = [ webService
                                      fetchVideoLikesAndDislikesWithVideoId: [videoId integerValue]
                                      videoType: @"evergreen"
                                     ] ;
        
        [self updateLikeDislikeButtonAndLabelOfVideo:video ] ;
        
    }
    
    
    
    
}



- (void) setupVideoLikeDislike {
    
    FIRUser *user = [FIRAuth auth].currentUser;
    
    if (user != nil ) {
        
        [user getIDTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
            if(!error)
            {
                if(token != nil)
                {
                    
                    [self getVideoLikesAndDislikesHavingVideoId:_video.ID videoType:_type withToken:token ] ;
                    [self setupVideos] ;
                    
                }else {
                    
                    [self getVideoLikesAndDislikesHavingVideoId:_video.ID videoType:_type ] ;
                    [self setupVideos] ;
                }
                
            }else {
                
                [self getVideoLikesAndDislikesHavingVideoId:_video.ID videoType:_type ] ;
                [self setupVideos] ;
            }
        }] ;
        
        
    }else {
        
        [self getVideoLikesAndDislikesHavingVideoId:_video.ID videoType:_type ] ;
        [self setupVideos] ;
    }
    
}



- (void) likeDislikeOperationHavingVideoId:(NSNumber*)videoId videoType:(NSString*)type videoAction:(NSString*)action userToken:(NSString*)token  {
    
    VideoWebService *webService = [VideoWebService new] ;
    
    if ( [type isEqualToString:@"track"] ) {
        
        
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            // perform background task like loading data from server like image data
            
            
            UsersVideoLikeDislike *video1 = [webService performLikeOrDislikeForVideoWithHavingVideoId:[videoId integerValue] videoType:@"tracks" andvideoAction:action userToken:token] ;
            
            VideoLikesDislikes *video =  [webService fetchVideoLikesAndDislikesWithVideoId:[videoId integerValue] videoType:@"tracks" userToken:token] ;
            
            
            
            [ self updateLikeDislikeButtonAndLabelOfVideo:video ] ;
            
            
        });
        
    }
    else if ( [type isEqualToString:@"trailer"] ) {
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            // perform background task like loading data from server like image data
            
            UsersVideoLikeDislike *video1 = [webService performLikeOrDislikeForVideoWithHavingVideoId:[videoId integerValue] videoType:@"trailers" andvideoAction:action userToken:token] ;
            
            VideoLikesDislikes *video =  [webService fetchVideoLikesAndDislikesWithVideoId:[videoId integerValue] videoType:@"trailers" userToken:token] ;
            [ self updateLikeDislikeButtonAndLabelOfVideo:video ] ;
            
            
        });
        
        
    }
    else if ( [type isEqualToString:@"top_video"] ) {
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            // perform background task like loading data from server like image data
            
            
            UsersVideoLikeDislike *video1 = [webService performLikeOrDislikeForVideoWithHavingVideoId:[videoId integerValue] videoType:@"top_videos" andvideoAction:action userToken:token] ;
            
            VideoLikesDislikes *video =  [webService fetchVideoLikesAndDislikesWithVideoId:[videoId integerValue] videoType:@"top_videos" userToken:token] ;
            
            [ self updateLikeDislikeButtonAndLabelOfVideo:video ] ;
            
        });
    }
    else if ( [type isEqualToString:@"gupshup"] ) {
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            // perform background task like loading data from server like image data
            
            
            UsersVideoLikeDislike *video1 = [webService performLikeOrDislikeForVideoWithHavingVideoId:[videoId integerValue] videoType:@"gupshups" andvideoAction:action userToken:token] ;
            
            VideoLikesDislikes *video =  [webService fetchVideoLikesAndDislikesWithVideoId:[videoId integerValue] videoType:@"gupshups" userToken:token] ;
            
            [ self updateLikeDislikeButtonAndLabelOfVideo:video ] ;
            
        });
    }
    else if ( [type isEqualToString:@"evergreen"] ) {
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            // perform background task like loading data from server like image data
            
            
            UsersVideoLikeDislike *video1 = [webService performLikeOrDislikeForVideoWithHavingVideoId:[videoId integerValue] videoType:@"evergreen" andvideoAction:action userToken:token] ;
            
            VideoLikesDislikes *video =  [webService fetchVideoLikesAndDislikesWithVideoId:[videoId integerValue] videoType:@"evergreen" userToken:token] ;
            
            
            [ self updateLikeDislikeButtonAndLabelOfVideo:video ] ;
            
        });
        
        
        
    }
    
}


- (void) performEitherLike:(BOOL) like orDislike:(BOOL) dislike {
    
    
    FIRUser *user = [FIRAuth auth].currentUser;
    
    if (user != nil ) {
        
        [user getIDTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
            if(!error)
            {
                if(token != nil)
                {
                    
                    if (like) {
                        
                        [self likeDislikeOperationHavingVideoId:_video.ID videoType:_type videoAction:@"like" userToken:token] ;
                        
                    } else if (dislike) {
                        
                        [self likeDislikeOperationHavingVideoId:_video.ID videoType:_type videoAction:@"dislike" userToken:token] ;
                        
                    }
                    
                    
                }else {
                    
                    [[BaseController sharedInstance] showToastError:@"Something went wrong please login again to conplete this action"];
                }
                
            }else {
                
                [[BaseController sharedInstance] showToastError:@"Something went wrong please login again to complete this action"];
                
            }
        }] ;
        
        
    }else {
        
        [[BaseController sharedInstance] showToastError:@"Please Login to perform this action"];
        
    }
    
    
    
}


- (IBAction)likeButton:(id)sender {
    
    [self performEitherLike:YES orDislike:NO];
    
}


- (IBAction)disLikeButton:(id)sender {
    
    [self performEitherLike:NO orDislike:YES];
    
}






#pragma mark Like Dislike Implementation END:


//
//- (void) setupVideoItemClick {
//
//
//    [[BaseController sharedInstance]
//     openVideoPlayerWithType:self.storyboard
//     andVideo:_video
//     andRootViewController:self.view.window.rootViewController
//     andType:@"trailer"];
//
//
//}




- (IBAction)shareBtn:(id)sender {


    if ( ![_type isEqualToString:@""] && _video.ID != nil ) {


        if(!isAddCompleted){
            [self.view makeToast:@"Wait till advertisement complete"] ;
            [CSToastManager setTapToDismissEnabled:YES] ;
            [CSToastManager setQueueEnabled:NO] ;
            return ;
        }

            [self.playerView pause];
            [contentPlayer pause];
            [adsManager pause];

            dispatch_async(dispatch_get_main_queue(), ^{

                shareBtnClicked = true ;

                NSString *shareMSG = self.video.Title;
                if([self.video.AlbumName isEqualToString:@""])
                    shareMSG = self.video.Title;

                if ( ![_type isEqualToString:@""]){


                    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
                    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
                    [SVProgressHUD showWithStatus:@"Generating Share Link"];
                    [CSToastManager setTapToDismissEnabled:YES];
                    [CSToastManager setQueueEnabled:NO];

                    // zohaib share url fetch made by muneeb

                    NSString *urlString =  [NSString stringWithFormat:@"https://api2-dot-bestsongs-156307.appspot.com/v1/videos/%@/share_url?type=%@",_video.ID,_type];
                    if ( [_type isEqualToString:@"evergreen"]  ) {
                        urlString =  [NSString stringWithFormat:@"https://api2-dot-bestsongs-156307.appspot.com/v1/videos/%@/share_url?type=%@",_video.ID,@"top_video"];
                    }
                    
                    NSURL *urlToFetchShareURL = [NSURL URLWithString:urlString];

                    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:urlToFetchShareURL];

                    //create the Method "GET"
                    [urlRequest setHTTPMethod:@"GET"];

                    NSURLSession *session = [NSURLSession sharedSession];

                    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                                      {
                                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                                          if(httpResponse.statusCode == 200)
                                                          {
                                                              [SVProgressHUD dismiss];

                                                              NSError *parseError = nil;
                                                              NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                                              NSLog(@"The response is - %@",responseDictionary);


                                                              [SVProgressHUD dismiss];
                                                              NSDictionary *dataDictionary = responseDictionary;
                                                              sharingLink = dataDictionary[@"share_url"];
                                                              NSString * message = [NSString stringWithFormat:@"Play and enjoy %@",_video.Title];
                                                              NSArray * shareItems = @[message, sharingLink];
                                                              UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
                                                              activityViewControntroller.excludedActivityTypes = @[];
                                                              if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                                                                  activityViewControntroller.popoverPresentationController.sourceView = self.view;
                                                                  activityViewControntroller.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/4, 0, 0);
                                                              }


                                                              [self presentViewController:activityViewControntroller animated:true completion:nil];


                                                          }
                                                          else
                                                          {
                                                              [SVProgressHUD dismiss];
                                                              [[BaseController sharedInstance] showToastError:error.localizedDescription];


                                                              if ([error.localizedDescription containsString:@"Pakistan"] || [error.localizedDescription containsString:@"available"]) {

                                                                  [self contentNotAvailablePopUp];

                                                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"videoViewIsDisplayed" object:nil];

                                                              } else {

                                                              }

                                                          }
                                                      }];
                    [dataTask resume];

                    // zohaib share url fetch made by muneeb

                }
                else if(!(self.video.Permalink == nil)){

                    if(sharingLink == nil){

                        [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
                        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
                        [SVProgressHUD showWithStatus:@"Generating Share Link"];
                        [CSToastManager setTapToDismissEnabled:YES];
                        [CSToastManager setQueueEnabled:NO];


                        [[BestsongsAPI sharedInstance] createShareLink:_video.Title
                                                               message:shareMSG
                                                             posterURL:_video.Poster
                                                                  link:_video.Permalink

                                                             onSuccess:^(id response)
                         {
                             [SVProgressHUD dismiss];
                             NSLog(@"key111::: %@",response);
                             NSDictionary *dataDictionary = (NSDictionary *) response;
                             sharingLink = dataDictionary[@"shortLink"];
                             NSString * message = [NSString stringWithFormat:@"Play and enjoy %@",_video.Title];
                             NSArray * shareItems = @[message, sharingLink];
                             UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
                             activityViewControntroller.excludedActivityTypes = @[];
                             if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                                 activityViewControntroller.popoverPresentationController.sourceView = self.view;
                                 activityViewControntroller.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/4, 0, 0);
                             }


                             [self.playerView pause];
                             [self presentViewController:activityViewControntroller animated:true completion:nil];
                         }
                                                             onFailure:^(NSError *error)
                         {
                             [SVProgressHUD dismiss];
                             [[BaseController sharedInstance] showToastError:error.localizedDescription];
                         }];



                    } else {
                        NSString * message = [NSString stringWithFormat:@"Play and enjoy %@",_video.Title];
                        NSArray * shareItems = @[message, sharingLink];
                        UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
                        activityViewControntroller.excludedActivityTypes = @[];
                        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                            activityViewControntroller.popoverPresentationController.sourceView = self.view;
                            activityViewControntroller.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/4, 0, 0);
                        }
                        [self presentViewController:activityViewControntroller animated:true completion:nil];
                    }


                }//else if type == nil




            });




    }
//    else if(![self.video.Permalink isEqualToString:@""] && self.video.Permalink.length > 20){
//        if(!isAddCompleted){
//            [self.view makeToast:@"Wait till advertisement complete"];
//            [CSToastManager setTapToDismissEnabled:YES];
//            [CSToastManager setQueueEnabled:NO];
//            return;
//        }
//        if(!(self.video.Permalink == nil)){
//            [self.playerView pause];
//            [contentPlayer pause];
//            [adsManager pause];
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                shareBtnClicked = true ;
//
//                NSString *shareMSG = self.video.Title;
//                if([self.video.AlbumName isEqualToString:@""])
//                    shareMSG = self.video.Title;
//
//                if ( ![_type isEqualToString:@""]){
//
//
//                    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
//                    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
//                    [SVProgressHUD showWithStatus:@"Generating Share Link"];
//                    [CSToastManager setTapToDismissEnabled:YES];
//                    [CSToastManager setQueueEnabled:NO];
//
//                    // zohaib share url fetch made by muneeb
//
//                    NSString *urlString =  [NSString stringWithFormat:@"https://api2-dot-bestsongs-156307.appspot.com/v1/videos/%@/share_url?type=%@",_video.ID,_type];
//                    NSURL *urlToFetchShareURL = [NSURL URLWithString:urlString];
//
//                    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:urlToFetchShareURL];
//
//                    //create the Method "GET"
//                    [urlRequest setHTTPMethod:@"GET"];
//
//                    NSURLSession *session = [NSURLSession sharedSession];
//
//                    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
//                                                      {
//                                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//                                                          if(httpResponse.statusCode == 200)
//                                                          {
//                                                              [SVProgressHUD dismiss];
//
//                                                              NSError *parseError = nil;
//                                                              NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
//                                                              NSLog(@"The response is - %@",responseDictionary);
//
//
//                                                              [SVProgressHUD dismiss];
//                                                              NSDictionary *dataDictionary = responseDictionary;
//                                                              sharingLink = dataDictionary[@"share_url"];
//                                                              NSString * message = [NSString stringWithFormat:@"Play and enjoy %@",_video.Title];
//                                                              NSArray * shareItems = @[message, sharingLink];
//                                                              UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
//                                                              activityViewControntroller.excludedActivityTypes = @[];
//                                                              if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//                                                                  activityViewControntroller.popoverPresentationController.sourceView = self.view;
//                                                                  activityViewControntroller.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/4, 0, 0);
//                                                              }
//
//
//                                                              [self presentViewController:activityViewControntroller animated:true completion:nil];
//
//
//                                                          }
//                                                          else
//                                                          {
//                                                              [SVProgressHUD dismiss];
//                                                              [[BaseController sharedInstance] showToastError:error.localizedDescription];
//
//
//                                                              if ([error.localizedDescription containsString:@"Pakistan"] || [error.localizedDescription containsString:@"available"]) {
//
//                                                                  [self contentNotAvailablePopUp];
//
//                                                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"videoViewIsDisplayed" object:nil];
//
//                                                              } else {
//
//                                                              }
//
//                                                          }
//                                                      }];
//                    [dataTask resume];
//
//                    // zohaib share url fetch made by muneeb
//
//                }
//
//
//                else{
//
//
//
//                    if(sharingLink == nil){
//
//                        [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
//                        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
//                        [SVProgressHUD showWithStatus:@"Generating Share Link"];
//                        [CSToastManager setTapToDismissEnabled:YES];
//                        [CSToastManager setQueueEnabled:NO];
//
//
//                        [[BestsongsAPI sharedInstance] createShareLink:_video.Title
//                                                               message:shareMSG
//                                                             posterURL:_video.Poster
//                                                                  link:_video.Permalink
//
//                                                             onSuccess:^(id response)
//                         {
//                             [SVProgressHUD dismiss];
//                             NSLog(@"key111::: %@",response);
//                             NSDictionary *dataDictionary = (NSDictionary *) response;
//                             sharingLink = dataDictionary[@"shortLink"];
//                             NSString * message = [NSString stringWithFormat:@"Play and enjoy %@",_video.Title];
//                             NSArray * shareItems = @[message, sharingLink];
//                             UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
//                             activityViewControntroller.excludedActivityTypes = @[];
//                             if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//                                 activityViewControntroller.popoverPresentationController.sourceView = self.view;
//                                 activityViewControntroller.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/4, 0, 0);
//                             }
//
//
//                             [self.playerView pause];
//                             [self presentViewController:activityViewControntroller animated:true completion:nil];
//                         }
//                                                             onFailure:^(NSError *error)
//                         {
//                             [SVProgressHUD dismiss];
//                             [[BaseController sharedInstance] showToastError:error.localizedDescription];
//                         }];
//
//
//
//                    } else {
//                        NSString * message = [NSString stringWithFormat:@"Play and enjoy %@",_video.Title];
//                        NSArray * shareItems = @[message, sharingLink];
//                        UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
//                        activityViewControntroller.excludedActivityTypes = @[];
//                        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//                            activityViewControntroller.popoverPresentationController.sourceView = self.view;
//                            activityViewControntroller.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/4, 0, 0);
//                        }
//                        [self presentViewController:activityViewControntroller animated:true completion:nil];
//                    }
//
//
//                }//else if type == nil
//
//            });
//        }
//    }
//    else {
//        [self.view makeToast:@"Share URL not found"];
//        [CSToastManager setTapToDismissEnabled:YES];
//        [CSToastManager setQueueEnabled:NO];
//    }


}


- (IBAction)didTap:(id)sender{
    if(timer != nil){
        @try{
            [timer invalidate];
            timer = nil;
            [self.playerView resetPlayer];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pauseVideoPlayerAudio" object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"playVideoPlayerAudio" object:nil];
        }@catch(id anException){
        }
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        [self dismissViewControllerAnimated:YES completion:nil];
        
        //////////////////////
        [[NSNotificationCenter defaultCenter] postNotificationName:@"videoViewIsDisappearing" object:nil];
        //////////////////////
        
        [videoCollectionView deInitialize];
        
        
        //        statusBarForVideoController.alpha = 0;
        //        bottomCoverBarForVideoController.alpha = 0;
    } else {
        [self.view makeToast:@"Press back again to exit" duration:[CSToastManager defaultDuration] position:CSToastPositionCenter];
        [CSToastManager setTapToDismissEnabled:YES];
        [CSToastManager setQueueEnabled:NO];
        timer = [NSTimer scheduledTimerWithTimeInterval: 3.0
                                                 target: self
                                               selector:@selector(onTick)
                                               userInfo: nil repeats:NO];
        
    }
}

-(void)onTick{
    [timer invalidate];
    timer = nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent                                                                                                                                    ;
}



- (void) setupAdsView {
    
    
    
    
    bannerViewDisplayerMachine = [[GiveMeABannerDisplayAd alloc] init] ;

    bannerView = [bannerViewDisplayerMachine
                  gievMeABannerViewWithAdUnitId: @"/21792359936/Mobile_Leaderboard_App_320x50"
                  andAdSize:bannerViewDisplayerMachine.sizePortraitBanner
                  rootVC:self
                  delegate:bannerViewDisplayerMachine] ;

    [bannerViewDisplayerMachine loadAdWithBannerView:bannerView] ;

    [_adsView addSubview:bannerView] ;



    
    bannerView.backgroundColor = UIColor.clearColor ;

    
}


#pragma mark


- (void)viewWillLayoutSubviews {
  

}

- (void)viewWillAppear:(BOOL)animated {
    
    [[ NSNotificationCenter defaultCenter ] postNotificationName:@"hideHomeAdd" object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
  
    
}


// Set up the new view controller.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        
        [_adsContainerView.heightAnchor constraintEqualToConstant:90].active = YES;
        
        
    }else if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {

        [_adsContainerView.heightAnchor constraintEqualToConstant:50].active = YES;
        
    }
    
    
    NSLog( @"joke : %@" , _video.ID) ;
    
    
    [self hideLoading2];
    //     _bottomBar.backgroundColor = _topBar.backgroundColor;
    
    //    [[[UIApplication sharedApplication] delegate] performSelector:@selector(applicationDidEnterBackground:)];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"videoViewIsDisplayed" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(applicationDidEnterBackground) name: UIApplicationDidEnterBackgroundNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(applicationWillEnterForeground) name: UIApplicationWillEnterForegroundNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(applicationWillResignActive) name: UIApplicationWillResignActiveNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(applicationDidBecomeActive) name: UIApplicationDidBecomeActiveNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAudioSessionEvent:) name:AVAudioSessionInterruptionNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(repeatPlayAction) name: @"replayButtonHasBeenPressed" object: nil];

  
    
    self.isAlreadyPlay = NO;
    [[PlayerViewController sharedInstance] pause];
    
    sharingLink = nil;
    marginTop = -1;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        marginTop = -96;
    
    UIColor *colour = [[UIColor alloc]initWithRed:255.0/255.0 green:64.0/255.0 blue:129.0/255.0 alpha:1.0];
    
    self.spinner.tintColor = colour;
    self.spinner.lineWidth = 3.5f;
    
    CGFloat spacing = 3.0;
    // Back Button
    CGSize imageSize = self.backButton.imageView.image.size;
    self.backButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    CGSize titleSize = [self.backButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.backButton.titleLabel.font}];
    self.backButton.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
    CGFloat edgeOffset = fabs(titleSize.height - imageSize.height) / 2.0;
    self.backButton.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset, 0.0, edgeOffset, 0.0);
    [self.backButton addTarget:self action:@selector(didTap:) forControlEvents:UIControlEventTouchUpInside];
    
    // Like Button
    
    //self.likeButton.titleLabel.text = @"";
    /*
     
     imageSize = self.likeButton.imageView.image.size;
     self.likeButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
     titleSize = [self.likeButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.likeButton.titleLabel.font}];
     self.likeButton.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
     edgeOffset = fabs(titleSize.height - imageSize.height) / 2.0;
     self.likeButton.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset, 0.0, edgeOffset, 0.0);
     
     */
    //
    //    // Share Button
    //    imageSize = self.shareButton.imageView.image.size;
    //    self.shareButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    //    titleSize = [self.shareButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.shareButton.titleLabel.font}];
    //    self.shareButton.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
    //    edgeOffset = fabs(titleSize.height - imageSize.height) / 2.0;
    //    self.shareButton.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset, 0.0, edgeOffset, 0.0);
    
    isStatusBarHidden = NO;
    isFullscreen = NO;
    isAddCompleted = NO;
    
    

    
    window = [UIApplication sharedApplication].keyWindow;
    
    statusBarForVideoController = [[UIView alloc] init];
    statusBarForVideoController.backgroundColor = _topBar.backgroundColor;
    statusBarForVideoController.translatesAutoresizingMaskIntoConstraints = false;
    
    
    [self.view addSubview:statusBarForVideoController];
    [self.view bringSubviewToFront:statusBarForVideoController];
    
    [statusBarForVideoController.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:0].active = true;
    [statusBarForVideoController.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:0].active = true;
    [statusBarForVideoController.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:0].active = true;
    
    
    bottomCoverBarForVideoController = [[UIView alloc] init];
    bottomCoverBarForVideoController.backgroundColor = _bottomBar.backgroundColor;
    bottomCoverBarForVideoController.translatesAutoresizingMaskIntoConstraints = false;
    
    
    [window addSubview:bottomCoverBarForVideoController];
    [window bringSubviewToFront:bottomCoverBarForVideoController];
    
    [bottomCoverBarForVideoController.bottomAnchor constraintEqualToAnchor:window.bottomAnchor constant:0].active = true;
    [bottomCoverBarForVideoController.leftAnchor constraintEqualToAnchor:window.leftAnchor constant:0].active = true;
    [bottomCoverBarForVideoController.rightAnchor constraintEqualToAnchor:window.rightAnchor constant:0].active = true;
    
    
    
    switch ((int)[[UIScreen mainScreen] nativeBounds].size.height) {
            
            
        case 2436:
            printf("iPhone X");
            [self.topBar.topAnchor constraintEqualToAnchor:
             self.view.topAnchor constant:
             33].active = true ;
            [statusBarForVideoController.heightAnchor constraintEqualToConstant:33].active = true;
            
            
            
            
            [self.bottomBar.bottomAnchor constraintEqualToAnchor:
             self.view.bottomAnchor constant:
             -12].active = true ;
            [bottomCoverBarForVideoController.heightAnchor constraintEqualToConstant:12].active = true;
            
            
            break;
            
        default:
            printf("unknown");
            [statusBarForVideoController.heightAnchor constraintEqualToConstant:23].active = true;
            [self.topBar.topAnchor constraintEqualToAnchor:
             self.view.topAnchor constant:
             23].active = true ;
            [bottomCoverBarForVideoController.heightAnchor constraintEqualToConstant:0].active = true;
    }
    
    
    
//    [self setupVideos] ;
//    [self setupVideoCollectionViews ];
//
    
    [self setupAdsView];
    [self fabricContentViewPlugin];
    


    dispatch_async(dispatch_get_main_queue(), ^ {
        [self retrieveData];
    });
    
    
    
    
    
    //    videoCollectionsView = [[VideoViewCollection alloc] init];
    //
    //    [self.view addSubview:videoCollectionsView];
    //
    //    [self.view bringSubviewToFront:videoCollectionsView];
    //
    //    [videoCollectionsView.topAnchor
    //     constraintEqualToAnchor:self.bottomBar.bottomAnchor
    //     constant:2].active = true;
    //
    //    [videoCollectionsView.leftAnchor
    //     constraintEqualToAnchor:self.view.leftAnchor
    //     constant:0].active = true;
    //
    //    [videoCollectionsView.rightAnchor
    //     constraintEqualToAnchor:self.view.rightAnchor
    //     constant:0].active = true;
    //
    //    switch ((int)[[UIScreen mainScreen] nativeBounds].size.height) {
    //
    //
    //        case 2436:
    //            printf("iPhone X");
    //              [videoCollectionsView.bottomAnchor
    ////            constraintEqualToAnchor:self.view.bottomAnchor
    ////            constant:-33].active = true;
    //            break;
    //
    //        default:
    //            [videoCollectionsView.bottomAnchor
    //            constraintEqualToAnchor:self.view.bottomAnchor
    //            constant:0].active = true;
    //            break;
    //
    //    }
    //
    //
    //}
    //
    //
    //- (void)applicationDidEnterBackground {
    //    printf("applicationDidEnterBackground\n");
    //    if(!isAddCompleted) {
    //
    //        [self.playerView pause];
    //        [contentPlayer pause];
    //        [adsManager destroy];
    //
    //    }
    //    else
    //    {
    //        [self.playerView pause];
    //
    //        [contentPlayer play];
    //
    //    }
    
    
    [[ NSNotificationCenter defaultCenter ] postNotificationName:@"hideHomeAdd" object:nil];
    
}




- (void)viewWillDisappear:(BOOL)animated {
    // Don't reset if we're presenting a modal view (e.g. in-app clickthrough).
    printf("viewWillDisappear\n");
    
    
    
    
    [contentPlayer pause];
    [adsManager destroy];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        if (adsManager) {
            [adsManager destroy];
            adsManager = nil;
        }
        contentPlayer = nil;
    }
    
    
    
    UIApplicationState state = UIApplication.sharedApplication.applicationState ;
    
    
    if (!shareBtnClicked && state != 0){
        
        [self reset];
        [self setupAdsLoader];
        [self requestAds];
        [self HideLoading];
        
        [super viewWillDisappear:animated];
        
    }else{
        
        shareBtnClicked = false;
        
    }
    
    
    
    //   [[NSNotificationCenter defaultCenter] postNotificationName:@"videoViewIsDisappearing" object:nil];
}

- (void)applicationWillResignActive {
    printf("applicationWillResignActive\n");
    //        isAddCompleted = NO;
    
    if(!isAddCompleted) {
        
        [self.playerView pause];
        [contentPlayer pause];
        [adsManager pause];
    }
    
}

- (void)applicationDidBecomeActive {
    
    printf("applicationDidBecomeActive\n");
    if (adsManager != nil){
        if (adsManagerIsStarted){
            [adsManager resume];
        }
    }
}

- (void)applicationDidEnterBackground{
    printf("applicationDidEnterBackground");
    
    if(!isAddCompleted) {
        
        [self.playerView pause];
        [contentPlayer pause];
        [adsManager destroy];
    }
}

- (void)applicationWillEnterForeground {
    printf("applicationWillEnterForeground\n");
    if(!isAddCompleted) {
        [self reset];
        //  [self setupAdsLoader];
        [self setUpContentPlayer];
        [self requestAds];
    }
}

- (void)dismissController{
    
    @try{
        [self.playerView resetPlayer];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pauseVideoPlayerAudio" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"playVideoPlayerAudio" object:nil];
    } @catch(id anException){
    }
    [self reset];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)fabricContentViewPlugin {
    
    [Answers logCustomEventWithName:@"Video View"
                   customAttributes:
     @{
       @"Video Name" : self.video.Title,
       @"Device Type" : @"iOS",
       }
     ];
    
    
    
    
}

- (void) onAudioSessionEvent: (NSNotification *) notification {
    
    
    if ([notification.name isEqualToString:AVAudioSessionInterruptionNotification]) {
        
        if ([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeBegan]]) {
            
            if(!isAddCompleted) {
                
                [self.playerView pause];
                [contentPlayer pause];
                [adsManager destroy];
                
            }
            else
            {
                [self.playerView pause];
                [contentPlayer play];
                
            }
            
        } else {
            if(!isAddCompleted) {
                
                [self.playerView pause];
                [contentPlayer pause];
                [adsManager destroy];
                
                [self reset];
                [self setupAdsLoader];
                [self setUpContentPlayer];
                [self requestAds];
            }
            else
            {
                [self.playerView pause];
                
                [contentPlayer play];
                
            }
        }
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)HideLoading {
    [self.spinner stopAnimating];
    self.spinner.hidden = YES;
}


- (void)showLoading2 {
    if(![SVProgressHUD isVisible]){
        
        [[BaseController sharedInstance] setupLoading];
        
        int screenSize =(int)[[UIScreen mainScreen] nativeBounds].size.height / 36;
        
        [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, (CGFloat)screenSize )];
        
        [SVProgressHUD show];
    }
}


- (void)hideLoading2 {
//    if([SVProgressHUD isVisible])
//        [SVProgressHUD dismiss];
}


-(void)ShowLoading {
//    [self.spinner startAnimating];
//    self.spinner.hidden = NO;
}

- (void) contentNotAvailablePopUp {
    
    self.addToContentNotAvailablePopupViewController = [[ContentNotAvailableViewController alloc] init];
    [self presentViewController:_addToContentNotAvailablePopupViewController animated:YES completion:nil];
    
}

-(void) retrieveData {
    @try {
      
      [self setupVideoLikeDislike] ;
        
//        if(self.isAlreadyPlay){
//            [self setupVideos] ;
//            [videoCollectionView.collectionView refreshCollectionView];
//        }

        [self HideLoading];
        
        
        if(self.isAlreadyPlay){
            @try{
                [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pauseVideoPlayerAudio" object:nil];
                [[NSNotificationCenter defaultCenter] removeObserver:self name:@"playVideoPlayerAudio" object:nil];
            }@catch(id anException){
            }
            playerModel = nil;
        }
        if(self.video.ID == 0 && [self.video.Title isEqualToString:@"DL"]){
            
            [[BestsongsAPI sharedInstance] fetchVideo:self.video.Permalink onSuccess:^(id response) {
                
                if ((Video *)response != nil) {
                    
                    self.video = (Video *)response;
                    
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [self loadPlayer];
                    });
                    
                   
                    
                }
                else{
                    [SVProgressHUD dismiss];
                    [[BaseController sharedInstance] showToastSuccess:@"Welcome To Bestsongs.pk : Har Gaana Milayga Yahan"];
                }
                
            } onFailure:^(NSError *error) {
                
                [[BaseController sharedInstance] showToastError:error.localizedDescription];
                
                if ([error.localizedDescription containsString:@"Pakistan"] || [error.localizedDescription containsString:@"available"]) {
                    
                    [self contentNotAvailablePopUp];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"videoViewIsDisplayed" object:nil];
                    
                } else {
                    
                }
                
            }];
        }
        else{
            [self loadPlayer];
        }
    } @catch (NSException *exception) {
        [[BaseController sharedInstance] showToastError:exception.reason];
    } @finally {
    }
}

- (void)loadPlayer {
    
//    [self setupVideoLikeDislike] ;
    
    [self.trailerName setText:self.video.Title];
    
    if(self.video.AlbumName == nil || [self.video.AlbumName isEqualToString:@""]){
        [self.albumName setHidden:YES];
        self.trailerNameTopConstraint.constant = 30;
    } else {
        self.trailerNameTopConstraint.constant = 20;
        [self.albumName setHidden:NO];
        [self.albumName setText:self.video.AlbumName];
    }
    
    [self.backgroundPoster sd_setImageWithURL:[NSURL URLWithString:self.video.Poster]
                             placeholderImage:[UIImage imageNamed:@"BestsongsPlaceholder.jpg"]];
    
    //    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(pauseVideoPlayer:) name: @"pauseVideoPlayerAudio" object: nil];
    //    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(playVideoPlayer:) name: @"playVideoPlayerAudio" object: nil];
    
    ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
    
    if(self.isAlreadyPlay){
        sharingLink = nil;
        
        isAddCompleted = NO;
        [self.playerView resetToPlayNewVideo:self.playerModel];
        
    } else {
        
        [self.playerView playerControlView:controlView playerModel:self.playerModel];
        self.playerView.delegate = self;
        self.playerView.hasDownload = NO;
        self.playerView.hasPreviewView = NO;
        self.playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        
    }
    
    [self setupAdsLoader];
    [self setUpContentPlayer];
    [self requestAds];
    
    [self.playerView autoPlayTheVideo];
    [[self centerView] bringSubviewToFront:_spinner];
    
//
//
//    [self setupVideoLikeDislike] ;

//
//    [self setupVideos] ;
//    [videoCollectionView.collectionView refreshCollectionView] ;
//        if(!self.isAlreadyPlay){
//            [self setupVideoCollectionViews ];
//        }

 
//    if(!self.isAlreadyPlay){
//        [self setupVideoCollectionViews ];
//    }
    
   
}

- (void)pauseVideoPlayer: (NSNotification*)notification{
    [self.playerView pause];
}

- (void)playVideoPlayer: (NSNotification*)notification{
    
    if(isAddCompleted)
        [self.playerView play];
    else {
        [self reset];
        [self setupAdsLoader];
        [self setUpContentPlayer];
        [self requestAds];
    }
}

- (ZFPlayerModel *)playerModel {
    if (!playerModel) {
        playerModel                  = [[ZFPlayerModel alloc] init];
        playerModel.title            = self.video.Title;
        playerModel.videoURL         = [NSURL URLWithString:self.video.VideoURL];
        playerModel.placeholderImageURLString = self.video.Poster;
        playerModel.fatherView       = self.centerView;
    }
    return playerModel;
}

//zf_playerRepeatAction
- (void)repeatPlayAction{
    isAddCompleted = NO;
    [self reset];
    [self setupAdsLoader];
    [self setUpContentPlayer];
    [self requestAds];
}



#pragma mark GMFVideoPlayer notifications

#pragma mark Content Player Setup
- (void)setUpContentPlayer {
    // Load AVPlayer with path to our content.
    NSURL *contentURL = [NSURL URLWithString:@""];
    contentPlayer = [AVPlayer playerWithURL: contentURL];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:contentPlayer];
    playerLayer.frame = self.playerView.layer.bounds;
    
    
    [self.playerView.layer addSublayer:playerLayer];
    contentPlayhead = [[IMAAVPlayerContentPlayhead alloc] initWithAVPlayer:contentPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentDidFinishPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:contentPlayer.currentItem];
}

#pragma mark SDK Setup
- (void)setupAdsLoader {
    adsLoader = [[IMAAdsLoader alloc] initWithSettings:nil];
    adsLoader.delegate = self;
}

- (void)requestAds {
    IMAAdDisplayContainer *adDisplayContainer = [[IMAAdDisplayContainer alloc] initWithAdContainer:self.playerView companionSlots:nil];
    IMAAdsRequest *request = [[IMAAdsRequest alloc] initWithAdTagUrl:ADTAGURL
                                                  adDisplayContainer:adDisplayContainer
                                                     contentPlayhead:contentPlayhead
                                                         userContext:nil];
    
    
    
    [adsLoader requestAdsWithRequest:request];
    
}

- (void)contentDidFinishPlaying:(NSNotification *)notification {
    // Make sure we don't call contentComplete as a result of an ad completing.
    if (notification.object == contentPlayer.currentItem) {
        [adsLoader contentComplete];
    }
}

- (void)reset {
    @try{
        [[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:AVPlayerItemDidPlayToEndTimeNotification
         object:nil];
        [adsManager destroy];
    }@catch(id anException){
    }
}





#pragma mark Video Collection Views Delegates



- (UICollectionViewCell * _Nonnull)collectionViewCellForItemAtCollectionView:(UICollectionView * _Nonnull)collectionView indexPath:(NSIndexPath * _Nonnull)indexPath {
    
    VideoView * video = videos[indexPath.item] ;
    
    VideoCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCell" forIndexPath:indexPath] ;
    
    
    NSURL *url = [NSURL URLWithString : video.coverUrl ] ;
    
    [cell.itemImage sd_setImageWithURL: url ];
    
    cell.itemAlbumName.text = video.title ;
    cell.itemTitleName.text = @"" ;
    
    return cell ;
    
}

- (void)collectionViewDidSelectCellWithCollectionView:(UICollectionView * _Nonnull)collectionView indexPath:(NSIndexPath * _Nonnull)indexPath {
    
    // [self setupVideoItemClick] ;
    
    
    if(!isAddCompleted){
        [self.view makeToast:@"Wait till advertisement complete"];
        [CSToastManager setTapToDismissEnabled:YES];
        [CSToastManager setQueueEnabled:NO];
        return;
    }
    
    if(![AFNetworkReachabilityManager sharedManager].isReachable){
        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
        return;
    }
    
  
    
    [self.playerView pause];
    
    VideoView * video = videos[indexPath.item] ;
    
    [SVProgressHUD show];
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        VideoWebService *webService = [VideoWebService new] ;
        
        NSString *videoUrl = [webService fetchVideoUrlForVideoWithId:video.id andType:video.type ] ;
        
        videoUrl = [videoUrl stringByReplacingOccurrencesOfString:@".mpd" withString:@".m3u8" ] ;
        
        Video *newVideo = [[Video alloc]
                           initWithID:[ NSNumber numberWithInteger:video.id ]
                           title:video.title
                           videoURL:videoUrl
                           albumName:@""
                           poster:video.coverUrl
                           permalink:@"https://bestsongs.pk/videos/881607/"];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            
            [SVProgressHUD dismiss];
            
            [[BaseController sharedInstance]
             openVideoPlayerWithType:self.storyboard
             andVideo:newVideo
             andRootViewController:self.view.window.rootViewController
             andType:_type];
            
        });
        
    }) ; 
    
    
    
    
}

- (NSInteger)numberOfItems {
    
    return videos.count  ;
}







#pragma mark AdsLoader Delegates

- (void)adsLoader:(IMAAdsLoader *)loader adsLoadedWithData:(IMAAdsLoadedData *)adsLoadedData {
    // Grab the instance of the IMAAdsManager and set ourselves as the delegate.
    adsManager = adsLoadedData.adsManager;
    adsManager.delegate = self;
    // Create ads rendering settings to tell the SDK to use the in-app browser.
    IMAAdsRenderingSettings *adsRenderingSettings = [[IMAAdsRenderingSettings alloc] init];
    adsRenderingSettings.bitrate = 1024;  // kbits
    adsRenderingSettings.mimeTypes = @[ @"application/x-mpegURL" , @"video/mp4" , @"video/mpeg"];
    adsRenderingSettings.webOpenerPresentingController = nil;
    adsRenderingSettings.webOpenerDelegate = self;
    // Initialize the ads manager.
    [adsManager initializeWithAdsRenderingSettings:adsRenderingSettings];
}

- (void)adsLoader:(IMAAdsLoader *)loader failedWithErrorData:(IMAAdLoadingErrorData *)adErrorData {
    // Something went wrong loading ads. Log the error and play the content.
    isAddCompleted = NO;
    //    [self.playerView play];
    [self reset];
    [self setupAdsLoader];
    [self requestAds];
    [self HideLoading];
}

#pragma mark AdsManager Delegates


- (void)adsManager:(IMAAdsManager *)adsManager didReceiveAdEvent:(IMAAdEvent *)event {
    // When the SDK notified us that ads have been loaded, play them.
    
    switch (event.type) {
        case kIMAAdEvent_LOADED:
            
            [self ShowLoading];
            [self.playerView setUserInteractionEnabled:NO];
            
            if(!autoPlayerAddIsRunning)
            { [adsManager start];
                adsManagerIsStarted = true;
            }
            break;
        case kIMAAdEvent_STARTED:
            [self.playerView pause];
            [self.playerView setUserInteractionEnabled:YES];
            [self HideLoading];
            break;
        case kIMAAdEvent_RESUME:
            [self HideLoading];
            [self.playerView setUserInteractionEnabled:YES];
            break;
        case kIMAAdEvent_PAUSE:
            [self.playerView setUserInteractionEnabled:YES];
            //[self reset];
            //[self ShowLoading];
            //[self requestAds];
            break;
        case kIMAAdEvent_TAPPED:
            break;
        case kIMAAdEvent_COMPLETE:
            [self.view setUserInteractionEnabled:YES];
            
            [self.playerView play];
            isAddCompleted = YES;
            break;
        case kIMAAdEvent_ALL_ADS_COMPLETED:{
            
            [self.playerView setUserInteractionEnabled:YES];
            [SVProgressHUD dismiss];
            [adsManager destroy];
            isAddCompleted = YES;
            break;
        }
        default:
            break;
    }
}

- (void)adsManager:(IMAAdsManager *)adsManager didReceiveAdError:(IMAAdError *)error {
    // Something went wrong with the ads manager after ads were loaded. Log the error and play the content.
    isAddCompleted = NO;
    //    [self.playerView play];
    
    [self reset];
    [self setupAdsLoader];
    [self requestAds];
    
    [self HideLoading];
}

- (void)adsManagerDidRequestContentPause:(IMAAdsManager *)adsManager {
    // The SDK is going to play ads, so pause the content.
    [self.playerView pause];
}

- (void)adsManagerDidRequestContentResume:(IMAAdsManager *)adsManager {
    // The SDK is done playing ads (at least for now), so resume the content.
    isAddCompleted = YES;
    [self.playerView play];
    [self HideLoading];
    
}







- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)prefersStatusBarHidden {
    return isStatusBarHidden;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)adsManagerAdDidStartBuffering:(IMAAdsManager *)adsManager {
    // Show your activity indicator above the video player - ad playback has
    // stopped to buffer.
    
    [self ShowLoading];
    
}

- (void)adsManagerAdPlaybackReady:(IMAAdsManager *)adsManager {
    // Hide your activity indicator - as playback will resume.
    
    
    [self HideLoading];
}




//- (void)applicationDidEnterBackground {
//    printf("applicationDidEnterBackground\n");
//    [self.playerView pause];
//    [contentPlayer pause];
//    [adsManager destroy];
//}
//
//- (void)applicationWillEnterForeground {
//    printf("applicationWillEnterForeground\n");
//    if(!isAddCompleted) {
//        [self reset];
//        [self setupAdsLoader];
//        [self setUpContentPlayer];
//        [self requestAds];
//    }
//
//    [self.playerView pause];
//    [contentPlayer pause];
//    [adsManager destroy];
//
//}
//
//- (void)applicationWillResignActive {
//    printf("applicationWillResignActive\n");
//
//    isAddCompleted = NO;
//    //    [self.playerView play];
//    [self.playerView pause];
//    [contentPlayer pause];
//    [adsManager destroy];
//}
//
//- (void)applicationDidBecomeActive {
//    printf("applicationDidBecomeActive\n");
////    isAddCompleted = NO;
//        [self.playerView play];
//
//
//    if(isAddCompleted)
//    {
//        printf("Ad Complete");
//    }
//    else
//    {
//        printf("Ad Not Complete");
//    }
//
////    [self reset];
////    [self setupAdsLoader];
////    [self requestAds];
////    [self HideLoading];
//
//
//}



//- (void)viewWillAppear:(BOOL)animated {
//    printf("viewWillAppear\n");
//
////    isAddCompleted = NO;
////    //    [self.playerView play];
////    [self reset];
////    [self setupAdsLoader];
////    [self requestAds];
////    [self HideLoading];
//
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//    printf("viewDidAppear\n");
//
////    isAddCompleted = NO;
////    //    [self.playerView play];
////    [self reset];
////    [self setupAdsLoader];
////    [self requestAds];
////    [self HideLoading];
//
//}
//
//
//
//- (void)viewWillDisappear:(BOOL)animated {
//    // Don't reset if we're presenting a modal view (e.g. in-app clickthrough).
//    printf("viewWillDisappear\n");
////    [contentPlayer pause];
////    [self.playerView pause];
////    [adsManager destroy];
////    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
////        if (adsManager) {
////            [adsManager destroy];
////            adsManager = nil;
////        }
////        contentPlayer = nil;
////    }
////    contentPlayer = nil;
////
////    [self HideLoading];
//    [super viewWillDisappear:animated];
//
//
//}
//
//- (void)viewDidDisappear:(BOOL)animated {
//    printf("viewDidDisappear\n");
//
////    [contentPlayer pause];
////    [self.playerView pause];
////    [adsManager destroy];
////    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
////        if (adsManager) {
////            [adsManager destroy];
////            adsManager = nil;
////        }
////        contentPlayer = nil;
////    }
////    contentPlayer = nil;
////    [self HideLoading];
//
//    [super viewDidDisappear:animated];
//
//}



@end


