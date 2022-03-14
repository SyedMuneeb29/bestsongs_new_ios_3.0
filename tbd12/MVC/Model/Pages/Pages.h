//
//  Pages.h
//  Bestsongs.pk
//
//  Created by Apnaweb on 4/1/17.
//  Copyright © 2017 Bestsongs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pages : NSObject

@property (nonatomic, copy, readonly) NSString *Title, *PageURL;

- (id)initWithtitle:(NSString *)title pageURL:(NSString *)pageURL;


@end
