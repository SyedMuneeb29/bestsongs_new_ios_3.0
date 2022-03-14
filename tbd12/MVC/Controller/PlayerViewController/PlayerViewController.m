//
//  PlayerViewController.m
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 7/28/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "PlayerViewController.h"
#import "VideoViewController.h"
#import "DownloadViewController.h"
// #import "AddToPlaylistViewController.h"
#import "CNPPopupController.h"
#import "LoginViewController.h"
#import "UIView+Toast.h"
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import <AVFoundation/AVFoundation.h>
#import <SDWebImage/UIImageView+WebCache.h>

@import LNPopupController;

static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;



typedef enum { PlayButton, PauseButton } PlayButtonType;
typedef enum { playIcon , barsIcon , bufferingIcon } PopupBarLeftButton;

@interface PlayerViewController () <CNPPopupControllerDelegate , PlayerTableViewCellDelegate , STKAudioPlayerDelegate> {
    ObjectiveCDM* objectiveCDM;
    UIColor *colour;
    UIImage *albumImage;
    
    NSString *sharingLink;
    
    NSTimer* timer;
    NSUInteger _currentTrackIndex;
    BOOL isSliderTouches;
    BOOL isReloaded;
    NSUInteger deleteSongIndex;
    BOOL hasAudioInterruptStarted;
    BOOL isRepeat;
    
    //PopupBar Left Icon
    UIView *popupBarOverlayView;
    NAKPlaybackIndicatorView *popupBarIndicator;
    UIImageView *popupBarPlayIcon;
    MMMaterialDesignSpinner *popupBarSpinner;
    UIImage *popupBarPoster;
    NSArray *objectiveCDMDownloadingTasks;
    
    
    BOOL addHasPausedThePlayer;
    
}

// Playlist Popup Controller View
@property (nonatomic, strong) AddToPlaylistViewController *addToPlayListViewController;
@property (nonatomic, strong) CNPPopupController *popupController;

//@property (nonatomic, strong) AVAudioSession *audioSession;

@property(nonatomic, strong) UIImage *playBtnBG;
@property(nonatomic, strong) UIImage *pauseBtnBG;



@end

@implementation PlayerViewController

+ (instancetype)sharedInstance {
    static PlayerViewController *_sharedPlayerVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
        _sharedPlayerVC = [storyBoard instantiateViewControllerWithIdentifier:@"Player"];
    });
    return _sharedPlayerVC;
}

-(void)audioSessionInterruptionNotification:(NSNotification*)notification {
    //Check the type of notification, especially if you are sending multiple AVAudioSession events here
    if ([notification.name isEqualToString:AVAudioSessionInterruptionNotification]) {
        NSInteger interuptionType = [[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] integerValue];
        switch (interuptionType) {
            case AVAudioSessionInterruptionTypeBegan:{
                if([_audioPlayer state] != STKAudioPlayerStatePaused && !hasAudioInterruptStarted){
                    [self pause];
                    hasAudioInterruptStarted = YES;
                }
                break;
            }
            case AVAudioSessionInterruptionTypeEnded:{
                if ([_audioPlayer state] == STKAudioPlayerStatePaused && hasAudioInterruptStarted){
                    [self play];
                    hasAudioInterruptStarted = NO;
                }
                break;
            }
        }
    }
}

- (void) addWillPauseThePlayerWhenAddWillRun{
    
    addHasPausedThePlayer = false;
    
    
    if (!_audioPlayer)
        return;
    
    if (_audioPlayer.state != STKAudioPlayerStatePaused){
        
        addHasPausedThePlayer = true;
        [_audioPlayer pause];
    }
}

- (void) addWillPlayThePlayerAfterFinishingAdd{
    
    if (!_audioPlayer)
        return;
    
    if(hasAudioInterruptStarted)
        hasAudioInterruptStarted = NO;
    
    if (addHasPausedThePlayer == true) {
        
        if (_audioPlayer.state == STKAudioPlayerStatePaused)
            [_audioPlayer resume];
        
    }
    
    addHasPausedThePlayer =false;
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    


    

    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(addWillPauseThePlayerWhenAddWillRun) name: @"autoPlayerAddIsNowRunning" object: nil];

    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(addWillPlayThePlayerAfterFinishingAdd) name: @"autoPlayerAddHasNowFinishedRunning" object: nil];


    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(applicationDidEnterBackground) name: UIApplicationDidEnterBackgroundNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(applicationWillEnterForeground) name: UIApplicationWillEnterForegroundNotification object: nil];


    hasAudioInterruptStarted = NO;
    sharingLink = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.songTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0); // Makes the horizontal row seperator stretch the entire length of the table view
    }

    AVAudioSession *session = [AVAudioSession sharedInstance];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionInterruptionNotification:)  name:AVAudioSessionInterruptionNotification object:session];

    _audioPlayer = [[STKAudioPlayer alloc] initWithOptions:(STKAudioPlayerOptions){
        .flushQueueOnSeek = YES,
        .enableVolumeMixer = NO,
        .equalizerBandFrequencies = {50, 100, 200, 400, 800, 1600, 2600, 16000}
    }];
    _audioPlayer.meteringEnabled = YES;
    _audioPlayer.volume = 1;
    _audioPlayer.delegate = self;

    objectiveCDM = [ObjectiveCDM sharedInstance];
    objectiveCDM.uiDelegate = self;
    objectiveCDM.dataDelegate = self;
    colour = [[UIColor alloc]initWithRed:255.0/255.0 green:64.0/255.0 blue:129.0/255.0 alpha:1.0];
    // Setup Spinner

    _spinnerView.tintColor = [[UIColor alloc]initWithRed:182.0/255.0 green:0.0/255.0 blue:61.0/255.0 alpha:1.0];
    _spinnerView.lineWidth = 2.5f;
    [_spinnerView startAnimating];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_spinnerView addGestureRecognizer:tapGestureRecognizer];

    isSliderTouches = NO;

    CGRect screen = [[UIScreen mainScreen] bounds];
    _songTableView.tableFooterView = [UIView new];
    [_earPhoneBtn setImage:[UIImage imageNamed:@"audioHigh.png"] forState:UIControlStateNormal];
    self.playBtn.adjustsImageWhenHighlighted = NO;
    /*self.audioSession = [AVAudioSession sharedInstance];
     [self.audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
     [self.audioSession setActive:YES error:nil];*/

    // Playlist View Controller
    _addToPlayListViewController = [AddToPlaylistViewController instantiateFromNib];

    _posterHeight.constant = screen.size.width / 2;
    _posterWidth.constant = screen.size.width / 2;

    _posterLayer.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    _posterLayer.layer.shadowColor = [UIColor blackColor].CGColor;
    _posterLayer.layer.shadowRadius = 6.0;
    _posterLayer.layer.shadowOpacity = 1.0;

    // Setup Color

    // Hide Progressbar and Other Buttons
    _playHeadTime.hidden = YES;
    _playHeadDuration.hidden = YES;
    _musicSlider.hidden = YES;
    _bufferingBar.hidden = YES;
    _downloadMP3Btn.hidden = YES;
    _shareBtn.hidden = YES;
    _watchVideoBtn.hidden = YES;
    _previousBtn.hidden = YES;
    _nextBtn.hidden = YES;
    _earPhoneBtn.hidden = YES;

    _spinnerView.hidden = YES;
    [self ShowLoading];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self popupOverlayView];
        [self popupIndicator];
        [self popupPlay];
        [self popupSpinner];

        //        [self createPopupbarLeftButton:bufferingIcon];


        UIBarButtonItem *playerClose = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Close-Icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(playerCloseButtonPressed)];
        playerClose.title = NSLocalizedString(@"", @"");
        self.popupItem.rightBarButtonItems = @[ playerClose ];

        [self createPopupbarLeftButton:bufferingIcon];
    });

    // Border Label
    _playHeadTime.layer.cornerRadius = 5;
    _playHeadTime.layer.borderColor = (__bridge CGColorRef _Nullable)(colour);
    _playHeadTime.layer.borderWidth = 1;
    _playHeadTime.layer.masksToBounds = YES;

    _playHeadDuration.layer.cornerRadius = 5;
    _playHeadDuration.layer.borderColor = (__bridge CGColorRef _Nullable)(colour);
    _playHeadDuration.layer.borderWidth = 1;
    _playHeadDuration.layer.masksToBounds = YES;

    // Set Button Border
    _watchVideoBtn.layer.cornerRadius = 15;
    _watchVideoBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _watchVideoBtn.layer.borderWidth = 1;
    _watchVideoBtn.layer.masksToBounds = YES;

    _shareBtn.layer.cornerRadius = 15;
    _shareBtn.layer.borderColor = (__bridge CGColorRef _Nullable)(colour);
    _shareBtn.layer.borderWidth = 1;
    _shareBtn.layer.masksToBounds = YES;

    _downloadMP3Btn.layer.cornerRadius = 15;
    _downloadMP3Btn.layer.borderColor = [UIColor whiteColor].CGColor;
    _downloadMP3Btn.layer.borderWidth = 1;
    _downloadMP3Btn.layer.masksToBounds = YES;

    _playBtnBG = [UIImage imageNamed:@"play"];
    _pauseBtnBG = [UIImage imageNamed:@"pause"];

    [_songTableView setTableFooterView:[[BaseController sharedInstance] getTableViewFooterView]];

    [self setupTimer];
    [self updateControls];


    
}



