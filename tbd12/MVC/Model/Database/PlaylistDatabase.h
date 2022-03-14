//
//  PlaylistDatabase.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 10/13/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "DBManager.h"
#import "User.h"
#import "Song.h"
#import "Playlist.h"
#import "BestsongsAPI.h"
#import "BaseController.h"
@import Firebase;
//@import FirebaseAuth;
//@import FirebaseDatabase;

@interface PlaylistDatabase : NSObject

@property (strong, nonatomic) FIRDatabaseReference *ref;

@property (nonatomic,strong)DBManager *dbManager;
@property (nonatomic,strong)NSMutableArray *columnNames;
@property (nonatomic,strong)NSString *DBName;

@property (nonatomic,strong)NSString *PlaylistTableName;
@property (nonatomic,strong)NSString *PlaylistID;
@property (nonatomic,strong)NSString *PlaylistName;
@property (nonatomic,strong)NSString *PlaylistCurrentRevision;
@property (nonatomic,strong)NSString *PlaylistBestsongID;
@property (nonatomic,strong)NSString *PlaylistTotalTracks;

@property (nonatomic,strong)NSString *TracksTableName;
@property (nonatomic,strong)NSString *TrackID;
@property (nonatomic,strong)NSString *TrackPlaylistID;
@property (nonatomic,strong)NSString *SongID;
@property (nonatomic,strong)NSString *TrackName;
@property (nonatomic,strong)NSString *Poster;
@property (nonatomic,strong)NSString *MP3URL;
@property (nonatomic,strong)NSString *VideoURL;
@property (nonatomic,strong)NSString *ShareURL;
@property (nonatomic,strong)NSString *VideoShareURL;
@property (nonatomic,strong)NSString *AlbumID;
@property (nonatomic,strong)NSString *AlbumName;
@property (nonatomic,strong)NSString *IsTrackFromBestsong;

- (void)loadDatabase;

- (void)createPlaylist:(Playlist *)playlist
        onSuccess:(void(^)(id response))successBlock
        onFailure:(void(^)(NSError * error)) failureBlock;

- (void)updatePlaylist:(Playlist *)playlist
        onSuccess:(void(^)(id response))successBlock
        onFailure:(void(^)(NSError * error)) failureBlock;

- (void)deletePlaylist:(Playlist *)playlist
        onSuccess:(void(^)(id response))successBlock
        onFailure:(void(^)(NSError * error)) failureBlock;

- (void)checkAndUpdatePlaylist:(void(^)(id response))successBlock
        onFailure:(void(^)(NSError * error)) failureBlock;

- (NSMutableArray *)getAllPlaylist;


- (void)getAllPlaylistAfterLogin:(void(^)(id response))successBlock
        onFailure:(void(^)(NSError * error)) failureBlock;

- (void)addTrack:(Playlist *)playlist
        track : (Song *)track
        onSuccess:(void(^)(id response))successBlock
        onFailure:(void(^)(NSError * error)) failureBlock;

- (void)deleteTrack:(Playlist *)playlist
        track : (Song *)track
        onSuccess:(void(^)(id response))successBlock
        onFailure:(void(^)(NSError * error)) failureBlock;

- (NSArray *)getTrack:(NSString *)trackID;
- (NSArray *)getAllTracks:(NSString *)playlistID;

- (void)removeAllData;

@end
