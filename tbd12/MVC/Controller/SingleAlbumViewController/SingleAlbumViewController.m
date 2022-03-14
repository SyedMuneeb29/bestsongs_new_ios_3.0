//
//  SingleAlbumViewController.m
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 12/5/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SingleAlbumViewController.h"

@import GoogleMobileAds ;
#import "tbd12-Swift.h"

@interface SingleAlbumViewController () <CNPPopupControllerDelegate> {
    
    BOOL isDataLoaded;
    BOOL isViewAppear;
    NSArray *objectiveCDMDownloadingTasks;
    UIView *noInternetView;
    UIView *noTracksview;
    
    NSString *sharingLink;
    NSMutableArray *songs;
    ObjectiveCDM *objectiveCDM;
    NSUInteger deleteSongIndex;
    
    ParallaxViewController *headerView;
    PlaylistDatabase *playlistDBManager;
    
    AddToPlaylistViewController *addToPlayListViewController;
    CNPPopupController *popupController;
    
    // addsUrl
    
    NSString* addsImageUrl;
    
    
    GADBannerView *bannerView ;
    GiveMeABannerDisplayAd *bannerViewDisplayerMachine ;
}
@end

@implementation SingleAlbumViewController
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
// MARK: viewDidLoad


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   
    
    
    
    
    
    
    deleteSongIndex = -1;
    sharingLink = nil;
    addToPlayListViewController = [AddToPlaylistViewController instantiateFromNib];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.title = [NSString stringWithFormat:@"%@",self.album.Title];
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButton:)];
    searchButton.tintColor = [UIColor whiteColor];
    
    if(_playlist  == nil && [_playlist.ID intValue] <= 0){
        UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStyleDone target:self action:@selector(shareButton:)];
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:searchButton,shareButton, nil]];
    } else {
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:searchButton, nil]];
    }
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    isDataLoaded = false;
    
    
    noTracksview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.songTableView.bounds.size.width, self.songTableView.bounds.size.height)];
    UILabel *messageLbl = [[UILabel alloc] initWithFrame:CGRectMake(30, (self.songTableView.bounds.size.height / 2 - 20), (self.songTableView.bounds.size.width - 60), 100)];
    [messageLbl setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:18]];
    messageLbl.text = @"No Tracks Found...";
    messageLbl.textAlignment = NSTextAlignmentCenter;
    messageLbl.numberOfLines = 2;
    [messageLbl setTextColor:[UIColor whiteColor]];
    [messageLbl sizeToFit];
    [noTracksview addSubview:messageLbl];
    
    CGFloat bannerHeight = screenRect.size.width;
    CGFloat heightSetter = 0;
    
    heightSetter = bannerHeight * 0.24 ;
    
    CGFloat height = 170; // 90
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        height = 250;
    bannerHeight -= height;
    headerView = [ParallaxViewController instantiateFromNib];
    [headerView.nameLabel setText:self.album.Title];  // self.album.Title
    
    
    
    //     [self.songTableView setTableHeaderView:headerView];
    //    [self.songTableView ];
    
    
    if(bannerHeight < 450){
        
        
        
        
        [self.songTableView
         setParallaxHeaderView:headerView
         mode:VGParallaxHeaderModeCenter
         height:bannerHeight + heightSetter];
        
    }
    else{
        
        [self.songTableView setParallaxHeaderView:headerView mode:VGParallaxHeaderModeTopFill height:bannerHeight ];
    }
    
    [self.songTableView setTableFooterView:[[BaseController sharedInstance] getTableViewFooterView]];
    
    
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.songTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0); // Makes the horizontal row seperator stretch the entire length of the table view
    }
    
    
    
    
    [self fabricContentViewOfAlbumOpenedPlugin];
    
    
    [[ NSNotificationCenter defaultCenter ] postNotificationName:@"hideHomeAdd" object:nil];

    
    
    
}



- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationMaskPortrait) forKey:@"orientation"];
    
    UIInterfaceOrientation statusBarOrientation =[UIApplication sharedApplication].statusBarOrientation;
    statusBarOrientation = UIInterfaceOrientationPortrait;
    return UIInterfaceOrientationPortrait;
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationMaskPortrait) forKey:@"orientation"];
    
    UIInterfaceOrientation statusBarOrientation =[UIApplication sharedApplication].statusBarOrientation;
    statusBarOrientation = UIInterfaceOrientationPortrait;
    
    
    return UIInterfaceOrientationMaskPortrait;
    
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)fabricContentViewOfAlbumOpenedPlugin {
    
    if (_album.ID != nil && _album.Title != nil) {
        
        [Answers logCustomEventWithName:@"Album View"
                       customAttributes:
         @{
           @"Album Id" : _album.ID,
           @"Album Name" : _album.Title,
           @"Device Type" : @"iOS",
           }
         ];
        
        
    }
    
}


- (void) fabricContentViewOfSelectedSongAddition {
    
    
    NSLog(@"id %@ :: albumid %@ :: title %@ :: albumtitle %@ :: ",   _selectedSong.ID,  _selectedSong.AlbumID, _selectedSong.Title ,   _selectedSong.AlbumTitle);
    
    
    
    
    
    [Answers logCustomEventWithName:@"Audio Play" customAttributes:@{
                                                                     @"Audio ID":_selectedSong.ID,
                                                                     @"Audio name":_selectedSong.Title,
                                                                     @"Audio Album":_selectedSong.AlbumTitle,
                                                                     @"Device Type":@"iOS"
                                                                     }];
    
    
    
}




