//
//  ShowDownloadsViewController.m
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 11/3/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import "ShowDownloadsTableViewCell.h"
#import "ShowDownloadsViewController.h"


@interface ShowDownloadsViewController () {
    UIView *noTracksview;
    NSMutableArray *tracks;
    UIBarButtonItem *deleteBtn;
    NSMutableArray *cellSelected;
    
    Boolean viewdisappear;
}

@end

@implementation ShowDownloadsViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[ NSNotificationCenter defaultCenter ] postNotificationName:@"hideHomeAdd" object:nil];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _downloadTableView.tableFooterView = [UIView new];
    
    viewdisappear = false;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController.navigationBar setTintColor:[[BaseController sharedInstance] getDefaultColor]];
    
    self.navigationItem.title = @"My Offline Songs";
    
    deleteBtn = [[UIBarButtonItem alloc] initWithTitle:@"Select All" style:UIBarButtonItemStyleDone target:self action:@selector(deleteAll:)];
    deleteBtn.tintColor = [UIColor whiteColor];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:deleteBtn, nil]];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    noTracksview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    UILabel *messageLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 100)];
    [messageLbl setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:20]];
    messageLbl.text = @"No Offline Songs Found...";
    messageLbl.textAlignment = NSTextAlignmentCenter;
    messageLbl.numberOfLines = 1;
    [messageLbl setTextColor:[UIColor whiteColor]];
    messageLbl.center = noTracksview.center;
    [noTracksview addSubview:messageLbl];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.downloadTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0); // Makes the horizontal row seperator stretch the entire length of the table view
    }
    
    cellSelected = [NSMutableArray array];
    [self showLoading];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self retrieveData];
    });
    
    
    
    
}

// MARK : delete all

- (IBAction)deleteAll:(id)sender {
    if([deleteBtn.title isEqualToString:@"Select All"]){
        if([_downloadTableView numberOfRowsInSection:0] > 0){
            for (int i = 0; i < [self.downloadTableView numberOfSections]; i++) {
                for (int j = 0; j < [self.downloadTableView numberOfRowsInSection:i]; j++) {
                    NSUInteger ints[2] = {i,j};
                    NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:ints length:2];
                    [cellSelected addObject:indexPath];
                }
            }
            [_downloadTableView reloadData];
            [deleteBtn setTitle:@"Delete"];
        } else {
            [[BaseController sharedInstance] showToastError:@"No Offline Songs Found for Delete..."];
        }
    } else {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Delete Offline Songs"
                                     message:@"Are you sure to delete offline songs ?"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Yes"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        [SVProgressHUD show];
                                        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
                                        
                                        for(int i = 0 ; i < cellSelected.count ; i++){
                                            NSIndexPath *indexPath = [cellSelected objectAtIndex:i];
                                            NSFileManager *fileManager = [NSFileManager defaultManager];
                                            Song *deletedSong = [tracks objectAtIndex:indexPath.row];
                                            if([[PlayerViewController sharedInstance] selectedSong] != nil && [[PlayerViewController sharedInstance] isRunFromDownload]){
                                                if(((Song *)[[PlayerViewController sharedInstance] selectedSong]).ID == deletedSong.ID && [((Song *)[[PlayerViewController sharedInstance] selectedSong]).Title isEqualToString:deletedSong.Title] && [[PlayerViewController sharedInstance] isRunFromDownload]){
                                                    continue;
                                                }
                                            }
                                            NSError *error;
                                            BOOL success = [fileManager removeItemAtPath:deletedSong.AudioURL error:&error];
                                            if (success) {
                                            }
                                        }
                                        
                                        [cellSelected removeAllObjects];
                                        [deleteBtn setTitle:@"Select All"];
                                        
                                        [self retrieveData];
                                        
                                        if([[PlayerViewController sharedInstance] isRunFromDownload]){
                                            [[PlayerViewController sharedInstance] setTracks:tracks];
                                            [[[PlayerViewController sharedInstance] songTableView] reloadData];
                                        }
                                        
                                        [SVProgressHUD dismiss];
                                        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                                        [self dismissViewControllerAnimated:YES completion:nil];
                                        [[BaseController sharedInstance] showToastSuccess:@"Offline Songs Successfully Deleted..."];
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       [cellSelected removeAllObjects];
                                       [_downloadTableView reloadData];
                                       [deleteBtn setTitle:@"Select All"];
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                   }];
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

# pragma mark - Update music indicator state

