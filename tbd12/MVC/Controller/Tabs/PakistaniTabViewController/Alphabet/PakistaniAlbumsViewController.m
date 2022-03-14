//
//  PakistaniAlbumsViewController.m
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 8/30/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PakistaniAlbumsViewController.h"

@interface PakistaniAlbumsViewController () {
    NSMutableArray * albums;
    NSUInteger currentPage;
    BOOL hasMoreItems;
    BOOL isDataLoaded;
    BOOL isViewAppear;
    UIView *noInternetView;
}
@end

@implementation PakistaniAlbumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.title = [NSString stringWithFormat:@"%@%@", @"Pakistani > ", _selectedAlphabet];
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButton:)];
    searchButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = searchButton;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.TableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0); // Makes the horizontal row seperator stretch the entire length of the table view
    }
    
    [self.TableView setTableFooterView:[[BaseController sharedInstance] getTableViewFooterView]];
    
    isDataLoaded = false;
    currentPage = 1;
    hasMoreItems = YES;
}

- (IBAction)searchButton:(id)sender {
    if(![AFNetworkReachabilityManager sharedManager].isReachable){
        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
        return;
    }
    SearchViewController *searchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"searchViewController"];
    [self.navigationController pushViewController:searchViewController animated:YES];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"PakistaniAlbumCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    Album * album = [albums objectAtIndex:indexPath.row];
    [cell.textLabel setText:album.Title];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:album.Poster]
                  placeholderImage:[UIImage imageNamed:DEFAULTALBUMART]];
    
    CGSize itemSize = CGSizeMake(40, 40);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    cell.backgroundColor = cell.contentView.backgroundColor;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(![AFNetworkReachabilityManager sharedManager].isReachable){
        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
        return;
    }
    if(tableView == self.TableView){
        SingleAlbumViewController * singleAlbumViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"singleAlbumViewController"];
        Album *album = [albums objectAtIndex:indexPath.row];
        Song *song = [[Song alloc] init];
        singleAlbumViewController.selectedSong = song;
        singleAlbumViewController.album = album;
        [self.navigationController pushViewController:singleAlbumViewController animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Methods
- (void) retrieveData {
    @try {
        if(!isDataLoaded){
            [self hideNoInternet];
            [self showLoading];
        }
        [[BestsongsAPI sharedInstance] fetchPakistaniAlbum:self.selectedAlphabet page:[NSNumber numberWithInteger:currentPage] onSuccess:^(id response) {
            NSDictionary *dataDictionary = (NSDictionary *) response;
            NSMutableArray *dataAlbums = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getAlbumsArrayFromJSON:dataDictionary[@"albums"]]];
            dispatch_async(dispatch_get_main_queue(), ^ {
                currentPage++;
                if(!isDataLoaded){
                    albums = [[NSMutableArray alloc] initWithArray:dataAlbums];
                    isDataLoaded = true;
                    [self.TableView reloadData];
                    [self hideLoading];
                    // Un comment this section after pagging implementation
                    /*__weak PakistaniAlbumsViewController *weakSelf = self;
                     [self.TableView addPullToRefreshWithActionHandler:^{
                     if(![AFNetworkReachabilityManager sharedManager].isReachable){
                     [weakSelf.TableView.pullToRefreshView stopAnimating];
                     [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
                     return;
                     }
                     [weakSelf pullToRefreshData];
                     } topMargin:65.0];
                     [self.TableView addInfiniteScrollingWithActionHandler:^{
                     if(![AFNetworkReachabilityManager sharedManager].isReachable){
                     [weakSelf.TableView.infiniteScrollingView stopAnimating];
                     [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
                     return;
                     }
                     if([weakSelf getHasMoreItems])
                     [weakSelf retrieveData];
                     else
                     [weakSelf.TableView.infiniteScrollingView stopAnimating];
                     }];*/
                } else if(hasMoreItems){
                    int64_t delayInSeconds = 0.5;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                        
                        NSMutableArray *indexPaths = [NSMutableArray array];
                        NSInteger currentCount = albums.count;
                        for (int i = 0; i < dataAlbums.count ; i++)
                            [indexPaths addObject:[NSIndexPath indexPathForRow:currentCount+i inSection:0]];
                        
                        [albums addObjectsFromArray:dataAlbums];
                        [self.TableView beginUpdates];
                        [self.TableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
                        [self.TableView endUpdates];
                        [self.TableView.infiniteScrollingView stopAnimating];
                    });
                }
                // Un comment this section after pagging implementation
                /*hasMoreItems = NO;
                 if(dataAlbums.count >= REQUESTPERPAGE)
                 hasMoreItems = YES;*/
            });
        } onFailure:^(NSError *error) {
            if(!isDataLoaded){
                [self hideLoading];
                [self showNoInternet];
            } else if(hasMoreItems){
                [self.TableView.infiniteScrollingView stopAnimating];
            }
            [[BaseController sharedInstance] showToastError:error.localizedDescription];
        }];
    } @catch (NSException *exception) {
        [self hideLoading];
        [self showNoInternet];
        [[BaseController sharedInstance] showToastError:exception.reason];
    } @finally {
    }
}

