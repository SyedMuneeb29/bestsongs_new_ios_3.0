//
//  PlaylistViewController.m
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 10/6/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import "PlaylistViewController.h"

@interface PlaylistViewController () <CNPPopupControllerDelegate> {
    NSMutableArray *playlists;
    PlaylistDatabase *playlistDBManager;
    UIView *noPlaylistview;
}

@property (nonatomic, strong) PlaylistNamePopupViewController *addToPlayListPopupViewController;

@end

@implementation PlaylistViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _playlistTableView.tableFooterView = [UIView new];
    
    [self.navigationController.navigationBar setTintColor:[[BaseController sharedInstance] getDefaultColor]];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.title = @"Playlists";
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButton:)];
    searchButton.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:searchButton, nil]];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    noPlaylistview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    
//    UIButton *createPlaylistButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _createPlaylistButton.frame = CGRectMake(noPlaylistview.center.x - 100   , 80, 200, 40);
    [_createPlaylistButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:17]];
//    [_createPlaylistButton setTitle:@"+ Create New Playlist" forState:UIControlStateNormal];
//    [_createPlaylistButton setTintColor:[UIColor whiteColor]];
//    [_createPlaylistButton setBackgroundColor:[[BaseController sharedInstance] getDefaultColor]];
    [_createPlaylistButton.layer setBorderWidth:1.0];
    [_createPlaylistButton.layer setCornerRadius:20.0];
    [_createPlaylistButton.layer setBorderColor:[[UIColor clearColor] CGColor]];
    [_createPlaylistButton addTarget:self action:@selector(createPlaylist:) forControlEvents:UIControlEventTouchUpInside];
//    [noPlaylistview addSubview:createPlaylistButton];
    
    
    UILabel *messageLbl = [[UILabel alloc] init];
    [messageLbl setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:18]];
    messageLbl.text = @"No Playlist Found...\nGet Rich! With every Playlist created with bestsongs.pk";
    messageLbl.textAlignment = NSTextAlignmentCenter;
    messageLbl.lineBreakMode = NSLineBreakByWordWrapping;
    messageLbl.numberOfLines = 3;
//    messageLbl.center = noPlaylistview.center;
    [messageLbl setTextColor:[UIColor whiteColor]];
    
    [noPlaylistview addSubview:messageLbl];
    noPlaylistview.alpha = 0;
    
    
    
    CGFloat centerPoint = (noPlaylistview.frame.size.height / 2 ) - 300;
    messageLbl.translatesAutoresizingMaskIntoConstraints = false;
    
    [messageLbl.centerYAnchor constraintEqualToAnchor:noPlaylistview.centerYAnchor constant:-110].active = true;
     [messageLbl.centerXAnchor constraintEqualToAnchor:noPlaylistview.centerXAnchor constant:0].active = true;
     [messageLbl.heightAnchor constraintEqualToConstant:200].active = true;
     [messageLbl.widthAnchor constraintEqualToAnchor:noPlaylistview.widthAnchor constant:0].active = true;
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.playlistTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
}

- (IBAction)createPlaylist:(id)sender{
    if(![AFNetworkReachabilityManager sharedManager].isReachable){
        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
        return;
    }
    
    self.addToPlayListPopupViewController = [PlaylistNamePopupViewController instantiateFromNib];
    [self.addToPlayListPopupViewController loadData];
    [self.addToPlayListPopupViewController setFrame:CGRectMake(0, 0, 300, 300)];
    // Popup
    CNPPopupController *newPopupController = [[CNPPopupController alloc] initWithContents:@[self.addToPlayListPopupViewController]];
    newPopupController.theme = [[BaseController sharedInstance] cnPopupDefaultTheme];
    newPopupController.theme.presentationStyle = CNPPopupPresentationStyleFadeIn;
    newPopupController.theme.movesAboveKeyboard = YES;
    newPopupController.delegate = self;
    
    self.addToPlayListPopupViewController.popupController = newPopupController;
    [newPopupController presentPopupControllerAnimated:YES];
}