- (void)applicationDidEnterBackground {
    printf("PlayerViewController:applicationDidEnterBackground\n");
}

- (void)applicationWillEnterForeground {
    printf("PlayerViewController:applicationWillEnterForeground\n");
    [self updateControls];
}

-(void) setupTimer {
    
    timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}

-(void) tick {
    

    if (!_audioPlayer) {
        _musicSlider.value = 0;
        self.popupItem.progress = 0;
        return;
    }

    if (_audioPlayer.currentlyPlayingQueueItemId == nil) {
        self.popupItem.progress = 0;
        _musicSlider.value = 0;
        _musicSlider.minimumValue = 0;
        _musicSlider.maximumValue = 0;
        return;
    }

    if (_audioPlayer.duration != 0) {

        _musicSlider.minimumValue = 0;
        _musicSlider.maximumValue = _audioPlayer.duration;
        _musicSlider.value = _audioPlayer.progress;
        _playHeadTime.text = [NSString stringWithFormat:@"%@",[self formatTimeFromSeconds:_audioPlayer.progress]];
        _playHeadDuration.text = [NSString stringWithFormat:@"%@",[self formatTimeFromSeconds:_audioPlayer.duration]];
        self.popupItem.progress = ((float)_audioPlayer.progress / (float)_audioPlayer.duration);
        // Setup Media Player
        MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
        NSMutableDictionary *playingInfo = [NSMutableDictionary dictionaryWithDictionary:center.nowPlayingInfo];
        [playingInfo setObject:[NSNumber numberWithFloat:_audioPlayer.progress] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        [playingInfo setObject:[NSNumber numberWithFloat:_audioPlayer.duration] forKey:MPMediaItemPropertyPlaybackDuration];
        center.nowPlayingInfo = playingInfo;
    }
    else {
        self.popupItem.progress = 0;
        _musicSlider.value = 0;
        _musicSlider.minimumValue = 0;
        _musicSlider.maximumValue = 0;
    }
    
    
}

-(NSString*) formatTimeFromSeconds:(int)totalSeconds {
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    if(hours == 00){
        return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    } else {
        return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    }
}

-(void) updateControls {
    if(_audioPlayer == nil)
        return;
    switch (_audioPlayer.state) {
        case STKAudioPlayerStatePlaying:{
            [MusicIndicator sharedInstance].state = NAKPlaybackIndicatorViewStatePlaying;
            [self HideLoading];
            [self setPlayButtonType:PauseButton];
            popupBarIndicator.state = NAKPlaybackIndicatorViewStatePlaying;
            [self addPopupBarOverlaySubView:popupBarIndicator];
            break;
        }
        case STKAudioPlayerStatePaused:{
            [MusicIndicator sharedInstance].state = NAKPlaybackIndicatorViewStatePaused;
            [self setPlayButtonType:PlayButton];
            [self addPopupBarOverlaySubView:popupBarPlayIcon];
            [self HideLoading];
            break;
        }
        case STKAudioPlayerStateBuffering:{
            [self ShowLoading];
            [MusicIndicator sharedInstance].state = NAKPlaybackIndicatorViewStatePaused;
            [self addPopupBarOverlaySubView:popupBarSpinner];
            break;
        }
        case STKAudioPlayerStateStopped:{
            [MusicIndicator sharedInstance].state = NAKPlaybackIndicatorViewStatePaused;
            [self setPlayButtonType:PlayButton];
            [self addPopupBarOverlaySubView:popupBarPlayIcon];
        }
        case STKAudioPlayerStateError:{
            //[[BaseController sharedInstance] showToastError:@"Can't Play this track. :(" ];
            
            [MusicIndicator sharedInstance].state = NAKPlaybackIndicatorViewStatePaused;
            [self HideLoading];
            [self setPlayButtonType:PlayButton];
            popupBarIndicator.state = NAKPlaybackIndicatorViewStatePaused;
            [self addPopupBarOverlaySubView:popupBarIndicator];
            break;
            
            break;
        }
        case STKAudioPlayerStateReady:{
            break;
        }
        case STKAudioPlayerStateRunning:{
            break;
        }
        case STKAudioPlayerStateDisposed:{
            break;
        }
        default:{
            [MusicIndicator sharedInstance].state = NAKPlaybackIndicatorViewStatePaused;
            [self setPlayButtonType:PlayButton];
            [self addPopupBarOverlaySubView:popupBarPlayIcon];
            break;
        }
    }
    [self updatePlaybackIndicatorOfVisisbleCells];
   // [self tick];
}

/*************************** Player *****************************/
- (void)createStreamer {
    if (0 == [_tracks count])
        return;
    
    _selectedSong = [_tracks objectAtIndex:_currentTrackIndex];
    
    [self fabricContentViewOfSelectedSongAddition:_selectedSong];
    
    NSURL* url = nil;
    if(_isRunFromDownload){
        url = [NSURL fileURLWithPath:_selectedSong.AudioURL];
    } else {
        url = [NSURL URLWithString:_selectedSong.AudioURL];
    }
    STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
    [_audioPlayer setDataSource:dataSource withQueueItemId:[[QueueId alloc] initWithUrl:url andCount:0]];
    
    [self changeTopSongAndAlbumTitle];
    [_songTableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentTrackIndex inSection:0];
    [_songTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    _musicSlider.value = 0.0f;
    _bufferingBar.progress = 0.0f;
    _playHeadDuration.text = [NSString stringWithFormat:@"%02d:%02d", 00, 00];
    _playHeadTime.text = [NSString stringWithFormat:@"%02d:%02d", 00, 00];
    
    [self play];
    if(_isRunFromDownload){
        _bufferingBar.progress = 1.0;
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:_selectedSong.AudioURL] options:nil];
        int time = (int)CMTimeGetSeconds(asset.duration);
        int second = time % 60;
        int minute = (time / 60) % 60;
        _playHeadDuration.text = [NSString stringWithFormat:@"%02d:%02d", minute, second];
    }
}

- (IBAction)didChangeMusicSliderValue:(id)sender {
    if (!_audioPlayer) {
        return;
    }
    [_audioPlayer seekToTime:_musicSlider.value];
}

- (void)progressSliderTouchBegan:(UISlider *)slider {
}

- (void)progressSliderValueChanged:(UISlider *)slider {
}


- (void)progressSliderTouchEnded:(UISlider *)slider {
    if (!_audioPlayer)
        return;
    [_audioPlayer seekToTime:slider.value];
}

- (void)tapSliderAction:(UITapGestureRecognizer *)tap {
    if (!_audioPlayer)
        return;
    if ([tap.view isKindOfClass:[UISlider class]]) {
        UISlider *slider = (UISlider *)tap.view;
        CGPoint point = [tap locationInView:slider];
        CGFloat length = slider.frame.size.width;
        CGFloat tapValue = point.x / length;
        [_audioPlayer seekToTime:tapValue];
    }
}

