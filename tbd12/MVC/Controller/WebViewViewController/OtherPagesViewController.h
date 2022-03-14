//
//  OtherPagesViewController.h
//  Bestsongs.pk
//
//  Created by Apnaweb on 4/4/17.
//  Copyright © 2017 Bestsongs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
#import "Pages.h"

@interface OtherPagesViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) Pages *page;

@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end