- (void)popupControllerDidDismiss:(CNPPopupController *)controller {
    [self retrieveData];
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
    return playlists.count;
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
    if([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    static NSString *cellID = @"playlistTableViewCell";
    PlaylistTableViewCell *cell = (PlaylistTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell)
        cell = [[PlaylistTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    
    Playlist *playlist = [playlists objectAtIndex:indexPath.row];
    
    cell.title.text = playlist.Title;
    [cell.title setTextColor:[UIColor whiteColor]];
    
    cell.subTitle.text = [NSString stringWithFormat:@"Total Tracks %@",playlist.TotalTracks];
    [cell.subTitle setTextColor:[UIColor lightGrayColor]];
    cell.imageView.image = [UIImage imageNamed:@"BestsongsPlaceholder.jpg"];
    
    // Add utility buttons
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    // Un comment this when working with edit Button
//    [rightUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
//                                                title:@"Edit"];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    cell.rightUtilityButtons = rightUtilityButtons;
    cell.delegate = self;
    
    
    CGSize itemSize = CGSizeMake(40, 40);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    cell.backgroundColor = cell.contentView.backgroundColor;
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Playlist *playlist = [playlists objectAtIndex:indexPath.row];
    SingleAlbumViewController *savc = [self.storyboard instantiateViewControllerWithIdentifier:@"singleAlbumViewController"];
    Album *album = [[Album alloc] initWithID:[NSNumber numberWithInteger:0] title:playlist.Title poster:@"" permalink:@""];
    savc.playlist = [playlists objectAtIndex:indexPath.row];
    savc.album = album;
    [self.navigationController pushViewController:savc animated:YES];
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state {
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    if(![AFNetworkReachabilityManager sharedManager].isReachable){
        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
        return;
    }
    [cell hideUtilityButtonsAnimated:YES];
    switch (index) {
            // Un Commit this when working with edit playlist
//        case 0:{
//            NSIndexPath *indexPath = [self.playlistTableView indexPathForCell:cell];
//            Playlist *playlist = [playlists objectAtIndex:indexPath.row];
//            
//            UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Playlist"
//                                                                                      message: @"Enter New Playlist Title"
//                                                                               preferredStyle:UIAlertControllerStyleAlert];
//            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//                textField.placeholder = @"Playlist Title";
//                textField.textColor = [UIColor blueColor];
//                textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//                textField.borderStyle = UITextBorderStyleRoundedRect;
//                textField.text = playlist.Title;
//            }];
//            [alertController addAction:[UIAlertAction actionWithTitle:@"Update" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                [[BaseController sharedInstance] setupLoading];
//                [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
//                [SVProgressHUD show];
//                NSArray * textfields = alertController.textFields;
//                UITextField * textField = textfields[0];
//                NSString *title = textField.text;
//                if(title == nil || title.length <= 0){
//                    [SVProgressHUD dismiss];
//                    [[BaseController sharedInstance] showToastError:@"Playlist Name Required."];
//                } else {
//                    [playlistDBManager updatePlaylist:playlist onSuccess:^(id response) {
//                        [SVProgressHUD dismiss];
//                        [[BaseController sharedInstance] showToastSuccess:@"Playlist Successfully Updated."];
//                        [self dismissViewControllerAnimated:YES completion:nil];
//                    } onFailure:^(NSError *error) {
//                        [[BaseController sharedInstance] showToastError:error.localizedDescription];
//                        
//                        
//                    
//                    }];
//                }
//            }]];
//            [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [self dismissViewControllerAnimated:YES completion:nil];
//            }]];
//            [self presentViewController:alertController animated:YES completion:nil];
//            break;
//        }
            // Change case to 1 when working with edit playlist
        case 0:{
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"Delete Playlist"
                                         message:@"Are you sure to delete this Playlist ?"
                                         preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"Yes"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            [[BaseController sharedInstance] setupLoading];
                                            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
                                            [SVProgressHUD show];
                                            
                                            NSIndexPath *indexPath = [self.playlistTableView indexPathForCell:cell];
                                            Playlist *playlist = [playlists objectAtIndex:indexPath.row];
                                            
                                            if([[PlayerViewController sharedInstance] selectedSong] != nil && ![[PlayerViewController sharedInstance] isRunFromDownload] && [[PlayerViewController sharedInstance] playlist] != nil && [[PlayerViewController sharedInstance] playlist].ID == playlist.ID){
                                                [SVProgressHUD dismiss];
                                                [[BaseController sharedInstance] showToastError:@"Could not delete Playlist. It is currenlty Playing"];
                                                return;
                                            }
                                            [playlistDBManager deletePlaylist:playlist onSuccess:^(id response) {
                                                [SVProgressHUD dismiss];
                                                [[BaseController sharedInstance] showToastSuccess:@"Playlist Successfully Deleted"];
                                                [playlists removeObjectAtIndex:indexPath.row];
                                                [self.playlistTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                                                if([playlists count] <= 0){
                                                    [self retrieveData];
                                                } else {
                                                    [self.playlistTableView reloadData];
                                                }
                                            } onFailure:^(NSError *error) {
                                                [self retrieveData];
                                                [SVProgressHUD dismiss];
                                                [[BaseController sharedInstance] showToastError:[NSString stringWithFormat:@"Error :: %@",error.localizedDescription]];
                                            }];
                                        }];
            UIAlertAction* noButton = [UIAlertAction
                                       actionWithTitle:@"No"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           [self dismissViewControllerAnimated:YES completion:nil];
                                       }];
            [alert addAction:yesButton];
            [alert addAction:noButton];
            [self presentViewController:alert animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Methods
- (void) retrieveData {
    
    
    
    playlists = [[NSMutableArray alloc] init];
    if(playlistDBManager == nil){
        playlistDBManager = [[PlaylistDatabase alloc] init];
        [playlistDBManager loadDatabase];
    }
    if(playlists != nil)
        playlists = nil;
    
    
    
    playlists = [[NSMutableArray alloc]initWithArray:[playlistDBManager getAllPlaylist]];
    dispatch_async(dispatch_get_main_queue(), ^ {
        if(playlists.count > 0){
            [UIView transitionWithView: self.playlistTableView
                              duration: 0.50f
                               options: UIViewAnimationOptionTransitionCrossDissolve
                            animations: ^(void) {
                                self.playlistTableView.backgroundView = [UIView new];
                                [self.playlistTableView setSeparatorColor:[[UIColor alloc]initWithRed:35.0/255.0 green:35.0/255.0 blue:35.0/255.0 alpha:1.0]];
                                self.playlistTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                                [self.playlistTableView reloadData];
                            } completion: ^(BOOL finished){
                                CATransition *animation = [CATransition animation];
                                animation.type = kCATransitionFade;
                                animation.duration = 0.3;
                                [self.playlistTableView.tableFooterView.layer addAnimation:animation forKey:nil];
                                [self.playlistTableView setTableFooterView:[[BaseController sharedInstance] getTableViewFooterView]];
                            }];
        } else {
            [self.playlistTableView reloadData];
            self.playlistTableView.backgroundView = noPlaylistview;
            [self.playlistTableView setTableFooterView:nil];
            self.playlistTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [UIView animateWithDuration:0.3f animations:^{
                noPlaylistview.alpha = 1;
            }];
        }
    });
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    
    
    
    [self retrieveData];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [playlistDBManager checkAndUpdatePlaylist:^(id response) {
            [self retrieveData];
        } onFailure:^(NSError *error) {
        }];
    });
    
    [self becomeFirstResponder];
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewDidDisappear:animated];
}

@end
