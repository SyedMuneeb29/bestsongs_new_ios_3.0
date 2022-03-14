//
//  PlaylistViewController.m
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 10/4/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "AddToPlaylistViewController.h"
#import "PlayerViewController.h"
#import "LoginViewController.h"
#import "UIView+Animations.h"

@interface AddToPlaylistViewController () <CNPPopupControllerDelegate>{
    NSMutableArray *tableviewItems;
    
    NSString *urlString;
    NSMutableURLRequest *urlRequest;
}

@property (nonatomic, strong) AddToPlaylistPopupViewController *addToPlayListPopupViewController;

@end

@implementation AddToPlaylistViewController

+ (instancetype)instantiateFromNib {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"%@", [self class]] owner:nil options:nil];
    return [views firstObject];
}

- (void)loadView {
    CGFloat spacing = 3.0;
    // Back Button
    CGSize imageSize = self.likeButton.imageView.image.size;
    if(self.song.IsLiked)
        [self.likeButton setImage:[UIImage imageNamed:@"unLike"] forState:UIControlStateNormal];
    else
        [self.likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    
    [self.likeButton setTitle:[NSString stringWithFormat:@"%@",self.song.Likes] forState:UIControlStateNormal];
    self.likeButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    CGSize titleSize = [self.likeButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.likeButton.titleLabel.font}];
    self.likeButton.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
    CGFloat edgeOffset = fabs(titleSize.height - imageSize.height) / 2.0;
    self.likeButton.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset, 0.0, edgeOffset, 0.0);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0); // Makes the horizontal row seperator stretch the entire length of the table view
    }
    
    tableviewItems = [[NSMutableArray alloc] initWithCapacity:6];
    [tableviewItems addObject:@"Add to Playlist"];
    [tableviewItems addObject:@"Save Song"];
    [tableviewItems addObject:@"Watch Video"];
    [tableviewItems addObject:@"Share Song"];
    [tableviewItems addObject:@"Show All Offline Songs"];
    [tableviewItems addObject:@"Delete Track from Playlist"];
    [self.tableView reloadData];
}