- (void) pullToRefreshData{
    @try {
        if(!isDataLoaded){
            [self hideNoInternet];
            [self showLoading];
        }
        [[BestsongsAPI sharedInstance] fetchPakistaniAlbum:self.selectedAlphabet page:[NSNumber numberWithInteger:1] onSuccess:^(id response) {
            NSDictionary *dataDictionary = (NSDictionary *) response;
            NSMutableArray *dataAlbums = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getAlbumsArrayFromJSON:dataDictionary[@"albums"]]];
            dispatch_async(dispatch_get_main_queue(), ^ {
                currentPage = 2;
                hasMoreItems = NO;
                if(dataAlbums.count >= REQUESTPERPAGE)
                    hasMoreItems = YES;
                NSMutableArray *dataAlbums = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getAlbumsArrayFromJSON:dataDictionary[@"albums"]]];
                dispatch_async(dispatch_get_main_queue(), ^ {
                    currentPage = 1;
                    currentPage += REQUESTPERPAGE;
                    albums = [[NSMutableArray alloc] initWithArray:dataAlbums];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    [self.TableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                    [self.TableView reloadData];
                    [self.TableView.pullToRefreshView stopAnimating];
                });
            });
        } onFailure:^(NSError *error) {
            [self.TableView.pullToRefreshView stopAnimating];
            [[BaseController sharedInstance] showToastError:error.localizedDescription];
        }];
    } @catch (NSException *exception) {
        [self.TableView.pullToRefreshView stopAnimating];
        [[BaseController sharedInstance] showToastError:exception.reason];
    } @finally {
    }
}

- (void)reachabilityChanged:(NSNotification *)notification  {
    if([[AFNetworkReachabilityManager sharedManager] isReachable]) {
        if(!isViewAppear)
            [[BaseController sharedInstance] showToastSuccess:INTERNETSUCCESSMESSAGE];
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
        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
    }
}

- (BOOL)getHasMoreItems {
    return hasMoreItems;
}

- (void)showNoInternet{
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

- (void)hideNoInternet{
    [noInternetView removeFromSuperview];
    noInternetView = nil;
}

- (void)showLoading {
    if(![SVProgressHUD isVisible]){
        [[BaseController sharedInstance] setupLoading];
        int screenSize =(int)[[UIScreen mainScreen] nativeBounds].size.height / 36;
        
        [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, (CGFloat)screenSize )];
        
        [SVProgressHUD show];
    }
}

- (void)hideLoading {
    if([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
}

-(BOOL)prefersStatusBarHidden {
    return NO;
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
    [self becomeFirstResponder];
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    isViewAppear = NO;
    [self hideLoading];
    [self resignFirstResponder];
    [super viewDidDisappear:animated];
}

@end
