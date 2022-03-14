//
//  HomeViewController.m
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 7/22/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "HomeViewController.h"
#import "tbd12-Swift.h"
#import <WebKit/WebKit.h>

#import "BollywoodViewController.h"
#import "ArtistViewController.h"
#import "MashupViewController.h"
#import "PakistaniViewController.h"
#import "RegionalViewController.h"
#import "DiscoverMoreViewController.h"


// MARK: - VAR Decalaration
@interface HomeViewController () {
    
    NSMutableArray * bannersArray;
    NSMutableArray * albumsArray;
    NSMutableArray * trailersArray;
    NSMutableArray * topVideosArray;
    NSMutableArray * artistsArray;
    NSMutableArray * pakistaniArray;
    NSMutableArray * mashupArray;
    NSMutableArray * weddingArray;
    NSMutableArray * gupshupArray;
    NSMutableArray * regionalArray;
    NSMutableArray * evergreenArray;
    NSMutableArray * playlistArray;
    
    
    BOOL isBannerLoaded;
    BOOL areCustomBannersLoaded;
    BOOL isCustomBannersAdded ;
    BOOL isBannerLoading;
    BOOL bannerAdRunning ;
    BOOL isDataLoaded;
    BOOL isDataLoading;
    BOOL isCheckedLogin;
    BOOL isLoginOpen;
    BOOL isFirstTimeCheckNetwork;
    BOOL isViewAppear;
    CGFloat singleAlbumWidth;
    UIView *noInternetView;
    
    NSString *addIsAllowedToBePresented ;
    
    bool volumeisMute  ;
    GiveMeAnIMASDKVideoAdPlayer *videoAdsPlayer ;
    AddsView *addsView ;
    NSString *isAddNeededToPlay ;
    UIWindow* window ;
    GiveMeACustomNativeAd *customNativeAdLoader ;
    GiveMeACustomNativeAd *customNativeAdLoader2 ;
    
    MainSlider *mainBanner ;
    
    UIImage *adImage1 ;
    UIImage *adImage2 ;

    HomeBannerViewController * bannerVC ;
}
@end



@implementation HomeViewController

@synthesize bollywoodCollectionView, pakistaniCollectionView, trailersCollectionView, topVideosCollectionView ,
            artistCollectionView, mashupCollectionView, weddingCollectionView, gupshupCollectionView,
            regionalCollectionView, evergreenCollectionView ,playlistCollectionView;




- (void)viewDidLoad {
    [super viewDidLoad];
    
//    mainBanner = [[MainSlider alloc] init] ;
//    isCustomBannersAdded = NO ;
//    areCustomBannersLoaded = NO ;
//
//     __weak HomeViewController *weakSelf = self;
//    [self fetchAdImagesForController:weakSelf havingAdUnitId:@"/21792359936/Bestsongs_Masthead_1280x720" andAdTemplateId:@"11836290" andAdKey:@"MastHeadBanner"] ;
//
//
//    [_mainShowOfflineSongsBtn.layer setBorderWidth:1.0];
//    [_mainShowOfflineSongsBtn.layer setCornerRadius:20.0];
//    [_mainShowOfflineSongsBtn.layer setBorderColor:[[UIColor clearColor] CGColor]];
//    [_mainShowOfflineSongsBtn setBackgroundColor:[[BaseController sharedInstance] getDefaultColor]];
////    [button.layer setBorderWidth:1.0];
//    //    [button.layer setCornerRadius:20.0];
//    //    [button.layer setBorderColor:[[UIColor clearColor] CGColor]];
//    //    [button setBackgroundColor:[[BaseController sharedInstance] getDefaultColor]];
//
//
//    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(applicationDidEnterBackground) name: UIApplicationDidEnterBackgroundNotification object: nil];
//    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(applicationWillEnterForeground) name: UIApplicationWillEnterForegroundNotification object: nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(applicationWillResignActive) name: UIApplicationWillResignActiveNotification object: nil];
//    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(applicationDidBecomeActive) name: UIApplicationDidBecomeActiveNotification object: nil];
//
//
//
//
//
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.navigationItem.titleView = [[BaseController sharedInstance] getNavigationbar:self.navigationController andTitle:@"bestsongs.pk" andTotalButtons:2];
//    [self setupHomeLayout];
//    //FIRCrashNSLog(@"View loaded loaded");
//    [self scrollViewPullToRefresh];
//
//    [self autoPlayAdd];
//
//    [self setupScoreView];
//
//
//    _videoAdsView.backgroundColor = [UIColor clearColor] ;
//    _videoAdsView.hidden = true ;
//    _videoAdsControlView.backgroundColor = [UIColor clearColor] ;
//    _videoAdsControlView.hidden = true ;
//
//    _videoAdsVolumeImageButton.hidden = true ;
//
//
//
//    videoAdsPlayer = [[GiveMeAnIMASDKVideoAdPlayer alloc] init];
//    bannerAdRunning = NO ;
//    [self setupSliderVideoViewAds] ;
//
//
//
//
//    bannerVC = [[HomeBannerViewController alloc ] init];
//
//    [bannerVC runrunWithTabBar:self.tabBarController tabBarHeight: [[self.tabBarController tabBar]frame].size.height];
//
//    [bannerVC addNotifiers] ;
//
//
//
//
    [self setupViewMores];
//
//    volumeisMute = YES ;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self setupSliderVideoViewAds] ;
//
//    if (bannerAdRunning) {
//        [videoAdsPlayer resumeAds] ;
//    }
//
//
//    [[ NSNotificationCenter defaultCenter ] postNotificationName:@"hideHomeAdd" object:nil];
//    [[ NSNotificationCenter defaultCenter ] postNotificationName:@"showHomeAdd" object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    
    [super viewDidAppear:animated];
    
    
    if([self connected]){
        _connectionFailedMessage.hidden = true;
        [self hideNoInternet];
    }
  
    // muneeb uncomment

//   [[FIRMessaging messaging] subscribeToTopic:@"/topics/test"];

//   [[FIRMessaging messaging] subscribeToTopic:@"iosall"];
//
//    [[PlayerViewController sharedInstance] updateControls];
//    isViewAppear = true;
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [self reachabilityChanged:nil];
    }];
    if(isDataLoading)
        [self showLoading];
    [self becomeFirstResponder];
//
//     [videoAdsPlayer resumeAds] ;
//
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [videoAdsPlayer pauseAds] ;
    
}

- (void)viewDidDisappear:(BOOL)animated {
    isViewAppear = false;
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    if(isDataLoading)
        [self hideLoading];
    [self resignFirstResponder];
    [super viewDidDisappear:animated];
}



-(BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)applicationWillResignActive {
    [videoAdsPlayer pauseAds] ;
    
}