# pragma mark - Handle Music Slider
/*************************** Player *****************************/

- (void)watchBtn:(id)sender {
    if(_isRunFromDownload){
        [self.view makeToast:@"No Video"];
        [CSToastManager setTapToDismissEnabled:YES];
        [CSToastManager setQueueEnabled:NO];
        return;
    }
    if(_selectedSong.ID != 0){
        if(_selectedSong.IsVideo){
            Video *video = [[Video alloc] initWithID:_selectedSong.ID title:_selectedSong.Title videoURL:_selectedSong.VideoURL albumName:_selectedSong.AlbumTitle poster:_selectedSong.Poster permalink:_selectedSong.VideoPermalink];
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
         //   [[BaseController sharedInstance] openVideoPlayer:storyBoard andVideo:video andRootViewController:self.view.window.rootViewController];
          
            [self showLoading2];
            
            
            [[BaseController sharedInstance] openVideoPlayerWithType:self.storyboard andVideo:video andRootViewController:self.view.window.rootViewController andType:@"track"];
        }else{
            [self.view makeToast:@"No Video"];
            [CSToastManager setTapToDismissEnabled:YES];
            [CSToastManager setQueueEnabled:NO];
        }
    }
}

- (void)downloadBtn:(id)sender {
    if(_isRunFromDownload){
        [self.view makeToast:@"Can't Save Already Saved Song"];
        [CSToastManager setTapToDismissEnabled:YES];
        [CSToastManager setQueueEnabled:NO];
        return;
    }
    if(_selectedSong.ID != 0){
        if(_selectedSong.IsDownload){
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
            DownloadViewController *downloadViewController = [[BaseController sharedInstance] downloadMP3:storyBoard song:_selectedSong rootViewController:self.view.window.rootViewController];
            downloadViewController.didDismiss = ^(NSString *data) {
                objectiveCDMDownloadingTasks = [objectiveCDM downloadingTasks];
                [self.songTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            };
        }
    }
}

- (void) contentNotAvailablePopUp {
    
    self.addToContentNotAvailablePopupViewController = [[ContentNotAvailableViewController alloc] init];
    [self presentViewController:_addToContentNotAvailablePopupViewController animated:YES completion:nil];
    
}



- (void)shareBtn:(id)sender {
    
    if(![AFNetworkReachabilityManager sharedManager].isReachable){
        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
        return;
    }
    if(_isRunFromDownload){
        [self.view makeToast:@"Can't Share Offline Songs.."];
        [CSToastManager setTapToDismissEnabled:YES];
        [CSToastManager setQueueEnabled:NO];
        return;
    }
    
    //    /// generating share link  :::::::
    //    NSString *urlString =  [NSString stringWithFormat:@"https://api2-dot-bestsongs-156307.appspot.com/v1/albums/%@/share_url",_album.ID];
    //    NSURL *urlToFetchShareURL = [NSURL URLWithString:urlString];
    //
    //
    //    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:urlToFetchShareURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    //
    //        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    //
    //        NSInteger regionErrorCode = 403;
    //
    //        if ([httpResponse statusCode] != regionErrorCode){
    //
    //
    //            NSDictionary *dataDictionary = (NSDictionary *) data;
    //            NSString *shareurl = dataDictionary[@"share_url"];
    //
    //            NSLog(@"album share url is here :: %@",shareurl);
    //        }
    //        else{
    //
    //          NSLog(@"album share url is here :: error");
    //        }
    //
    //    }];
    //    [task resume];
    //
    //    /// checking region :::::::
    //
    //
    
    
    if( ![_album.Permalink isEqualToString:@""] || [_album.Permalink isEqualToString:@""] ){
        if(!(_album.Permalink == nil)){
            if(_playlist == nil){
                [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
                [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
                int screenSize =(int)[[UIScreen mainScreen] nativeBounds].size.height / 36 ;
                
                [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, (CGFloat)screenSize )];
                [SVProgressHUD showWithStatus:@"Generating Share Link"];
                [CSToastManager setTapToDismissEnabled:YES];
                [CSToastManager setQueueEnabled:NO];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    // zohaib share url fetch made by muneeb
                    
                    NSString *urlString =  [NSString stringWithFormat:@"https://api2-dot-bestsongs-156307.appspot.com/v1/albums/%@/share_url",_album.ID];
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
                                                              NSError *parseError = nil;
                                                              NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                                              NSLog(@"The response is - %@",responseDictionary);
                                                              
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  // do work here
                                                                  
                                                                  [SVProgressHUD dismiss];
                                                                  NSDictionary *dataDictionary = responseDictionary;
                                                                  sharingLink = dataDictionary[@"share_url"];
                                                                  NSString * message = [NSString stringWithFormat:@"Play and enjoy %@",_album.Title];
                                                                  NSArray * shareItems = @[message, sharingLink];
                                                                  UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
                                                                  activityViewControntroller.excludedActivityTypes = @[];
                                                                  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                                                                      activityViewControntroller.popoverPresentationController.sourceView = self.view;
                                                                      activityViewControntroller.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/4, 0, 0);
                                                                  }
                                                                  [self presentViewController:activityViewControntroller animated:true completion:nil];
                                                                  
                                                              });
                                                              
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
                    
                    
                    
                    
                    
                    //                    if(sharingLink == nil){
                    //                        [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
                    //                        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
                    //                        int screenSize =(int)[[UIScreen mainScreen] nativeBounds].size.height / 36 ;
                    //
                    //                        [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, (CGFloat)screenSize )];
                    //                        [SVProgressHUD showWithStatus:@"Generating Share Link"];
                    //                        [CSToastManager setTapToDismissEnabled:YES];
                    //                        [CSToastManager setQueueEnabled:NO];
                    //                        [[BestsongsAPI sharedInstance] createShareLink:_album.Title
                    //                                                               message:_album.Title
                    //                                                             posterURL:_album.Poster
                    //                                                                  link:_album.Permalink
                    //                                                             onSuccess:^(id response) {
                    //                                                                 [SVProgressHUD dismiss];
                    //                                                                 NSDictionary *dataDictionary = (NSDictionary *) response;
                    //                                                                 sharingLink = dataDictionary[@"shortLink"];
                    //                                                                 NSString * message = [NSString stringWithFormat:@"Play and enjoy %@",_album.Title];
                    //                                                                 NSArray * shareItems = @[message, sharingLink];
                    //                                                                 UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
                    //                                                                 activityViewControntroller.excludedActivityTypes = @[];
                    //                                                                 if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    //                                                                     activityViewControntroller.popoverPresentationController.sourceView = self.view;
                    //                                                                     activityViewControntroller.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/4, 0, 0);
                    //                                                                 }
                    //                                                                 [self presentViewController:activityViewControntroller animated:true completion:nil];
                    //                                                             } onFailure:^(NSError *error) {
                    //                                                                 [SVProgressHUD dismiss];
                    //                                                                 [[BaseController sharedInstance] showToastError:error.localizedDescription];
                    //
                    //
                    //                                                                 if ([error.localizedDescription containsString:@"Pakistan"] || [error.localizedDescription containsString:@"available"]) {
                    //
                    //                                                                     [self contentNotAvailablePopUp];
                    //
                    //                                                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"videoViewIsDisplayed" object:nil];
                    //
                    //                                                                 } else {
                    //
                    //                                                                 }
                    //
                    //
                    //
                    //                                                             }];
                    //                    } else {
                    //                        NSString * message = [NSString stringWithFormat:@"Play and enjoy %@",_album.Title];
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
                    
                });
            }
        }
    } else {
        [self.view makeToast:@"Share URL not found"];
        [CSToastManager setTapToDismissEnabled:YES];
        [CSToastManager setQueueEnabled:NO];
    }
    
    
}