- (void)unLikeTrack{
    [self.likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    int totalLikes = [self.song.Likes intValue];
    totalLikes--;
    if(totalLikes < 0)
        totalLikes = 0;
    
    Song *track = [[Song alloc] initWithID:_song.ID albumId:_song.AlbumID likes:[NSNumber numberWithInt:totalLikes] title:_song.Title albumTitle:_song.AlbumTitle poster:_song.Poster permalink:_song.Permalink audioURL:_song.AudioURL videoURL:_song.VideoURL videoPermalink:_song.VideoPermalink isDowload:_song.IsDownload isVideo:_song.IsVideo isLikes:NO];
    
    self.song = track;
    
    [self.likeButton setTitle:[NSString stringWithFormat:@"%d",totalLikes] forState:UIControlStateNormal];
    if (_delegate && [_delegate respondsToSelector:@selector(unLikeTrack:)]) {
        [_delegate unLikeTrack:self.song.ID];
    }
}

- (void)likeTrack{
    [self.likeButton setImage:[UIImage imageNamed:@"unLike"] forState:UIControlStateNormal];
    int totalLikes = [self.song.Likes intValue];
    totalLikes++;
    Song *track = [[Song alloc] initWithID:_song.ID albumId:_song.AlbumID likes:[NSNumber numberWithInt:totalLikes] title:_song.Title albumTitle:_song.AlbumTitle poster:_song.Poster permalink:_song.Permalink audioURL:_song.AudioURL videoURL:_song.VideoURL videoPermalink:_song.VideoPermalink isDowload:_song.IsDownload isVideo:_song.IsVideo isLikes:YES];
    
    self.song = track;
    [self.likeButton setTitle:[NSString stringWithFormat:@"%d",totalLikes] forState:UIControlStateNormal];
    if(_delegate && [_delegate respondsToSelector:@selector(likeTrack:)]){
        [_delegate likeTrack:self.song.ID];
    }
}

- (IBAction)likeButton:(id)sender {
    @try {
        if(![AFNetworkReachabilityManager sharedManager].isReachable){
            [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
            return;
        }
        if([[BaseController sharedInstance] checkIsUserLogin]){
            if(self.song.IsLiked){
                // Track Already Like
                [self.likeButton startDuangAnimation];
                [self unLikeTrack];
                [[BestsongsAPI sharedInstance] unLikeTrack:[NSString stringWithFormat:@"%@",self.song.ID] onSuccess:^(id response) {
                } onFailure:^(NSError *error) {
                    [self.likeButton startDuangAnimation];
                    [self likeTrack];
                    [[BaseController sharedInstance] showToastError:error.localizedDescription];
                }];
            } else {
                [self.likeButton startDuangAnimation];
                [self likeTrack];
                // Send Request to like track
                [[BestsongsAPI sharedInstance] likeTrack:[NSString stringWithFormat:@"%@",self.song.ID] onSuccess:^(id response) {
                } onFailure:^(NSError *error) {
                    [self unLikeTrack];
                    [[BaseController sharedInstance] showToastError:error.localizedDescription];
                }];
            }
        } else {
            [self.popupController dismissPopupControllerAnimated:YES];
            // Open Login Screen;
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
            LoginViewController *loginViewController = [storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            
            loginViewController.modalInPopover = YES;
            loginViewController.hidesBottomBarWhenPushed = YES;
            loginViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            
            UINavigationController *navController = [[UINavigationController alloc] init];
            [navController setNavigationBarHidden:YES animated:NO];
            [navController pushViewController:loginViewController animated:NO];
            [self.window.rootViewController presentViewController:navController animated:NO completion:nil];
        }
    } @catch (NSException *exception) {
        [self hideLoading];
        [[BaseController sharedInstance] showToastError:exception.description];
    } @finally {
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableviewItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    [cell.textLabel setText:[tableviewItems objectAtIndex:indexPath.row]];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    [cell.textLabel setTextColor:[UIColor grayColor]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        switch (indexPath.row) {
            case 0:
                [self addToPlaylist];
                break;
                
            case 1:
                [self downloadMP3];
                break;
                
            case 2:
                [self watchVideo];
                break;
                
            case 3:
                [self shareTrack];
                break;
                
            case 4:
                [self showAllDownloads:(UIViewController*)self.delegate];
                break;
                
            case 5:
                [self deleteTrackFromPlaylist];
                break;
                
            default:
                break;
        }
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    } @catch (NSException *exception) {
        [[BaseController sharedInstance] showToastError:exception.description];
    } @finally {
    }
}

- (void)addToPlaylist{
    if(![AFNetworkReachabilityManager sharedManager].isReachable){
        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
        return;
    }
    [self.popupController dismissPopupControllerAnimated:YES];
    
    if([[BaseController sharedInstance] checkIsUserLogin]){
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        self.addToPlayListPopupViewController = [AddToPlaylistPopupViewController instantiateFromNib];
        self.addToPlayListPopupViewController.album = self.album;
        self.addToPlayListPopupViewController.song = self.song;
        [self.addToPlayListPopupViewController loadData];
        [self.addToPlayListPopupViewController setFrame:CGRectMake(0, 0, (screenRect.size.width - 50), (screenRect.size.height - 100))];
        // Popup
        CNPPopupController *newPopupController = [[CNPPopupController alloc] initWithContents:@[self.addToPlayListPopupViewController]];
        newPopupController.theme = [[BaseController sharedInstance] cnPopupDefaultTheme];
        newPopupController.theme.presentationStyle = CNPPopupPresentationStyleFadeIn;
        newPopupController.theme.movesAboveKeyboard = NO;
        newPopupController.delegate = self;
        
        self.addToPlayListPopupViewController.popupController = newPopupController;
        [newPopupController presentPopupControllerAnimated:YES];
    } else {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
        LoginViewController *loginViewController = [storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
        loginViewController.modalInPopover = YES;
        loginViewController.hidesBottomBarWhenPushed = YES;
        loginViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
        UINavigationController *navController = [[UINavigationController alloc] init];
        [navController setNavigationBarHidden:YES animated:NO];
        [navController pushViewController:loginViewController animated:NO];
        [self.window.rootViewController presentViewController:navController animated:NO completion:nil];
    }
}

- (void)downloadMP3{
    if(![AFNetworkReachabilityManager sharedManager].isReachable){
        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
        return;
    }
    if(self.song.ID != 0){
        if(self.song.IsDownload){
            [self.popupController dismissPopupControllerAnimated:YES];
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
            [[BaseController sharedInstance] downloadMP3:storyBoard song:self.song rootViewController:self.window.rootViewController];
        }
    }
}

- (void)watchVideo{
    if(![AFNetworkReachabilityManager sharedManager].isReachable){
        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
        return;
    }
    if(self.song.ID != 0){
        if(self.song.IsVideo){
            [self.popupController dismissPopupControllerAnimated:YES];
            
            Video *video = [[Video alloc]
                            initWithID:self.song.ID//self.song.AlbumID
                            title:self.song.Title
                            videoURL:self.song.VideoURL
                            albumName:self.song.AlbumTitle
                            poster:self.song.Poster
                            permalink:self.song.VideoPermalink];
            
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
            
//            [[BaseController sharedInstance]
//             openVideoPlayer:storyBoard
//             andVideo:video
//             andRootViewController:self.window.rootViewController];
//
            [[BaseController sharedInstance]
             openVideoPlayerWithType:storyBoard
             andVideo:video
             andRootViewController:self.window.rootViewController
             andType:@"track"];
            
            
            
        }
        else{
            [self.viewForLastBaselineLayout makeToast:@"No Video"];
            [CSToastManager setTapToDismissEnabled:YES];
            [CSToastManager setQueueEnabled:NO];
        }
    }
}

- (void) shareTrack{

    if(![AFNetworkReachabilityManager sharedManager].isReachable){
        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
        return;
    }
   
    
    if(![_album.Permalink isEqualToString:@""]){
        if(!(_album.Permalink == nil)){
            if(_playlist == nil){
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                                        [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
                                        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
                                        [SVProgressHUD showWithStatus:@"Generating Share Link"];
                                        [CSToastManager setTapToDismissEnabled:YES];
                                        int screenSize =(int)[[UIScreen mainScreen] nativeBounds].size.height / 36 ;
                    
                                        [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, (CGFloat)screenSize )];
                                        [CSToastManager setQueueEnabled:NO];
                    
                    
                    // zohaib share url fetch made by muneeb
                    
                    NSString *urlString =  [NSString stringWithFormat:@"https://api-v2-dot-bestsongs-156307.appspot.com/api/v1/track/%@/share_url",self.song.ID];
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
                                                              NSString *sharingLink = dataDictionary[@"share_url"];
                                                              NSString * message = [NSString stringWithFormat:@"Play and enjoy %@",_album.Title];
                                                              NSArray * shareItems = @[message, sharingLink];
                                                              UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
                                                              activityViewControntroller.excludedActivityTypes = @[];
                                                              if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                                                                  activityViewControntroller.popoverPresentationController.sourceView = self.window.viewForLastBaselineLayout;
                                                                  activityViewControntroller.popoverPresentationController.sourceRect = CGRectMake(self.window.bounds.size.width/2, self.window.bounds.size.height/4, 0, 0);
                                                              }
                                                              [self.popupController dismissPopupControllerAnimated:YES];
                                                             
                                                                   [self.window.rootViewController presentViewController:activityViewControntroller animated:true completion:nil];
                                                             
                                                              });
                                                              
                                                           
                                                          }
                                                          else
                                                          {
                                                              [SVProgressHUD dismiss];
                                                              [[BaseController sharedInstance] showToastError:error.localizedDescription];
                                                              
                                                          }
                                                      }];
                    [dataTask resume];
                    
                    // zohaib share url fetch made by muneeb
                    
//                    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
//                    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
//                    [SVProgressHUD showWithStatus:@"Generating Share Link"];
//                    [CSToastManager setTapToDismissEnabled:YES];
//                    int screenSize =(int)[[UIScreen mainScreen] nativeBounds].size.height / 36 ;
//
//                    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, (CGFloat)screenSize )];
//                    [CSToastManager setQueueEnabled:NO];
//                    [[BestsongsAPI sharedInstance] createShareLink:_song.Title
//                                                           message:_album.Title
//                                                         posterURL:_song.Poster
//                                                              link:[NSString stringWithFormat:@"%@?track=%@",_album.Permalink,_song.Permalink]
//
//                                                         onSuccess:^(id response) {
//                                                             [SVProgressHUD dismiss];
//                                                             NSDictionary *dataDictionary = (NSDictionary *) response;
//                                                             NSString *sharingLink = dataDictionary[@"shortLink"];
//                                                             NSString * message = [NSString stringWithFormat:@"Play and enjoy %@",_album.Title];
//                                                             NSArray * shareItems = @[message, sharingLink];
//                                                             UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
//                                                             activityViewControntroller.excludedActivityTypes = @[];
//                                                             if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//                                                                 activityViewControntroller.popoverPresentationController.sourceView = self.window.viewForLastBaselineLayout;
//                                                                 activityViewControntroller.popoverPresentationController.sourceRect = CGRectMake(self.window.bounds.size.width/2, self.window.bounds.size.height/4, 0, 0);
//                                                             }
//                                                             [self.popupController dismissPopupControllerAnimated:YES];
//                                                             [self.window.rootViewController presentViewController:activityViewControntroller animated:true completion:nil];
//                                                         } onFailure:^(NSError *error) {
//                                                             [SVProgressHUD dismiss];
//                                                             [[BaseController sharedInstance] showToastError:error.localizedDescription];
//                                                         }];
                });
            }
        }
    }
    else if( _playlist != nil ){

        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
            [SVProgressHUD showWithStatus:@"Generating Share Link"];
            [CSToastManager setTapToDismissEnabled:YES];
            int screenSize =(int)[[UIScreen mainScreen] nativeBounds].size.height / 36 ;
            
            [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, (CGFloat)screenSize )];
            [CSToastManager setQueueEnabled:NO];
            
            
            // zohaib share url fetch made by muneeb
            
             NSString *urlString =  [NSString stringWithFormat:@"https://api-v2-dot-bestsongs-156307.appspot.com/api/v1/track/%@/share_url",self.song.ID];
            NSURL *urlToFetchShareURL = [NSURL URLWithString:urlString];
            
            if (urlString != nil && ![urlString isEqualToString:@""] )
            {
                
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
                                                              NSString *sharingLink = dataDictionary[@"share_url"];
                                                              NSString * message = [NSString stringWithFormat:@"Play and enjoy %@",_album.Title];
                                                              NSArray * shareItems = @[message, sharingLink];
                                                              UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
                                                              activityViewControntroller.excludedActivityTypes = @[];
                                                              if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                                                                  activityViewControntroller.popoverPresentationController.sourceView = self.window.viewForLastBaselineLayout;
                                                                  activityViewControntroller.popoverPresentationController.sourceRect = CGRectMake(self.window.bounds.size.width/2, self.window.bounds.size.height/4, 0, 0);
                                                              }
                                                              [self.popupController dismissPopupControllerAnimated:YES];
                                                              
                                                              [self.window.rootViewController presentViewController:activityViewControntroller animated:true completion:nil];
                                                              
                                                          });
                                                          
                                                          
                                                      }
                                                      else
                                                      {
                                                          [SVProgressHUD dismiss];
                                                          [[BaseController sharedInstance] showToastError:error.localizedDescription];
                                                          
                                                      }
                                                  }];
                [dataTask resume];
            }
            
        });
        
    }
    else if (self.song.ID != nil ) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
            [SVProgressHUD showWithStatus:@"Generating Share Link"];
            [CSToastManager setTapToDismissEnabled:YES];
            int screenSize =(int)[[UIScreen mainScreen] nativeBounds].size.height / 36 ;
            
            [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, (CGFloat)screenSize )];
            [CSToastManager setQueueEnabled:NO];
            
            
            // zohaib share url fetch made by muneeb
            