- (void)applicationDidBecomeActive {

//    [self setupSliderVideoViewAds] ;
//    if (bannerAdRunning) {
//        [videoAdsPlayer resumeAds] ;
//    }
//
}


- (void)applicationDidEnterBackground {
    printf("PlayerViewController:applicationDidEnterBackground\n");
    
    [videoAdsPlayer pauseAds] ;
    
}

- (void)applicationWillEnterForeground {
    printf("PlayerViewController:applicationWillEnterForeground\n");
    
    
//     [self setupSliderVideoViewAds] ;
//    if (bannerAdRunning) {
//        [videoAdsPlayer resumeAds] ;
//    }
    
}



//MARK: -



#pragma mark - UICollectionView Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(collectionView == bollywoodCollectionView)
        return albumsArray.count;
    else if(collectionView == pakistaniCollectionView)
        return pakistaniArray.count;
    else if(collectionView == trailersCollectionView)
        return trailersArray.count;
    else if(collectionView == topVideosCollectionView)
        return topVideosArray.count;
    else if(collectionView == artistCollectionView)
        return artistsArray.count;
    else if (collectionView == mashupCollectionView)
        return mashupArray.count;
    else if (collectionView == weddingCollectionView)
        return weddingArray.count;
    else if(collectionView == gupshupCollectionView)
        return gupshupArray.count;
    else if(collectionView == regionalCollectionView)
        return regionalArray.count;
    else if(collectionView == evergreenCollectionView)
        return evergreenArray.count;
    else if(collectionView == playlistCollectionView)
        return playlistArray.count;
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(collectionView == bollywoodCollectionView) {
        CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BollywoodCell" forIndexPath:indexPath];
        Album * album = [albumsArray objectAtIndex:indexPath.row];
        return [self fillCollectionViewCell:cell andcollectionView:collectionView andcellForItemAtIndexPath:indexPath andtitle:album.Title andposter:album.Poster];
    } else if(collectionView == pakistaniCollectionView) {
        CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PakistaniCell" forIndexPath:indexPath];
        Album * album = [pakistaniArray objectAtIndex:indexPath.row];
        return [self fillCollectionViewCell:cell andcollectionView:collectionView andcellForItemAtIndexPath:indexPath andtitle:album.Title andposter:album.Poster];
    } else if(collectionView == trailersCollectionView) {
        CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TrailerCell" forIndexPath:indexPath];
        Video * trailer = [trailersArray objectAtIndex:indexPath.row];
        return [self fillCollectionViewCell:cell andcollectionView:collectionView andcellForItemAtIndexPath:indexPath andtitle:trailer.Title andposter:trailer.Poster];
    } else if(collectionView == topVideosCollectionView){
        CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TopVideoCell" forIndexPath:indexPath];
        Video * topVideo = [topVideosArray objectAtIndex:indexPath.row];
        return [self fillCollectionViewCell:cell andcollectionView:collectionView andcellForItemAtIndexPath:indexPath andtitle:topVideo.Title andposter:topVideo.Poster];
    }else if(collectionView == artistCollectionView) {
        CollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ArtistCell" forIndexPath:indexPath];
        Album * album = [artistsArray objectAtIndex:indexPath.row];
        return [self fillCollectionViewCell:cell andcollectionView:collectionView andcellForItemAtIndexPath:indexPath andtitle:album.Title andposter:album.Poster];
    } else if(collectionView == mashupCollectionView) {
        CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MashupCell" forIndexPath:indexPath];
        Album * album = [mashupArray objectAtIndex:indexPath.row];
        return [self fillCollectionViewCell:cell andcollectionView:collectionView andcellForItemAtIndexPath:indexPath andtitle:album.Title andposter:album.Poster];
    } else if(collectionView == weddingCollectionView) {
        CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WeddingCell" forIndexPath:indexPath];
        Album * album = [weddingArray objectAtIndex:indexPath.row];
        return [self fillCollectionViewCell:cell andcollectionView:collectionView andcellForItemAtIndexPath:indexPath andtitle:album.Title andposter:album.Poster];
    } else if(collectionView == gupshupCollectionView) {
        CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GupshupCell" forIndexPath:indexPath];
        Video * trailer = [gupshupArray objectAtIndex:indexPath.row];
        return [self fillCollectionViewCell:cell andcollectionView:collectionView andcellForItemAtIndexPath:indexPath andtitle:trailer.Title andposter:trailer.Poster];
    } else if (collectionView == regionalCollectionView) {
        CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RegionalCell" forIndexPath:indexPath];
        Album * album = [regionalArray objectAtIndex:indexPath.row];
        return [self fillCollectionViewCell:cell andcollectionView:collectionView andcellForItemAtIndexPath:indexPath andtitle:album.Title andposter:album.Poster];
    }else if (collectionView == evergreenCollectionView) {
        CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EvergreenCell" forIndexPath:indexPath];
        Album * album = [evergreenArray objectAtIndex:indexPath.row];
        return [self fillCollectionViewCell:cell andcollectionView:collectionView andcellForItemAtIndexPath:indexPath andtitle:album.Title andposter:album.Poster];
    }
    else {
        CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlaylistCell" forIndexPath:indexPath];
        Album * album = [playlistArray objectAtIndex:indexPath.row];
        return [self fillCollectionViewCell:cell andcollectionView:collectionView andcellForItemAtIndexPath:indexPath andtitle:album.Title andposter:album.Poster];
    }
}

- (CollectionViewCell *)fillCollectionViewCell:(CollectionViewCell *)cell andcollectionView:(UICollectionView *)collectionView andcellForItemAtIndexPath:(NSIndexPath *)indexPath andtitle:(NSString *)title andposter:(NSString *)poster{
    [cell.Title setText:title];
    [cell.Image sd_setImageWithURL:[NSURL URLWithString:poster]
                  placeholderImage:[UIImage imageNamed:DEFAULTALBUMART]];
    return cell;
}

