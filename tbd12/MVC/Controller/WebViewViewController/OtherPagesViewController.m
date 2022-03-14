//
//  OtherPagesViewController.m
//  Bestsongs.pk
//
//  Created by Apnaweb on 4/4/17.
//  Copyright © 2017 Bestsongs. All rights reserved.
//

#import "OtherPagesViewController.h"

@interface OtherPagesViewController ()

@end

@implementation OtherPagesViewController


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.title = self.page.Title;
    [self showLoading];
    NSURL *url = [NSURL URLWithString:self.page.PageURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:urlRequest];
    [_webView setOpaque:NO];
    _webView.backgroundColor = [UIColor clearColor];
    _webView.alpha = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (webView.isLoading)
        return;
    
    [self hideLoading];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.5f];
    _webView.alpha = 1;
    [UIView commitAnimations];
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

- (void)viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self hideLoading];
    [self resignFirstResponder];
    [super viewDidDisappear:animated];
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
