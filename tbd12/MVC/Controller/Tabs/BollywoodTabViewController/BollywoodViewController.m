//
//  BollywoodViewController.m
//  Bestsongs.pk
//
//  Created by Syed Muneeb Ur Rehman ... on 7/25/18.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BollywoodViewController.h"

@interface BollywoodViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property NSUInteger currentPage;
@property BOOL hasMoreItems;
@property BOOL isDataLoaded;
@property BOOL isDataLoading;
@property BOOL isFirstTimeCheckNetwork;
@property BOOL isViewAppear;
@property CGFloat singleAlbumWidth;
@property UIView *noInternetView;

@property NSMutableArray * albums;
@property NSMutableArray * alphabets;

@property NSArray *alphabets2;

@end

#import "tbd12-Swift.h"


@implementation BollywoodViewController

@synthesize alphabetCollectionView;



- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    _alphabets2 = [[NSArray alloc] initWithObjects:@"0-9",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.title = @"Bollywood";
    
    [self.alphabetCollectionView setHidden:YES];
    [self.CollectionView setHidden:YES];
    self.view.backgroundColor = [[BaseController sharedInstance] getDefaultBackgroundColor];
    
    _alphabets = [[NSMutableArray alloc] init];
    _isDataLoaded = NO;
    _isDataLoading = NO;
    _isFirstTimeCheckNetwork = YES;
    _currentPage = 1;
    _hasMoreItems = YES;
    _singleAlbumWidth = 2;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        _singleAlbumWidth = 3;
    [self.CollectionView addPullToRefreshWithActionHandler:^{
        if(![AFNetworkReachabilityManager sharedManager].isReachable){
            [self.CollectionView.pullToRefreshView stopAnimating];
            [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
            return;
        }
        [self pullToRefreshData];
    } topMargin:0.0];
    
    [self.CollectionView addInfiniteScrollingWithActionHandler:^{
        if(![AFNetworkReachabilityManager sharedManager].isReachable){
            [self.CollectionView.infiniteScrollingView stopAnimating];
            [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
            return;
        }
        if(_hasMoreItems)
            [self retrieveData];
        else
            [self.CollectionView.infiniteScrollingView stopAnimating];
    }];
}

#pragma mark - UICollectionView Datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(collectionView == self.alphabetCollectionView) {
        NSInteger count = _alphabets2.count;
        return count;
    } else if(collectionView == self.CollectionView)
        return _albums.count;
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(collectionView == self.CollectionView){
        static NSString *CellIdentifier = @"BollywoodCell";
        CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        if(cell == nil)
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
        Album * currentAlbum = [_albums objectAtIndex:indexPath.row];
        [cell.Title setText:currentAlbum.Title];
        
        [cell.Image sd_setImageWithURL:[NSURL URLWithString:currentAlbum.Poster]
                      placeholderImage:[UIImage imageNamed:DEFAULTALBUMART]];
        
        return cell;
    }
    AlphabetLabelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Alphabet_Cell_ID" forIndexPath:indexPath];
    cell.alphabet.text = [_alphabets2 objectAtIndex:indexPath.row];
//    if(cell == nil)
//        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BollywoodAlphabetsCell" forIndexPath:indexPath];
//    [cell.alphabet setText:[_alphabets objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UICollectionView Delegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(![AFNetworkReachabilityManager sharedManager].isReachable){
//        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
        [self showNoInternetAlertMessag];
        return;
    }
    if(collectionView == self.CollectionView){
        SingleAlbumViewController * singleAlbumViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"singleAlbumViewController"];
        Album *album;
        Song *song = [[Song alloc] init];
        singleAlbumViewController.selectedSong = song;
        album = [_albums objectAtIndex:indexPath.row];
        singleAlbumViewController.album = album;
        [self.navigationController pushViewController:singleAlbumViewController animated:YES];
    } else if(collectionView == self.alphabetCollectionView){
        NSString * selectedAlphabet = [_alphabets2 objectAtIndex:indexPath.row];
        BollywoodAlbumsViewController * bavc = [self.storyboard instantiateViewControllerWithIdentifier:@"bollywoodAlbumViewController"];
        bavc.selectedAlphabet = selectedAlphabet;
        [self.navigationController pushViewController:bavc animated:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(collectionView == self.CollectionView){
        CGFloat width = (collectionView.frame.size.width / _singleAlbumWidth) - (_singleAlbumWidth + 0.5);
        return CGSizeMake(width, width);
    }
    else{
        CGFloat width = 23;
        NSString *al = [_alphabets2 objectAtIndex:indexPath.row];
        if([al isEqualToString:@"0-9"])
            return CGSizeMake((width + 18), (width - 2));
        else
            return CGSizeMake((width + 6), (width - 2));
    }
}

#pragma mark - Methods
- (void) retrieveData {
    
    
    
    @try {
        if(!_isDataLoaded && !_isDataLoading){
            [self hideNoInternet];
            [self showLoading];
            _isDataLoading = YES;
        }
        [[BestsongsAPI sharedInstance] fetchBollywood:[NSNumber numberWithInteger:_currentPage] onSuccess:^(id response) {
            [self hideNoInternet];
            NSDictionary *dataDictionary = (NSDictionary *) response;
            NSMutableArray *dataAlbums = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getAlbumsArrayFromJSON:dataDictionary[@"albums"]]];
            dispatch_async(dispatch_get_main_queue(), ^ {
                _currentPage++;
                if(!_isDataLoaded){
//                    [_alphabets addObject:@"0-9"];
//                    for (char a = 'A'; a <= 'Z'; a++)
//                        [_alphabets addObject:[NSString stringWithFormat:@"%c", a]];
//                    [self.alphabetCollectionView reloadData];
                    
                    _albums = [[NSMutableArray alloc] initWithArray:dataAlbums];
                    [self.CollectionView reloadData];
                    
                    _isDataLoaded = YES;
                    _isDataLoading = NO;
                    [self.alphabetCollectionView setHidden:NO];
                    [self.CollectionView setHidden:NO];
                    if(!_isViewAppear)
                        [self hideLoading];
                }
                else if(_hasMoreItems && dataAlbums.count > 0){
                    int64_t delayInSeconds = 0.5;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                        NSMutableArray *indexPaths = [NSMutableArray array];
                        NSInteger currentCount = _albums.count;
                        for (int i = 0; i < dataAlbums.count ; i++)
                            [indexPaths addObject:[NSIndexPath indexPathForRow:currentCount+i inSection:0]];
                        
                        [_albums addObjectsFromArray:dataAlbums];
                        [self.CollectionView insertItemsAtIndexPaths:indexPaths];
                        [self.CollectionView.infiniteScrollingView stopAnimating];
                    });
                }
                _hasMoreItems = NO;
                
               
                
                if(dataAlbums.count >= REQUESTPERPAGE)
                    _hasMoreItems = YES;
            });
        } onFailure:^(NSError *error) {
            if(!_isDataLoaded){
                if(!_isViewAppear)
                    [self hideLoading];
                _isDataLoading = NO;
                [self showNoInternet];
                
                if ([error.localizedDescription containsString:@"Pakistan"] || [error.localizedDescription containsString:@"available"]) {
                    
                    [self contentNotAvailablePopUp];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"videoViewIsDisplayed" object:nil];
                    
                }
                
                
            } else if(_hasMoreItems){
                [self.CollectionView.infiniteScrollingView stopAnimating];
            }
            [[BaseController sharedInstance] showToastError:error.localizedDescription];
        }];
    } @catch (NSException *exception) {
        if(!_isViewAppear)
            [self hideLoading];
        _isDataLoading = NO;
        [self showNoInternet];
        [[BaseController sharedInstance] showToastError:exception.reason];
    } @finally {
        
        [self hideLoading];
    }
}


