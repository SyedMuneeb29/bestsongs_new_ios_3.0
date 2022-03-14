//
//  DownloadViewController.m
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 7/30/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "DownloadViewController.h"
#import "LoginViewController.h"
#import "BaseController.h"
#import "PlayerViewController.h"
#import "AppDelegate.h"

@interface DownloadViewController () <IMAWebOpenerDelegate , IMAAdsLoaderDelegate, IMAAdsManagerDelegate>

// Tracking for play/pause
@property(nonatomic) BOOL isAdPlayback;



/// Content video player.
@property(nonatomic, strong) AVPlayer *contentPlayer;
@property(nonatomic, weak) AppDelegate* shared ;

// SDK
@property(nonatomic, strong) IMAAdsLoader *adsLoader;
@property(nonatomic, strong) IMAAVPlayerContentPlayhead *contentPlayhead;
@property(nonatomic, strong) IMAAdsManager *adsManager;

@property(nonatomic, strong) NSTimer *timer;

@end

@implementation DownloadViewController {
@private BOOL isStatusBarHidden;
@private BOOL isFullscreen;
@private  BOOL addShown;
@private  BOOL autoRotate;
    Boolean viewdisappear;
}
    
#pragma mark Set-up methods

// Set up the new view controller.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _shared =  [UIApplication sharedApplication].delegate;
    
    _shared.unBlockRotation = YES;
    
        [[NSNotificationCenter defaultCenter] postNotificationName:@"stopSongAddsPlaying" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"videoViewIsDisplayed" object:nil];
    
    viewdisappear = false;
    
    addShown = NO;
    autoRotate = YES;
    
    [[PlayerViewController sharedInstance] pause];
    CGFloat spacing = 3.0;
    // Back Button
    CGSize imageSize = self.backButton.imageView.image.size;
    self.backButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    CGSize titleSize = [self.backButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.backButton.titleLabel.font}];
    self.backButton.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
    [self.backButton addTarget:self action:@selector(didTap:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat edgeOffset = fabs(titleSize.height - imageSize.height) / 2.0;
    self.backButton.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset, 0.0, edgeOffset, 0.0);
    
    // Setup Spinner
    self.spinner.tintColor = [[UIColor alloc]initWithRed:182.0/255.0 green:0.0/255.0 blue:61.0/255.0 alpha:1.0];
    self.spinner.lineWidth = 1.5f;
    
    // muneeb
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
    
    // muneeb
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(pauseVideoPlayer:) name: @"pauseVideoPlayerAudio" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(playVideoPlayer:) name: @"playVideoPlayerAudio" object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    /*if(![baseController checkIsUserLogin]){
     LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
     loginViewController.didDismiss = ^(NSString *data) {
     if([baseController checkIsUserLogin])
     [self setupAdPlayer];
     else
   
        [self dismissViewControllerAnimated:YES completion:nil];
     };
     loginViewController.modalInPopover = YES;
     loginViewController.hidesBottomBarWhenPushed = YES;
     loginViewController.modalPresentationStyle = UIModalPresentationFullScreen;
     [self presentViewController:loginViewController animated:YES completion:nil];
     } else
     [self setupAdPlayer];*/
    [self setupAdPlayer];
    
    
    
    [[ NSNotificationCenter defaultCenter ] postNotificationName:@"hideHomeAdd" object:nil];
    
    
}

