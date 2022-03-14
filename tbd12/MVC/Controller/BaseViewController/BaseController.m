//
//  BaseController.m
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 10/27/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import "BaseController.h"
#import "PlayerViewController.h"
#import "VideoViewController.h"

@import LNPopupController;


@implementation BaseController

+ (BaseController *)sharedInstance {
    static BaseController *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[BaseController alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init{
    if(self = [super init]){
//        [self setupLoading];
    }
    return self;
}

- (BOOL) checkIsUserLogin{
    FIRUser *user = [FIRAuth auth].currentUser;
    return user != nil ? YES : NO;
}

- (BOOL) checkIsUserDownloadAnySong{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *filePathsArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory  error:nil];
    for (NSString *filename in filePathsArray) {
        NSString *strFileName = [filename.lastPathComponent lowercaseString];
        if([strFileName.pathExtension isEqualToString:@"mp3"]) {
            NSString *soundPath = [documentsDirectory stringByAppendingPathComponent:filename];
            if ([[NSFileManager defaultManager] fileExistsAtPath:soundPath])
                return YES;
        }
    }
    return NO;
}

- (User *)getLoginUserDetail{
    User *userDetails;
    if([self checkIsUserLogin]){
        FIRUser *user = [FIRAuth auth].currentUser;
        userDetails = [[User alloc]initWithID:user.uid andName:user.displayName andEmail:user.email andGender:@"" andPhotoURL:user.photoURL];
    } else {
        userDetails = [[User alloc]initWithID:@"" andName:@"" andEmail:@"" andGender: @"" andPhotoURL:[NSURL URLWithString:@""]];
    }
    return userDetails;
}

- (void)registerNewUser:(User *)user{
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    long long milliseconds = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    NSDictionary *dictionary = @{
                                 @"created_at":[NSString stringWithFormat:@"%lld",milliseconds],
                                 @"email":user.Email,
                                 @"gender":user.Gender,
                                 @"links":@{
                                         @"playlists":[NSString stringWithFormat:@"userplaylists/%@",user.UserID]
                                         },
                                 @"name":user.Name,
                                 @"profile_image":[NSString stringWithFormat:@"%@",user.PhotoURL]
                                 };
    [[[ref child:@"users"] child:user.UserID] setValue:dictionary];
}

- (void)registerNewUser:(User *)user andFirebaseUser:(FIRUser *)firebaseUser callback:(void (^)(NSError *, BOOL))callback{
    [self registerNewUser:user];
    [self getUserPlaylists:^(NSError *error, BOOL success) {
        callback(error,success);
    }];
}

- (void)getUserPlaylists:(void (^)(NSError *error, BOOL success))callback{
    PlaylistDatabase *playlistDatabase = [[PlaylistDatabase alloc] init];
    [playlistDatabase loadDatabase];
    [playlistDatabase getAllPlaylistAfterLogin:^(id response) {
        callback(nil,YES);
    } onFailure:^(NSError *error) {
        callback(error,NO);
    }];
}

- (UIView *)getNavigationbar:(NSString *)title{
    UIImage *image = [UIImage imageNamed: @"bestsong_logo.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    imageView.backgroundColor = [UIColor orangeColor];
    imageView.frame = CGRectMake(60, 0, 30, 30);
    
    // label
    UILabel *tmpTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 3, 150, 25)];
    tmpTitleLabel.text = title;
    tmpTitleLabel.backgroundColor = [UIColor clearColor];
    tmpTitleLabel.backgroundColor = [UIColor yellowColor];
    tmpTitleLabel.font = [UIFont fontWithName:@"ProximaNova-semibold" size:17];
    tmpTitleLabel.textColor = [UIColor whiteColor];
    
    CGRect applicationFrame = CGRectMake(0, 0, 300, 30);
    UIView * newView = [[UIView alloc] initWithFrame:applicationFrame];
    [newView setBackgroundColor:[UIColor redColor]];
    [newView addSubview:imageView];
    [newView addSubview:tmpTitleLabel];
    return newView;
}

