//
//  DiscoverMoreViewController.m
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 10/29/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DiscoverMoreViewController.h"

@interface DiscoverMoreViewController () {
    NSMutableArray * albums;
    
    NSUInteger currentPage;
    BOOL hasMoreItems;
    BOOL isDataLoaded;
    BOOL isDataLoading;
    BOOL isFirstTimeCheckNetwork;
    BOOL isViewAppear;
    CGFloat singleAlbumWidth;
    UIView *noInternetView;
    UIView *noPlaylistview;
}
@end

@implementation DiscoverMoreViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController.navigationBar setTintColor:[[BaseController sharedInstance] getDefaultColor]];
    self.navigationItem.title = self.discover.Title;
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButton:)];
    searchButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = searchButton;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    noPlaylistview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    UILabel *messageLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 200)];
    [messageLbl setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:18]];
    messageLbl.text = @"Coming Soon";
    messageLbl.textAlignment = NSTextAlignmentCenter;
    messageLbl.lineBreakMode = NSLineBreakByWordWrapping;
    messageLbl.numberOfLines = 1;
    messageLbl.center = noPlaylistview.center;
    [messageLbl setTextColor:[UIColor whiteColor]];
    [noPlaylistview addSubview:messageLbl];
    
    self.view.backgroundColor = [[BaseController sharedInstance] getDefaultBackgroundColor];
    [self.CollectionView setHidden:YES];
    
    isDataLoaded = NO;
    isDataLoading = NO;
    isFirstTimeCheckNetwork = YES;
    currentPage = 1;
    hasMoreItems = YES;
    singleAlbumWidth = 2;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        singleAlbumWidth = 3;
    
    [self.CollectionView addPullToRefreshWithActionHandler:^{
        if(![AFNetworkReachabilityManager sharedManager].isReachable){
            [self.CollectionView.pullToRefreshView stopAnimating];
            [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
            return;
        }
        [self pullToRefreshData];
    } topMargin:0.0];
    
    // Uncomment when pagination done
    [self.CollectionView addInfiniteScrollingWithActionHandler:^{
        if(![AFNetworkReachabilityManager sharedManager].isReachable){
            [self.CollectionView.infiniteScrollingView stopAnimating];
            [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
            return;
        }
        if(hasMoreItems) {
            
            if([self.discover.Permalink  isEqualToString:@"trailers"]){
                
                if (currentPage >= 7) {
                    [self.CollectionView.infiniteScrollingView stopAnimating];
                }else {
                    [self retrieveData];
                }
                
            }
            if([self.discover.Permalink  isEqualToString:@"top_videos"]){
                
                if (currentPage >= 11) {
                    [self.CollectionView.infiniteScrollingView stopAnimating];
                }else {
                    [self retrieveData];
                }
                
            }
            if([self.discover.Permalink  isEqualToString:@"evergreen"]){
                
                if (currentPage > 2) {
                    [self.CollectionView.infiniteScrollingView stopAnimating];
                }else {
                    [self retrieveData];
                }
                
            }
            if([self.discover.Permalink  isEqualToString:@"gupshups"]){
                
                if (currentPage > 1) {
                    [self.CollectionView.infiniteScrollingView stopAnimating];
                }else {
                    [self retrieveData];
                }
                
            }else {
                [self retrieveData];
            }
            
            
        }
        else
            [self.CollectionView.infiniteScrollingView stopAnimating];
    }];
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

#pragma mark - UICollectionView Datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return albums.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DiscoverMoreCell";
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if(cell == nil)
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
    Album * currentAlbum = [albums objectAtIndex:indexPath.row];
    [cell.Title setText:currentAlbum.Title];
        
    [cell.Image sd_setImageWithURL:[NSURL URLWithString:currentAlbum.Poster]
                  placeholderImage:[UIImage imageNamed:DEFAULTALBUMART]];
    
    if([self.discover.Permalink isEqualToString:@"trailers"])
        cell.videoPlayIcon.hidden = NO;
    else if([self.discover.Permalink isEqualToString:@"top_videos"])
        cell.videoPlayIcon.hidden = NO;
    else if([self.discover.Permalink isEqualToString:@"evergreen"])
        cell.videoPlayIcon.hidden = NO;
    else {
        
        if(![self.discover.Permalink isEqualToString:@"gupshups"])
            cell.videoPlayIcon.hidden = YES;
        
    }
    

    return cell;
}

#pragma mark - UICollectionView Delegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(![AFNetworkReachabilityManager sharedManager].isReachable){
        //        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
        [self showNoInternetAlertMessag];
        return;
    }
    
    if(collectionView == _CollectionView){
        
        if([self.discover.Permalink  isEqualToString:@"trailers"]){
            
            Video *video = [albums objectAtIndex:indexPath.row];
            NSArray *indexPaths = [collectionView indexPathsForSelectedItems];
            NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
            //            [[BaseController sharedInstance] openVideoPlayer:self.storyboard andVideo:video andRootViewController:self.view.window.rootViewController];
            
            [self showLoading] ; 
            
            VideoWebService *webService = [VideoWebService new] ;
            NSString *videoUrl = [webService
                                  fetchVideoUrlForVideoWithId:[video.ID integerValue] andType:@"trailers" ] ;
            
            videoUrl = [videoUrl stringByReplacingOccurrencesOfString:@".mpd" withString:@".m3u8" ] ;
            
            
            
            Video * newVideo = [[Video alloc]initWithID:video.ID title:video.Title videoURL:videoUrl albumName:video.AlbumName poster:video.Poster permalink:video.Permalink] ;
           
            
            [[BaseController sharedInstance] openVideoPlayerWithType:self.storyboard andVideo:newVideo andRootViewController:self.view.window.rootViewController andType:@"trailer"] ;
            [collectionView deselectItemAtIndexPath:indexPath animated:NO];
        }
        else if([self.discover.Permalink  isEqualToString:@"top_videos"]){
            
            Video *video = [albums objectAtIndex:indexPath.row];
            NSArray *indexPaths = [collectionView indexPathsForSelectedItems];
            NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
            //            [[BaseController sharedInstance] openVideoPlayer:self.storyboard andVideo:video andRootViewController:self.view.window.rootViewController];
            [self showLoading] ;
            
            VideoWebService *webService = [VideoWebService new] ;
            NSString *videoUrl = [webService
                                  fetchVideoUrlForVideoWithId:[video.ID integerValue] andType:@"top_videos" ] ;
            
            videoUrl = [videoUrl stringByReplacingOccurrencesOfString:@".mpd" withString:@".m3u8" ] ;
            
            
            Video * newVideo = [[Video alloc]initWithID:video.ID title:video.Title videoURL:videoUrl albumName:video.AlbumName poster:video.Poster permalink:video.Permalink] ;
            
            
            [[BaseController sharedInstance] openVideoPlayerWithType:self.storyboard andVideo:newVideo andRootViewController:self.view.window.rootViewController andType:@"top_video"] ;
            [collectionView deselectItemAtIndexPath:indexPath animated:NO];
            
        }
        else if([self.discover.Permalink  isEqualToString:@"evergreen"]){
            
            Video *video = [albums objectAtIndex:indexPath.row];
            NSArray *indexPaths = [collectionView indexPathsForSelectedItems];
            NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
            //            [[BaseController sharedInstance] openVideoPlayer:self.storyboard andVideo:video andRootViewController:self.view.window.rootViewController];
            
            [self showLoading] ;
            
            VideoWebService *webService = [VideoWebService new] ;
            NSString *videoUrl = [webService
                                  fetchVideoUrlForVideoWithId:[video.ID integerValue] andType:@"evergreen" ] ;
            
            videoUrl = [videoUrl stringByReplacingOccurrencesOfString:@".mpd" withString:@".m3u8" ] ;
            
            
            Video * newVideo = [[Video alloc]initWithID:video.ID title:video.Title videoURL:videoUrl albumName:video.AlbumName poster:video.Poster permalink:video.Permalink] ;
            
            
            [[BaseController sharedInstance] openVideoPlayerWithType:self.storyboard andVideo:newVideo andRootViewController:self.view.window.rootViewController andType:@"evergreen"] ;
            [collectionView deselectItemAtIndexPath:indexPath animated:NO];
            
        }
        else if([self.discover.Permalink  isEqualToString:@"gupshups"]){
            Video *video = [albums objectAtIndex:indexPath.row];
            NSArray *indexPaths = [collectionView indexPathsForSelectedItems];
            NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
            
            [self showLoading] ; 
            
//            [[BaseController sharedInstance] openVideoPlayer:self.storyboard andVideo:video andRootViewController:self.view.window.rootViewController];
            [[BaseController sharedInstance] openVideoPlayerWithType:self.storyboard andVideo:video andRootViewController:self.view.window.rootViewController andType:@"gupshup"] ;
             [collectionView deselectItemAtIndexPath:indexPath animated:NO];
        } else {
            Song *song = [[Song alloc] init];
            Album *album = [albums objectAtIndex:indexPath.row];
            SingleAlbumViewController * singleAlbumViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"singleAlbumViewController"];
            singleAlbumViewController.selectedSong = song;
            singleAlbumViewController.album = album;
            [self.navigationController pushViewController:singleAlbumViewController animated:YES];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (collectionView.frame.size.width / singleAlbumWidth) - (singleAlbumWidth + 0.5);
    return CGSizeMake(width, width);
}

