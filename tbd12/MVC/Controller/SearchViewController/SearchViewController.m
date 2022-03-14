//
//  SearchViewController.m
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 7/27/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import "SearchViewController.h"

#define SEARCHURL @"https://bestsongs-156307.appspot.com/v1/search?q="

@interface SearchViewController () {
    NSArray * sections;
    NSMutableArray * albums;
    NSMutableArray * tracks;
    NSMutableArray * artists;
    
    
    __weak NSURLSessionTask *task;
    
    BOOL isDataLoaded;
    BOOL isViewAppear;
    BOOL isLoad;
    UIView *noInternetView;
    
    AFURLSessionManager *manager;
}
@end

@implementation SearchViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController.navigationBar setTintColor:[[BaseController sharedInstance] getDefaultColor]];
    self.navigationItem.title = @"Search";
    
    manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    isDataLoaded = NO;
    
    isLoad = NO;
    
    sections = [[NSArray alloc] init];
    sections = [NSArray arrayWithObjects:@"Albums" , @"Tracks" , @"Artists", nil];
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.searchBar.delegate = self;
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.definesPresentationContext = YES;
    self.searchTableView.tableHeaderView = self.searchController.searchBar;
    self.searchTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    tracks = [[NSMutableArray alloc] init];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.searchTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0); // Makes the horizontal row seperator stretch the entire length of the table view
    }
    self.tableView.backgroundView = [UIView new];
    
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
  
}





- (void) showKeyboard {
    [self.searchController.searchBar becomeFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [sections count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewHeaderFooterView class]]] setTextAlignment:NSTextAlignmentCenter];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewHeaderFooterView class]]] setTextColor:[UIColor whiteColor]];
    return [sections objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch(section){
        case 0:{
            return [albums count];
            break;
        }
        case 1:{
            return [tracks count];
            break;
        }
        case 2:{
            return [artists count];
            break;
        }
        default:{
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *searchCell = @"SearchCell";
    static NSString *searchCellSong = @"SearchCellSong";
    UITableViewCell *cell = nil;
    NSString *title = nil;
    NSString *subTitle = nil;
    NSString *poster = nil;

    switch([indexPath section]) {
        case 0: {
            // fabric error fixed
           Album * album ;
            
            if (indexPath.row < albums.count && indexPath.row > -1 ) {
                
                album = [albums objectAtIndex:indexPath.row];
            }
            
            if (album != nil) {
                
                title = album.Title;
                poster = album.Poster;
                
            }else {
                
                NSString *errorTitle = @"titleName '2382' ";
                title = errorTitle;
               }
            
            
            break;
        }
        case 1: {
            
             // fabric error fixed
            Song * track ;
            
            if (indexPath.row < tracks.count && indexPath.row > -1 ) {
                
                track = [tracks objectAtIndex:indexPath.row];
            }
           
            if (track != nil) {
                
                title = track.Title;
                
                if (track.AlbumTitle != nil){
                subTitle = track.AlbumTitle;
                }
                else
                {
                subTitle = @"_";
                }
                poster = track.Poster;
                
            }
            else {
                
                NSString *errorTitle = @"titleName '2382' ";
                NSString *errorAlbumTitle = @"albumName '2382' ";
                title = errorTitle;
                subTitle = errorAlbumTitle;
              
            }
            
            
        
            break;
        }
        case 2: {
            
             // fabric error fixed
            Artist *artist ;
            
            if (indexPath.row < artists.count && indexPath.row > -1 ) {
                
                 artist = [artists objectAtIndex:indexPath.row];
            }
            
            if (artist != nil){
            
            title = artist.Name;
            poster = artist.Poster;
                
            }else{
                NSString *errorTitle = @"titleName '2382' ";
                title = errorTitle;
                
            }
                
            break;
        }
            
    }
    
    if(indexPath.section == 1){
//        cell = [tableView dequeueReusableCellWithIdentifier:searchCellSong];
        //if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:searchCellSong];
        [cell.detailTextLabel setText:subTitle];
        [cell.detailTextLabel setTextColor:[UIColor whiteColor]];
    } else {
//        cell = [tableView dequeueReusableCellWithIdentifier:searchCell];
        //if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchCell];
    }
    
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundColor:[UIColor colorWithRed:12.0/255.0 green:13.0/255.0 blue:14.0/255.0 alpha:1]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.textLabel setText:title];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
     // fabric error fixed
    if (poster != nil ){
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:poster]
                                           placeholderImage:[UIImage imageNamed:DEFAULTALBUMART]];
    }else{
       
        cell.imageView.image = [UIImage imageNamed:DEFAULTALBUMART];
        
    }
    
   
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0 || section == 1)
        return 0;
    else
        return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
    //return [self.baseController getTableViewFooterView];
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Song *song = nil;
    Album *album = nil;
    switch(indexPath.section){
        case 0:{
            song = [[Song alloc] init];
            album = [albums objectAtIndex:indexPath.row];
            SingleAlbumViewController *savc = [self.storyboard instantiateViewControllerWithIdentifier:@"singleAlbumViewController"];
            savc.selectedSong = song;
            
          
            savc.album = album;
            [self.navigationController pushViewController:savc animated:YES];
            break;
        }
        case 1:{
            song = [tracks objectAtIndex:indexPath.row];
            album = [[Album alloc] initWithID:song.AlbumID title:song.AlbumTitle poster:song.Poster permalink:song.Permalink];
            SingleAlbumViewController *savc = [self.storyboard instantiateViewControllerWithIdentifier:@"singleAlbumViewController"];
            savc.selectedSong = song;
            savc.album = album;
            [self.navigationController pushViewController:savc animated:YES];
            break;
        }
        case 2:{
            Artist *artist = [artists objectAtIndex:indexPath.row];
            ArtistSongsViewController * asvc = [self.storyboard instantiateViewControllerWithIdentifier:@"artistSongsViewController"];
            asvc.artist = artist;
            [self.navigationController pushViewController:asvc animated:YES];
            break;
        }
    }
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    [task cancel];
    
