//
//  DBManager.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 10/13/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject

@property (strong, nonatomic)NSMutableArray *arrColumnNames;
@property (nonatomic)int affectedRows;
@property (nonatomic) long long lastInsertedRowID;

- (instancetype)initWithDatabaseName:(NSString *)dbFilename;

- (NSArray *)loadDataFromDB:(NSString *)query;

- (void)executeQuery:(NSString *)query;

@end