- (void) contentNotAvailablePopUp{
    
    self.addToContentNotAvailablePopupViewController = [[ContentNotAvailableViewController alloc] init];
    
    [self presentViewController:_addToContentNotAvailablePopupViewController animated:YES completion:nil];
    
    
    
}


#pragma mark - Methods
- (void) retrieveData {
    @try {
        if(!isDataLoaded && !isDataLoading){
            [self hideNoInternet];
            [self showLoading];
            isDataLoading = YES;
        }
        [[BestsongsAPI sharedInstance] fetchDiscover:_discover.Permalink page:[NSNumber numberWithInteger:currentPage] onSuccess:^(id response) {
            NSDictionary *dataDictionary = (NSDictionary *) response;
            NSMutableArray *dataAlbums;
            
            if([self.discover.Permalink  isEqualToString:@"trailers"]){
                dataAlbums = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getVideosArrayFromJSON:dataDictionary[@"videos"]]];
            }
            else if([self.discover.Permalink  isEqualToString:@"top_videos"]){
                dataAlbums = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getVideosArrayFromJSON:dataDictionary[@"videos"]]];
            }
            else if([self.discover.Permalink  isEqualToString:@"evergreen"]){
                dataAlbums = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getVideosArrayFromJSON:dataDictionary[@"videos"]]];
            }
            else if([self.discover.Permalink  isEqualToString:@"gupshups"]){
                dataAlbums = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getVideosArrayFromJSON:dataDictionary[@"videos"]]];
            } else {
                dataAlbums = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getAlbumsArrayFromJSON:dataDictionary[@"albums"]]];
            }
            dispatch_async(dispatch_get_main_queue(), ^ {
                currentPage++;
                if(!isDataLoaded){
                    if(dataAlbums.count > 0){
                        [UIView transitionWithView: self.CollectionView
                                          duration: 0.50f
                                           options: UIViewAnimationOptionTransitionCrossDissolve
                                        animations: ^(void) {
                                            albums = [[NSMutableArray alloc] initWithArray:dataAlbums];
                                            [self.CollectionView reloadData];
                                            [self.CollectionView setHidden:NO];
                                        } completion: ^(BOOL finished){
                                        }];
                    } else {
                        [self.view addSubview:noPlaylistview];
                    }
                    isDataLoaded = YES;
                    isDataLoading = NO;
                    [self hideLoading];
                } else if(hasMoreItems){
                    int64_t delayInSeconds = 0.5;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                        NSMutableArray *indexPaths = [NSMutableArray array];
                        NSInteger currentCount = albums.count;
                        for (int i = 0; i < dataAlbums.count ; i++)
                            [indexPaths addObject:[NSIndexPath indexPathForRow:currentCount+i inSection:0]];
                        
                        [albums addObjectsFromArray:dataAlbums];
                        [self.CollectionView insertItemsAtIndexPaths:indexPaths];
                        [self.CollectionView.infiniteScrollingView stopAnimating];
                    });
                }
                hasMoreItems = NO;
                if(dataAlbums.count >= REQUESTPERPAGE)
                    hasMoreItems = YES;
            });
        } onFailure:^(NSError *error) {
            if(!isDataLoaded){
                [self hideLoading];
                isDataLoading = NO;
                [self showNoInternet];
                
                if ([error.localizedDescription containsString:@"Pakistan"] || [error.localizedDescription containsString:@"available"]) {
                    
                    [self contentNotAvailablePopUp];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"videoViewIsDisplayed" object:nil];
                    
                } else {
                    
                }
                
                
            } else if(hasMoreItems){
                [self.CollectionView.infiniteScrollingView stopAnimating];
            }
            [[BaseController sharedInstance] showToastError:error.localizedDescription];
        }];
    } @catch (NSException *exception) {
        [self hideLoading];
        isDataLoading = NO;
        [self showNoInternet];
        [[BaseController sharedInstance] showToastError:exception.reason];
    } @finally {
    }
}