//            NSString *urlString =  [NSString stringWithFormat:@"https://api2-dot-bestsongs-156307.appspot.com/v1/tracks/%@/share_url",self.song.ID];
            NSString *urlString =  [NSString stringWithFormat:@"https://api-v2-dot-bestsongs-156307.appspot.com/api/v1/track/%@/share_url",self.song.ID];
            NSURL *urlToFetchShareURL = [NSURL URLWithString:urlString];
            
            if (urlString != nil && ![urlString isEqualToString:@""] )
            {
                
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
                                                              NSString *sharingLink = dataDictionary[@"share_url"];
                                                              NSString * message = [NSString stringWithFormat:@"Play and enjoy %@",_album.Title];
                                                              NSArray * shareItems = @[message, sharingLink];
                                                              UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
                                                              activityViewControntroller.excludedActivityTypes = @[];
                                                              if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                                                                  activityViewControntroller.popoverPresentationController.sourceView = self.window.viewForLastBaselineLayout;
                                                                  activityViewControntroller.popoverPresentationController.sourceRect = CGRectMake(self.window.bounds.size.width/2, self.window.bounds.size.height/4, 0, 0);
                                                              }
                                                              [self.popupController dismissPopupControllerAnimated:YES];
                                                              
                                                              [self.window.rootViewController presentViewController:activityViewControntroller animated:true completion:nil];
                                                              
                                                          });
                                                          
                                                          
                                                      }
                                                      else
                                                      {
                                                          [SVProgressHUD dismiss];
                                                          [[BaseController sharedInstance] showToastError:error.localizedDescription];
                                                          
                                                      }
                                                  }];
                [dataTask resume];
            }
            
        });
        
    }
    else {
        [self.viewForLastBaselineLayout makeToast:@"Share Link not found"];
        [CSToastManager setTapToDismissEnabled:YES];
        [CSToastManager setQueueEnabled:NO];
    }
}