- (void) dismissMyself {
    [UIView animateWithDuration:0.25 delay:10 options:UIViewAnimationOptionCurveLinear  animations:^{
        _videoView.alpha = 0;
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        [UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationPortrait;
        [UINavigationController attemptRotationToDeviceOrientation];
        [self toOrientation:UIInterfaceOrientationPortrait];
        isFullscreen = NO;
        
    } completion:^(BOOL finished) {
     
        [UIView transitionWithView:_videoView duration:0.25 options: UIViewAnimationOptionAutoreverse animations:^{
            _videoView.alpha = 1;
        } completion:^(BOOL finished) {
               [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
     
        
    }];
  
    
    
}

- (IBAction)didTap:(id)sender{
    
   
    
    if(self.timer != nil){
        @try{
            [self.timer invalidate];
            self.timer = nil;
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pauseVideoPlayerAudio" object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"playVideoPlayerAudio" object:nil];
        }@catch(id anException){
        }
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"videoViewIsDisappearing" object:nil];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
    } else {
        [self.view makeToast:@"Press back again to exit" duration:[CSToastManager defaultDuration] position:CSToastPositionCenter];
        [CSToastManager setTapToDismissEnabled:YES];
        [CSToastManager setQueueEnabled:NO];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target: self
                                                    selector:@selector(onTick)
                                                    userInfo: nil repeats:NO];
    }
    
    
    
    
}

-(void)onTick{
    [self.timer invalidate];
    self.timer = nil;
}

-(void)pauseVideoPlayer: (NSNotification*)notification{
}

-(void)playVideoPlayer: (NSNotification*)notification{
    [self reset];
    [self ShowLoading];
    [self requestAds];
}

- (void)setupAdPlayer {
    isStatusBarHidden = NO;
    isFullscreen = NO;
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft ||
        [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
     [UIApplication sharedApplication].statusBarOrientation = [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft ? UIInterfaceOrientationLandscapeLeft : UIInterfaceOrientationLandscapeRight;
        isFullscreen = YES;
      [self toOrientation:[[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft ? UIInterfaceOrientationLandscapeLeft : UIInterfaceOrientationLandscapeRight];
    }
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self ShowLoading];
        [self setupAdsLoader];
        [self setUpContentPlayer];
        [self requestAds];
    });
}



-(void)downloadMP3File {
    
     // uncomment the following when turning auto rotate on
    
  //  [self dismissMyself];
    
    _shared.unBlockRotation = NO;
   
    autoRotate = NO;
    addShown = YES;
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    [UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationPortrait;
    [UINavigationController attemptRotationToDeviceOrientation];
     [self toOrientation:UIInterfaceOrientationPortrait];
    isFullscreen = NO;
    // do what you want to do.
    [[BaseController sharedInstance] showToastError:@"Track Already Exists"];
    // [NSThread sleepForTimeInterval:1.50];
  
    // uncomment the following when turning auto rotate on
    
   //  [self dismissMyself];
    
    
    [self dismissViewControllerAnimated:NO completion:nil];
 
  
    
    NSString *URL = self.song.AudioURL;
    @try{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pauseVideoPlayerAudio" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"playVideoPlayerAudio" object:nil];
        isFullscreen = NO;
        isStatusBarHidden = NO;
        [self.adsManager destroy];
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    }@catch(id anException){
    }
    if([self checkFileAlreadyExists:[NSString stringWithFormat:@"%@%@",self.song.Title,@".mp3"]]){
     
            
            NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
            [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
            [UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationPortrait;
            
          
            isFullscreen = NO;
        
             [[BaseController sharedInstance] showToastError:@"Track Already Exists"];
        
        
         // uncomment the following when turning auto rotate on
            
     //  [self dismissMyself];
    
       [self dismissViewControllerAnimated:NO completion:nil];
        
            
        
           [[NSNotificationCenter defaultCenter] postNotificationName:@"videoViewIsDisappearing" object:nil];
        
    } else {
        [[ObjectiveCDM sharedInstance] addDownloadTask:@{@"url": URL, @"destination": [NSString stringWithFormat:@"%@%@" , self.song.Title , @".mp3"]}];
        [[ObjectiveCDM sharedInstance] startDownloadingCurrentBatch];
        [[BaseController sharedInstance] showToastSuccess:@"Offline Saving Has Been Started.."];
   
            
            
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        [UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationPortrait;
        [UINavigationController attemptRotationToDeviceOrientation];
        //  [self toOrientation:UIInterfaceOrientationPortrait];
            isFullscreen = NO;
            // do what you want to do.
        
         // uncomment the following when turning auto rotate on
        
        //  [self dismissMyself];
    
         [self dismissViewControllerAnimated:NO completion:nil];
        
            if (self.didDismiss)
                self.didDismiss(@"some extra data");
            
            

         [[NSNotificationCenter defaultCenter] postNotificationName:@"videoViewIsDisappearing" object:nil];
    }
    
    
}

-(bool)checkFileAlreadyExists:(NSString *)fileName {
    NSString *filename = fileName;
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [pathArray objectAtIndex:0];
    NSString *yourSoundPath = [documentsDirectory stringByAppendingPathComponent:filename];
    if ([[NSFileManager defaultManager] fileExistsAtPath:yourSoundPath])
        return YES;
    else
        return NO;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

    if(!addShown){

        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown ) { return; }

        switch (interfaceOrientation) {
            case UIInterfaceOrientationPortraitUpsideDown:{
            }
                break;
            case UIInterfaceOrientationPortrait:{
                if (isFullscreen) {
                    [self toOrientation:UIInterfaceOrientationPortrait];
                    isFullscreen = NO;
                } else {
                    [self toOrientation:UIInterfaceOrientationPortrait];
                }
            }
                break;
            case UIInterfaceOrientationLandscapeLeft:{
                if (isFullscreen == NO) {
                    [self toOrientation:UIInterfaceOrientationLandscapeLeft];
                    isFullscreen = YES;
                } else {
                    [self toOrientation:UIInterfaceOrientationLandscapeLeft];
                }

            }
                break;
            case UIInterfaceOrientationLandscapeRight:{
                if (isFullscreen == NO) {
                    [self toOrientation:UIInterfaceOrientationLandscapeRight];
                    isFullscreen = YES;
                } else {
                    [self toOrientation:UIInterfaceOrientationLandscapeRight];
                }
            }
                break;
            default:
                break;
        }


    }
}

- (void)toOrientation:(UIInterfaceOrientation)orientation {
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (currentOrientation == orientation) { return; }

    if (orientation == UIInterfaceOrientationPortrait) {
        if(!isFullscreen)
            isFullscreen = YES;
    }

    // Depending on the direction you want to rotate, use Masonry to redefine the limit
    if (orientation != UIInterfaceOrientationPortrait) {
        if (currentOrientation == UIInterfaceOrientationPortrait) {
            isFullscreen = NO;
        }
    }
    [self resizeVideoPlayer];
    [UIApplication sharedApplication].statusBarOrientation = orientation;
}

- (void) resizeVideoPlayer {
    if(isFullscreen){
        isStatusBarHidden = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomBar.alpha = 0;
            self.advertisementLabel.alpha = 0;
        } completion:^(BOOL finished) {
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    } else {
        isStatusBarHidden = NO;
        self.bottomBar.alpha = 0;
        self.advertisementLabel.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomBar.alpha = 1;
            self.advertisementLabel.alpha = 1;
        } completion:^(BOOL finished) {
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    }
    [self.view setNeedsDisplay];
}

- (void)setUpContentPlayer {
    NSURL *contentURL = [NSURL URLWithString:@""];
    self.contentPlayer = [AVPlayer playerWithURL:contentURL];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.contentPlayer];
    
    playerLayer.frame = self.videoView.layer.bounds;
    [self.videoView.layer addSublayer:playerLayer];
    
    self.contentPlayhead = [[IMAAVPlayerContentPlayhead alloc] initWithAVPlayer:self.contentPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentDidFinishPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.contentPlayer.currentItem];
    
}

#pragma mark SDK Setup
- (void)setupAdsLoader {
    self.adsLoader = [[IMAAdsLoader alloc] initWithSettings:nil];
    self.adsLoader.delegate = self;
}

- (void)requestAds {
    IMAAdDisplayContainer *adDisplayContainer =
    [[IMAAdDisplayContainer alloc] initWithAdContainer:self.videoView companionSlots:nil];
    
    IMAAdsRequest *request = [[IMAAdsRequest alloc] initWithAdTagUrl:ADTAGURL
                                                  adDisplayContainer:adDisplayContainer
                                                     contentPlayhead:self.contentPlayhead
                                                         userContext:nil];
    [self.adsLoader requestAdsWithRequest:request];
}

- (void)contentDidFinishPlaying:(NSNotification *)notification {
    if (notification.object == self.contentPlayer.currentItem) {
        [self.adsLoader contentComplete];
    }
}

#pragma mark AdsLoader Delegates

- (void)adsLoader:(IMAAdsLoader *)loader adsLoadedWithData:(IMAAdsLoadedData *)adsLoadedData {
    self.adsManager = adsLoadedData.adsManager;
    self.adsManager.delegate = self;
    // Create ads rendering settings to tell the SDK to use the in-app browser.
    IMAAdsRenderingSettings *adsRenderingSettings = [[IMAAdsRenderingSettings alloc] init];
    adsRenderingSettings.bitrate = 1024;  // kbits
    adsRenderingSettings.mimeTypes = @[ @"application/x-mpegURL"];
    adsRenderingSettings.webOpenerPresentingController = nil;
    adsRenderingSettings.webOpenerDelegate = self;
    // Initialize the ads manager.
    [self.adsManager initializeWithAdsRenderingSettings:adsRenderingSettings];
}

- (void)adsLoader:(IMAAdsLoader *)loader failedWithErrorData:(IMAAdLoadingErrorData *)adErrorData {
    [self reset];
    [self ShowLoading];
    [self requestAds];
}

#pragma mark AdsManager Delegates

- (void)adsManager:(IMAAdsManager *)adsManager didReceiveAdEvent:(IMAAdEvent *)event {
    // When the SDK notified us that ads have been loaded, play them.
    switch (event.type) {
        case kIMAAdEvent_LOADED:
            [self ShowLoading];
            
            [self.adsManager start];
            break;
        case kIMAAdEvent_STARTED:
            
            [self HideLoading];
            
            break;
        case kIMAAdEvent_RESUME:
            
            [self HideLoading];
            
            break;
        case kIMAAdEvent_PAUSE:
            
            //            [self ShowLoading];
            
            break;
        case kIMAAdEvent_TAPPED:
            break;
        case kIMAAdEvent_ALL_ADS_COMPLETED:{
            [self downloadMP3File];
            addShown = YES;
            [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationMaskPortrait) forKey:@"orientation"];
            [UINavigationController attemptRotationToDeviceOrientation];
            UIInterfaceOrientation statusBarOrientation =[UIApplication sharedApplication].statusBarOrientation;
            statusBarOrientation = UIInterfaceOrientationPortrait;
            autoRotate = NO;
            [NSThread sleepForTimeInterval:2];
            break;
        case kIMAAdEvent_COMPLETE:
            [self downloadMP3File];
            
            addShown = YES;
            [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationMaskPortrait) forKey:@"orientation"];
            [UINavigationController attemptRotationToDeviceOrientation];
            statusBarOrientation = UIInterfaceOrientationPortrait;
            autoRotate = NO; 
            [NSThread sleepForTimeInterval:2];
            
            break;
            
        }
        default:
            break;
    }
}

- (void)adsManager:(IMAAdsManager *)adsManager didReceiveAdError:(IMAAdError *)error {
    [self reset];
    [self ShowLoading];
    [self requestAds];
}

- (void)adsManagerDidRequestContentPause:(IMAAdsManager *)adsManager {
    // The SDK is going to play ads, so pause the content.
}

- (void)adsManagerDidRequestContentResume:(IMAAdsManager *)adsManager {
    // The SDK is done playing ads (at least for now), so resume the content.
    
    
    
}

//muneeb
- (void) orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            /* start special animation */
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            /* start special animation */
            break;
        case UIDeviceOrientationLandscapeLeft :
            if (!autoRotate) {
             [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationIsPortrait(YES)];
                
                float   angle = -M_PI/2;  //rotate 180°, or 1 π radians
                self.view.layer.transform = CATransform3DMakeRotation(angle, 0, 0.0, 1.0);
            }
            break;
        case UIDeviceOrientationLandscapeRight :
            if (!autoRotate) {
              [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationIsPortrait(YES)];
               
                float   angle = M_PI/2;  //rotate 180°, or 1 π radians
                self.view.layer.transform = CATransform3DMakeRotation(angle, 0, 0.0, 1.0);
            }
            break;
            
        default:
            break;
    };
}