// Common Methods in All Controller
- (void) pullToRefreshData{
    @try {
        [[BestsongsAPI sharedInstance] fetchDiscover:_discover.Permalink page:[NSNumber numberWithInteger:1] onSuccess:^(id response) {
            NSDictionary *dataDictionary = (NSDictionary *) response;
            NSMutableArray *dataAlbums;
            
             if([self.discover.Permalink  isEqualToString:@"trailers"]){
                dataAlbums = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getVideosArrayFromJSON:dataDictionary[@"videos"]]];
            }
            else if([self.discover.Permalink  isEqualToString:@"top_videos"]){
                dataAlbums = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getVideosArrayFromJSON:dataDictionary[@"videos"]]];
            }
            else if([self.discover.Permalink  isEqualToString:@"evergreen"]){
                dataAlbums = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getVideosArrayFromJSON:dataDictionary[@"videos"]]];
            }
            else if([self.discover.Permalink  isEqualToString:@"gupshups"]){
                dataAlbums = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getVideosArrayFromJSON:dataDictionary[@"videos"]]];
            } else {
                dataAlbums = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getAlbumsArrayFromJSON:dataDictionary[@"albums"]]];
            }
            dispatch_async(dispatch_get_main_queue(), ^ {
                currentPage = 2;
                hasMoreItems = NO;
                if(dataAlbums.count >= REQUESTPERPAGE)
                    hasMoreItems = YES;
                albums = [[NSMutableArray alloc] initWithArray:dataAlbums];
                [self.CollectionView reloadData];
                [self.CollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                                            atScrollPosition:UICollectionViewScrollPositionTop
                                                    animated:YES];
                [self.CollectionView reloadData];
                [self.CollectionView.pullToRefreshView stopAnimating];
            });
        } onFailure:^(NSError *error) {
            [self.CollectionView.pullToRefreshView stopAnimating];
            [[BaseController sharedInstance] showToastError:error.localizedDescription];
            
            //////////////////////
            if ([error.localizedDescription containsString:@"Pakistan"] || [error.localizedDescription containsString:@"available"]) {
                
                [self contentNotAvailablePopUp];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"videoViewIsDisplayed" object:nil];
                
            } else {
                
            }

            //////////////////////
            
            
        }];
    } @catch (NSException *exception) {
        [self.CollectionView.pullToRefreshView stopAnimating];
        [[BaseController sharedInstance] showToastError:exception.reason];
    } @finally {
    }
}

