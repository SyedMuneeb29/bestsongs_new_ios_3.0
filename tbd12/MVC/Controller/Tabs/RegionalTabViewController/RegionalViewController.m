//
//  RegionalViewController.m
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 8/30/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import "RegionalViewController.h"

@interface RegionalViewController () {
    NSMutableArray *regionalArray;
}

@end

@implementation RegionalViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:[[BaseController sharedInstance] getDefaultColor]];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.title = @"Regional";
    self.view.backgroundColor = [[BaseController sharedInstance] getDefaultBackgroundColor];
    
    [self.tableView setSeparatorColor:[UIColor blackColor]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0); // Makes the horizontal row seperator stretch the entire length of the table view
    }
    
    regionalArray = [[NSMutableArray alloc] initWithCapacity:5];
    
    Discover *discover = [[Discover alloc] initWithID:[NSNumber numberWithInt:1] title:@"Punjabi" permalink:@"punjabi"];
    [regionalArray addObject:discover];
    
    discover = [[Discover alloc] initWithID:[NSNumber numberWithInt:1] title:@"Balochi" permalink:@"balochi"];
    [regionalArray addObject:discover];
    
    discover = [[Discover alloc] initWithID:[NSNumber numberWithInt:1] title:@"Pashto" permalink:@"pashto"];
    [regionalArray addObject:discover];
    
    discover = [[Discover alloc] initWithID:[NSNumber numberWithInt:1] title:@"Sindhi" permalink:@"sindhi"];
    [regionalArray addObject:discover];
    
    discover = [[Discover alloc] initWithID:[NSNumber numberWithInt:1] title:@"Saraiki" permalink:@"saraiki"];
    [regionalArray addObject:discover];
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [regionalArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"RegionalCell";
    RegionalTableViewCell * cell = (RegionalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
        cell = [[RegionalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    Discover *discover = [regionalArray objectAtIndex:indexPath.section];

    [cell.banner setImage:[UIImage imageNamed:discover.Permalink]];
    cell.backgroundColor = cell.contentView.backgroundColor;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIScreen *screen = [UIScreen mainScreen];
    float height = 10.0 * regionalArray.count;
    return (screen.bounds.size.height - 110 + height) / [regionalArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(![AFNetworkReachabilityManager sharedManager].isReachable){
//        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
        [self showNoInternetAlertMessag];
        return;
    }
    Discover * selectedDiscover = [regionalArray objectAtIndex:indexPath.section];
    DiscoverMoreViewController * dmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"discoverMoreViewController"];
    dmvc.discover = selectedDiscover;
    [self.navigationController pushViewController:dmvc animated:YES];
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

-(BOOL)prefersStatusBarHidden{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated]  ;
    
    [[ NSNotificationCenter defaultCenter ] postNotificationName:@"hideHomeAdd" object:nil];
    
    [[ NSNotificationCenter defaultCenter ] postNotificationName:@"showHomeAdd" object:nil];
    
}



- (void)viewDidAppear:(BOOL)animated {
    [[PlayerViewController sharedInstance] updateControls];
    [self becomeFirstResponder];
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewDidDisappear:animated];
}

- (void)openDownload {
    ShowDownloadsViewController *showDownloadsController = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowDownloadsViewController"];
    [self.navigationController pushViewController:showDownloadsController animated:NO];
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
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self showShowOfflineAlert];
    }];
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