- (void)showShowOfflineAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"bestsongs.pk" message:@"Show Offline Songs?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self openDownload];
    }];
    UIAlertAction *noButton = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showNoInternetAlertMessag {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"bestsongs.pk" message:@"You must connect ot Wi-fi or a Cellular Network to get online again." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self showShowOfflineAlert];
    }];
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UICollectionView Delegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(![AFNetworkReachabilityManager sharedManager].isReachable){
//        [[BaseController sharedInstance] showToastError:@"Hello Buddy"];
        
        [self showNoInternetAlertMessag];

        return;
    }
    SingleAlbumViewController * singleAlbumViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"singleAlbumViewController"];
    Album *album;
    Song *song = [[Song alloc] init];
    singleAlbumViewController.selectedSong = song;
    
    if(collectionView == bollywoodCollectionView){
        album = [albumsArray objectAtIndex:indexPath.row];
        singleAlbumViewController.album = album;
        [self.navigationController pushViewController:singleAlbumViewController animated:YES];
    }
    
    else if(collectionView == artistCollectionView){
        album = [artistsArray objectAtIndex:indexPath.row];
        singleAlbumViewController.album = album;
        [self.navigationController pushViewController:singleAlbumViewController animated:YES];
    }
    
    else if(collectionView == mashupCollectionView){
        album = [mashupArray objectAtIndex:indexPath.row];
        singleAlbumViewController.album = album;
        [self.navigationController pushViewController:singleAlbumViewController animated:YES];
    }
    
    else if(collectionView == pakistaniCollectionView){
        album = [pakistaniArray objectAtIndex:indexPath.row];
        singleAlbumViewController.album = album;
        [self.navigationController pushViewController:singleAlbumViewController animated:YES];
    }
    
    else if(collectionView == regionalCollectionView){
        album = [regionalArray objectAtIndex:indexPath.row];
        singleAlbumViewController.album = album;
        [self.navigationController pushViewController:singleAlbumViewController animated:YES];
    }
    
    else if(collectionView == weddingCollectionView){
        album = [weddingArray objectAtIndex:indexPath.row];
        singleAlbumViewController.album = album;
        [self.navigationController pushViewController:singleAlbumViewController animated:YES];
    }
    
    else if(collectionView == playlistCollectionView){
        album = [playlistArray objectAtIndex:indexPath.row];
        singleAlbumViewController.album = album;
        [self.navigationController pushViewController:singleAlbumViewController animated:YES];
    }
 
    else if(collectionView == evergreenCollectionView) {
        Video *video = [evergreenArray objectAtIndex:indexPath.row];
      //  [[BaseController sharedInstance] openVideoPlayer:self.storyboard andVideo:video andRootViewController:self.view.window.rootViewController];
        
        [self showLoading];
        
        [[BaseController sharedInstance]
         openVideoPlayerWithType:self.storyboard
         andVideo:video
         andRootViewController:self.view.window.rootViewController
         andType:@"evergreen"];
        
    }
    
    else if(collectionView == trailersCollectionView) {
        
        if(![AFNetworkReachabilityManager sharedManager].isReachable){
            [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
            return;
        }
        
        
        Video *video = [trailersArray objectAtIndex:indexPath.row];
       // [[BaseController sharedInstance] openVideoPlayer:self.storyboard andVideo:video andRootViewController:self.view.window.rootViewController];
        
        [self showLoading];
        
        [[BaseController sharedInstance]
         openVideoPlayerWithType:self.storyboard
         andVideo:video
         andRootViewController:self.view.window.rootViewController
         andType:@"trailer"];
    }
    
    else if(collectionView == topVideosCollectionView){
        
        if(![AFNetworkReachabilityManager sharedManager].isReachable){
            [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
            return;
        }
        
        
        Video *video = [topVideosArray objectAtIndex:indexPath.row];
       // [[BaseController sharedInstance] openVideoPlayer:self.storyboard andVideo:video andRootViewController:self.view.window.rootViewController];
       
        [self showLoading];
        
        [[BaseController sharedInstance] openVideoPlayerWithType:self.storyboard andVideo:video andRootViewController:self.view.window.rootViewController andType:@"top_video"];
    }
    
    else if(collectionView == gupshupCollectionView) {
        
        if(![AFNetworkReachabilityManager sharedManager].isReachable){
            [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
            return;
        }
        
        
        
        Video *video = [gupshupArray objectAtIndex:indexPath.row];
       // [[BaseController sharedInstance] openVideoPlayer:self.storyboard andVideo:video andRootViewController:self.view.window.rootViewController];
      
        [self showLoading];
        
        [[BaseController sharedInstance] openVideoPlayerWithType:self.storyboard andVideo:video andRootViewController:self.view.window.rootViewController andType:@"gupshup"];
    }
}
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = collectionView.frame.size.width / singleAlbumWidth;
    width -= 5;
    return CGSizeMake(width, (width + 35));
}

- (void) contentNotAvailablePopUp{
    
    self.addToContentNotAvailablePopupViewController = [[ContentNotAvailableViewController alloc] init];
    
    [self presentViewController:_addToContentNotAvailablePopupViewController animated:YES completion:nil];
    
    
    
}

// MARK: - Banner


- (void) fetchAdImagesForController:(UIViewController*) controller
                    havingAdUnitId : (NSString*) unitId
                    andAdTemplateId : (NSString*) templateId
                    andAdKey : (NSString*) adKey {
    
    customNativeAdLoader = [[GiveMeACustomNativeAd alloc] init] ;
    
    __weak HomeViewController *weakSelf = self;
    customNativeAdLoader.closureToBeExecutedWhenImageIsFetched = ^(UIImage* image){
        
        adImage1 = image ;
        [weakSelf fetchAdImagesForController2:weakSelf
                               havingAdUnitId:@"/21792359936/Bestsongs-App-Masthead-Banner-1280x720"
                              andAdTemplateId:@"11836828"
                                     andAdKey:@"MastHeadBanner" ] ;
        
    } ;
    
//    [ customNativeAdLoader
//      setupCustomNativeAdWithViewController:controller
//      havingAdUnitId:unitId
//      adTemplateId:templateId
//      adKey:adKey ]  ;
//
//
}


- (void) fetchAdImagesForController2:(UIViewController*) controller
                    havingAdUnitId : (NSString*) unitId
                   andAdTemplateId : (NSString*) templateId
                          andAdKey : (NSString*) adKey {
    
    
    customNativeAdLoader2 = [[GiveMeACustomNativeAd alloc] init] ;
    
    __weak HomeViewController *weakSelf = self;
    
    
    customNativeAdLoader2.closureToBeExecutedWhenImageIsFetched = ^(UIImage* image){
        
        adImage2 = image ;
        
        if (isCustomBannersAdded) {
            [weakSelf refreshBanners] ;
        }
        else {
            [weakSelf fetchBanners] ;
            NSLog(@"Images fetched") ;
        }
        
        
        
    } ;
    
    [customNativeAdLoader2
     setupCustomNativeAdWithViewController:weakSelf
     havingAdUnitId:unitId
     adTemplateId:templateId
     adKey:adKey ]  ;
    
    
    
    
}

- (void) addBannerView {
    

    
}

- (void) fetchBanners {
    
    if(!isBannerLoaded && !isBannerLoading){
        isBannerLoading = true;
        [[BestsongsAPI sharedInstance] fetchBanner:^(id response) {
            NSDictionary *dataDictionary = (NSDictionary *) response;
            bannersArray = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getBannersArrayFromJSON:dataDictionary]];
            dispatch_async(dispatch_get_main_queue(), ^ {
                isBannerLoading = false;
                isBannerLoaded = true;
                
                [self setupBanners] ;
                
                //   [self.banners reloadData];
            });
        } onFailure:^(NSError *error) {
            isBannerLoading = false;
        }];
    }
    

}