- (void)reachabilityChanged:(NSNotification *)notification  {
    if([[AFNetworkReachabilityManager sharedManager] isReachable]) {
        if(!isViewAppear)
//            [[BaseController sharedInstance] showToastSuccess:INTERNETSUCCESSMESSAGE];
            _connectionFailedMessage.hidden = true;
        if(isViewAppear)
            isViewAppear = !isViewAppear;
        if(!isDataLoaded && !isDataLoading)
            [self retrieveData];
    } else {
        if(isViewAppear){
            isViewAppear = !isViewAppear;
            if(!isDataLoaded)
                [self showNoInternet];
        }
//        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
        _connectionFailedMessage.hidden = false;
    }
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

- (void)showNoInternet{
//    noInternetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
//    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,160,160)];
//    image.image=[UIImage imageNamed:@"server-not-found.png"];
//    image.contentMode = UIViewContentModeScaleAspectFill;
//
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 140, 160, 20)];
//    label.text = @"Could Not Connect";
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:14.0];
//    [label setTextColor:[UIColor whiteColor]];
//
//    noInternetView.center = self.view.center;
//    [noInternetView addSubview:image];
//    [noInternetView addSubview:label];
//    [self.view addSubview:noInternetView];
}

- (void)hideNoInternet{
//    [noInternetView removeFromSuperview];
//    noInternetView = nil;
}

- (void)showLoading {
    if(![SVProgressHUD isVisible]){
        [[BaseController sharedInstance] setupLoading];
        int screenSize =(int)[[UIScreen mainScreen] nativeBounds].size.height / 36 ;
        
        [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, (CGFloat)screenSize )];
        [SVProgressHUD show];
    }
}

- (void)hideLoading {
    if([SVProgressHUD isVisible])
        [SVProgressHUD dismiss];
}

-(BOOL)prefersStatusBarHidden{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [[PlayerViewController sharedInstance] updateControls];
    isViewAppear = YES;
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [self reachabilityChanged:nil];
    }];
    if(isDataLoading)
        [self showLoading];
    [self becomeFirstResponder];
    [super viewDidAppear:animated];
    
    if([AFNetworkReachabilityManager sharedManager].isReachable){
        _connectionFailedMessage.hidden = true;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    isViewAppear = NO;
    if(isDataLoading)
        [self hideLoading];
    [self resignFirstResponder];
    [super viewDidDisappear:animated];
}

- (void)openDownload{
    ShowDownloadsViewController *showDownloadsController = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowDownloadsViewController"];
    [self.navigationController pushViewController:showDownloadsController animated:NO];
}

-(IBAction)clickedShowOffline:(id)sender {
    [self openDownload];
}

@end