//    @try {
//        [albums removeAllObjects];
//        [tracks removeAllObjects];
//        [artists removeAllObjects];
//        [self.tableView reloadData];
//        
        NSString *searchString = self.searchController.searchBar.text;
//        NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ."] invertedSet];
//        searchString = [[searchString componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
//        
        if([searchString isEqualToString:@""]){
//            [albums removeAllObjects];
//            [tracks removeAllObjects];
//            [artists removeAllObjects];
//            [self.tableView reloadData];
//            [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
            [self hideLoading];
            return;
        }
        @try {
            [self showLoading];
            if(manager.operationQueue.operationCount > 0)
                [manager.operationQueue cancelAllOperations];
            
            NSString *encodedString = [searchString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//            NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[NSString stringWithFormat:@"%@%@",SEARCHURL,encodedString] parameters:nil error:nil];
//            req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
//            [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SEARCHURL,encodedString]];
            NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [req setHTTPMethod:@"GET"];
            
            
            
            
            
            
            
            
            
            
            
            
            task = [[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    if (error.code == NSURLErrorCancelled) {
                        return;
                    }
                    [self hideLoading];
                    return;
                }
//                if (!error) {
//                    NSLog(@"connection error = %@", error);
//                    return;
//                    [albums removeAllObjects];
//                    [tracks removeAllObjects];
//                    [artists removeAllObjects];
                    
                    
                    NSError *parseError;
                    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
                    
                    [albums removeAllObjects];
                    albums = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getAlbumsArrayFromJSON:responseObject[@"albums"]]];
                    
                    [tracks removeAllObjects];
                    NSDictionary *tracksData = [responseObject objectForKey:@"tracks"];
                    //            tracks = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getsongs]]
                    tracks = [[NSMutableArray alloc] initWithArray:[[BaseController sharedInstance] getSongsArrayFromJSON:tracksData]];
                    //            tracks = [[NSMutableArray alloc] initWithArray:[self.baseController getSongsArrayFromJSON:tracksData]];
                    
                    [artists removeAllObjects];
                    artists = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getArtistsArrayFromJSON:responseObject[@"artists"]]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        
                        [self.tableView reloadData];
                        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
                        [self hideLoading];
                    });

                    
//                } else {
//                    [self hideLoading];
//                }
//                NSError *parseError;
//                NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
//                if (!responseObject) {
//                    NSLog(@"parse error = %@", parseError);
//                }
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    // use response here; e.g., updating UI or model objects
//                });
            }];
            [task resume];
            
            
            
            
            
            
            
//            [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//                if (!error) {
//                    [albums removeAllObjects];
//                    [tracks removeAllObjects];
//                    [artists removeAllObjects];
//                    
//                    
//                    NSDictionary *dataDictionary = (NSDictionary *) responseObject;
//                    
//                    [albums removeAllObjects];
//                    albums = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getAlbumsArrayFromJSON:dataDictionary[@"albums"]]];
//                    
//                    [tracks removeAllObjects];
//                    NSDictionary *tracksData = [dataDictionary objectForKey:@"tracks"];
//                    //            tracks = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getsongs]]
//                    tracks = [[NSMutableArray alloc] initWithArray:[[BaseController sharedInstance] getSongsArrayFromJSON:tracksData]];
//                    //            tracks = [[NSMutableArray alloc] initWithArray:[self.baseController getSongsArrayFromJSON:tracksData]];
//                    
//                    [artists removeAllObjects];
//                    artists = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getArtistsArrayFromJSON:dataDictionary[@"artists"]]];
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        
//                        
//                        
//                        [self.tableView reloadData];
//                        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
//                        [self hideLoading];
//                    });
//                } else {
//                    [self hideLoading];
////                    [[BaseController sharedInstance] showToastError:@"No Data Found"];
//                }
//            }] resume];
        }
        @catch (NSException *exception) {
            [self hideLoading];
            [[BaseController sharedInstance] showToastError:@"No Data Found"];
        }
//    }
//    @catch (NSException *exception) {
//        [self hideLoading];
//        
//        [[BaseController sharedInstance] showToastError:@"No Data Found"];
//        
//    }
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    [self updateSearchResultsForSearchController:self.searchController];
}

- (void)reachabilityChanged:(NSNotification *)notification  {
    if([[AFNetworkReachabilityManager sharedManager] isReachable]) {
        if(!isViewAppear)
            [[BaseController sharedInstance] showToastSuccess:INTERNETSUCCESSMESSAGE];
        if(isViewAppear)
            isViewAppear = !isViewAppear;
        if(!isDataLoaded){
            isDataLoaded = YES;
            [self hideNoInternet];
        }
    } else {
        if(isViewAppear){
            isViewAppear = !isViewAppear;
            if(!isDataLoaded)
                [self showNoInternet];
        }
        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
    }
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
        int screenSize =(int)[[UIScreen mainScreen] nativeBounds].size.height / 36 ;
        
        [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, (CGFloat)screenSize )];        [SVProgressHUD show];
    }
}

- (void)hideLoading {
    if([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
}

-(BOOL)prefersStatusBarHidden{
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
    if(!isLoad){
        isLoad = YES;
        [self becomeFirstResponder];
        [self performSelector:@selector(showKeyboard) withObject:nil afterDelay:0.1];
    }
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    isViewAppear = NO;
    [self resignFirstResponder];
    [super viewDidDisappear:animated];
}

-(void)dealloc {
    [_searchController.view removeFromSuperview];
}


@end
