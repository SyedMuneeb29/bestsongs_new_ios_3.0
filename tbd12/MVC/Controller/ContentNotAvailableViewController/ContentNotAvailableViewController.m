//
//  ContentNotAvailableViewController.m
//  Bestsongs.pk
//
//  Created by IMac on 28/04/2018.
//  Copyright © 2018 Bestsongs. All rights reserved.
//

#import "ContentNotAvailableViewController.h"
#import "ShowDownloadsViewController.h"

@interface ContentNotAvailableViewController ()

@property (nonatomic, strong) ShowDownloadsViewController *downloadsView;




@end

@implementation ContentNotAvailableViewController





- (void)viewDidLoad {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"videoViewIsDisplayed" object:nil];
    
    [self.moreInfoBtn.layer setBorderWidth:1.0];
    [self.moreInfoBtn.layer setCornerRadius:20.0];
    [self.moreInfoBtn.layer setBorderColor:[[UIColor clearColor] CGColor]];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat width = screenRect.size.width;
    
    UIFont *font = _lblOfContentNotAvailableDescription.font;
    
     //    float fontSize = width * 0.04;
    
    if (width > 450){

        _lblOfContentNotAvailableDescription.font = [font fontWithSize:25];
        _leadingConstraintOfDescription.constant = 80;
        _trailingConstraintOfDescription.constant = 80;


        _lblContentNotAvailableContactDetail.font = [font fontWithSize:23];
        _leadingConstraintOfContactDetail.constant = 120;
        _trailingConstraintOfContactDetail.constant = 120;
        
        
        
        _bestSongsLogoLeadingConsraint.constant = 120;
        _bestSongsLogoTrailingConstraint.constant = 120;
        _bestSongsLogoTopConstraint.constant = 10;
        _bestSongsLogoBottomConstraint.constant = -10;
    }

    if (width < 340){

        _lblOfContentNotAvailableDescription.font = [font fontWithSize:10];



        _lblContentNotAvailableContactDetail.font = [font fontWithSize:12];


    }

    
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[ NSNotificationCenter defaultCenter ] postNotificationName:@"hideHomeAdd" object:nil];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) openDownload {
    
    
    
    self.downloadsView = [[ShowDownloadsViewController alloc] init];
    
    [self presentViewController:self.downloadsView animated:YES completion:nil];
    
    
    
    
}



- (IBAction)ShowOfflineSongs:(UIButton *)sender {
    
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"bestsongs.pk" message:@"Dear User, Bestsongs.pk is only available and accessible from Pakistan if you are in Pakistan and you are facing this issue please make sure you are not connected to any VPN and your WiFi provider is also not connected to any VPN - Try using Bestsongs.pk through your Mobile Data Connnection if your WiFi provider is using VPN ." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
    
    
    UIAlertAction *refreshButton = [UIAlertAction actionWithTitle:@"Refresh" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        [[self presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        
        
        
    }];
    
    
    [alert addAction:okButton];
    [alert addAction:refreshButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
    //    self.addToContentNotAvailablePopupViewController = [[ShowDownloadsViewController alloc] init];
    //
    //    [self presentViewController:_addToContentNotAvailablePopupViewController animated:YES completion:nil];
    
    
}



- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