- (void) setupBanners {
    
    
    // [self addBannerView];
    
    [self.banners addSubview:mainBanner];
    [mainBanner.topAnchor constraintEqualToAnchor:self.banners.topAnchor constant:0].active = true ;
    [mainBanner.bottomAnchor constraintEqualToAnchor:self.banners.bottomAnchor constant:0].active = true ;
    [mainBanner.rightAnchor constraintEqualToAnchor:self.banners.rightAnchor constant:0].active = true ;
    [mainBanner.leftAnchor constraintEqualToAnchor:self.banners.leftAnchor constant:0].active = true ;
    
    isCustomBannersAdded = YES ;
    
    NSMutableArray * imageUrls = [[NSMutableArray alloc] init] ;
    
    for (Banner* banner in bannersArray) {
        [imageUrls addObject: banner.Poster  ];
    }
    
    NSString *url1 = imageUrls[ 1 ] ;
    NSString *url2 = imageUrls[ 3 ] ;
    
    
    imageUrls[ 1 ] = adImage1 ;
    imageUrls[ 3 ] = adImage2 ;
    
    
    [ imageUrls addObject:  url1 ] ;
    [ imageUrls addObject:  url2 ] ; //[UIImage imageNamed:@"home"] ];
    
    
    [mainBanner setupSliderWithSliderUrlsOrUIImages:imageUrls] ;
    
    
    
}

- (void) refreshBanners {
    
    
    if ( adImage1 != nil || adImage2 != nil ) {
        
        if ( isCustomBannersAdded == NO ) {
            
            [self.banners addSubview:mainBanner];
            [mainBanner.topAnchor constraintEqualToAnchor:self.banners.topAnchor constant:0].active = true ;
            [mainBanner.bottomAnchor constraintEqualToAnchor:self.banners.bottomAnchor constant:0].active = true ;
            [mainBanner.rightAnchor constraintEqualToAnchor:self.banners.rightAnchor constant:0].active = true ;
            [mainBanner.leftAnchor constraintEqualToAnchor:self.banners.leftAnchor constant:0].active = true ;
            
            isCustomBannersAdded = YES ;
            
        }
        
        
        
        
        NSMutableArray * imageUrls = [[NSMutableArray alloc] init] ;
        for (Banner* banner in bannersArray) {
            [imageUrls addObject: banner.Poster ];
        }
        
        
        NSString *url1 = imageUrls[ 1 ] ;
        NSString *url2 = imageUrls[ 3 ] ;
        
        
        imageUrls[ 1 ] = adImage1 ;
        imageUrls[ 3 ] = adImage2 ;
        
        
        [  imageUrls addObject:  url1  ] ;
        [  imageUrls addObject:  url2  ] ; //[UIImage imageNamed:@"home"] ];
        
        [mainBanner refreshSliderWithSliderData:imageUrls] ;
        
    }else {
        
        __weak HomeViewController *weakSelf = self;
        [self fetchAdImagesForController:weakSelf havingAdUnitId:@"/21792359936/Bestsongs_Masthead_1280x720" andAdTemplateId:@"11836290" andAdKey:@"MastHeadBanner"] ;

    }
    

}


-(void) setupSliderVideoViewAds {
    
    
    if (!bannerAdRunning) {
    
        bannerAdRunning = YES ;
    
    
        _videoAdsView.hidden = false ;
        _videoAdsControlView.hidden = false ;
        
        _videoAdsVolumeImageButton.image = [UIImage imageNamed:@"audioMute"];
        volumeisMute = YES ;
        
        IMAAVPlayerContentPlayhead *videoPlayerContentPlayhead = nil ;
        
        NSString *addTag = @"https://pubads.g.doubleclick.net/gampad/ads?iu=/21792359936/Masthead-VIdeo-for-iOS&description_url=[placeholder]&env=vp&impl=s&correlator=&tfcd=0&npa=0&gdfp_req=1&output=vast&sz=640x480&unviewed_position_start=1" ;
        
//
//        @"https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&"
//        @"iu=/39243592/387337752&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&"
//        @"output=vast&unviewed_position_start=1&"
//        @"correlator=";
//
        __weak typeof(self) weakSelf = self;
        
        //    _videoAdsVolumeImageButton.hidden = false ;
        
        videoAdsPlayer.closureWhenAdIsAboutToRun = ^{

//            typeof(self) strongSelf = weakSelf;
//
//            if ( strongSelf ) {
//                strongSelf->bannerAdRunning = YES ;
//            }

            weakSelf.videoAdsVolumeImageButton.hidden = false ;

        } ;
        
        
        [videoAdsPlayer integrateAndPlayAdsOnVideoView: _videoAdsView playersContentPlayHead:videoPlayerContentPlayhead isVideoViewAnAVPlayer:true withAdTagUrl:addTag andProvideClosureToBeExecutedWhenAdFinishedRunnind:^{
            
            typeof(self) strongSelf = weakSelf;
            
            if ( strongSelf ) {
                strongSelf->bannerAdRunning = NO ;
            }
            bannerAdRunning = NO ;
            weakSelf.videoAdsView.hidden = true ;
            weakSelf.videoAdsControlView.hidden = true ;
            weakSelf.videoAdsVolumeImageButton.hidden = true ;
            
        }];
        
        
    }
    
}

-(void) autoPlayAdd {
    
    addIsAllowedToBePresented = 0;
    
    //
    //
    //    //    MARK: Ads api fetch to retrive value :
    //
    window = [UIApplication sharedApplication].keyWindow;
    
    
    addsView.tag = 100;
    
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://bestsongs-156307.appspot.com/v1/marketing/showpopupad"]];
    
    //create the Method "GET"
    [urlRequest setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                          if(httpResponse.statusCode == 200)
                                          {
                                              NSError *parseError = nil;
                                              NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                              NSLog(@"The response is - %@",responseDictionary);
                                              
                                              addIsAllowedToBePresented = [responseDictionary[@"show_popup_ad"] stringValue] ;
                                              
                                              
                                              
                                              ////////////////////////////////////
                                              
                                              NSLog(@"Add Is Not Allowed To Be Presented ... %@",addIsAllowedToBePresented);
                                              
                                              
                                              if([addIsAllowedToBePresented isEqualToString:@"1"]){
                                                  
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      
                                                      addsView = [[AddsView alloc] init];
                                                      
                                                      [window addSubview:addsView];
                                                      
                                                      
                                                      
                                                      
                                                      [addsView.topAnchor
                                                       constraintEqualToAnchor:window.topAnchor
                                                       constant:0].active = true;
                                                      
                                                      [addsView.leftAnchor
                                                       constraintEqualToAnchor:window.leftAnchor
                                                       constant:0].active = true;
                                                      
                                                      [addsView.rightAnchor
                                                       constraintEqualToAnchor:window.rightAnchor
                                                       constant:0].active = true;
                                                      
                                                      
                                                      [addsView.bottomAnchor
                                                       constraintEqualToAnchor:window.bottomAnchor
                                                       constant:0].active = true;
                                                      
                                                      addsView.alpha = 0.1;
                                                      
                                                      
                                                      
                                                      [window sendSubviewToBack: addsView];
                                                      
                                                      addsView.hidden = YES;
                                                      
                                                      //when add added then will animate it to appear after sometime
                                                      [self createAutoPlayerAds];
                                                      
                                                  });
                                              }
                                              
                                              ////////////////////////////////////
                                              
                                              
                                          }
                                          else
                                          {
                                              NSLog(@"Add Is Not Allowed To Be Presented ...");
                                          }
                                      }];
    
    [dataTask resume];
    
    
    
    
}