- (UIView *)getNavigationbar:(UINavigationController *)navController andTitle:(NSString *)title andTotalButtons:(int)totalButtons{
    int btnWidth = 50;
    int finalBtnWidth = (btnWidth * totalButtons);
    CGFloat navWidth = navController.navigationBar.bounds.size.width;
    navWidth = (navWidth - finalBtnWidth);
    CGFloat labelWidth = (navWidth - 35);
    
    UIImage *image = [UIImage imageNamed: @"bestsong_logo.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    imageView.frame = CGRectMake(0, 0, 30, 30);
    
    // label
    UILabel *tmpTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, labelWidth, 25)];
    tmpTitleLabel.text = title;
    tmpTitleLabel.backgroundColor = [UIColor clearColor];
    tmpTitleLabel.font = [UIFont fontWithName:@"Comfortaa-Bold" size:17];
    tmpTitleLabel.textColor = [UIColor whiteColor];
    CGFloat newLabelWidth = [self getLabelWidth:tmpTitleLabel];
    if(newLabelWidth > labelWidth){
    } else
        labelWidth = newLabelWidth;
    
    CGFloat totalWidth = imageView.frame.size.width + 10 + labelWidth;
    CGFloat leftMargin = (navWidth - totalWidth)/2;
    
    imageView.frame = CGRectMake(leftMargin, 0, imageView.frame.size.width, imageView.frame.size.height);
    tmpTitleLabel.frame = CGRectMake((imageView.frame.origin.x + imageView.frame.size.width + 5), 3, labelWidth, 25);
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, navWidth, 30)];
    [view addSubview:imageView];
    [view addSubview:tmpTitleLabel];
    return view;
    
}

- (CGFloat)getLabelWidth:(UILabel*)label {
    label.numberOfLines = 1;
    CGSize constraint = CGSizeMake(label.bounds.size.width, 25);
    CGSize size;
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    return size.width;
}

