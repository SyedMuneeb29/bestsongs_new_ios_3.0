//
//  AddToPlaylistPopupViewController.m
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 10/7/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import "AddToPlaylistPopupViewController.h"

@interface AddToPlaylistPopupViewController (){
    NSMutableArray *playlists;
    PlaylistDatabase *playlistDB;
}

@end

@implementation AddToPlaylistPopupViewController

+ (instancetype)instantiateFromNib {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"%@", [self class]] owner:nil options:nil];
    return [views firstObject];
}

- (IBAction)saveButton:(id)sender {
    if(![AFNetworkReachabilityManager sharedManager].isReachable){
        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
        return;
    }
    [self dismissKeyboard];
    NSString *title = self.txtName.text;
    [[BaseController sharedInstance] setupLoading];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    int screenSize =(int)[[UIScreen mainScreen] nativeBounds].size.height / 36;
    
    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, (CGFloat)screenSize )];
    [SVProgressHUD show];
    playlistDB = [[PlaylistDatabase alloc] init];
    [playlistDB loadDatabase];
    Playlist *playlist = [[Playlist alloc] initWithID:0 bestsongID:0 totalTracks:0 currentRevision:0 title:title];
    [playlistDB createPlaylist:playlist onSuccess:^(id response) {
        [SVProgressHUD dismiss];
        [[BaseController sharedInstance] showToastSuccess:@"Playlist Successfully Created."];
        [self.txtName setText:@""];
        [UIView animateWithDuration:0.3 animations:^{
            self.createPlaylistView.alpha = 0;
        } completion: ^(BOOL finished) {
            self.createPlaylistView.hidden = finished;
        }];
        [self getData];
    } onFailure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [[BaseController sharedInstance] showToastError:error.localizedDescription];
    }];
}

- (IBAction)cancelButton:(id)sender {
    [self dismissKeyboard];
    [UIView animateWithDuration:0.3 animations:^{
        self.createPlaylistView.alpha = 0;
    } completion: ^(BOOL finished) {
        self.createPlaylistView.hidden = finished;
    }];
}

-(void)loadData {
    [self.saveBtn.layer setBorderWidth:1.0];
    [self.saveBtn.layer setCornerRadius:20.0];
    [self.saveBtn.layer setBorderColor:[[UIColor clearColor] CGColor]];
    
    [self.txtName.layer setBorderWidth:1.0];
    [self.txtName.layer setCornerRadius:20.0];
    [self.txtName.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    [self.cancelBtn.layer setBorderWidth:1.0];
    [self.cancelBtn.layer setCornerRadius:20.0];
    [self.cancelBtn.layer setBorderColor:[[UIColor clearColor] CGColor]];
    
    self.createPlaylistView.alpha = 0;
    self.createPlaylistView.hidden = YES;
    
    self.txtName.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.createPlaylistView addGestureRecognizer:tap];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0); // Makes the horizontal row seperator stretch the entire length of the table view
    }
    
    playlistDB = [[PlaylistDatabase alloc]init];
    [playlistDB loadDatabase];
    
    [self getData];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [playlistDB checkAndUpdatePlaylist:^(id response) {
            [self getData];
        } onFailure:^(NSError *error) {
        }];
    });
}

- (void)dismissKeyboard {
    [self.txtName resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)getData{
    if(playlists != nil)
        playlists = nil;
    playlists = [[NSMutableArray alloc]initWithArray:[playlistDB getAllPlaylist]];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return playlists.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    Playlist *playlist = [playlists objectAtIndex:indexPath.row];
    
    cell.textLabel.text = playlist.Title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Total Tracks %@",playlist.TotalTracks];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(![AFNetworkReachabilityManager sharedManager].isReachable){
        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
        return;
    }
    Playlist *playlist = [playlists objectAtIndex:indexPath.row];
    
    [[BaseController sharedInstance] setupLoading];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    playlistDB = [[PlaylistDatabase alloc] init];
    [playlistDB loadDatabase];
    __weak AddToPlaylistPopupViewController *weakPlaylist = self;
    [playlistDB addTrack:playlist track:self.song onSuccess:^(id response) {
        [SVProgressHUD dismiss];
        [[BaseController sharedInstance] showToastSuccess:@"Track Successfully Added to Playlist"];
        [weakPlaylist popupCloseButton:nil];
    } onFailure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [[BaseController sharedInstance] showToastError:error.localizedDescription];
    }];
}

- (IBAction)popupCloseButton:(id)sender {
    [self dismissKeyboard];
    [self.popupController dismissPopupControllerAnimated:YES];
}

- (IBAction)createNewPlaylist:(id)sender {
    self.createPlaylistView.alpha = 0;
    self.createPlaylistView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.createPlaylistView.alpha = 1;
    }];
}

@end