- (void)createAutoPlayerAds{

    NSString *abc = @"asd";
    
    //    MARK: Adds Screen Making :
    //  if(isAddNeededToPlay != nil){
    
    
    if ( [abc isEqualToString:@"asd"] ) {
        
        
        NSLog(@"muneeb  :::%@", isAddNeededToPlay);
        
        
        [UIView animateWithDuration:0.5
                              delay:4
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             addsView.alpha = 0;
                             
                             
                             
                         } completion:^(BOOL finished) {
                             
                             [window bringSubviewToFront:addsView];
                             
                             [UIView animateWithDuration:0.5
                                                   delay:4
                              
                                                 options:UIViewAnimationOptionAllowUserInteraction
                                              animations:^{
                                                  
                                                  addsView.alpha = 0;
                                                  addsView.hidden = NO;
                                                  
                                                  [[ NSNotificationCenter defaultCenter ] postNotificationName:@"addsPlaying" object:nil];
                                                  
                                              } completion:^(BOOL finished) {
                                                  
                                                  
                                              }];
                         }];
    }else {
        
        [addsView removeFromSuperview];
    }
    //   /////// adds screen added
}





// MARK: - SETUP Methods

- (void)setupHomeLayout {
    
    isBannerLoaded = NO;
    isBannerLoading = NO;
    isDataLoaded = NO;
    isDataLoading = NO;
    isCheckedLogin = NO;
    isLoginOpen = NO;
 
    isFirstTimeCheckNetwork = YES;
   
    isViewAppear = YES;
 
    [self.mainView setHidden:YES];
    
    UIScreen *screen = [UIScreen mainScreen];
   
    singleAlbumWidth = 2.5;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        singleAlbumWidth = 4.5;
    
    CGFloat carouselHeight = (screen.bounds.size.width / singleAlbumWidth) - 5;
  
    CGFloat bannerHeight = screen.bounds.size.width;
    
    bannerHeight = (bannerHeight / 1.78);
    
    self.bannerViewHeight.constant = bannerHeight;
    
    carouselHeight += 35;
    
    CGFloat viewsHeight = (45 + carouselHeight + 10);
    
    self.bollywoodViewHeight.constant = viewsHeight;
    self.pakistaniViewHeight.constant = viewsHeight;
    self.trailersViewHeight.constant = viewsHeight;
    self.topVideosViewHeight.constant = viewsHeight;
    self.artistViewHeight.constant = viewsHeight;
    self.mashupViewHeight.constant = viewsHeight;
    self.weddingViewHeight.constant = viewsHeight;
    self.gupshupViewHeight.constant = viewsHeight;
    self.regionalViewHeight.constant = viewsHeight;
    self.evergreenViewHeight.constant = viewsHeight;  ///
    self.playlistViewHeight.constant = viewsHeight;
    
    self.bollywoodCollectionViewHeight.constant = carouselHeight;
    self.pakistaniCollectionViewHeight.constant = carouselHeight;
    self.trailersCollectionViewHeight.constant = carouselHeight;
    self.topVideosCollectionViewHeight.constant = carouselHeight;
    self.artistCollectionViewHeight.constant = carouselHeight;
    self.mashupCollectionViewHeight.constant = carouselHeight;
    self.weddingCollectionViewHeight.constant = carouselHeight;
    self.gupshupCollectionViewHeight.constant = carouselHeight;
    self.regionalCollectionViewHeight.constant = carouselHeight;
    self.evergreenCollectionViewHeight.constant = carouselHeight;
    self.playlistCollectionViewHeight.constant = carouselHeight;
    
    [self.bollywoodView.layer addSublayer:[[BaseController sharedInstance] setViewBottomBorder:viewsHeight]];
    [self.trailersView.layer addSublayer:[[BaseController sharedInstance] setViewBottomBorder:viewsHeight]];
    [self.topVideosView.layer addSublayer:[[BaseController sharedInstance] setViewBottomBorder:viewsHeight]];
    [self.artistView.layer addSublayer:[[BaseController sharedInstance] setViewBottomBorder:viewsHeight]];
    [self.mashupView.layer addSublayer:[[BaseController sharedInstance] setViewBottomBorder:viewsHeight]];
    [self.pakistaniView.layer addSublayer:[[BaseController sharedInstance] setViewBottomBorder:viewsHeight]];
    [self.gupshupView.layer addSublayer:[[BaseController sharedInstance] setViewBottomBorder:viewsHeight]];
    [self.regionalView.layer addSublayer:[[BaseController sharedInstance] setViewBottomBorder:viewsHeight]];
    [self.weddingView.layer addSublayer:[[BaseController sharedInstance] setViewBottomBorder:viewsHeight]];
    
   //  [self.evergreenView.layer addSublayer:[[BaseController sharedInstance] setViewBottomBorder:viewsHeight]];
    
    self.mainViewHeight.constant = ((viewsHeight * 11) + bannerHeight+ 12 + (11 * 9)) + 106 ; //66 ;
    
    self.view.backgroundColor = [[BaseController sharedInstance] getDefaultBackgroundColor];
    self.banners.backgroundColor = [[BaseController sharedInstance] getDefaultBackgroundColor];
    

}
 
- (void) setupScoreView {
    
    [_scoreView setBackgroundColor:[UIColor clearColor]];
    [_scoreView setOpaque:NO];
    
//    NSURL *url = [[NSURL alloc] initWithString:@"https://bestsongs.pk/live_Score.html"];
//
//    NSURLRequest *asd = [[NSURLRequest alloc] initWithURL:url];
//
//    [_scoreView loadRequest: asd ];
    
    // _scoreView.scrollView.scrollEnabled = false ;
    
}


// MARK: - Network