- (UIView *)getTableViewFooterView {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.numberOfLines = 0;
    [label setText:[NSString stringWithFormat:@"\u00A9 Glitz And Glamour (Pvt) Ltd."]];
    [label setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:10]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    label.backgroundColor = [UIColor clearColor];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    
    [footer addSubview:label];
    NSDictionary *dict = NSDictionaryOfVariableBindings(label);
    [footer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[label]-10-|" options:0 metrics:nil views:dict]];
    [footer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|" options:0 metrics:nil views:dict]];
    return footer;
}

- (CALayer *)setViewBottomBorder:(CGFloat)height{
    UIScreen *screen = [UIScreen mainScreen];
    CALayer *viewBottomBorder = [CALayer layer];
    UIColor *bottomBorderColor = [[UIColor alloc]initWithRed:38.0/255.0 green:39.0/255.0 blue:41.0/255.0 alpha:1.0];
    viewBottomBorder.backgroundColor = bottomBorderColor.CGColor;
    viewBottomBorder.frame = CGRectMake(0, height - 0.6f, screen.bounds.size.width, 0.6f);
    return viewBottomBorder;
}

- (void)openAudioPlayer:(UIStoryboard *)storyboard tabbarController:(UITabBarController *)tabbarController album:(Album *)album selectedTrack:(Song *)selectedTrack tracks:(NSMutableArray *)tracks playlist:(Playlist *)playlist isRunFromDownload:(BOOL)isRunFromDownload delegate:(id<PlayerViewControllerDelegate>)delegate{

    
    

    if (tabbarController.popupPresentationState != LNPopupPresentationStateTransitioning) {
            static dispatch_once_t onceToken;
//
            dispatch_once(&onceToken, ^{
                
                NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                paragraphStyle.alignment = NSTextAlignmentCenter;
                paragraphStyle.firstLineHeadIndent = 5.0 ;

                [[LNPopupBar appearanceWhenContainedInInstancesOfClasses:@[[UINavigationController class]]] setTitleTextAttributes:@{NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName: [UIColor yellowColor]}];
                
                [[LNPopupBar appearanceWhenContainedInInstancesOfClasses:@[[UINavigationController class]]] setSubtitleTextAttributes:@{NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName: [UIColor grayColor]}];
            });

        bool isFound = NO;
        bool isRetriveData = YES;
        PlayerViewController *MusicPlayer = [PlayerViewController sharedInstance];
        MusicPlayer.delegate = delegate;
        
       
        
      
        if(MusicPlayer.album == album){
            isFound = YES;
            isRetriveData = NO;
            [MusicPlayer playSelectedSong:selectedTrack];
        }

        if(!isFound){
            MusicPlayer.popupItem.title =album.Title;//
            MusicPlayer.album = album;
            MusicPlayer.selectedSong = selectedTrack;
            MusicPlayer.tracks = tracks;
            MusicPlayer.popupItem.progress = 0.0;
            MusicPlayer.isRunFromDownload = isRunFromDownload;
            MusicPlayer.playlist = playlist;
        }
        
        if(isRetriveData)
            [MusicPlayer retrieveData];




        //    if((unsigned long)tabbarController.popupPresentationState != LNPopupPresentationStateClosed){
        //        if ((unsigned long)tabbarController.popupPresentationState != LNPopupPresentationStateOpen) {
        //            MusicPlayer.popupItem.title = NSLocalizedString(album.Title, @"");
        //            MusicPlayer.popupItem.accessibilityHint = NSLocalizedString(@"Custom popup bar accessibility hint", @"");
        //            tabbarController.popupContentView.popupCloseButton.titleLabel.text = @"Custom popup button accessibility label";
        //            tabbarController.popupContentView.popupCloseButton.accessibilityHint = NSLocalizedString(@"Custom popup button accessibility hint", @"");
        //        }
        //    }

        //    tabbarController.popupContentView.popupInteractionGestureRecognizer.enabled = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            paragraphStyle.alignment = NSTextAlignmentCenter;
            paragraphStyle.firstLineHeadIndent = 5.0 ;
            
            [[LNPopupBar appearanceWhenContainedInInstancesOfClasses:@[[PlayerViewController class]]] setTitleTextAttributes:@{NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName: [UIColor whiteColor]}];
            
            [[LNPopupBar appearanceWhenContainedInInstancesOfClasses:@[[UINavigationController class]]] setSubtitleTextAttributes:@{NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName: [UIColor grayColor]}];
            
        });
        
      
        tabbarController.popupContentView.popupCloseButton.hidden = YES ;
        tabbarController.popupBar.barStyle = LNPopupBarStyleCompact;
        tabbarController.popupBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
        tabbarController.popupBar.subtitleTextAttributes = @{NSForegroundColorAttributeName: [UIColor lightGrayColor]};
        [tabbarController presentPopupBarWithContentViewController:MusicPlayer animated:YES completion:nil];
    }

    
    
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (DownloadViewController *)downloadMP3:(UIStoryboard *)storyboard song:(Song *)song rootViewController:(UIViewController *)rootViewController{
    DownloadViewController *downloadController = [storyboard instantiateViewControllerWithIdentifier:@"DownloadViewController"];
    downloadController.song = song;
    
    UINavigationController *navController = [[UINavigationController alloc] init];
    [navController setNavigationBarHidden:YES animated:NO];
    [navController pushViewController:downloadController animated:NO];
    [rootViewController presentViewController:navController animated:YES completion:nil];
    return downloadController;
}

- (void)openVideoPlayerWithType:(UIStoryboard *)storyboard
                       andVideo:(Video *)video
                       andRootViewController:(UIViewController *)rootViewController
                       andType:(NSString *)type {
    
    
    // check if already video player is visible then refresh it. If not then load new video player
    VideoViewController *videoController;
    BOOL isFound = NO;
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    if([topController isKindOfClass:[LoginViewController class]]){
        LoginViewController *loginViewController = (LoginViewController *)topController;
        loginViewController.IsVideo = YES;
        loginViewController.video = video;
        loginViewController.rootViewController = rootViewController;
    } else {
        if([topController isKindOfClass:[UINavigationController class]]){
            UINavigationController *navController = (UINavigationController *)topController;
            NSArray *viewControllers = navController.viewControllers;
            for (UIViewController *anVC in viewControllers) {
                if ([anVC isKindOfClass:[VideoViewController class]]) {
                    isFound = YES;
                    videoController = (VideoViewController *)anVC;
                    break;
                }
            }
        }
        if(isFound){
            
            // if is found then refresh
            
            videoController.video = video;
            videoController.type = type;
            videoController.isAlreadyPlay = YES;
            [videoController retrieveData];
            
            
        } else {
            
            // else reload a new video view controller
            
            videoController = [storyboard instantiateViewControllerWithIdentifier:@"VideoViewController"];
            videoController.video = video;
            videoController.type = type;
            
            UINavigationController *navController = [[UINavigationController alloc] init];
            [navController setNavigationBarHidden:YES animated:NO];
            [navController pushViewController:videoController animated:NO];
            [navController setModalPresentationStyle: UIModalPresentationOverFullScreen];
            [rootViewController presentViewController:navController animated:YES completion:nil];
            
        }
    }
}


-(void)openVideoPlayer:(UIStoryboard *)storyboard
              andVideo:(Video *)video
              andRootViewController:(UIViewController *)rootViewController{
    

    
    // check if already video player is visible then refresh it. If not then load new video player
    VideoViewController *videoController;
    BOOL isFound = NO;
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    if([topController isKindOfClass:[LoginViewController class]]){
        LoginViewController *loginViewController = (LoginViewController *)topController;
        loginViewController.IsVideo = YES;
        loginViewController.video = video;
        loginViewController.rootViewController = rootViewController;
    } else {
        if([topController isKindOfClass:[UINavigationController class]]){
            UINavigationController *navController = (UINavigationController *)topController;
            NSArray *viewControllers = navController.viewControllers;
            for (UIViewController *anVC in viewControllers) {
                if ([anVC isKindOfClass:[VideoViewController class]]) {
                    isFound = YES;
                    videoController = (VideoViewController *)anVC;
                    break;
                }
            }
        }
        if(isFound){
            videoController.video = video;
            videoController.type = @"top_video"; //muneeb
            videoController.isAlreadyPlay = YES;
            [videoController retrieveData];
        } else {
            videoController = [storyboard instantiateViewControllerWithIdentifier:@"VideoViewController"];
            videoController.video = video;
            videoController.type = @"top_video"; // muneeb
            UINavigationController *navController = [[UINavigationController alloc] init];
            [navController setNavigationBarHidden:YES animated:NO];
            [navController pushViewController:videoController animated:NO];
            [rootViewController presentViewController:navController animated:YES completion:nil];
        }
    }
}




- (UIViewController *)topViewController{
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [self topViewController:[navigationController.viewControllers lastObject]];
    }
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabController = (UITabBarController *)rootViewController;
        return [self topViewController:tabController.selectedViewController];
    }
    if (rootViewController.presentedViewController) {
        return [self topViewController:rootViewController];
    }
    return rootViewController;
}