- (void) contentNotAvailablePopUp{
    
    self.addToContentNotAvailablePopupViewController = [[ContentNotAvailableViewController alloc] init];
    
    [self presentViewController:_addToContentNotAvailablePopupViewController animated:YES completion:nil];
    
    
    
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

// Common Methods in All Controller
- (void) pullToRefreshData{
    @try {
        [[BestsongsAPI sharedInstance] fetchBollywood:[NSNumber numberWithInteger:1] onSuccess:^(id response) {
            NSDictionary *dataDictionary = (NSDictionary *) response;
            NSMutableArray *dataAlbums = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getAlbumsArrayFromJSON:dataDictionary[@"albums"]]];
            dispatch_async(dispatch_get_main_queue(), ^ {
                _currentPage = 2;
                
                _hasMoreItems = NO;
                if(dataAlbums.count >= REQUESTPERPAGE)
                    _hasMoreItems = YES;
                _albums = [[NSMutableArray alloc] initWithArray:dataAlbums];
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
            
            if ([error.localizedDescription containsString:@"Pakistan"] || [error.localizedDescription containsString:@"available"]) {
                
                [self contentNotAvailablePopUp];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"videoViewIsDisplayed" object:nil];
                
            } else {
                
            }
            
        }];
    } @catch (NSException *exception) {
        [self.CollectionView.pullToRefreshView stopAnimating];
        [[BaseController sharedInstance] showToastError:exception.reason];
    } @finally {
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

- (void)reachabilityChanged:(NSNotification *)notification  {
    if([[AFNetworkReachabilityManager sharedManager] isReachable]) {
        if(_isFirstTimeCheckNetwork)
            _isFirstTimeCheckNetwork = !_isFirstTimeCheckNetwork;
        else{
            if(!_isViewAppear)
//                [[BaseController sharedInstance] showToastSuccess:INTERNETSUCCESSMESSAGE];
                _connectionFailedMessage.hidden = true;
        }
        if(_isViewAppear)
            _isViewAppear = !_isViewAppear;
        if(!_isDataLoaded && !_isDataLoading)
            [self retrieveData];
    } else {
        if(_isFirstTimeCheckNetwork){
            _isFirstTimeCheckNetwork = false;
            [self showNoInternet];
        }
        if(_isViewAppear)
            _isViewAppear = !_isViewAppear;
//        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
        _connectionFailedMessage.hidden = false;
    }
}

- (void)showNoInternet{
//    _noInternetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
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
//    _noInternetView.center = self.view.center;
//    [_noInternetView addSubview:image];
//    [_noInternetView addSubview:label];
//    [self.view addSubview:_noInternetView];
}

- (void)hideNoInternet{
//    [_noInternetView removeFromSuperview];
//    _noInternetView = nil;
}

- (void)showLoading {
//    if(![SVProgressHUD isVisible]){
//        [[BaseController sharedInstance] setupLoading];
//
//        int screenSize =(int)[[UIScreen mainScreen] nativeBounds].size.height / 36 ;
//
//        [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, (CGFloat)screenSize )];
//
//        [SVProgressHUD show];
//    }
}

- (void)hideLoading {
//    if([SVProgressHUD isVisible])
//        [SVProgressHUD dismiss];
}

-(BOOL)prefersStatusBarHidden{
    return NO;
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    
    
    
    [[PlayerViewController sharedInstance] updateControls];
    _isViewAppear = YES;
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [self reachabilityChanged:nil];
    }];
    if(_isDataLoading)
        [self showLoading];
    [self becomeFirstResponder];
    [super viewDidAppear:animated];
    
    
    if([AFNetworkReachabilityManager sharedManager].isReachable){
        _connectionFailedMessage.hidden = true;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    _isViewAppear = NO;
    if(_isDataLoading)
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