- (void)getData:(void (^)(id))successBlock
    onFailure:(void (^)(NSError *))failureBlock{
@try {
    [[BestsongsAPI sharedInstance] fetchHome:^(id response) {
        NSDictionary *dataDictionary = (NSDictionary *) response;
        
        self->albumsArray = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getAlbumsArrayFromJSON:[dataDictionary objectForKey:@"latest"]]];
        self->trailersArray = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getVideosArrayFromJSON:[dataDictionary objectForKey:@"trailers"]]];
        self->topVideosArray = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getVideosArrayFromJSON:[dataDictionary objectForKey:@"top_video_chart"]]];
        self->artistsArray = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getAlbumsArrayFromJSON:[dataDictionary objectForKey:@"artists"]]];
        self->mashupArray = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getAlbumsArrayFromJSON:[dataDictionary objectForKey:@"mashups"]]];
        self->pakistaniArray = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getAlbumsArrayFromJSON:[dataDictionary objectForKey:@"latest_pakistani"]]];
        self->gupshupArray = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getVideosArrayFromJSON:[dataDictionary objectForKey:@"gupshup"]]];
        self->regionalArray = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getAlbumsArrayFromJSON:[dataDictionary objectForKey:@"regional"]]];
        self->weddingArray = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getAlbumsArrayFromJSON:[dataDictionary objectForKey:@"wedding"]]];
        self->evergreenArray = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getVideosArrayFromJSON:[dataDictionary objectForKey:@"evergreen"]]];
        self->playlistArray = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getAlbumsArrayFromJSON:[dataDictionary objectForKey:@"feature_playlist"]]];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self.bollywoodCollectionView reloadData];
//            [self.trailersCollectionView reloadData];
//            [self.topVideosCollectionView reloadData];
//            [self.artistCollectionView reloadData];
//            [self.mashupCollectionView reloadData];
//            [self.pakistaniCollectionView reloadData];
//            [self.gupshupCollectionView reloadData];
//            [self.regionalCollectionView reloadData];
//            [self.weddingCollectionView reloadData];
//            [self.evergreenCollectionView reloadData];
//            [self.playlistCollectionView reloadData];
        });
        
        successBlock(nil);
    } onFailure:^(NSError *error) {
        failureBlock(error);
    }];
} @catch (NSException *exception) {
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
    NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
    failureBlock(error);
} @finally {
}
}

- (void) retrieveData {
    if(!isDataLoaded && !isDataLoading){
        @try {
            [self hideNoInternet];
            [self showLoading];
            isDataLoading = YES;
            [self getData:^(id response) {
                isDataLoaded = YES;
                isDataLoading = NO;
                [self.mainView setHidden:NO];
//                [self scrollViewPullToRefresh];
                if(!isViewAppear)
                    [self hideLoading];
                
            } onFailure:^(NSError *error) {
                
                NSLog(@"errror :: %@",error.localizedDescription);
                
                isDataLoading = NO;
                if(!isViewAppear)
                    [self hideLoading];
                
                [self showNoInternet];
                
                if ([error.localizedDescription containsString:@"Pakistan"] || [error.localizedDescription containsString:@"available"]) {
                
                    [self contentNotAvailablePopUp];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"videoViewIsDisplayed" object:nil];
                    
                } else {
                  
                }
  
                
                [[BaseController sharedInstance] showToastError:error.localizedDescription];
                
            }];
        } @catch (NSException *exception) {
            if(!isViewAppear)
                [self hideLoading];
            isDataLoading = NO;
            [self showNoInternet];
            [[BaseController sharedInstance] showToastError:exception.reason];
        }
        @finally {
            
             [self hideLoading];
        }
    }
    
//    if(!isBannerLoaded && !isBannerLoading){
//        isBannerLoading = true;
//        [[BestsongsAPI sharedInstance] fetchBanner:^(id response) {
//            NSDictionary *dataDictionary = (NSDictionary *) response;
//            bannersArray = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getBannersArrayFromJSON:dataDictionary]];
//            dispatch_async(dispatch_get_main_queue(), ^ {
//                isBannerLoading = false;
//                isBannerLoaded = true;
//             //   [self.banners reloadData];
//            });
//        } onFailure:^(NSError *error) {
//            isBannerLoading = false;
//        }];
//    }
}


//MARK: - IBACTIONS

- (IBAction)accountButton:(id)sender {
    if(![AFNetworkReachabilityManager sharedManager].isReachable){
//        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
        [self showNoInternetAlertMessag];
        return;
    }
    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"sidebarNavigationVC"];
    [navController setModalPresentationStyle: UIModalPresentationOverFullScreen];
    [self.view.window.rootViewController presentViewController:navController animated:YES completion:nil];
}

- (IBAction)searchButton:(id)sender {
    
    if(![AFNetworkReachabilityManager sharedManager].isReachable){
//        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
        [self showNoInternetAlertMessag];
        return;
    }
    SearchViewController *searchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"searchViewController"];
    
     [self.navigationController pushViewController:searchViewController animated:YES];
}

-(IBAction)clickedShowOffline:(id)sender {
    [self openDownload];
}

-(IBAction)clickedMainShowOfflineSongsBtn:(id)sender {
    [self openDownload];
}


//MARK: - Utility Methods

- (void) pullToRefreshData{
    @try {
        
        // fetching banner
        
        if( !isBannerLoading){
            isBannerLoading = true;
            [[BestsongsAPI sharedInstance] fetchBanner:^(id response) {
                NSDictionary *dataDictionary = (NSDictionary *) response;
                bannersArray = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getBannersArrayFromJSON:dataDictionary]];
                dispatch_async(dispatch_get_main_queue(), ^ {
                    isBannerLoading = false;
                    isBannerLoaded = true;
                    [self refreshBanners];
                });
            } onFailure:^(NSError *error) {
                isBannerLoading = false;
            }];
        }
        
        
        // fetching data
        
        [self getData:^(id response) {
            [self.scrollView.pullToRefreshView stopAnimating];
        } onFailure:^(NSError * error) {
            [self.scrollView.pullToRefreshView stopAnimating];
            [[BaseController sharedInstance] showToastError:error.localizedDescription];
            
            
            if ([error.localizedDescription containsString:@"Pakistan"] || [error.localizedDescription containsString:@"available"]) {
                
                [self contentNotAvailablePopUp];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"videoViewIsDisplayed" object:nil];
                
            } else {
                
            }
            
        }];
    } @catch (NSException *exception) {
        [self.scrollView.pullToRefreshView stopAnimating];
        [[BaseController sharedInstance] showToastError:exception.reason];
    } @finally {
    }
}