- (void)updatePlaybackIndicatorWithIndexPath:(NSIndexPath *)indexPath {
    for (PlayerTableViewCell *cell in self.downloadTableView.visibleCells) {
        cell.state = NAKPlaybackIndicatorViewStateStopped;
    }
    PlayerTableViewCell *musicsCell = [self.downloadTableView cellForRowAtIndexPath:indexPath];
    musicsCell.state = NAKPlaybackIndicatorViewStatePlaying;
}

- (void)updatePlaybackIndicatorOfCell:(ShowDownloadsTableViewCell *)cell {
    int index = [[cell.sNo text] intValue];
    index--;
    
    if (index < tracks.count && index > -1 ) {
    
    Song * song = [tracks objectAtIndex:index];
    
    if (song!=nil){
    
    if([[PlayerViewController sharedInstance] album].ID == song.AlbumID){
        if([MusicIndicator sharedInstance].state != NAKPlaybackIndicatorViewStateStopped) {
            if([[PlayerViewController sharedInstance] selectedSong] != nil){
                if([[PlayerViewController sharedInstance] selectedSong].ID != 0){
                    if(song.ID == [[PlayerViewController sharedInstance] selectedSong].ID){
                        cell.state = NAKPlaybackIndicatorViewStateStopped;
                        cell.state = [MusicIndicator sharedInstance].state;
                        UIColor *colour = [[UIColor alloc]initWithRed:255.0/255.0 green:64.0/255.0 blue:129.0/255.0 alpha:1.0];
                        cell.trackTitle.textColor = UIColor.whiteColor;
                        [cell.poster setHidden:NO];
                        [cell.musicIndicator setHidden:NO];
                        [cell.poster setHidden:YES];
                        return;
                    }
                }
            }
        }
    }
    
    }
    
}
    
    cell.state = NAKPlaybackIndicatorViewStateStopped;
    [cell.trackTitle setTextColor:[UIColor whiteColor]];
    [cell.border setHidden:YES];
    [cell.poster setHidden:YES];
    [cell.musicIndicator setHidden:YES];
}

- (void)updatePlaybackIndicatorOfVisisbleCells {
    for (ShowDownloadsTableViewCell *cell in self.downloadTableView.visibleCells) {
        [self updatePlaybackIndicatorOfCell:cell];
    }
}

