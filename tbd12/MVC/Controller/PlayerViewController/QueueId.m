//
//  QueueId.m
//  Bestsongs.pk
//
//  Created by Apnaweb on 2/28/17.
//  Copyright © 2017 Bestsongs. All rights reserved.
//

#import "QueueId.h"

@implementation QueueId

-(id) initWithUrl:(NSURL*)url andCount:(int)count {
    if (self = [super init]) {
        self.url = url;
        self.count = count;
    }
    return self;
}

-(BOOL) isEqual:(id)object {
    if (object == nil) {
        return NO;
    }
    
    if ([object class] != [QueueId class]) {
        return NO;
    }
    return [((QueueId*)object).url isEqual: self.url] && ((QueueId*)object).count == self.count;
}

-(NSString*) description {
    return [self.url description];
}

@end