- (void)reachabilityChanged:(NSNotification *)notification  {
    [self retrieveData];
//    if([[AFNetworkReachabilityManager sharedManager] isReachable]) {
//        if(isFirstTimeCheckNetwork)
//            isFirstTimeCheckNetwork = !isFirstTimeCheckNetwork;
//        else{
//            if(!isViewAppear)
////                [[BaseController sharedInstance] showToastSuccess:INTERNETSUCCESSMESSAGE];
//                _connectionFailedMessage.hidden = true;
//        }
//        if(isViewAppear)
//            isViewAppear = !isViewAppear;
//        if(isCheckedLogin){
//            if((!isDataLoaded && !isDataLoading) || (!isBannerLoaded && !isBannerLoading))
//                [self retrieveData];
//        } else{
//            if(!isLoginOpen){
//                if(![[BaseController sharedInstance] checkIsUserLogin]){
//                    isLoginOpen = YES;
//                    LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//                    loginViewController.didDismiss = ^(NSString *data) {
//                        isCheckedLogin = YES;
//                        if((!isDataLoaded && !isDataLoading) || (!isBannerLoaded && !isBannerLoading))
//                            [self retrieveData];
//                    };
//                    loginViewController.modalInPopover = YES;
//                    loginViewController.hidesBottomBarWhenPushed = YES;
//                    loginViewController.modalPresentationStyle = UIModalPresentationFullScreen;
//                    [self.tabBarController presentViewController:loginViewController animated:NO completion:nil];
//                } else {
//                    isLoginOpen = YES;
//                    isCheckedLogin = YES;
//                    if((!isDataLoaded && !isDataLoading) || (!isBannerLoaded && !isBannerLoading))
//                        [self retrieveData];
//                }
//            }
//        }
//    } else {
//        if(!isLoginOpen){
//            isFirstTimeCheckNetwork = false;
//            isLoginOpen = true;
//            isCheckedLogin = true;
//            [self showNoInternet];
//        }
//        if(isViewAppear)
//            isViewAppear = !isViewAppear;
////        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
//        _connectionFailedMessage.hidden = false;
//    }
}

- (void)showNoInternet{
//    noInternetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 235)];
//
//    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,noInternetView.frame.size.width,160)];
//    image.image=[UIImage imageNamed:@"server-not-found.png"];
//    image.contentMode = UIViewContentModeScaleAspectFill;
//
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, noInternetView.frame.size.width, 20)];
//    label.text = @"Could Not Connect";
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:15.0];
//    [label setTextColor:[UIColor whiteColor]];
//
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 190, noInternetView.frame.size.width, 40)];
//    [button setTitle:@"Show Offline Songs" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    button.titleLabel.textAlignment = NSTextAlignmentCenter;
//    button.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:16.0];
//    [button.layer setBorderWidth:1.0];
//    [button.layer setCornerRadius:20.0];
//    [button.layer setBorderColor:[[UIColor clearColor] CGColor]];
//    [button setBackgroundColor:[[BaseController sharedInstance] getDefaultColor]];
//    [button addTarget:self action:@selector(openDownload) forControlEvents:UIControlEventTouchUpInside];
//
//    noInternetView.center = self.view.center;
//    [noInternetView addSubview:image];
//    [noInternetView addSubview:label];
//    [noInternetView addSubview:button];
//    [self.view addSubview:noInternetView];
    
    _couldNotConnectView.hidden = false;
}

- (void)openDownload{
    ShowDownloadsViewController *showDownloadsController = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowDownloadsViewController"];
    [self.navigationController pushViewController:showDownloadsController animated:NO];
}

- (void)hideNoInternet{
//    [noInternetView removeFromSuperview];
//    noInternetView = nil;
    _couldNotConnectView.hidden = true;
}

- (void)showLoading {
//    if(![SVProgressHUD isVisible]){
//        [[BaseController sharedInstance] setupLoading];
//
//        int screenSize =(int)[[UIScreen mainScreen] nativeBounds].size.height / 36;
//
//        [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, (CGFloat)screenSize )];
//
//        [SVProgressHUD show];
//
//    }
}

- (void)hideLoading {
//    if([SVProgressHUD isVisible])
//        [SVProgressHUD dismiss];
}

- (void)scrollViewPullToRefresh{

    [self.scrollView addPullToRefreshWithActionHandler:^{
        if(![AFNetworkReachabilityManager sharedManager].isReachable){
            [self.scrollView.pullToRefreshView stopAnimating];
            [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
            return;
        }
        [self pullToRefreshData];
    } topMargin:0.0];
    
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)connected {
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    
    if ([reach isReachable]) {
        return TRUE;
    } else {
        return FALSE;
    }
}


//MARK: - ViewMore

- (void) setupViewMores {
    

    // View More Labels inititalizations :
    
    UITapGestureRecognizer *bollywoodViewMoreTapGestures = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bollywoodViewMoreTapped:)];
    UITapGestureRecognizer *trailersViewMoreTapGestures = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(trailersViewMoreTapped:)];
    UITapGestureRecognizer *topVideoViewMoreTapGestures = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topVideoViewMoreTapped:)];
    UITapGestureRecognizer *artistsViewMoreTapGestures = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(artistsViewMoreTapped:)];
    UITapGestureRecognizer *mashupsViewMoreTapGestures = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mashupsViewMoreTapped:)];
    UITapGestureRecognizer *pakistaniViewMoreTapGestures = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pakistaniViewMoreTapped:)];
    UITapGestureRecognizer *gupshupViewMoreTapGestures = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gupshupViewMoreTapped:)];
    UITapGestureRecognizer *regionalViewMoreTapGestures = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(regionalViewMoreTapped:)];
    UITapGestureRecognizer *weddingViewMoreTapGestures = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weddingViewMoreTapped:)];
    UITapGestureRecognizer *evergreenViewMoreTapGestures = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(evergreenViewMoreTapped:)];
    UITapGestureRecognizer *playlistViewMoreTapGestures = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playlistViewMoreTapped:)];
    
    
    UITapGestureRecognizer *videoAdsVolumeTapGestures = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(volumeButtonTapped:)];
    
    [_bollywoodViewMore addGestureRecognizer: bollywoodViewMoreTapGestures];
    [_trailersViewMore addGestureRecognizer: trailersViewMoreTapGestures];
    [_topVideosViewMore addGestureRecognizer: topVideoViewMoreTapGestures];
    [_artistsViewMore addGestureRecognizer: artistsViewMoreTapGestures];
    [_mashupsViewMore addGestureRecognizer: mashupsViewMoreTapGestures];
    [_pakistaniViewMore addGestureRecognizer: pakistaniViewMoreTapGestures];
    [_gupshupsViewMore addGestureRecognizer: gupshupViewMoreTapGestures];
    [_regionalViewMore addGestureRecognizer: regionalViewMoreTapGestures];
    [_weddingViewMore addGestureRecognizer: weddingViewMoreTapGestures];
    [_evergreenViewMore addGestureRecognizer: evergreenViewMoreTapGestures];
    [_playlistsViewMore addGestureRecognizer: playlistViewMoreTapGestures];
    [_videoAdsControlView addGestureRecognizer: videoAdsVolumeTapGestures];
    
    
    _bollywoodViewMore.userInteractionEnabled = YES;
    _trailersViewMore.userInteractionEnabled = YES;
    _topVideosViewMore.userInteractionEnabled = YES;
    _artistsViewMore.userInteractionEnabled = YES;
    _mashupsViewMore.userInteractionEnabled = YES;
    _pakistaniViewMore.userInteractionEnabled = YES;
    _gupshupsViewMore.userInteractionEnabled = YES;
    _regionalViewMore.userInteractionEnabled = YES;
    _weddingViewMore.userInteractionEnabled = YES;
    _evergreenViewMore.userInteractionEnabled = YES;
    _playlistsViewMore.userInteractionEnabled = YES;
    
    
    _videoAdsControlView.userInteractionEnabled = YES;
   
    
    _trailersViewMore.hidden = NO ;
    _topVideosViewMore.hidden = NO ;
    
}