// MARK : tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = tracks.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    //fabric error fixed

  
    
    Song * track;
    
    if (indexPath.row < tracks.count && indexPath.row > -1) {
        
        track = [tracks objectAtIndex:indexPath.row];
    }
    
    
    static NSString *cellIdentifier = @"ShowDownloadCell";
    
    ShowDownloadsTableViewCell *cell = (ShowDownloadsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(!cell)
    {   cell = [[ShowDownloadsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    // Add utility buttons
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons
     sw_addUtilityButtonWithColor:[UIColor
                                   colorWithRed:1.0f
                                   green:0.231f
                                   blue:0.188
                                   alpha:1.0f]
     title:@"Delete"];
    
    
    
    
    cell.rightUtilityButtons = rightUtilityButtons;
    cell.delegate = self;
    
    ////////////////////////////////////////////
    [cell.sNo setText:[NSString stringWithFormat:@"%ld", (indexPath.row + 1)]];
    
    cell.trackTitle.numberOfLines = 0;
    
    if (track != nil )
    {
        if ( track.Title != nil )
        { [cell.trackTitle setText: track.Title];  }
        else { [cell.trackTitle setText: @"DefaultSongName-(NetworkError || DataError)"]; }
        if ( track.AlbumTitle != nil )
        {  [cell.albumTitle setText: track.AlbumTitle]; }
        else {  [cell.albumTitle setText:  @"DefaultAlbumName-(NetworkError || DataError)"];}
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = [cellSelected containsObject:indexPath] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    [self updatePlaybackIndicatorOfCell:cell];
    cell.backgroundColor = cell.contentView.backgroundColor;
    
    
    
    return cell;
    

//    } else {
//        return nil;
//    }
}






- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShowDownloadsTableViewCell *cell = (ShowDownloadsTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    // fabric error fixed
    
    Song *track;
    
    if (indexPath.row < tracks.count && indexPath.row > -1 ) {
        
        track = [tracks objectAtIndex:indexPath.row];
    }
 
    if (track != nil) {
        
        [cell.trackTitle setText:track.Title];
        CGFloat height = [self getLabelHeight:cell.trackTitle];
        CGFloat rowHeight = 40;
        rowHeight += height;
        return rowHeight;
        
    }
    else{
     return 0.0;
    }
    
}

- (CGFloat)getLabelHeight:(UILabel*)label {
    label.numberOfLines = 2;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    UIScreen *screen = [UIScreen mainScreen];
    CGSize constraint = CGSizeMake((screen.bounds.size.width - 55), CGFLOAT_MAX);
    CGSize size;
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    return size.height;
}

#pragma mark - UITableView Delegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if([deleteBtn.title isEqualToString:@"Delete"]){
        if ([cellSelected containsObject:indexPath]) {
            [cellSelected removeObject:indexPath];
        }
        else {
            [cellSelected addObject:indexPath];
        }
        [tableView beginUpdates];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [tableView endUpdates];
        
    } else {
      
        
         // fabric error fixed 
        
        Song *song;
        
        if (indexPath.row < tracks.count && indexPath.row > -1 ) {
            
            song = [tracks objectAtIndex:indexPath.row];
            
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            
         //   [self updatePlaybackIndicatorWithIndexPath:indexPath];
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
           
            
//            for(int iterator=0;iterator<tracks.count;iterator++){
//
//                UITableViewCell *eachCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:iterator inSection:0]];
//                [eachCell setSelected:NO animated:YES];
//
//            }
//
//            UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
//            [newCell setSelected:YES animated:YES];
           
            
            
            
          
        }
        // Song *song = [tracks objectAtIndex:indexPath.row];
        
        if (song!=nil){
            
             // [self updatePlaybackIndicatorWithIndexPath:indexPath];
        Album *album = [[Album alloc] initWithID:song.AlbumID title:song.AlbumTitle poster:song.Poster permalink:song.Permalink];
            
        [[BaseController sharedInstance] openAudioPlayer:self.storyboard tabbarController:self.tabBarController album:album selectedTrack:song tracks:tracks playlist:nil isRunFromDownload:YES delegate:self];
            
      
        
        }
        
        
    }
    
}


#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state {
    switch (state) {
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    [cell hideUtilityButtonsAnimated:YES];
    switch (index) {
        case 0:{
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"Delete Offline Song"
                                         message:@"Are you sure to delete this offline song ?"
                                         preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"Yes"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            [SVProgressHUD show];
                                            NSFileManager *fileManager = [NSFileManager defaultManager];
                                            NSIndexPath *indexPath = [self.downloadTableView indexPathForCell:cell];
                                            
                                            // fabric error fixed
                                            
                                            Song *deletedSong;
                                            
                                            if (indexPath.row < tracks.count && indexPath.row > -1 ) {
                                                
                                                deletedSong = [tracks objectAtIndex:indexPath.row];
                                            }
                                            else{
                                                
                                                [[BaseController sharedInstance] showToastError:@"Error '3282' : Your song cannot be deleted now , please try later "];
                                                
                                            }
                                            
                                          //  Song *deletedSong = [tracks objectAtIndex:indexPath.row];
                                            
                                            
                                            if([[PlayerViewController sharedInstance] selectedSong] != nil && [[PlayerViewController sharedInstance] isRunFromDownload]){
                                                
                                                 if (deletedSong != nil ){
                                                
                                                if(((Song *)[[PlayerViewController sharedInstance] selectedSong]).ID == deletedSong.ID && [((Song *)[[PlayerViewController sharedInstance] selectedSong]).Title isEqualToString:deletedSong.Title] && [[PlayerViewController sharedInstance] isRunFromDownload]){
                                                    [SVProgressHUD dismiss];
                                                    [[BaseController sharedInstance] showToastError:@"Could not delete playing offline song."];
                                                    return;
                                               
                                                
                                                }
                                                     
                                                     
                                                 } // if deleted song is not equal to null
                                           
                                            
                                            }
                                            NSError *error;
                                            
                                            if (deletedSong != nil ){
                                            
                                            BOOL success = [fileManager removeItemAtPath:deletedSong.AudioURL error:&error];
                                            
                                            
                                            if (success) {
                                                [SVProgressHUD dismiss];
                                                [[BaseController sharedInstance] showToastSuccess:@"Offline Song Successfully Deleted.."];
                                                [tracks removeObjectAtIndex:indexPath.row];
                                                if([[PlayerViewController sharedInstance] isRunFromDownload]){
                                                    [[PlayerViewController sharedInstance] setTracks:tracks];
                                                    [[[PlayerViewController sharedInstance] songTableView] reloadData];
                                                }
                                                
                                                [self.downloadTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                                                if(tracks.count <= 0)
                                                    [self retrieveData];
                                                else {
                                                    [self.downloadTableView reloadData];
                                                }
                                            }
                                            else {
                                                [SVProgressHUD dismiss];
                                                [[BaseController sharedInstance] showToastError:[NSString stringWithFormat:@"Could not delete offline song -:%@",[error localizedDescription]]];
                                            }
                                                
                                            } // if deleted song is not equal to nil
                                            
                                            
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

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state {
    switch (state) {
        case 1:
            if([deleteBtn.title isEqualToString:@"Delete"]){
                return NO;
            }
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            if([deleteBtn.title isEqualToString:@"Delete"]){
                return NO;
            }
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    return YES;
}

#pragma mark - Methods
- (void) retrieveData {
    tracks = [[NSMutableArray alloc] init];
    int serialNo = 1;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *filePathsArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory  error:nil];
    for (NSString *filename in filePathsArray) {
        NSString *strFileName = [filename.lastPathComponent lowercaseString];
        if([strFileName.pathExtension isEqualToString:@"mp3"]) {
            NSString *soundPath = [documentsDirectory stringByAppendingPathComponent:filename];
            if ([[NSFileManager defaultManager] fileExistsAtPath:soundPath]) {
                NSURL *fileURL = [NSURL fileURLWithPath:soundPath isDirectory:NO];
                AVURLAsset *asset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
                NSArray *albumNames = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata withKey:AVMetadataCommonKeyAlbumName keySpace:AVMetadataKeySpaceCommon];
                NSString * albumName;
                if(albumNames.count == 0){
                    albumName = @"N/A";
                }
                else {
                    AVMetadataItem *metaAlbumName = [albumNames objectAtIndex:0];
                    albumName = [metaAlbumName.value copyWithZone:nil];
                }
                NSNumber * songID = [NSNumber numberWithInt:serialNo];
                NSString * name = [filename stringByReplacingOccurrencesOfString:@".mp3" withString:@""];
                
                NSString * mp3 = soundPath;
                NSString * videoURL = @"";
                NSString * shareUrl = @"";
                NSString * videoShareUrl = @"";
                NSString * poster = @"";
                Song *song = [[Song alloc] initWithID:songID albumId:0 likes:0 title:name albumTitle:albumName poster:poster permalink:shareUrl audioURL:mp3 videoURL:videoURL videoPermalink:videoShareUrl isDowload:NO isVideo:NO isLikes:NO];
                [tracks addObject:song];
                
                
                
                serialNo ++;
            }
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^ {
        if([tracks count] > 0){
            self.downloadTableView.backgroundView = nil;
            [UIView transitionWithView: self.downloadTableView
                              duration: 0.50f
                               options: UIViewAnimationOptionTransitionCrossDissolve
                            animations: ^(void) {
                                [self.downloadTableView setSeparatorColor:[[UIColor alloc]initWithRed:35.0/255.0 green:35.0/255.0 blue:35.0/255.0 alpha:1.0]];
                                self.downloadTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                                [self.downloadTableView reloadData];
                            } completion: ^(BOOL finished){
                                CATransition *animation = [CATransition animation];
                                animation.type = kCATransitionFade;
                                animation.duration = 0.3;
                                [self.downloadTableView.tableFooterView.layer addAnimation:animation forKey:nil];
                                [self.downloadTableView setTableFooterView:[[BaseController sharedInstance] getTableViewFooterView]];
                                [self hideLoading];
                            }];
        } else {
            [self.downloadTableView reloadData];
            self.downloadTableView.backgroundView = noTracksview;
            self.downloadTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.downloadTableView setTableFooterView:nil];
            [self hideLoading];
        }
    });
}
- (void)showLoading {
    [[BaseController sharedInstance] setupLoading];
    int screenSize =(int)[[UIScreen mainScreen] nativeBounds].size.height / 36 ;
    
    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, (CGFloat)screenSize )];
    [SVProgressHUD show];
}

- (void)hideLoading {
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
    [super viewDidAppear:animated];
    
    //
    //    cellSelected = [NSMutableArray array];
    //    [self showLoading];
    //
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    //        [self retrieveData];
    //    });
    
    if (viewdisappear == true) {
        cellSelected = [NSMutableArray array];
        [self showLoading];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self retrieveData];
        });
        
    }
    
    
}


- (void)viewDidDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewDidDisappear:animated];
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
    
    viewdisappear = true;
    
}

@end
