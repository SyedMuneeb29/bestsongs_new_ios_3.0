//
//  Pages.m
//  Bestsongs.pk
//
//  Created by Apnaweb on 4/1/17.
//  Copyright © 2017 Bestsongs. All rights reserved.
//

#import "Pages.h"

@implementation Pages

- (id)initWithtitle:(NSString *)title pageURL:(NSString *)pageURL{
    self = [super init];
    if(self){
        _Title = title;
        _PageURL = pageURL;
    }
    return self;
}

@end