- (void)showAllDownloads: (UIViewController*)controller{
    
    [self.popupController dismissPopupControllerAnimated:YES];
    [[PlayerViewController sharedInstance].popupPresentationContainerViewController closePopupAnimated:YES completion:nil];
    
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    ShowDownloadsViewController *showDownloadsController = [storyBoard instantiateViewControllerWithIdentifier:@"ShowDownloadsViewController"];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ShowDownloadsViewController *showDownloadsController = (ShowDownloadsViewController*) [storyBoard instantiateViewControllerWithIdentifier:@"ShowDownloadsViewController"];
    
    
//    if ([controller isKindOfClass:[PlayerViewController class]]) {
//        UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
//        UINavigationController *navController = (UINavigationController *)tabBarController.selectedViewController;
//        [navController pushViewController:showDownloadsController animated:NO];
        
        
        
        
//        TabbarViewController *ctr = (TabbarViewController*) [UIApplication sharedApplication].keyWindow.rootViewController;
//    UINavigationController *moreNavCtr = ctr.moreNavigationController;
//    UINavigationController *topVC = [moreNavCtr topViewController];
//
//
//
//        UINavigationController *navController = ctr.selectedViewController;
//
//    [navController pushViewController:showDownloadsController animated:NO];
    
    
    
    
    
    
    TabbarViewController *tabBar = (TabbarViewController*) self.window.rootViewController;
    UINavigationController* navigationController = tabBar.selectedViewController;
    UIViewController* top = nil;
    if ([navigationController respondsToSelector:@selector(topViewController)]) {
        top = navigationController.topViewController;
    }
    UINavigationController *curNavController;
    if (top == nil) {
        curNavController = tabBar.moreNavigationController;
    } else {
        curNavController = navigationController;
    }
    [curNavController pushViewController:showDownloadsController animated:NO];
        
        
        
        
        
        
        
//
//    } else {
//        [controller.navigationController pushViewController:showDownloadsController animated:NO];
//    }
    
    
    
    

    
    

    

    
    
    
    

//    TabbarViewController *ctr = (TabbarViewController*) [UIApplication sharedApplication].keyWindow.rootViewController;
//    UINavigationController *navController = ctr.selectedViewController;
//    [controller.navigationController pushViewController:showDownloadsController animated:NO];

    
    
    
    
    
}