// MARK: IBACTIONS

- (IBAction)searchButton:(id)sender {
    if(![AFNetworkReachabilityManager sharedManager].isReachable){
        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
        return;
    }
    SearchViewController *searchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"searchViewController"];
    [self.navigationController pushViewController:searchViewController animated:YES];
}

- (IBAction)shareButton:(id)sender {
    
    // Share Album - OK
    
    
    
    if(![AFNetworkReachabilityManager sharedManager].isReachable){
        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
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
    
    
    
    
    if(![_album.Permalink isEqualToString:@""]){
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
                    //                NSString *urlString =  [NSString stringWithFormat:@"https://api2-dot-bestsongs-156307.appspot.com/v1/albums/%@/share_url",_album.ID];
                    
                    NSString *urlString =  [NSString stringWithFormat:@"https://api-v2-dot-bestsongs-156307.appspot.com/api/v1/album/%@/share_url",_album.ID];
                    
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
                                                              //NSLog(@"The response is - %@",responseDictionary);
                                                              
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

#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    [self.songTableView shouldPositionParallaxHeader];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableViewDownloadBtn:(id)sender {
    if(![AFNetworkReachabilityManager sharedManager].isReachable){
        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
        return;
    }
    UIButton *downloadButton = (UIButton*)sender;
    Song *downloadSong = [songs objectAtIndex:downloadButton.tag];
    if(downloadSong.ID != 0){
        if(downloadSong.IsDownload){
            DownloadViewController *downloadViewController = [[BaseController sharedInstance] downloadMP3:self.storyboard song:downloadSong rootViewController:self.view.window.rootViewController];
            downloadViewController.didDismiss = ^(NSString *data) {
                objectiveCDMDownloadingTasks = [objectiveCDM downloadingTasks];
                [self.songTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            };
        }
    }
    
    
}

-(void)tableViewWatchVideoBtn:(id)sender {
    if(![AFNetworkReachabilityManager sharedManager].isReachable){
        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
        return;
    }
    UIButton *watchButton = (UIButton*)sender;
    Song *videoSong = [songs objectAtIndex:watchButton.tag];
    if(videoSong.ID != 0){
        if(videoSong.IsVideo){
            Video *video = [[Video alloc]
                            initWithID:videoSong.ID
                            title:videoSong.Title
                            videoURL:videoSong.VideoURL
                            albumName:videoSong.AlbumTitle
                            poster:videoSong.Poster
                            permalink:videoSong.VideoPermalink]; // videoSong.AlbumID
            //  [[BaseController sharedInstance] openVideoPlayer:self.storyboard andVideo:video andRootViewController:self.view.window.rootViewController];
            
            [self showLoading];
            
            [[BaseController sharedInstance]
             openVideoPlayerWithType:self.storyboard
             andVideo:video
             andRootViewController:self.view.window.rootViewController
             andType:@"track"];
        }
    }
}

- (void)updateTableview{
    if(_playlist != nil){
        if(deleteSongIndex != -1){
            [songs removeObjectAtIndex:deleteSongIndex];
            [self.songTableView reloadData];
            if(![[PlayerViewController sharedInstance] isRunFromDownload] && [[PlayerViewController sharedInstance] playlist] != nil && [[PlayerViewController sharedInstance] playlist].ID == _playlist.ID){
                [[PlayerViewController sharedInstance] setTracks:songs];
                [[[PlayerViewController sharedInstance] songTableView] reloadData];
            }
            
            
            deleteSongIndex = -1;
        }
    }
}


// MARK: tracks methods

- (int)getTrackByID:(NSNumber *)trackID{
    int index = -1;
    for (int i = 0; i < songs.count; i++) {
        if(((Song *)[songs objectAtIndex:i]).ID == trackID){
            index = i;
            break;
        }
    }
    return index;
}

- (int)getTrackByPermalink:(NSString *)permalink{
    int index = -1;
    for (int i = 0; i < songs.count; i++) {
        if([((Song *)[songs objectAtIndex:i]).Permalink isEqualToString:permalink]){
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
        [songs removeObjectAtIndex:index];
        [self.songTableView reloadData];
        if(![[PlayerViewController sharedInstance] isRunFromDownload] && [[PlayerViewController sharedInstance] playlist] != nil && [[PlayerViewController sharedInstance] playlist].ID == _playlist.ID){
            [[PlayerViewController sharedInstance] setTracks:songs];
            [[[PlayerViewController sharedInstance] songTableView] reloadData];
        }
    }
}

- (void)likeTrack:(NSNumber *)trackID{
    int index = [self getTrackByID:trackID];
    if(index == -1)
        return;
    Song *track = [songs objectAtIndex:index];
    if(track.AlbumID != _album.ID)
        return;
    int totalLikes = [track.Likes intValue];
    totalLikes++;
    track = [[Song alloc] initWithID:track.ID albumId:track.AlbumID likes:[NSNumber numberWithInt:totalLikes] title:track.Title albumTitle:track.AlbumTitle poster:track.Poster permalink:track.Permalink audioURL:track.AudioURL videoURL:track.VideoURL videoPermalink:track.VideoPermalink isDowload:track.IsDownload isVideo:track.IsVideo isLikes:YES];
    [songs replaceObjectAtIndex:index withObject:track];
    [_songTableView reloadData];
    if(![[PlayerViewController sharedInstance] isRunFromDownload] && [[PlayerViewController sharedInstance] album].ID == track.AlbumID){
        [[PlayerViewController sharedInstance] setTracks:songs];
        [[[PlayerViewController sharedInstance] songTableView] reloadData];
    }
}

- (void)likeTrackFromPlayer:(NSNumber *)trackID{
    [self likeTrack:trackID];
}

- (void)unLikeTrack:(NSNumber *)trackID{
    int index = [self getTrackByID:trackID];
    if(index == -1)
        return;
    Song *track = [songs objectAtIndex:index];
    if(track.AlbumID != _album.ID)
        return;
    int totalLikes = [track.Likes intValue];
    totalLikes--;
    if(totalLikes < 0)
        totalLikes = 0;
    track = [[Song alloc] initWithID:track.ID albumId:track.AlbumID likes:[NSNumber numberWithInt:totalLikes] title:track.Title albumTitle:track.AlbumTitle poster:track.Poster permalink:track.Permalink audioURL:track.AudioURL videoURL:track.VideoURL videoPermalink:track.VideoPermalink isDowload:track.IsDownload isVideo:track.IsVideo isLikes:NO];
    [songs replaceObjectAtIndex:index withObject:track];
    [_songTableView reloadData];
    if(![[PlayerViewController sharedInstance] isRunFromDownload] && [[PlayerViewController sharedInstance] album].ID == track.AlbumID){
        [[PlayerViewController sharedInstance] setTracks:songs];
        [[[PlayerViewController sharedInstance] songTableView] reloadData];
    }
}

- (void)unLikeTrackFromPlayer:(NSNumber *)trackID{
    [self unLikeTrack:trackID];
}

-(void)tableViewPlaylistBtn:(id)sender {
    
    if(![AFNetworkReachabilityManager sharedManager].isReachable){
        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
        return;
    }
    
    UIButton *playlistButton = (UIButton*)sender;
    
    Song *playListSong = [songs objectAtIndex:playlistButton.tag];
    
    if(playListSong.ID != 0){
        if(playListSong.IsDownload) {
            //Popup Show Here
            UIScreen *screen = [UIScreen mainScreen];
            double height = 297;
            addToPlayListViewController.album = self.album;
            addToPlayListViewController.song = playListSong;
            [addToPlayListViewController.movieName setText:playListSong.AlbumTitle];
            [addToPlayListViewController.songName setText:playListSong.Title];
            addToPlayListViewController.playlist = nil;
            deleteSongIndex = -1;
            addToPlayListViewController.delegate = self;
            if(_playlist != nil){
                addToPlayListViewController.playlist = _playlist;
                deleteSongIndex = playlistButton.tag;
                height = 340;
            }
            [addToPlayListViewController loadView];
            [addToPlayListViewController.backgroundPoster sd_setImageWithURL:[NSURL URLWithString:playListSong.Poster]
                                                            placeholderImage:[UIImage imageNamed:DEFAULTPLACEHOLDER]];
            
            [addToPlayListViewController.poster sd_setImageWithURL:[NSURL URLWithString:playListSong.Poster]
                                                  placeholderImage:[UIImage imageNamed:DEFAULTALBUMART]];
            [addToPlayListViewController setFrame:CGRectMake(0, 0, screen.bounds.size.width, height)];
            
            // Popup
            popupController = [[CNPPopupController alloc] initWithContents:@[addToPlayListViewController]];
            
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
            
            popupController.theme = defaultTheme;
            
            popupController.theme.popupStyle = CNPPopupStyleActionSheet;
            popupController.delegate = self;
            addToPlayListViewController.popupController = popupController;
            [popupController presentPopupControllerAnimated:YES];
            
        }
    }
}

# pragma ObjectiveCDMUIDelagate

- (void) didReachProgress:(float)progress {
}

- (void) didFinishAll {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void) didFinishAllForDataDelegate {
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
    
    
    
    for (PlayerTableViewCell *cell in self.songTableView.visibleCells) {
        cell.state = NAKPlaybackIndicatorViewStateStopped;
    }
    PlayerTableViewCell *musicsCell = [self.songTableView cellForRowAtIndexPath:indexPath];
    musicsCell.state = NAKPlaybackIndicatorViewStatePlaying;
    
}

- (void)updatePlaybackIndicatorOfCell:(PlayerTableViewCell *)cell {
    
    
    int index = [[cell.sNo text] intValue];
    
    index--;
    
    if ( index == -1 ) {
        
        index = 0 ;
        
    }
    
    
    Song * song = [songs objectAtIndex:index ];
    if([[PlayerViewController sharedInstance] album].ID == self.album.ID){
        if([MusicIndicator sharedInstance].state != NAKPlaybackIndicatorViewStateStopped) {
            if([[PlayerViewController sharedInstance] selectedSong] != nil){
                if([[PlayerViewController sharedInstance] selectedSong].ID != 0){
                    if(song.ID == [[PlayerViewController sharedInstance] selectedSong].ID){
                        cell.state = NAKPlaybackIndicatorViewStateStopped;
                        cell.state = [MusicIndicator sharedInstance].state;
                        UIColor *colour = [[UIColor alloc]initWithRed:255.0/255.0 green:64.0/255.0 blue:129.0/255.0 alpha:1.0];
                        cell.songName.textColor = colour;
                        [cell.border setHidden:YES];
                        [cell.image setHidden:NO];
                        [cell.musicIndicator setHidden:NO];
                        [cell.image setHidden:YES];
                        return;
                    }
                }
            }
        }
    }
    cell.state = NAKPlaybackIndicatorViewStateStopped;
    [cell.songName setTextColor:[UIColor whiteColor]];
    [cell.border setHidden:YES];
    [cell.image setHidden:YES];
    [cell.musicIndicator setHidden:YES];
    
}

- (void)updatePlaybackIndicatorOfVisisbleCells {
    for (PlayerTableViewCell *cell in self.songTableView.visibleCells) {
        [self updatePlaybackIndicatorOfCell:cell];
    }
}

- (void) didFinishDownloadTask:(ObjectiveCDMDownloadTask *)downloadInfo {
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (songs.count == 0) {
        return 0 ;
    }else {
        return songs.count + 1;
    }
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0){
        
        NSLog(@"Muneeb %i " , indexPath.row) ;
        
        static NSString *CellIdentifier = @"SongCell2";
        PlayerTableViewCell *cell = (PlayerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        
        
        UIView * adsView = [[UIView alloc] init];
        
        [cell addSubview:adsView];
        
        adsView.translatesAutoresizingMaskIntoConstraints = NO;
        [adsView.leftAnchor constraintEqualToAnchor:cell.leftAnchor].active = YES ;
        [adsView.rightAnchor constraintEqualToAnchor:cell.rightAnchor].active = YES ;
        [adsView.bottomAnchor constraintEqualToAnchor:cell.bottomAnchor].active = YES ;
        [adsView.topAnchor constraintEqualToAnchor:cell.topAnchor ].active = YES ;
        adsView.backgroundColor = [[UIColor alloc]initWithRed:12.0/255.0 green:13.0/255.0 blue:14.0/255.0 alpha:1.0];
        
        bannerViewDisplayerMachine = [[GiveMeABannerDisplayAd alloc] init] ;
        bannerView = [bannerViewDisplayerMachine
                      gievMeABannerViewWithAdUnitId: @"/21792359936/Mobile_Leaderboard_App_320x50"
                      andAdSize:bannerViewDisplayerMachine.sizePortraitBanner
                      rootVC:self
                      delegate:bannerViewDisplayerMachine] ;
        [bannerViewDisplayerMachine loadAdWithBannerView:bannerView] ;
        
        [adsView addSubview:bannerView] ;
        
        bannerView.backgroundColor = [[UIColor alloc]initWithRed:12.0/255.0 green:13.0/255.0 blue:14.0/255.0 alpha:1.0];
        
        return cell ;
        
    }
    else
    {
        static NSString *CellIdentifier = @"SongCell";
        PlayerTableViewCell * cell = (PlayerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
            cell = [[PlayerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        Song * song = [songs objectAtIndex:indexPath.row - 1 ];
        [cell.sNo setText:[NSString stringWithFormat:@"%li", (indexPath.row )]]; // + 1
        cell.songName.numberOfLines = 0;
        [cell.songName setText:song.Title];
        [cell.albumName setText:song.AlbumTitle];
//        [cell.progressView setProgressImage:[UIImage imageNamed:@"downloadFill"]];
        if(song.IsVideo){
            [cell.videoIcon setHidden:false];
            [cell.videoIcon setTag:indexPath.row - 1];
            [cell.videoIcon addTarget:self action:@selector(tableViewWatchVideoBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
            [cell.videoIcon setHidden:true];
        
        if(song.IsDownload){
            [cell.downloadIcon setHidden:NO];
            [cell.playlistIcon setHidden:NO];
//            [cell.progressView setHidden:YES];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewProgressViewBtn:)];
//            [cell.progressView addGestureRecognizer:tapGesture];
            
            [cell.downloadIcon setTag:indexPath.row - 1 ];
            [cell.downloadIcon addTarget:self action:@selector(tableViewDownloadBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.playlistIcon setTag:indexPath.row - 1];
            [cell.playlistIcon addTarget:self action:@selector(tableViewPlaylistBtn:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [cell.downloadIcon setHidden:true];
            [cell.playlistIcon setHidden:true];
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
//                            [cell.progressView setHidden:YES];
                            [cell.downloadIcon setHidden:YES];
//                            [cell.progressView setHidden:NO];
                        }
                    }
                }
                break;
            }
        }
        cell.backgroundColor = cell.contentView.backgroundColor;
        return cell;
    }
    
    
}

- (void)tableViewProgressViewBtn:(id)sender {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0){
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            CGFloat rowHeight = 90;
            return rowHeight;
        }else {
            CGFloat rowHeight = 50;
            return rowHeight;
        }
        
        
    }else {
        PlayerTableViewCell *cell = (PlayerTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        Song * song = [songs objectAtIndex:indexPath.row - 1];
        [cell.songName setText:song.Title];
        CGFloat height = [[BaseController sharedInstance] getLabelHeight:cell.songName];
        CGFloat rowHeight = 40;
        rowHeight += height;
        return rowHeight;
        
    }
    
    
}



//- (void) playSharingSong {
//
//
//
//    [[BestsongsAPI sharedInstance] fetchAlbumTracks:_album.ID onSuccess:^(id response) {
//        [self hideLoading];
//        [self.songTableView.tableFooterView setHidden:YES];
//        NSDictionary *dataDictionary = (NSDictionary *) response;
//        songs = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getTracksArrayFromJSON:dataDictionary[@"tracks"] album:self.album]];
//
//     for ( Song *song in songs) {
//
//           if (song.AlbumTitle == _album.Title){
//
//                [[BaseController sharedInstance] openAudioPlayer:self.storyboard tabbarController:self.tabBarController album:_album selectedTrack:_selectedSong tracks:songs playlist:_playlist isRunFromDownload:NO delegate:self];
//
//                for (PlayerTableViewCell *cell in self.songTableView.visibleCells) {
//                    cell.state = NAKPlaybackIndicatorViewStatePlaying;
//
//                    if(cell.songName.text == _selectedSong.Title){
//                        cell.state = NAKPlaybackIndicatorViewStatePlaying;
//                    }
//                }
//
//           }
//
//      }
//
//
//
//        [self reloadData];
//    } onFailure:^(NSError *error) {
//        [self hideLoading];
//        // [self showNoInternet];
//
//        [[BaseController sharedInstance] showToastError:error.localizedDescription];
//
//
//
//
//        if ([error.localizedDescription containsString:@"Pakistan"] || [error.localizedDescription containsString:@"available"]) {
//
//            [self contentNotAvailablePopUp];
//
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"videoViewIsDisplayed" object:nil];
//
//        } else {
//
//        }
//
//    }];
//
//
//
//}

#pragma mark - UITableView Delegate methods

bool didSelectItem = NO ;


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(![AFNetworkReachabilityManager sharedManager].isReachable){
        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
        return;
    }
    didSelectItem = YES ;
    
    if (indexPath.row != 0 ){
        
        
        Song *song = [songs objectAtIndex:indexPath.row - 1 ];
        if([song.AudioURL length] != 0){
            self.selectedSong = song;
            
            
            //     [self fabricContentViewOfSelectedSongAddition ];
            
            [[BaseController sharedInstance] openAudioPlayer:self.storyboard tabbarController:self.tabBarController album:self.album selectedTrack:song tracks:songs playlist:_playlist isRunFromDownload:NO delegate:self];
            [self updatePlaybackIndicatorWithIndexPath:indexPath];
        } else {
            if(song.ID != 0){
                if(song.IsVideo){
                    Video *video = [[Video alloc] initWithID:song.ID title:song.Title videoURL:song.VideoURL albumName:song.AlbumTitle poster:song.Poster permalink:song.VideoPermalink]; //song.AlbumID
                    // [[BaseController sharedInstance] openVideoPlayer:self.storyboard andVideo:video andRootViewController:self.view.window.rootViewController];
                    [[BaseController sharedInstance] openVideoPlayerWithType:self.storyboard andVideo:video andRootViewController:self.view.window.rootViewController andType:@"track"];
                }else{
                    [self.view makeToast:@"No Video"];
                    [CSToastManager setTapToDismissEnabled:YES];
                    [CSToastManager setQueueEnabled:NO];
                }
            }
        }
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
    }
}




- (void) contentNotAvailablePopUp {
    
    self.addToContentNotAvailablePopupViewController = [[ContentNotAvailableViewController alloc] init];
    [self presentViewController:_addToContentNotAvailablePopupViewController animated:YES completion:nil];
    
}





#pragma mark - Methods
- (void) retrieveData {
    
    
    
    if(!isDataLoaded){
        @try {
            
            [self hideNoInternet];
            [self showLoading];
            
            
            ///////////////////////////////////
            
            if(_playlist  != nil && [_playlist.ID intValue] > 0){
                
                
                FIRUser *user = [FIRAuth auth].currentUser;
                
                [user getIDTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {

                    
                    if( [_playlist.ID intValue] > 0 ){
                        
                        int playlistNo = [_playlist.ID intValue];
                        NSString *urlWithString = [NSString stringWithFormat:@"https://bestsongs-156307.appspot.com/v2/playlists/%d", playlistNo];
                        _uRLOfApiForCoverOfPlaylistImage = [NSURL URLWithString:urlWithString];
                        
                        
                        
                    }
                    else{
                        _uRLOfApiForCoverOfPlaylistImage = [NSURL URLWithString:@"https://bestsongs-156307.appspot.com/v2/playlists/1"];
                    }
                    
                    //   _uRLOfApiForCoverOfPlaylistImage = [NSURL URLWithString:@"https://bestsongs-156307.appspot.com/v2/playlists/1"];
                    
                    
                    NSMutableURLRequest *request =  [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[NSString stringWithFormat:@"%@",_uRLOfApiForCoverOfPlaylistImage] parameters:nil error:nil];
                    
                    [request setValue:token forHTTPHeaderField:@"Authorization"];
                    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                    
                    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                    
                    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
                      {
                          
                          NSDictionary *jsonResponse = responseObject;
                          
                          
                          NSString *urlWithString = [jsonResponse valueForKey:@"cover_url"];
                          
                          _playlistCoverURLFromApiOfAds = [NSURL URLWithString:urlWithString];
                          
                          NSLog(@"api check  ::: %@",urlWithString);
                          
                          
                          if(_playlistCoverURLFromApiOfAds != nil){
                              
                              NSLog(@"playlistCoverURL not empty ::: ");
                              
                              //                          headerView.poster.alpha = 0;
                              headerView.poster.image =  [UIImage imageWithData:[NSData dataWithContentsOfURL:_playlistCoverURLFromApiOfAds]];
                              
                              //                          [UIView animateWithDuration:1.7 delay:0.5 options:nil animations:^{
                              //
                              //                              UI
                              //
                              //                               headerView.poster.alpha = 1;
                              //                          } completion:^(BOOL finished) {
                              //
                              //                          }];
                              //
                              
                              
                              
                              //  headerView.poster.image =  [UIImage imageNamed:DEFAULTALBUMART];
                          }
                          
                          else
                          {
                              headerView.poster.image =  [UIImage imageNamed:DEFAULTALBUMART];
                          }
                          
                          
                          
                      }] resume];
                    
                    
                }];
                
                
                
                ///////////////////////////////////
                
                
                [self.songTableView.tableFooterView setHidden:YES];
                
                
                
                CATransition *transition = [CATransition animation];
                transition.duration = 0.5f;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionFade;
                [headerView.poster.layer addAnimation:transition forKey:nil];
                
                
                
                [[BestsongsAPI sharedInstance] fetchPlaylistTracks:[NSString stringWithFormat:@"%@",_playlist.BestsongID] onSuccess:^(id response)
                 {
                     [self hideLoading];
                     [self.songTableView.tableFooterView setHidden:YES];
                     NSDictionary *dataDictionary = (NSDictionary *) response;
                     songs = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getTracksArrayFromJSON:dataDictionary[@"tracks"] album:self.album]];
                     [self reloadData];
                 }
                                                         onFailure:^(NSError *error)
                 {
                     [self hideLoading];
                     //  [self showNoInternet];
                     
                     
                     [[BaseController sharedInstance] showToastError:error.localizedDescription];
                     
                     
                     
                     if ([error.localizedDescription containsString:@"Pakistan"] || [error.localizedDescription containsString:@"available"]) {
                         
                         [self contentNotAvailablePopUp];
                         
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"videoViewIsDisplayed" object:nil];
                         
                     } else {
                         
                     }
                     
                     
                     
                     
                     
                 }];
                
                
            } else{
                _playlist = nil;
                if([self.album.Poster isEqualToString:@""]){
                    headerView.poster.image = [UIImage imageNamed:DEFAULTALBUMART];
                    CATransition *transition = [CATransition animation];
                    transition.duration = 0.5f;
                    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                    transition.type = kCATransitionFade;
                    [headerView.poster.layer addAnimation:transition forKey:nil];
                } else {
                    
                    
                    
                    /////////////////////////////////////////////////////////////////
                    
                    //                    NSString *urlAsString = @"https://bestsongs-156307.appspot.com/v1/featured" ;
                    //
                    //                    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
                    //                    NSLog(@"%@", urlAsString);
                    //
                    //
                    //                    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData         *data, NSError *error) {
                    //
                    //                        if (error) {
                    //
                    //                            [headerView.poster sd_setImageWithURL:[NSURL URLWithString:self.album.Poster] //self.album.Poster
                    //                                                 placeholderImage:[UIImage imageNamed:DEFAULTALBUMART]];
                    //
                    //                        } else {
                    //
                    //
                    //                            NSDictionary *addsData = [NSJSONSerialization JSONObjectWithData:data options:0 error: nil];
                    //
                    //                            NSDictionary *inTheAddsDataFromJson = [addsData valueForKey:@"addsData"];
                    //
                    //
                    //
                    //
                    //
                    //                            NSString *playlistBannerAddsImageURL = [inTheAddsDataFromJson valueForKey:@"playlistBannerAddsImage"];
                    //
                    //                            NSString *nameOfPlaylistForAddsToBeAdded = [inTheAddsDataFromJson valueForKey:@"nameOfPlaylistForAdd"];
                    //
                    //                            NSString *playOnAllPlaylist = [inTheAddsDataFromJson valueForKey:@"playOnAllPlaylist"];
                    //
                    //
                    //                            if ( ![playlistBannerAddsImageURL isEqualToString:@""] ) {
                    //
                    //                                if ( [playOnAllPlaylist isEqualToString:@"true"] ) {
                    //
                    //
                    //                                    [headerView.poster sd_setImageWithURL:[NSURL URLWithString: playlistBannerAddsImageURL]
                    //                                                         placeholderImage:[UIImage imageNamed:DEFAULTALBUMART]];
                    //
                    //
                    //
                    //                                }
                    //                                else if ( ![nameOfPlaylistForAddsToBeAdded isEqualToString:@""] ) {
                    //
                    //
                    //                                    if ( self.album.Title == nameOfPlaylistForAddsToBeAdded) {
                    //
                    //
                    //                                        [headerView.poster sd_setImageWithURL:[NSURL URLWithString: playlistBannerAddsImageURL]
                    //                                                             placeholderImage:[UIImage imageNamed:DEFAULTALBUMART]];
                    //
                    //                                    }
                    //
                    //                                }
                    //                                else {
                    //
                    //
                    //                                    [headerView.poster sd_setImageWithURL:[NSURL URLWithString:self.album.Poster] //self.album.Poster
                    //                                                         placeholderImage:[UIImage imageNamed:DEFAULTALBUMART]];
                    //
                    //                                }
                    //
                    //
                    //
                    //                            }else {
                    //
                    //
                    //
                    //                                [headerView.poster sd_setImageWithURL:[NSURL URLWithString:self.album.Poster] //self.album.Poster
                    //                                                     placeholderImage:[UIImage imageNamed:DEFAULTALBUMART]];
                    //
                    //
                    //                            }
                    //
                    //
                    //
                    //
                    //                        }
                    //
                    //
                    //                    }];
                    //
                    
                    
                    
                    
                    
                    /////////////////////////////////////////////////////////////////
                    
                    [headerView.poster sd_setImageWithURL:[NSURL URLWithString:self.album.Poster]
                                         placeholderImage:[UIImage imageNamed:DEFAULTALBUMART]];
                    
                    
                    
                    
                    //                    let imageView = UIImageView()
                    //                    imageView.contentMode = .scaleAspectFill
                    //                    imageView.image = UIImage(named: "example")?.withAlignmentRectInsets(UIEdgeInsets(top: -4, left: 0, bottom: -4, right: 0))
                    
                    //                    [headerView.poster.image resizableImageWithCapInsets:(UIEdgeInsets){
                    //                        .left = 50, .right = 50,
                    //                        .top = 110, .bottom = 0
                    //                    }];
                    
                    
                    /////////////////////////////////////////////////////////////////
                    
                    
                    
                    
                    
                }
                [[BestsongsAPI sharedInstance] fetchAlbumTracks:_album.ID onSuccess:^(id response) {
                    [self hideLoading];
                    [self.songTableView.tableFooterView setHidden:YES];
                    NSDictionary *dataDictionary = (NSDictionary *) response;
                    songs = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getTracksArrayFromJSON:dataDictionary[@"tracks"] album:self.album]];
                    [self reloadData];
                } onFailure:^(NSError *error) {
                    [self hideLoading];
                    // [self showNoInternet];
                    
                    [[BaseController sharedInstance] showToastError:error.localizedDescription];
                    
                    
                    
                    
                    if ([error.localizedDescription containsString:@"Pakistan"] || [error.localizedDescription containsString:@"available"]) {
                        
                        [self contentNotAvailablePopUp];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"videoViewIsDisplayed" object:nil];
                        
                    } else {
                        
                    }
                    
                }];
            }
        } @catch (NSException *exception) {
            [self hideLoading];
            [self showNoInternet];
            
            [[BaseController sharedInstance] showToastError:exception.reason];
        } @finally {
        }
    }
}

