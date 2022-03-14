//
//  ArtistViewController.m
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 7/25/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ArtistViewController.h"

@interface ArtistViewController () {
    NSMutableArray * artists;
    NSMutableArray * alphabets;
    
    NSUInteger currentPage;
    BOOL hasMoreItems;
    BOOL isDataLoaded;
    BOOL isDataLoading;
    BOOL isFirstTimeCheckNetwork;
    BOOL isViewAppear;
    CGFloat singleAlbumWidth;
    UIView *noInternetView;
}
@end

@implementation ArtistViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.title = @"Artists";
    
    [self.alphabetCollectionView setHidden:YES];
    [self.CollectionView setHidden:YES];
    self.view.backgroundColor = [[BaseController sharedInstance] getDefaultBackgroundColor];
    
    alphabets = [[NSMutableArray alloc] init];
    isDataLoaded = NO;
    isDataLoading = NO;
    isFirstTimeCheckNetwork = YES;
    currentPage = 1;
    hasMoreItems = YES;
    singleAlbumWidth = 2;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        singleAlbumWidth = 3;
    
    // Un comment this section after pagging implementation
  
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
        if(hasMoreItems)
            [self retrieveData];
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
    if(collectionView == _alphabetCollectionView)
        return alphabets.count;
    else if(collectionView == self.CollectionView)
        return artists.count;
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(collectionView == self.CollectionView){
        static NSString *CellIdentifier = @"ArtistCell";
        CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        if(cell == nil)
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        Artist *artist = [artists objectAtIndex:indexPath.row];
        [cell.Title setText:artist.Name];
        [cell.Image sd_setImageWithURL:[NSURL URLWithString:artist.Poster]
                      placeholderImage:[UIImage imageNamed:DEFAULTARTISTART]];
        
        return cell;
    }
    static NSString *CellIdentifier = @"ArtistAlphabetsCell";
    AlphabetCollectionViewCell *cell = (AlphabetCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if(cell == nil)
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell.alphabet setText:[alphabets objectAtIndex:indexPath.row]];
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
        Artist *artist = [artists objectAtIndex:indexPath.row];
        ArtistSongsViewController * asvc = [self.storyboard instantiateViewControllerWithIdentifier:@"artistSongsViewController"];
        asvc.artist = artist;
        [self.navigationController pushViewController:asvc animated:YES];
    } else if(collectionView == self.alphabetCollectionView){
        NSString * selectedAlphabet = [alphabets objectAtIndex:indexPath.row];
        ArtistAlbumsViewController * aavc = [self.storyboard instantiateViewControllerWithIdentifier:@"artistAlbumViewController"];
        aavc.selectedAlphabet = selectedAlphabet;
        [self.navigationController pushViewController:aavc animated:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(collectionView == self.CollectionView){
        CGFloat width = (collectionView.frame.size.width / singleAlbumWidth) - (singleAlbumWidth + 0.5);
        return CGSizeMake(width, width);
    }
    else {
        CGFloat width = 23;
        NSString *al = [alphabets objectAtIndex:indexPath.row];
        if([al isEqualToString:@"0-9"])
            return CGSizeMake((width + 18), (width - 2));
        else
            return CGSizeMake((width + 6), (width - 2));
    }
}

#pragma mark - Methods
- (void) retrieveData {
    @try {
        if(!isDataLoaded && !isDataLoading){
            [self hideNoInternet];
            [self showLoading];
            isDataLoading = YES;
        }
        [[BestsongsAPI sharedInstance] fetchArtists:[NSNumber numberWithInteger:currentPage] onSuccess:^(id response) {
            NSDictionary *dataDictionary = (NSDictionary *) response;
            NSMutableArray *dataAlbums = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getArtistsArrayFromJSON:dataDictionary[@"artists"]]];
            dispatch_async(dispatch_get_main_queue(), ^ {
                currentPage++;
                if(!isDataLoaded){
                    [alphabets addObject:@"0-9"];
                    for (char a = 'A'; a <= 'Z'; a++)
                        [alphabets addObject:[NSString stringWithFormat:@"%c", a]];
                    [self.alphabetCollectionView reloadData];
                    
                    artists = [[NSMutableArray alloc] initWithArray:dataAlbums];
                    [self.CollectionView reloadData];
                    
                    isDataLoaded = YES;
                    isDataLoading = NO;
                    [self.alphabetCollectionView setHidden:NO];
                    [self.CollectionView setHidden:NO];
                    if(!isViewAppear)
                        [self hideLoading];
                } else if(hasMoreItems && dataAlbums.count > 0){
                    int64_t delayInSeconds = 0.5;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                        NSMutableArray *indexPaths = [NSMutableArray array];
                        NSInteger currentCount = artists.count;
                        for (int i = 0; i < dataAlbums.count ; i++)
                            [indexPaths addObject:[NSIndexPath indexPathForRow:currentCount+i inSection:0]];
                        
                        [artists addObjectsFromArray:dataAlbums];
                        [self.CollectionView insertItemsAtIndexPaths:indexPaths];
                        [self.CollectionView.infiniteScrollingView stopAnimating];
                    });
                }
                // Un comment this section after pagging implementation
                /*hasMoreItems = NO;
                if(dataAlbums.count >= REQUESTPERPAGE)
                    hasMoreItems = YES;*/
            });
        } onFailure:^(NSError *error) {
            if(!isDataLoaded){
                if(!isViewAppear)
                    [self hideLoading];
                isDataLoading = NO;
                [self showNoInternet];
                
                if ([error.localizedDescription containsString:@"Pakistan"] || [error.localizedDescription containsString:@"available"]) {
                    
                    [self contentNotAvailablePopUp];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"videoViewIsDisplayed" object:nil];
                    
                }
                
            } else if(hasMoreItems){
                [self.CollectionView.infiniteScrollingView stopAnimating];
            }
            [[BaseController sharedInstance] showToastError:error.localizedDescription];
        }];
    } @catch (NSException *exception) {
        if(!isViewAppear)
            [self hideLoading];
        [self showNoInternet];
        [[BaseController sharedInstance] showToastError:exception.reason];
    } @finally {
    }
}