- (void)shareBtn2:(id)sender {
    if(![AFNetworkReachabilityManager sharedManager].isReachable){
        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
        return;
    }
    if(_isRunFromDownload){
        [self.view makeToast:@"Can't Share Offline Songs.."];
        [CSToastManager setTapToDismissEnabled:YES];
        [CSToastManager setQueueEnabled:NO];
        return;
    }
    if( ![_album.Permalink isEqualToString:@""] ){
        if( !(_album.Permalink == nil)){
            if(_playlist == nil){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(sharingLink == nil){
                        [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
                        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
                        [SVProgressHUD showWithStatus:@"Generating Share Link"];
                        [CSToastManager setTapToDismissEnabled:YES];
                        [CSToastManager setQueueEnabled:NO];
                        [[BestsongsAPI sharedInstance] createShareLink:_album.Title
                                                               message:_album.Title
                                                             posterURL:_album.Poster
                                                                  link:_album.Permalink
                                                             onSuccess:^(id response) {
                                                                 [SVProgressHUD dismiss];
                                                                 NSDictionary *dataDictionary = (NSDictionary *) response;
                                                                 sharingLink = dataDictionary[@"shortLink"];
                                                                 NSString * message = [NSString stringWithFormat:@"Play and enjoy %@",_album.Title];
                                                                 NSArray * shareItems = @[message, sharingLink];
                                                                 UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
                                                                 activityViewControntroller.excludedActivityTypes = @[];
                                                                 if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                                                                     activityViewControntroller.popoverPresentationController.sourceView = self.view;
                                                                     activityViewControntroller.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/4, 0, 0);
                                                                 }
                                                                 [self presentViewController:activityViewControntroller animated:true completion:nil];
                                                             } onFailure:^(NSError *error) {
                                                                 [SVProgressHUD dismiss];
                                                                 [[BaseController sharedInstance] showToastError:error.localizedDescription];
                                                             }];
                    }
                    else {
                        NSString * message = [NSString stringWithFormat:@"Play and enjoy %@",_album.Title];
                        NSArray * shareItems = @[message, sharingLink];
                        UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
                        activityViewControntroller.excludedActivityTypes = @[];
                        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                            activityViewControntroller.popoverPresentationController.sourceView = self.view;
                            activityViewControntroller.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/4, 0, 0);
                        }
                        [self presentViewController:activityViewControntroller animated:true completion:nil];
                    }
                });
            }
        }
    }
    else {
        [self.view makeToast:@"Share URL not found"];
        [CSToastManager setTapToDismissEnabled:YES];
        [CSToastManager setQueueEnabled:NO];
    }
}

- (void)downPlayer{
    [self backBtn:nil];
}

- (IBAction)backBtn:(id)sender {
    [self.popupPresentationContainerViewController closePopupAnimated:YES completion:^{
        [self updateControls];
    }];
}


- (IBAction)closePlayerBtn:(id)sender {
    [self playerCloseButtonPressed];
}

- (IBAction)repeatBtn:(id)sender {
    if(isRepeat){
        isRepeat = NO;
        [_repeatButton setImage:[UIImage imageNamed:@"repeat.png"] forState:UIControlStateNormal];
    } else {
        isRepeat = YES;
        [_repeatButton setImage:[UIImage imageNamed:@"repeatActive.png"] forState:UIControlStateNormal];
    }
}


- (IBAction)previousBtn:(id)sender {
    [self previous];
}

- (IBAction)playBtn:(id)sender {
    if (!_audioPlayer) {
        return;
    }
    if(isReloaded){
        isReloaded = false;
        [self createStreamer];
        return;
    }
    if (_audioPlayer.state == STKAudioPlayerStatePaused) {
        [self play];
    }
    else {
        [self pause];
    }
}

- (IBAction)nextBtn:(id)sender {
    [self next];
}

- (IBAction)earPhoneBtn:(id)sender {
    _audioPlayer.muted = !_audioPlayer.muted;
    if (_audioPlayer.muted) {
        [_earPhoneBtn setImage:[UIImage imageNamed:@"audioMute.png"] forState:UIControlStateNormal];
    }
    else {
        [_earPhoneBtn setImage:[UIImage imageNamed:@"audioHigh.png"] forState:UIControlStateNormal];
    }
    //    AVAudioSessionPortDescription *routePort = self.audioSession.currentRoute.outputs.firstObject;
    //    NSString *portType = routePort.portType;
    //    if ([portType isEqualToString:@"Speaker"]) {
    //        [_earPhoneBtn setImage:[UIImage imageNamed:@"earPhoneFill.png"] forState:UIControlStateNormal];
    //        [_audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
    //    }
    //    else if ([portType isEqualToString:@"Receiver"]) {
    //        [_earPhoneBtn setImage:[UIImage imageNamed:@"earPhone.png"] forState:UIControlStateNormal];
    //        [_audioSession  overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    //    }
}