- (void)reloadData{
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        
        
        if(songs.count > 0){
            if(self.selectedSong != nil){
                if([self.selectedSong.ID intValue] > 0){
                    for (int i = 0; i < songs.count; i++) {
                        if([((Song *)[songs objectAtIndex:i]).ID isEqualToNumber:self.selectedSong.ID]){
                            self.selectedSong = [songs objectAtIndex:i];
                            [[BaseController sharedInstance] openAudioPlayer:self.storyboard tabbarController:self.tabBarController album:_album selectedTrack:_selectedSong tracks:songs playlist:_playlist isRunFromDownload:NO delegate:self];
                            break;
                        }
                    }
                } else if(self.selectedSong.ID == 0 && [self.selectedSong.Title isEqualToString:@"DL"] && [self.selectedSong.AudioURL isEqualToString:@"DL"] && [self.selectedSong.AlbumTitle isEqualToString:@"DL"]){
                    NSString *permalink = self.selectedSong.Permalink;
                    int index = [self getTrackByPermalink:permalink];
                    if(index != -1){
                        Song *track = [songs objectAtIndex:index];
                        if(track.AlbumID == _album.ID){
                            _selectedSong = track;
                            [[BaseController sharedInstance] openAudioPlayer:self.storyboard tabbarController:self.tabBarController album:_album selectedTrack:_selectedSong tracks:songs playlist:_playlist isRunFromDownload:NO delegate:self];
                        }
                    }
                } else {
                    if ((unsigned long)self.tabBarController.popupPresentationState == 3) {
                        [[PlayerViewController sharedInstance] downPlayer];
                    }
                }
            }
        } else {
            self.songTableView.backgroundView = noTracksview;
            self.songTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        [UIView transitionWithView: self.songTableView
                          duration: 0.30f
                           options: UIViewAnimationOptionTransitionCrossDissolve
                        animations: ^(void) {
                            objectiveCDM = [ObjectiveCDM sharedInstance];
                            objectiveCDM.uiDelegate = self;
                            objectiveCDM.dataDelegate = self;
                            objectiveCDMDownloadingTasks = [objectiveCDM downloadingTasks];
                            isDataLoaded = true;
                            [self.songTableView setSeparatorColor:[[UIColor alloc]initWithRed:35.0/255.0 green:35.0/255.0 blue:35.0/255.0 alpha:1.0]];
                            self.songTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                            [self.songTableView reloadData];
                            [self hideLoading];
                        } completion: ^(BOOL finished){
                            CATransition *animation = [CATransition animation];
                            animation.type = kCATransitionFade;
                            animation.duration = 0.3;
                            [self.songTableView.tableFooterView.layer addAnimation:animation forKey:nil];
                            self.songTableView.tableFooterView.hidden = NO;
                            [PlayerViewController sharedInstance].delegate = self;
                        }];
        
        
    });
    
}