- (void)deleteTrackFromPlaylist{
    if(![AFNetworkReachabilityManager sharedManager].isReachable){
        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
        return;
    }
    if(self.playlist != nil || [self.playlist.ID intValue] > 0){
        if([self.song.ID intValue] > 0){
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"Delete Track"
                                         message:@"Are you sure to delete this track ?"
                                         preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"Yes"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            [[BaseController sharedInstance] setupLoading];
                                            PlaylistDatabase *playlistDB = [[PlaylistDatabase alloc] init];
                                            [playlistDB loadDatabase];
                                            [SVProgressHUD show];
                                            
                                            if([[PlayerViewController sharedInstance] selectedSong] != nil && ![[PlayerViewController sharedInstance] isRunFromDownload] && [[PlayerViewController sharedInstance] playlist] != nil && [[PlayerViewController sharedInstance] playlist].ID == self.playlist.ID){
                                                
                                                if([[PlayerViewController sharedInstance] selectedSong].ID == _song.ID && ![[PlayerViewController sharedInstance] isRunFromDownload]){
                                                    [SVProgressHUD dismiss];
                                                    [[BaseController sharedInstance] showToastError:@"Could not delete playing track."];
                                                    return;
                                                }
                                            }
                                            [playlistDB deleteTrack:_playlist track:_song onSuccess:^(id response) {
                                                [SVProgressHUD dismiss];
                                                [[BaseController sharedInstance] showToastSuccess:@"Track Successfully Deleted."];
                                                [self.popupController dismissPopupControllerAnimated:YES];
                                                if(_delegate && [_delegate respondsToSelector:@selector(deleteTrackFromPlaylist:)]){
                                                    [_delegate deleteTrackFromPlaylist:_song.ID];
                                                }
                                                
                                            } onFailure:^(NSError *error) {
                                                [SVProgressHUD dismiss];
                                                [[BaseController sharedInstance] showToastError:error.localizedDescription];
                                            }];
                                        }];
            
            UIAlertAction* noButton = [UIAlertAction
                                       actionWithTitle:@"No"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
                                       }];
            
            [alert addAction:yesButton];
            [alert addAction:noButton];
            [self.popupController dismissPopupControllerAnimated:YES];
            [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        } else {
            
        }
    }
}

- (void)showLoading{
    [[BaseController sharedInstance] setupLoading];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
}

- (void)hideLoading{
    [SVProgressHUD dismiss];
}

@end