// The event handling method
- (void)bollywoodViewMoreTapped:(UITapGestureRecognizer *)recognizer
{
    
    BollywoodViewController *bollywood = [[UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle] instantiateViewControllerWithIdentifier:@"BollywoodViewController"];
    
    [self.navigationController pushViewController:bollywood animated:YES];
    
}
//The event handling method
- (void)trailersViewMoreTapped:(UITapGestureRecognizer *)recognizer
{
    
    
    DiscoverMoreViewController *discoverMoreVC = [[UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle] instantiateViewControllerWithIdentifier:@"discoverMoreViewController"];
    Discover *discover = [[Discover alloc]initWithID:[NSNumber numberWithInteger:16] title:@"Movie Trailers" permalink:@"trailers"];
    discoverMoreVC.discover = discover;
    
    [self.navigationController pushViewController:discoverMoreVC animated:YES];
    
}
//The event handling method
- (void)topVideoViewMoreTapped:(UITapGestureRecognizer *)recognizer
{

    DiscoverMoreViewController *discoverMoreVC = [[UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle] instantiateViewControllerWithIdentifier:@"discoverMoreViewController"];
    Discover *discover = [[Discover alloc]initWithID:[NSNumber numberWithInteger:16] title:@"Top Videos" permalink:@"top_videos"];
    discoverMoreVC.discover = discover;
    
    [self.navigationController pushViewController:discoverMoreVC animated:YES];
    
}
//The event handling method
- (void)artistsViewMoreTapped:(UITapGestureRecognizer *)recognizer
{
    
    
    
    ArtistViewController *artistsVC = [[UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle] instantiateViewControllerWithIdentifier:@"ArtistViewControllerIdentifier"];
    
    [self.navigationController pushViewController:artistsVC animated:YES];
    
}
//The event handling method
- (void)mashupsViewMoreTapped:(UITapGestureRecognizer *)recognizer
{
    
    
    
    MashupViewController *mashupVC = [[UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle] instantiateViewControllerWithIdentifier:@"MashupViewControllerIdentifier"];
    
    [self.navigationController pushViewController:mashupVC animated:YES];
    
}
//The event handling method
- (void)pakistaniViewMoreTapped:(UITapGestureRecognizer *)recognizer
{
    
    
    
    PakistaniViewController *pakistaniVC = [[UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle] instantiateViewControllerWithIdentifier:@"PakistaniViewControllerIdentifie"];
    
    [self.navigationController pushViewController:pakistaniVC animated:YES];
    
}
//The event handling method
- (void)gupshupViewMoreTapped:(UITapGestureRecognizer *)recognizer
{
    
    DiscoverMoreViewController *discoverMoreVC = [[UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle] instantiateViewControllerWithIdentifier:@"discoverMoreViewController"];
    Discover *discover = [[Discover alloc]initWithID:[NSNumber numberWithInteger:16] title:@"Bollywood Gupshup" permalink:@"gupshups"];
    discoverMoreVC.discover = discover;
    
    [self.navigationController pushViewController:discoverMoreVC animated:YES];
    
    
}
//The event handling method
- (void)regionalViewMoreTapped:(UITapGestureRecognizer *)recognizer
{
    
    NSNumber *number = [NSNumber numberWithInt:1];
    
    Discover * selectedDiscover = [[Discover alloc]initWithID:number title:@"Punjabi Songs" permalink:@"punjabi"];
    DiscoverMoreViewController * dmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"discoverMoreViewController"];
    dmvc.discover = selectedDiscover;
    [self.navigationController pushViewController:dmvc animated:YES];
    
}
//The event handling method
- (void)weddingViewMoreTapped:(UITapGestureRecognizer *)recognizer
{
    DiscoverMoreViewController *discoverMoreVC =  [[UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle] instantiateViewControllerWithIdentifier:@"discoverMoreViewController"];
    Discover *discover = [[Discover alloc] initWithID:[NSNumber numberWithInt:1] title:@"Wedding Songs" permalink:@"wedding"];
    
  
    discoverMoreVC.discover = discover;
    
    
    [self.navigationController pushViewController:discoverMoreVC animated:YES];
    
}
//The event handling method
- (void)evergreenViewMoreTapped:(UITapGestureRecognizer *)recognizer
{
    
    DiscoverMoreViewController *discoverMoreVC = [[UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle] instantiateViewControllerWithIdentifier:@"discoverMoreViewController"];
    Discover *discover = [[Discover alloc]initWithID:[NSNumber numberWithInteger:16] title:@"Evergreen Songs" permalink:@"evergreen"];
    discoverMoreVC.discover = discover;
    
    [self.navigationController pushViewController:discoverMoreVC animated:YES];
    
}
//The event handling method
- (void)playlistViewMoreTapped:(UITapGestureRecognizer *)recognizer
{
    
    DiscoverMoreViewController *discoverMoreVC = [[UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle] instantiateViewControllerWithIdentifier:@"discoverMoreViewController"];
    
    Discover *discover = [[Discover alloc]initWithID:[NSNumber numberWithInteger:16] title:@"Today's Playlist" permalink:@"playlists"];
    
    discoverMoreVC.discover = discover;
    
    [self.navigationController pushViewController:discoverMoreVC animated:YES];
    
    
    
}

- (void)volumeButtonTapped:(UITapGestureRecognizer *)recognizer
{
    
    if (volumeisMute){
        _videoAdsVolumeImageButton.image = [UIImage imageNamed:@"audioHigh"];
        volumeisMute = NO ;
        [videoAdsPlayer unmuteAds] ;
        
    }else {
        
        _videoAdsVolumeImageButton.image = [UIImage imageNamed:@"audioMute"];
        volumeisMute = YES ;
        [videoAdsPlayer muteAds] ;
        
    }

}




@end