- (NSMutableArray *)getSongsArrayFromJSON:(NSDictionary *)songsArray{
    NSMutableArray * songs = [[NSMutableArray alloc] init];
    for (NSDictionary *singleSong in songsArray)
        [songs addObject:[self getSongFromJSON:singleSong]];
    return songs;
}

- (Song *)getSongFromJSON: (NSDictionary *)song{
    NSNumber * songID = 0;
    NSString * name = nil;
    NSString * mp3 = nil;
    NSString * videoURL = nil;
    NSString * shareUrl = nil;
    NSString * videoShareUrl = nil;
    BOOL isVideo = false;
    BOOL isDownload = false;
    NSNumber * albumID = 0;
    //int albumId = 0;
    NSString * albumName = nil;
    NSString * poster = nil;
    
    if([song objectForKey:@"id"])
        songID = [song objectForKey:@"id"] == NULL ? [NSNumber numberWithInt:0] : @([[song objectForKey:@"id"] integerValue]);
    if([song objectForKey:@"title"])
        name = [song objectForKey:@"title"] == NULL ? @"" : [NSString stringWithFormat:@"%@", [song objectForKey:@"title"]];
    if([song objectForKey:@"audio_url"]){
        mp3 = [song objectForKey:@"audio_url"] == NULL ? @"" : [NSString stringWithFormat:@"%@", [song objectForKey:@"audio_url"]];
        mp3 = [mp3 stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    }
    if([song objectForKey:@"video_url"]){
        videoURL = [song objectForKey:@"video_url"] == NULL ? @"" : [NSString stringWithFormat:@"%@", [song objectForKey:@"video_url"]];
        videoURL = [videoURL stringByReplacingOccurrencesOfString:@".mpd" withString:@".m3u8"];
        videoURL = [videoURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    }else if([song objectForKey:@"mpd_url"]){
        videoURL = [song objectForKey:@"mpd_url"] == NULL ? @"" : [NSString stringWithFormat:@"%@", [song objectForKey:@"mpd_url"]];
        videoURL = [videoURL stringByReplacingOccurrencesOfString:@".mpd" withString:@".m3u8"];
        videoURL = [videoURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    }
    if([song objectForKey:@"share_url"])
        shareUrl = [song objectForKey:@"share_url"] == NULL ? @"" : [NSString stringWithFormat:@"%@", [song objectForKey:@"share_url"]];
    if([song objectForKey:@"video_share_url"])
        videoShareUrl = [song objectForKey:@"video_share_url"] == NULL ? @"" : [NSString stringWithFormat:@"%@", [song objectForKey:@"video_share_url"]];
    if([song objectForKey:@"album_id"]){
        albumID = [song objectForKey:@"album_id"] == NULL ? [NSNumber numberWithInt:0] : @([[song objectForKey:@"album_id"] integerValue]);
        //albumId = [albumID intValue];
        //serialNO = [albumID intValue];
    }
    if([song objectForKey:@"album_name"])
        albumName = [song objectForKey:@"album_name"] == NULL ? @"" : [NSString stringWithFormat:@"%@", [song objectForKey:@"album_name"]];
    if([song objectForKey:@"cover_url"]){
        poster = [song objectForKey:@"cover_url"] == NULL ? @"" : [NSString stringWithFormat:@"%@", [song objectForKey:@"cover_url"]];
        poster = [poster stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    }
    if(videoURL.length > 0)
        isVideo = true;
    if(mp3.length > 0)
        isDownload = true;
    Song *newSong = [[Song alloc] initWithID:songID albumId:albumID likes:0 title:name albumTitle:albumName poster:poster permalink:shareUrl audioURL:mp3 videoURL:videoURL videoPermalink:videoShareUrl isDowload:isDownload isVideo:isVideo isLikes:NO];
    return newSong;
}

- (void)showToastSuccess:(NSString *)text{
//    [self showToastNotification:text
//                      textColor:self.getSuccessTextMessageColor
//                backgroundColor:self.getSuccessMessageBackgroundColor
//                          image:[UIImage imageNamed:@"smile.png"]];
    
    
    
    [FFToast showToastWithTitle:@"Success" message:text iconImage:[UIImage imageNamed:@"imageCheckCircle"] duration:3 toastType:FFToastTypeSuccess];

    
}





- (void)showToastError:(NSString *)text{
//
//     [self showToastNotification:text
//                      textColor:self.getErrorTextMessageColor
//                backgroundColor:self.getErrorMessageBackgroundColor
//                          image:[UIImage imageNamed:@"sad.png"]];
    
    
  
    
    [FFToast showToastWithTitle:@"Attention" message:text iconImage:[UIImage imageNamed:@"imageError"] duration:3 toastType:FFToastTypeError];

    
    
    
}

- (void)showToastNotification:(NSString *)text
                    textColor:(UIColor *)textColor
              backgroundColor:(UIColor *)backgroundColor
                        image:(UIImage *)image{
    
    NSMutableDictionary *options = [@{kCRToastNotificationTypeKey               : @(CRToastTypeNavigationBar),
                                      kCRToastNotificationPresentationTypeKey   : @(CRToastPresentationTypeCover),
                                      kCRToastUnderStatusBarKey                 : @NO,
                                      kCRToastTextKey                           : text,
                                      kCRToastTextColorKey                      : textColor,
                                      kCRToastBackgroundColorKey                : backgroundColor,
                                      kCRToastTextAlignmentKey                  : @(NSTextAlignmentLeft),
                                      kCRToastForceUserInteractionKey           : @NO,
                                      kCRToastTimeIntervalKey                   : @(2.0),
                                      kCRToastAnimationInTypeKey                : @(CRToastAnimationTypeSpring),
                                      kCRToastAnimationOutTypeKey               : @(CRToastAnimationTypeLinear),
                                      kCRToastAnimationInDirectionKey           : @(CRToastAnimationDirectionTop),
                                      kCRToastAnimationOutDirectionKey          : @(CRToastAnimationDirectionTop),
                                      kCRToastNotificationPreferredPaddingKey   : @(15)} mutableCopy];
    if(image != nil){
        options[kCRToastImageKey] = image;
        options[kCRToastImageAlignmentKey] = @(CRToastAccessoryViewAlignmentLeft);
    }
    
    options[kCRToastInteractionRespondersKey] = @[[CRToastInteractionResponder
                                                   interactionResponderWithInteractionType:CRToastInteractionTypeAll
                                                   automaticallyDismiss:YES
                                                   block:^(CRToastInteractionType interactionType){
                                                       //NSLog(@"Dismissed with %@ interaction", NSStringFromCRToastInteractionType(interactionType));
                                                   }]];
    
    [CRToastManager showNotificationWithOptions:[NSDictionary dictionaryWithDictionary:options] completionBlock:nil];




}

- (void)setupLoading{
    [SVProgressHUD setRingThickness:7.0f];
    [SVProgressHUD setRingRadius:20];
    //[SVProgressHUD setForegroundColor:[self getDefaultColor]];
    // Make it Dark
    [SVProgressHUD setForegroundColor:[[UIColor alloc]initWithRed:182.0/255.0 green:0.0/255.0 blue:61.0/255.0 alpha:1.0]];
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    int screenSize =(int)[[UIScreen mainScreen] nativeBounds].size.height / 36 ;
    
    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, (CGFloat)screenSize )];
    
    //    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack]; // if you want to restrict screen use this
}

//#FF4081
- (UIColor *)getDefaultColor{
    return [[UIColor alloc]initWithRed:255.0/255.0 green:64.0/255.0 blue:129.0/255.0 alpha:1.0];
}

- (UIColor *)getDefaultBackgroundColor{
    return [[UIColor alloc]initWithRed:18.0/255.0 green:19.0/255.0 blue:20.0/255.0 alpha:1.0];
}

- (NSString *)getCurrentFormattedDateTime{
    NSDateFormatter *formatter;
    NSString        *dateString;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, yyyy hh:mm:ss a"];
    dateString = [formatter stringFromDate:[NSDate date]];
    return dateString;
}

- (NSString *)getCurrentTimeUniqueID{
    NSDateFormatter *formatter;
    NSString        *dateString;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MM yyyy HH mm ss"];
    dateString = [formatter stringFromDate:[NSDate date]];
    dateString = [dateString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return dateString;
}

- (CGFloat)getLabelHeight:(UILabel*)label {
    label.numberOfLines = 2;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    UIScreen *screen = [UIScreen mainScreen];
    //CGSize constraint = CGSizeMake((screen.bounds.size.width - 155), CGFLOAT_MAX);
    CGSize constraint = CGSizeMake((screen.bounds.size.width - 175), CGFLOAT_MAX);
    CGSize size;
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    return size.height;
}

- (CNPPopupTheme *)cnPopupDefaultTheme{
    CNPPopupTheme *defaultTheme = [[CNPPopupTheme alloc] init];
    defaultTheme.backgroundColor = [UIColor whiteColor];
    defaultTheme.cornerRadius = 10.0f;
    defaultTheme.popupContentInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    defaultTheme.popupStyle = CNPPopupStyleCentered;
    defaultTheme.presentationStyle = CNPPopupPresentationStyleSlideInFromBottom;
    defaultTheme.dismissesOppositeDirection = NO;
    defaultTheme.maskType = CNPPopupMaskTypeDimmed;
    defaultTheme.shouldDismissOnBackgroundTouch = NO;
    defaultTheme.movesAboveKeyboard = YES;
    defaultTheme.contentVerticalPadding = 16.0f;
    defaultTheme.maxPopupWidth = 300.0f;
    defaultTheme.animationDuration = 0.3f;
    return defaultTheme;
}

- (UITabBarController *)getCurrentTabbarController{
    UITabBarController *tabBarController = (UITabBarController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    return tabBarController;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
    if (event.type == UIEventTypeRemoteControl) {
        UITabBarController *tabbarController = [self getCurrentTabbarController];
        if((unsigned long)tabbarController.popupPresentationState == 1){
         
            if([tabbarController.popupContentViewController isKindOfClass:[PlayerViewController class]]){
                
                PlayerViewController *MusicPlayer = (PlayerViewController *)tabbarController.popupContentViewController;
                
                switch (event.subtype) {
                    case UIEventSubtypeRemoteControlTogglePlayPause: {
                        break;
                    }
                 
                    case UIEventSubtypeRemoteControlPlay: {
                        [MusicPlayer play];
                        break;
                    }
                  
                    case UIEventSubtypeRemoteControlPause: {
                        [MusicPlayer pause];
                        break;
                    }
                   
                    case UIEventSubtypeRemoteControlStop:{
                        [MusicPlayer stop];
                        break;
                    }
                   
                    case UIEventSubtypeRemoteControlNextTrack:{
                        [MusicPlayer next];
                        break;
                    }
             
                    case UIEventSubtypeRemoteControlPreviousTrack:{
                        [MusicPlayer previous];
                        break;
                    }
                    default:
                        break;
                }
            }
        }
    }
}

- (UIColor *)getErrorMessageBackgroundColor{
    return [[UIColor alloc] initWithRed:204.0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
}

/*- (UIColor *)getSuccessMessageBackgroundColor{
 return [[UIColor alloc] initWithRed:0.0/255.0 green:63.0/255.0 blue:0.0/255.0 alpha:1.0];
 }*/

- (UIColor *)getSuccessMessageBackgroundColor{
    return [[UIColor alloc] initWithRed:255.0/255.0 green:64.0/255.0 blue:129.0/255.0 alpha:1.0];
}

- (UIColor *)getErrorTextMessageColor{
    return [[UIColor alloc] initWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
}

/*- (UIColor *)getSuccessTextMessageColor{
 return [[UIColor alloc] initWithRed:79.0/255.0 green:138.0/255.0 blue:16.0/255.0 alpha:1.0];
 }*/

- (UIColor *)getSuccessTextMessageColor{
    return [[UIColor alloc] initWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
}

- (void)popup_open:(UIStoryboard *)storyboard tabbarController:(UITabBarController *)tabbarController{
    
    tabbarController.popupContentView.popupInteractionGestureRecognizer.enabled = NO;
}

@end