-(void)tableViewDownloadBtn:(id)sender {
    UIButton *downloadBbtn = (UIButton*)sender;
    Song *downloadSong = [_tracks objectAtIndex:downloadBbtn.tag];
    if(downloadSong.ID != 0){
        if(downloadSong.IsDownload){
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
            DownloadViewController *downloadViewController = [[BaseController sharedInstance] downloadMP3:storyBoard song:downloadSong rootViewController:self.view.window.rootViewController];
            downloadViewController.didDismiss = ^(NSString *data) {
                objectiveCDMDownloadingTasks = [objectiveCDM downloadingTasks];
                [self.songTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            };
        }
    }
}

-(void)tableViewWatchVideoBtn:(id)sender {
    UIButton *watchButton = (UIButton*)sender;
    Song *videoSong = [_tracks objectAtIndex:watchButton.tag];
    
    if(videoSong.ID != 0){
        if(videoSong.IsVideo){
            
            
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
            Video *video = [[Video alloc] initWithID:videoSong.ID title:videoSong.Title videoURL:videoSong.VideoURL albumName:videoSong.AlbumTitle poster:videoSong.Poster permalink:videoSong.VideoPermalink];
            
           // [[BaseController sharedInstance] openVideoPlayer:storyBoard andVideo:video andRootViewController:self.view.window.rootViewController];
            
            [self showLoading2];
            
            [[BaseController sharedInstance] openVideoPlayerWithType:self.storyboard andVideo:video andRootViewController:self.view.window.rootViewController andType:@"track"];
        }
    }
}

-(void)tableViewPlaylistBtn:(id)sender {
    UIButton *playlistButton = (UIButton*)sender;
    Song *playListSong = [_tracks objectAtIndex:playlistButton.tag];
    if(playListSong.ID != 0){
        if(playListSong.IsDownload){
            //Popup Show Here
            UIScreen *screen = [UIScreen mainScreen];
            double height = 297;
            self.addToPlayListViewController.album = self.album;
            self.addToPlayListViewController.song = playListSong;
            [self.addToPlayListViewController.movieName setText:playListSong.AlbumTitle];
            [self.addToPlayListViewController.songName setText:playListSong.Title];
            self.addToPlayListViewController.playlist = nil;
            self.addToPlayListViewController.delegate = self;
            [self.addToPlayListViewController loadView];
            [self.addToPlayListViewController.backgroundPoster sd_setImageWithURL:[NSURL URLWithString:playListSong.Poster]
                                                                 placeholderImage:[UIImage imageNamed:DEFAULTPLACEHOLDER]];
            
            [self.addToPlayListViewController.poster sd_setImageWithURL:[NSURL URLWithString:playListSong.Poster]
                                                       placeholderImage:[UIImage imageNamed:DEFAULTALBUMART]];
            [self.addToPlayListViewController setFrame:CGRectMake(0, 0, screen.bounds.size.width, height)];
            
            // Popup
            self.popupController = [[CNPPopupController alloc] initWithContents:@[self.addToPlayListViewController]];
            CNPPopupTheme *defaultTheme = [[CNPPopupTheme alloc] init];
            defaultTheme.backgroundColor = [UIColor whiteColor];
            defaultTheme.cornerRadius = 4.0f;
            defaultTheme.popupContentInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
            defaultTheme.popupStyle = CNPPopupStyleCentered;
            defaultTheme.presentationStyle = CNPPopupPresentationStyleSlideInFromBottom;
            defaultTheme.dismissesOppositeDirection = NO;
            defaultTheme.maskType = CNPPopupMaskTypeDimmed;
            defaultTheme.shouldDismissOnBackgroundTouch = YES;
            defaultTheme.movesAboveKeyboard = YES;
            defaultTheme.contentVerticalPadding = 16.0f;
            defaultTheme.maxPopupWidth = 300.0f;
            defaultTheme.animationDuration = 0.3f;
            self.popupController.theme = defaultTheme;
            self.popupController.theme.popupStyle = CNPPopupStyleActionSheet;
            self.popupController.delegate = self;
            self.addToPlayListViewController.popupController = self.popupController;
            [self.popupController presentPopupControllerAnimated:YES];
        }
    }
}

- (int)getTrackByID:(NSNumber *)trackID{
    int index = -1;
    for (int i = 0; i < _tracks.count; i++) {
        if(((Song *)[_tracks objectAtIndex:i]).ID == trackID){
            index = i;
            break;
        }
    }
    return index;
}

- (void)deleteTrackFromPlaylist:(NSNumber *)trackID{
    if(_playlist != nil){
        int index = [self getTrackByID:trackID];
        if(index == -1)
            return;
        [_tracks removeObjectAtIndex:index];
    }
}

- (void)likeTrack:(NSNumber *)trackID{
    int index = [self getTrackByID:trackID];
    if(index == -1)
        return;
    Song *track = [_tracks objectAtIndex:index];
    if(track.AlbumID != _album.ID)
        return;
    int totalLikes = [track.Likes intValue];
    totalLikes++;
    track = [[Song alloc] initWithID:track.ID albumId:track.AlbumID likes:[NSNumber numberWithInt:totalLikes] title:track.Title albumTitle:track.AlbumTitle poster:track.Poster permalink:track.Permalink audioURL:track.AudioURL videoURL:track.VideoURL videoPermalink:track.VideoPermalink isDowload:track.IsDownload isVideo:track.IsVideo isLikes:YES];
    [_tracks replaceObjectAtIndex:index withObject:track];
    [_songTableView reloadData];
    if(_delegate && [_delegate respondsToSelector:@selector(likeTrackFromPlayer:)]){
        [_delegate likeTrackFromPlayer:trackID];
    }
}

- (void)unLikeTrack:(NSNumber *)trackID{
    int index = [self getTrackByID:trackID];
    if(index == -1)
        return;
    Song *track = [_tracks objectAtIndex:index];
    if(track.AlbumID != _album.ID)
        return;
    int totalLikes = [track.Likes intValue];
    totalLikes--;
    if(totalLikes < 0)
        totalLikes = 0;
    track = [[Song alloc] initWithID:track.ID albumId:track.AlbumID likes:[NSNumber numberWithInt:totalLikes] title:track.Title albumTitle:track.AlbumTitle poster:track.Poster permalink:track.Permalink audioURL:track.AudioURL videoURL:track.VideoURL videoPermalink:track.VideoPermalink isDowload:track.IsDownload isVideo:track.IsVideo isLikes:NO];
    [_tracks replaceObjectAtIndex:index withObject:track];
    [_songTableView reloadData];
    if(_delegate && [_delegate respondsToSelector:@selector(unLikeTrackFromPlayer:)]){
        [_delegate unLikeTrackFromPlayer:trackID];
    }
}

- (void)updateTableview{
    if(_playlist != nil){
        if(deleteSongIndex){
            [_tracks removeObjectAtIndex:deleteSongIndex];
            [self.songTableView reloadData];
            if(_delegate && [_delegate respondsToSelector:@selector(updateTableview)]){
            }
            deleteSongIndex = -1;
        }
    }
}

- (void)handleTap:(UITapGestureRecognizer *)gestureRecognizer{
    [self pause];
}

- (void)setPlayButtonType:(PlayButtonType)buttonType {
    [_playBtn setImage:buttonType == PauseButton ? _pauseBtnBG : _playBtnBG
              forState:UIControlStateNormal];
}

# pragma ObjectiveCDMUIDelagate
- (void) didReachProgress:(float)progress {
}

- (void) didFinishAll {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void) didFinishAllForDataDelegate {
    // handle whatever things that need to be done after the finish has been completed
}

- (void) didFinishOnDownloadTaskUI:(ObjectiveCDMDownloadTask *) downloadTask {
}

- (void) didHitDownloadErrorOnTask:(ObjectiveCDMDownloadTask* ) task {
}

- (void) didReachIndividualProgress:(float)progress onDownloadTask:(ObjectiveCDMDownloadTask* )downloadTask {
}
# pragma ObjectiveCDMDataDelegate

# pragma mark - Update music indicator state
- (void)updatePlaybackIndicatorWithIndexPath:(NSIndexPath *)indexPath {
    for (PlayerTableViewCell *cell in _songTableView.visibleCells) {
        cell.state = NAKPlaybackIndicatorViewStateStopped;
    }
    PlayerTableViewCell *musicsCell = [_songTableView cellForRowAtIndexPath:indexPath];
    musicsCell.state = NAKPlaybackIndicatorViewStatePlaying;
}

- (void)updatePlaybackIndicatorOfCell:(PlayerTableViewCell *)cell {
    int index = [[cell.sNo text] intValue];
    index--;
    
    
     Song * song;
    
    if (index < _tracks.count && index > -1) {
        
        song = [_tracks objectAtIndex:index];
        
    }
    
   
    if(_selectedSong.ID != 0){
        
        if (song!= nil){
        
        if(song.ID == _selectedSong.ID){
            cell.state = [MusicIndicator sharedInstance].state;
            cell.songName.textColor = colour;
            [cell.border setHidden:YES];
            [cell.image setHidden:NO];
            [cell.musicIndicator setHidden:NO];
            [cell.image setHidden:YES];
        }
        else {
            cell.state = NAKPlaybackIndicatorViewStateStopped;
            [cell.songName setTextColor:[UIColor whiteColor]];
            [cell.border setHidden:YES];
            [cell.image setHidden:YES];
            [cell.musicIndicator setHidden:YES];
        }
        
    }
        
    }
    else{
        
         if (song!= nil){
        
        cell.state = NAKPlaybackIndicatorViewStateStopped;
        [cell.songName setTextColor:[UIColor whiteColor]];
        [cell.border setHidden:YES];
        [cell.image setHidden:YES];
        [cell.musicIndicator setHidden:YES];
             
             
         }
    }
}

- (void)updatePlaybackIndicatorOfVisisbleCells {
    if (_delegate && [_delegate respondsToSelector:@selector(updatePlaybackIndicatorOfVisisbleCells)]) {
        [_delegate updatePlaybackIndicatorOfVisisbleCells];
    }
    for (PlayerTableViewCell *cell in _songTableView.visibleCells) {
        [self updatePlaybackCell:cell];
    }
}

- (void)updatePlaybackCell:(PlayerTableViewCell *)cell{
    
    if([_tracks count] <= 0)
        return;
    int index = [[cell.sNo text] intValue];
    index--;
    
    // fabric error fixed
    
    Song * song;
    
    if (index < _tracks.count && index > -1) {
        
        song = [_tracks objectAtIndex:index];
    }
    
    
    //Song * song = [_tracks objectAtIndex:index];
    
    
    if(_selectedSong.ID != 0){
        
        if (song != nil) {
            
            if(song.ID == _selectedSong.ID){
                cell.state = [MusicIndicator sharedInstance].state;
                return;
            }
            
        }
    }
    cell.state = NAKPlaybackIndicatorViewStateStopped;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tracks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SongCell";
    PlayerTableViewCell * cell = (PlayerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
        cell = [[PlayerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    Song * song = [_tracks objectAtIndex:indexPath.row];
    [cell.sNo setText:[NSString stringWithFormat:@"%li", (indexPath.row + 1)]];
    cell.songName.numberOfLines = 0;
    
    
    if (song != nil) {
    [cell.songName setText:song.Title];
    [cell.albumName setText:song.AlbumTitle];
    }
    else{
        
        [cell.songName setText:@""];
        [cell.albumName setText:@""];
        
    }
        
//    [cell.progressView setProgressImage:[UIImage imageNamed:@"downloadFill"]];
    
    if(_isRunFromDownload) {
        [cell.videoIcon setHidden:YES];
        [cell.downloadIcon setHidden:YES];
        [cell.playlistIcon setHidden:YES];
//        [cell.progressView setHidden:YES];
    } else {
        if(song.IsVideo){
            [cell.videoIcon setHidden:NO];
            
            [cell.videoIcon setTag:indexPath.row];
            [cell.videoIcon addTarget:self action:@selector(tableViewWatchVideoBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
            [cell.videoIcon setHidden:YES];
        
        if(song.IsDownload){
            [cell.downloadIcon setHidden:NO];
            [cell.playlistIcon setHidden:NO];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewProgressViewBtn:)];
//            [cell.progressView addGestureRecognizer:tapGesture];
            
            [cell.downloadIcon setTag:indexPath.row];
            [cell.downloadIcon addTarget:self action:@selector(tableViewDownloadBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.playlistIcon setTag:indexPath.row];
            [cell.playlistIcon addTarget:self action:@selector(tableViewPlaylistBtn:) forControlEvents:UIControlEventTouchUpInside];
            
        } else {
            [cell.downloadIcon setHidden:YES];
            [cell.playlistIcon setHidden:YES];
        }
    }
    cell.delegate = self;
    [self updatePlaybackIndicatorOfCell:cell];
    for (int i = 0; i < [objectiveCDMDownloadingTasks count]; i++) {
        ObjectiveCDMDownloadTask *taskInfo = objectiveCDMDownloadingTasks[i];
        if([taskInfo.urlString isEqualToString:song.AudioURL]){
            if(taskInfo.completed){
                if(cell.timer != nil){
                    [cell.timer invalidate];
                    cell.timer = nil;
                }
            } else {
                if(cell.timer == nil){
                    [cell displayProgressForDownloadTask:objectiveCDMDownloadingTasks[i]];
                    if(![cell.downloadIcon isHidden]){
//                        [cell.progressView setHidden:YES];
                        [cell.downloadIcon setHidden:YES];
//                        [cell.progressView setHidden:NO];
                    }
                }
            }
            break;
        }
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}

- (void)tableViewProgressViewBtn:(id)sender {
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayerTableViewCell *cell = (PlayerTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    Song * song = [_tracks objectAtIndex:indexPath.row];
    [cell.songName setText:song.Title];
    CGFloat height = [[ BaseController sharedInstance] getLabelHeight:cell.songName];
    CGFloat rowHeight = 40;
    rowHeight += height;
    return rowHeight;
}

#pragma mark - UITableView Delegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Song *song = [_tracks objectAtIndex:indexPath.row];
    [self playSelectedSong:song];
    [self updatePlaybackIndicatorWithIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    
    
}



- (void) fabricContentViewOfSelectedSongAddition:(Song *)song {
    //NSLog(@"id %@ :: albumid %@ :: title %@ :: albumtitle %@ :: ",   _selectedSong.ID,  _selectedSong.AlbumID, _selectedSong.Title ,   _selectedSong.AlbumTitle);
    
    [Answers logCustomEventWithName:@"Audio Play" customAttributes:@{
                                                                     @"Audio ID":song.ID,
                                                                     @"Audio name":song.Title,
                                                                     @"Audio Album":song.AlbumTitle,
                                                                     @"Device Type":@"iOS"
                                                                     }];
    
}


#pragma mark - Pop up 

- (void)changeTopSongAndAlbumTitle{
    
    
    if (_selectedSong.Title != nil )
    {
        [_topSongName setText:_selectedSong.Title];
        self.popupItem.title = _selectedSong.Title;
        [self.songTitle setText:_selectedSong.Title];
        
    }else{
        
        [_topSongName setText:@""];
        self.popupItem.title = @"";
        [self.songTitle setText:@""];
        
    }
    
    self.popupItem.image = [UIImage imageNamed:DEFAULTPLACEHOLDER];
    
    if (_selectedSong.AlbumTitle != nil )
    {
        self.popupItem.subtitle = _selectedSong.AlbumTitle;
        [self.albumTitle setText:_selectedSong.AlbumTitle];
        [_topMovieName setText:_selectedSong.AlbumTitle];
        [_movieName setText:_selectedSong.AlbumTitle];
    }else{
        self.popupItem.subtitle = @"";
        [self.albumTitle setText:@""];
        [_topMovieName setText:@""];
        [_movieName setText:@""];
    }
    
   

    //Setup the "Now Playing"
    
     [NSThread sleepForTimeInterval:0.1500];
    
    NSMutableDictionary *mediaInfo = [[NSMutableDictionary alloc]init];
    
    if (_selectedSong.Title != nil ){
        
       [mediaInfo setObject:_selectedSong.Title forKey:MPMediaItemPropertyTitle];
    }
    else{
        
        NSString *errorSongTitle = @"song title no 3282";
     [mediaInfo setObject:errorSongTitle forKey:MPMediaItemPropertyTitle];
    }
    
    
    if (_selectedSong.AlbumTitle != nil ){
        [mediaInfo setObject:_selectedSong.AlbumTitle forKey:MPMediaItemPropertyAlbumTitle];
        
    }
    else{
        
        NSString *errorAlbumTitle = @"album title no 3282";
         [mediaInfo setObject:errorAlbumTitle forKey:MPMediaItemPropertyAlbumTitle];
    }
    
   
    if (_audioPlayer.duration != 0) {
        [mediaInfo setObject:[NSString stringWithFormat:@"%f", _audioPlayer.duration] forKey:MPMediaItemPropertyPlaybackDuration];
    }
    [mediaInfo setObject:@"1.0f" forKey:MPNowPlayingInfoPropertyPlaybackRate];
    MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:DEFAULTPLACEHOLDER]];
    
    [mediaInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:mediaInfo];
    
    
    ///
    
    if(_isRunFromDownload){
        
        [NSThread sleepForTimeInterval:0.1500];
        
        NSMutableDictionary *mediaInfo = [[NSMutableDictionary alloc]init];
        
        // fabric error fixed
        
        if (_selectedSong.Title != nil ){
            [mediaInfo setObject:_selectedSong.Title forKey:MPMediaItemPropertyTitle]; }
        else{
            
            NSString *errorSongTitle = @"song title no 3282";
            [mediaInfo setObject:errorSongTitle forKey:MPMediaItemPropertyTitle];
        }
        if ( _selectedSong.AlbumTitle != nil ){
            [mediaInfo setObject:_selectedSong.AlbumTitle forKey:MPMediaItemPropertyAlbumTitle]; }
        else{
            
            NSString *errorAlbumTitle = @"song album no 3282";
            [mediaInfo setObject:errorAlbumTitle forKey:MPMediaItemPropertyTitle];
        }
        
        
        
        if (_audioPlayer.duration != 0) {
            [mediaInfo setObject:[NSString stringWithFormat:@"%f", _audioPlayer.duration] forKey:MPMediaItemPropertyPlaybackDuration];
        }
        
        
    }
    ///
    
    if(_selectedSong.Poster == nil || [_selectedSong.Poster isEqualToString:@""]){
        _backgroundPoster.image = [UIImage imageNamed:DEFAULTPLACEHOLDER];
        _poster.image = [UIImage imageNamed:DEFAULTPLACEHOLDER];
        
        popupBarPoster = [UIImage imageNamed:DEFAULTPLACEHOLDER];
        //        [self createPopupbarLeftButton:bufferingIcon];
        
        albumImage = [UIImage imageNamed:DEFAULTPLACEHOLDER];
        
    
        
    } else {
        [_backgroundPoster sd_setImageWithURL:[NSURL URLWithString:_selectedSong.Poster]
                             placeholderImage:[UIImage imageNamed:DEFAULTPLACEHOLDER]];
        
        [_poster sd_setImageWithURL:[NSURL URLWithString:_selectedSong.Poster]
                   placeholderImage:[UIImage imageNamed:DEFAULTALBUMART]];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        
        [manager downloadImageWithURL:[NSURL URLWithString:_selectedSong.Poster]
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                 // progression tracking code
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (image) {
                                    popupBarPoster = image;
                                    //                                    [self createPopupbarLeftButton:bufferingIcon];
                                    albumImage = image;
                                    
                                    self.popupItem.image = image;
                                    
                                    if(!_isRunFromDownload){
                                        
                                        NSMutableDictionary *mediaInfo = [[NSMutableDictionary alloc]init];
                                        
                                        // fabric error fixed
                                        
                                        if (_selectedSong.Title != nil ){
                                            [mediaInfo setObject:_selectedSong.Title forKey:MPMediaItemPropertyTitle]; }
                                        else{
                                            
                                            NSString *errorSongTitle = @"song title no 3282";
                                            [mediaInfo setObject:errorSongTitle forKey:MPMediaItemPropertyTitle];
                                        }
                                        if ( _selectedSong.AlbumTitle != nil ){
                                            [mediaInfo setObject:_selectedSong.AlbumTitle forKey:MPMediaItemPropertyAlbumTitle]; }
                                        else{
                                            
                                            NSString *errorAlbumTitle = @"song album no 3282";
                                            [mediaInfo setObject:errorAlbumTitle forKey:MPMediaItemPropertyTitle];
                                        }
                                        
                                        
                                        
                                        if (_audioPlayer.duration != 0) {
                                            [mediaInfo setObject:[NSString stringWithFormat:@"%f", _audioPlayer.duration] forKey:MPMediaItemPropertyPlaybackDuration];
                                        }
                                        [mediaInfo setObject:@"1.0f" forKey:MPNowPlayingInfoPropertyPlaybackRate];
                                        MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:image];
                                        
                                        [mediaInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
                                        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:mediaInfo];
                                        
                                        
                                    }
                                    
                                }
                            }];
    }
    
    [_albumYear setHidden:YES];
    [_movieName setHidden:YES];
}

- (UIView *)popupOverlayView{
    popupBarOverlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [popupBarOverlayView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    return popupBarOverlayView;
}

- (NAKPlaybackIndicatorView *)popupIndicator{
    popupBarIndicator = [[NAKPlaybackIndicatorView alloc] initWithFrame:CGRectZero];
    popupBarIndicator.state = NAKPlaybackIndicatorViewStatePlaying;
    //    popupBarIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [popupBarIndicator sizeToFit];
    popupBarIndicator.center = popupBarOverlayView.center;
    return popupBarIndicator;
}

- (UIImageView *)popupPlay{
    popupBarPlayIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    popupBarPlayIcon.image = [UIImage imageNamed:@"Play-Icon"];
    
    UIImage *newImage = [popupBarPlayIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIGraphicsBeginImageContextWithOptions(popupBarPlayIcon.image.size, NO, newImage.scale);
    [colour set];
    [newImage drawInRect:CGRectMake(0, 0, popupBarPlayIcon.image.size.width, newImage.size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    popupBarPlayIcon.image = newImage;
    popupBarPlayIcon.center = popupBarOverlayView.center;
    return popupBarPlayIcon;
}

- (MMMaterialDesignSpinner *)popupSpinner{
    popupBarSpinner = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectMake(0, 0, popupBarOverlayView.frame.size.width - 5, popupBarOverlayView.frame.size.height - 5)];
    popupBarSpinner.tintColor = [[UIColor alloc]initWithRed:182.0/255.0 green:0.0/255.0 blue:61.0/255.0 alpha:1.0];
    popupBarSpinner.lineWidth = 2.5f;
    popupBarSpinner.center = popupBarOverlayView.center;
    [popupBarSpinner startAnimating];
    return popupBarSpinner;
}

- (void)addPopupBarOverlaySubView:(UIView *)view{
    for(UIView *subview in [popupBarOverlayView subviews]) {
        [subview removeFromSuperview];
    }
    [UIView transitionWithView:popupBarOverlayView duration:0.2
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^ { [popupBarOverlayView addSubview:view]; }
                    completion:nil];
}

- (void)createPopupbarLeftButton:(PopupBarLeftButton)popupBarButton {
    //    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //    UIBarButtonItem *playerPoster = [[UIBarButtonItem alloc] initWithCustomView:button];
    ////    UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"play"] style:UIBarButtonItemStylePlain target:self action:@selector(posterButtonPressed)];
    //    button.accessibilityLabel = NSLocalizedString(@"play", @"");
    //    button.accessibilityIdentifier = @"PlayButton";
    //    button.accessibilityTraits = UIAccessibilityTraitButton;
    //
    //    self.popupItem.leftBarButtonItems = @[ playerPoster ];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button.layer setBackgroundColor:[UIColor clearColor].CGColor];
    //    [button setImage:popupBarPoster forState:UIControlStateNormal];
    button.showsTouchWhenHighlighted = YES;
    button.frame = CGRectMake(0, 0, 35, 35);
    
    [button addTarget:self action:@selector(posterButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    switch (popupBarButton) {
        case playIcon:{
            [self addPopupBarOverlaySubView:popupBarPlayIcon];
            break;
        }
        case barsIcon:{
            popupBarIndicator.state = NAKPlaybackIndicatorViewStatePlaying;
            [self addPopupBarOverlaySubView:popupBarIndicator];
            break;
        }
        case bufferingIcon:{
            if(_isRunFromDownload){
                popupBarIndicator.state = NAKPlaybackIndicatorViewStatePlaying;
                [self addPopupBarOverlaySubView:popupBarIndicator];
            } else
                [self addPopupBarOverlaySubView:popupBarSpinner];
            break;
        }
        default:
            break;
    }
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(posterButtonPressed)];
    [popupBarOverlayView addGestureRecognizer:tapGesture];
    [button addSubview:popupBarOverlayView];
    UIBarButtonItem *playerPoster = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.popupItem.leftBarButtonItems = @[ playerPoster ];
}

#pragma mark - Methods
- (void) retrieveData {
    sharingLink = nil;
    isReloaded = true;
    [_topSongName setText:@""];
    [_topMovieName setText:@""];
    [_movieName setText:@""];
    [_albumYear setText:@""];
    _bufferingBar.progress = 0.0;
    _musicSlider.value = 0;
    dispatch_async(dispatch_get_main_queue(), ^ {
        if(_tracks.count > 0){
            bool isFound = false;
            int index = 0;
            
            if(_selectedSong == nil || _selectedSong.ID == 0){
                _selectedSong = [_tracks objectAtIndex:index];
            }
            else {
                for (int i = 0; i < _tracks.count; i++) {
                    if([((Song *)[_tracks objectAtIndex:i]).ID isEqualToNumber:_selectedSong.ID]){
                        _selectedSong = [_tracks objectAtIndex:i];
                        index = i;
                        isFound = true;
                        break;
                    }
                }
            }
            
         //   [self changeTopSongAndAlbumTitle];
            [UIView transitionWithView: _songTableView
                              duration: 0.50f
                               options: UIViewAnimationOptionTransitionCrossDissolve
                            animations: ^(void) {
                                [_songTableView setSeparatorColor:[[UIColor alloc]initWithRed:27.0/255.0 green:27.0/255.0 blue:29.0/255.0 alpha:1.0]];
                                _songTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                                [_songTableView reloadData];
                            } completion: nil];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
          
            [_songTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
            // Show Progressbar and Other Buttons
            _playHeadTime.hidden = NO;
            _playHeadDuration.hidden = NO;
            _musicSlider.hidden = NO;
            _bufferingBar.hidden = NO;
            _previousBtn.hidden = NO;
            _nextBtn.hidden = NO;
            _earPhoneBtn.hidden = NO;
            _downloadMP3Btn.hidden = NO;
            _shareBtn.hidden = NO;
            _watchVideoBtn.hidden = NO;
            //            if(_isRunFromDownload){
            //                _downloadMP3Btn.enabled = NO;
            //                _shareBtn.enabled = NO;
            //                _watchVideoBtn.enabled = NO;
            //                _watchShareDownloadView.hidden = YES;
            //                _watchShareDownloadHeightConstraint.constant = 0.0f;
            //            }
            [self HideLoading];
            if(isFound){
                isReloaded = false;
                _currentTrackIndex = index;
                [self createStreamer];
            }
        }
    });
}

- (void) previous{
    
    if (!_audioPlayer)
        return;
    if(_tracks.count > 1){
        if(_currentTrackIndex == 0)
            _currentTrackIndex = ([_tracks count] - 1);
        else
            --_currentTrackIndex;
        [self createStreamer];
    } else {
        if (_audioPlayer.state == STKAudioPlayerStatePaused)
            [self play];
        else if(_audioPlayer.state == STKAudioPlayerStatePlaying)
            [self pause];
        else {
            _currentTrackIndex = 0;
            [self createStreamer];
        }
    }
}

- (void) next{
    
    if (!_audioPlayer)
        return;
    if(_tracks.count > 1){
        if (++_currentTrackIndex >= [_tracks count])
            _currentTrackIndex = 0;
        [self createStreamer];
    } else {
        if (_audioPlayer.state == STKAudioPlayerStatePaused)
            [self play];
        else if(_audioPlayer.state == STKAudioPlayerStatePlaying)
            [self pause];
        else{
            _currentTrackIndex = 0;
            [self createStreamer];
        }
    }
}

- (void) pause{
    if (!_audioPlayer)
        return;
    if (_audioPlayer.state != STKAudioPlayerStatePaused)
        [_audioPlayer pause];
}

- (void) play{
    
    if (!_audioPlayer)
        return;
    if(hasAudioInterruptStarted)
        hasAudioInterruptStarted = NO;
    if (_audioPlayer.state == STKAudioPlayerStatePaused)
        [_audioPlayer resume];
}

- (void) stop{
    if (!_audioPlayer)
        return;
    [_audioPlayer stop];
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState{
    [self updateControls];
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode{
    switch (errorCode) {
        case STKAudioPlayerErrorNone:
            break;
            
        case STKAudioPlayerErrorOther:
            break;
            
        case STKAudioPlayerErrorCodecError:
            break;
            
        case STKAudioPlayerErrorDataSource:{
            [[BaseController sharedInstance] showToastError:@"No Track Found... Try Again Later..."];
            [self next];
            break;
        }
            
        case STKAudioPlayerErrorDataNotFound:{
            [[BaseController sharedInstance] showToastError:@"No Track Found... Try Again Later..."];
            [self next];
            break;
        }
            
        case STKAudioPlayerErrorAudioSystemError:{
            //            [[BaseController sharedInstance] showToastError:@"System Error Occured...!!!"];
            //            [self play];
            break;
        }
            
        case STKAudioPlayerErrorStreamParseBytesFailed:{
            [[BaseController sharedInstance] showToastError:@"Can't Play this track..."];
            [self next];
            break;
        }
            
        default:
            break;
    }
    [self updateControls];
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId {
    [self updateControls];
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId{
    [self updateControls];
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration {
    [self updateControls];
    if((long)stopReason == 0 || (long)stopReason == 2) { // Stop Reason 0 for next, previous and change track stop reason 2 for close player
        if(isRepeat)
            [self repeatBtn:nil];
        return;
    }
    if(isRepeat)
        --_currentTrackIndex;
    [self next];
}

-(void)audioPlayer:(STKAudioPlayer *)audioPlayer logInfo:(NSString *)line {
}

- (void) playSelectedSong:(Song *)song {
    if (!_audioPlayer) {
        return;
    }
    if([song.AudioURL length] != 0){
        if(song.ID == _selectedSong.ID){
            if (_audioPlayer.state == STKAudioPlayerStatePaused) {
                [self play];
            }
            else if(_audioPlayer.state == STKAudioPlayerStatePlaying){
                [self pause];
            } else {
                for (int i = 0; i < _tracks.count; i++) {
                    if(((Song *)[_tracks objectAtIndex:i]).ID == song.ID){
                        _currentTrackIndex = i;
                        [self createStreamer];
                        
                        
                        
                        
                        
                        
                        break;
                    }
                }
            }
        }
        else {
            isReloaded = false;
            for (int i = 0; i < _tracks.count; i++) {
                if(((Song *)[_tracks objectAtIndex:i]).ID == song.ID){
                    _currentTrackIndex = i;
                    [self createStreamer];
                    break;
                }
            }
        }
    } else {
        if(song.ID != 0){
            if(song.IsVideo){
                Video *video = [[Video alloc] initWithID:song.ID title:song.Title videoURL:song.VideoURL albumName:song.AlbumTitle poster:song.Poster permalink:song.VideoPermalink];
              //  [[BaseController sharedInstance] openVideoPlayer:self.storyboard andVideo:video andRootViewController:self.view.window.rootViewController];
                 [[BaseController sharedInstance] openVideoPlayerWithType:self.storyboard andVideo:video andRootViewController:self.view.window.rootViewController andType:@"track"];
                
            }else{
                [self.view makeToast:@"No Video"];
                [CSToastManager setTapToDismissEnabled:YES];
                [CSToastManager setQueueEnabled:NO];
            }
        }
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[ NSNotificationCenter defaultCenter ] postNotificationName:@"hideHomeAdd" object:nil];
    
    
}


-(void)playerCloseButtonPressed{
    @try{
        [self stop];
        _selectedSong = nil;
        _playlist = nil;
        //        _isRunFromDownload = NO;
        
        [self updateControls];
        [MusicIndicator sharedInstance].state = NAKPlaybackIndicatorViewStateStopped;
        [self updatePlaybackIndicatorOfVisisbleCells];
        [self.songTableView reloadData];
        //[_tracks removeAllObjects];
    }
    @catch(id exception){
    }
    [self.popupPresentationContainerViewController dismissPopupBarAnimated:NO completion:nil];
    
 
    [[ NSNotificationCenter defaultCenter ] postNotificationName:@"hideHomeAdd" object:nil];

    [[ NSNotificationCenter defaultCenter ] postNotificationName:@"showHomeAdd" object:nil];
    
   
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
    //return self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

-(void)HideLoading{
    if(!_spinnerView.hidden){
        _spinnerView.hidden = YES;
        _playBtn.hidden = NO;
    }
}

-(void)ShowLoading{
    if(_spinnerView.hidden){
        _spinnerView.hidden = NO;
        _playBtn.hidden = YES;
    }
}

-(void)posterButtonPressed{
    [self playBtn:nil];
    //[_popupPresentationContainerViewController openPopupAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}


- (void)showLoading2 {
    if(![SVProgressHUD isVisible]){
        
        [[BaseController sharedInstance] setupLoading];
        
        int screenSize =(int)[[UIScreen mainScreen] nativeBounds].size.height / 36;
        
        [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, (CGFloat)screenSize )];
        
        [SVProgressHUD show];
    }
}



- (void)viewDidAppear:(BOOL)animated {
    objectiveCDMDownloadingTasks = [objectiveCDM downloadingTasks];

    
    [self becomeFirstResponder];
    
    [super viewDidAppear:animated];
    
    // fabric error resolved
    
    [self.songTableView reloadData];
    [self.songTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];


    
   
   
    [NSThread sleepForTimeInterval:0.15];
     [self updatePlaybackIndicatorOfVisisbleCells];
   


    if(self.tabBarController.popupContentView.popupCloseButton.isHidden == true)
    {
        printf("Yes Dikha");
    }
    else if(self.tabBarController.popupContentView.popupCloseButton.isHidden == false)
    {
        _open_popup = @"open";

        SingleAlbumViewController * vc = [[SingleAlbumViewController alloc] init];

        [[BaseController sharedInstance] popup_open:self.storyboard tabbarController:vc.tabBarController];
    }

    
    
    
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return 1;
    
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return UIInterfaceOrientationPortrait;
    
}

- (BOOL)shouldAutorotate {
    return NO;
}


- (void)viewDidDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewDidDisappear:animated];
}

#pragma mark - remote control events
- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause: {
                [self playBtn:nil];
                break;
            }
            case UIEventSubtypeRemoteControlPlay: {
                [self play];
                break;
            }
            case UIEventSubtypeRemoteControlPause: {
                [self pause];
                break;
            }
            case UIEventSubtypeRemoteControlStop:{
                [self stop];
                break;
            }
            case UIEventSubtypeRemoteControlNextTrack:{
                [self next];
                break;
            }
            case UIEventSubtypeRemoteControlPreviousTrack:{
                [self previous];
                break;
            }
            default:
                break;
        }
    }
}

@end