- (void)reachabilityChanged:(NSNotification *)notification {
    if([[AFNetworkReachabilityManager sharedManager] isReachable]) {
        [self hideNoInternet];
        //        if(!isViewAppear)
        //            [[BaseController sharedInstance] showToastSuccess:INTERNETSUCCESSMESSAGE];
        if(isViewAppear)
            isViewAppear = !isViewAppear;
        if(!isDataLoaded)
            [self retrieveData];
    } else {
        if(isViewAppear){
            isViewAppear = !isViewAppear;
            if(!isDataLoaded)
                [self showNoInternet];
        }
        //        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
    }
}

- (void)showNoInternet {
    noInternetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,160,160)];
    image.image=[UIImage imageNamed:@"server-not-found.png"];
    image.contentMode = UIViewContentModeScaleAspectFill;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 140, 160, 20)];
    label.text = @"Could Not Connect";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:14.0];
    [label setTextColor:[UIColor whiteColor]];
    
    noInternetView.center = self.view.center;
    [noInternetView addSubview:image];
    [noInternetView addSubview:label];
    [self.view addSubview:noInternetView];
}





//- (void) createPlaylist{
//
//
//    self.addToPlayListPopupViewController = [PlaylistNamePopupViewController instantiateFromNib];
//
//    [self.addToPlayListPopupViewController setFrame:CGRectMake(0, 0, 300, 300)];
//    // Popup
//    CNPPopupController *newPopupController = [[CNPPopupController alloc] initWithContents:@[self.addToPlayListPopupViewController]];
//    newPopupController.theme = [[BaseController sharedInstance] cnPopupDefaultTheme];
//    newPopupController.theme.presentationStyle = CNPPopupPresentationStyleFadeIn;
//    newPopupController.theme.movesAboveKeyboard = YES;
//    newPopupController.delegate = self;
//
//    self.addToPlayListPopupViewController.popupController = newPopupController;
//    [newPopupController presentPopupControllerAnimated:YES];
//}
//
//- (void) contentNotAvailablePopUp{
//
//
//    self.addToContentNotAvailablePopupViewController = [[ContentNotAvailableViewController alloc] init];
//
//    [self presentViewController:_addToContentNotAvailablePopupViewController animated:YES completion:nil];
//
//
//
//
//}