- (BOOL)shouldAutorotate {
    
    return NO;

    // un comment when turnong auto rotate on
    
//    if(autoRotate){
//        return YES;
//    }else{
//        return NO;
//    }
    
    
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    if (!addShown && autoRotate){
    return UIInterfaceOrientationMaskAll;
    }
    else{
        return UIInterfaceOrientationMaskPortrait;
    }
}




- (void)reset {
    @try{
        [[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:AVPlayerItemDidPlayToEndTimeNotification
         object:nil];
        [self.adsManager destroy];
    }@catch(id anException){
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    _shared.unBlockRotation = NO;
    
   
    
    [self.contentPlayer pause];
    [self.adsManager destroy];
    
    // Don't reset if we're presenting a modal view (e.g. in-app clickthrough).
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        if (self.adsManager) {
            [self.adsManager destroy];
            self.adsManager = nil;
        }
        self.contentPlayer = nil;
    }
    [super viewWillDisappear:animated];
    
    viewdisappear = true;

  
    
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

-(void)HideLoading {
    [self.spinner stopAnimating];
    self.spinner.hidden = YES;
}

-(void)ShowLoading {
    [self.spinner startAnimating];
    self.spinner.hidden = NO;
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

-(BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
    [super viewDidAppear:animated];
    
    
    if (viewdisappear == true) {
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self ShowLoading];
            [self setupAdsLoader];
            [self setUpContentPlayer];
            [self requestAds];
        });
        
    }
    
}

- (void)appDidBecomeActive:(NSNotification *)notification {
    
    
    //    if (viewdisappear == true) {
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self ShowLoading];
        [self setupAdsLoader];
        [self setUpContentPlayer];
        [self requestAds];
    });
    //
    //    }
}

- (void)appWillEnterForeground:(NSNotification *)notification {
    viewdisappear = true;
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewDidDisappear:animated];
    
    //
    //    [[NSNotificationCenter defaultCenter]
    //     removeObserver:self
    //     name:UIApplicationDidBecomeActiveNotification
    //     object:[UIApplication sharedApplication]];
    //
    //    [_contentPlayer pause];
    //    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
    //        if (_adsManager) {
    //            [_adsManager destroy];
    //                        _adsManager = nil;
    //        }
    //        _contentPlayer = nil;
    //    }
    //    [super viewWillDisappear:animated];
    
    
    
}

@end
