//
//  QueueId.h
//  Bestsongs.pk
//
//  Created by Apnaweb on 2/28/17.
//  Copyright © 2017 Bestsongs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueueId : NSObject
@property (readwrite) int count;
@property (readwrite) NSURL* url;

-(id) initWithUrl:(NSURL*)url andCount:(int)count;
@end