- (void)hideNoInternet{
    [noInternetView removeFromSuperview];
    noInternetView = nil;
}

- (void)showLoading {
//    if(![SVProgressHUD isVisible]){
//
//        //        self.navigationController.navigationBar.userInteractionEnabled = NO;
//
//        [[BaseController sharedInstance] setupLoading];
//        [SVProgressHUD show];
//    }
}



- (void)hideLoading {
//    if([SVProgressHUD isVisible]){
//        
//        self.navigationController.navigationBar.userInteractionEnabled = YES;
//        
//        [SVProgressHUD dismiss];
//    }
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
    [UINavigationController attemptRotationToDeviceOrientation];
    [UIViewController attemptRotationToDeviceOrientation];
    
    
    [[ NSNotificationCenter defaultCenter ] postNotificationName:@"hideHomeAdd" object:nil];
    
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
    [UINavigationController attemptRotationToDeviceOrientation];
    [UIViewController attemptRotationToDeviceOrientation];
    
    [[PlayerViewController sharedInstance] updateControls];
    objectiveCDMDownloadingTasks = [objectiveCDM downloadingTasks];
    [self.songTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    
    isViewAppear = YES;
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [self reachabilityChanged:nil];
    }];
    [self becomeFirstResponder];
    [super viewDidAppear:animated];
    
    
    
    
    
    
}




- (void)viewDidDisappear:(BOOL)animated {
    if ([self isMovingFromParentViewController]) {
        for (int i = 0; i < [self.songTableView numberOfRowsInSection:0]; i++) {
            PlayerTableViewCell *cell = (PlayerTableViewCell *)[self.songTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if(cell.timer != nil){
                [cell.timer invalidate];
                cell.timer = nil;
            }
        }
    }
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    isViewAppear = NO;
    [self hideLoading];
    [self resignFirstResponder];
    [super viewDidDisappear:animated];
}

@end