- (void) contentNotAvailablePopUp{
    
    self.addToContentNotAvailablePopupViewController = [[ContentNotAvailableViewController alloc] init];
    
    [self presentViewController:_addToContentNotAvailablePopupViewController animated:YES completion:nil];
    
    
    
}

// Common Methods in All Controller
- (void) pullToRefreshData{
    @try {
        [[BestsongsAPI sharedInstance] fetchArtists:[NSNumber numberWithInteger:1] onSuccess:^(id response) {
            NSDictionary *dataDictionary = (NSDictionary *) response;
            NSMutableArray *dataAlbums = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getArtistsArrayFromJSON:dataDictionary[@"albums"]]];
            dispatch_async(dispatch_get_main_queue(), ^ {
                currentPage = 2;
                // Un comment this section after pagging implementation
                /*
                hasMoreItems = NO;
                if(dataAlbums.count >= REQUESTPERPAGE)
                    hasMoreItems = YES;
                artists = [[NSMutableArray alloc] initWithArray:dataAlbums];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.CollectionView reloadData];
                 
                 
                 });
             
               */
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

- (void)reachabilityChanged:(NSNotification *)notification  {
    if([[AFNetworkReachabilityManager sharedManager] isReachable]) {
        if(isFirstTimeCheckNetwork)
            isFirstTimeCheckNetwork = !isFirstTimeCheckNetwork;
        else{
            if(!isViewAppear)
//                [[BaseController sharedInstance] showToastSuccess:INTERNETSUCCESSMESSAGE];
                _connectionFailedMessage.hidden = true;
        }
        if(isViewAppear)
            isViewAppear = !isViewAppear;
        if(!isDataLoaded && !isDataLoading)
            [self retrieveData];
    } else {
        if(isFirstTimeCheckNetwork){
            isFirstTimeCheckNetwork = false;
            [self showNoInternet];
        }
        if(isViewAppear)
            isViewAppear = !isViewAppear;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[ NSNotificationCenter defaultCenter ] postNotificationName:@"hideHomeAdd" object:nil];
    
    [[ NSNotificationCenter defaultCenter ] postNotificationName:@"showHomeAdd" object:nil];
    
    
    
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
    isViewAppear = YES;
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
