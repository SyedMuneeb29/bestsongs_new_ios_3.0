//
//  BestsongsAPI.h
//  Bestsongs.pk
//
//  Created by Apnaweb on 2/21/17.
//  Copyright © 2017 Bestsongs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "Song.h"
#import "Album.h"
#import "Video.h"
#import "Banner.h"
#import "Artist.h"
#import "Playlist.h"
#import "Constants.h"
#import "BaseController.h"
#import "PlaylistDatabase.h"

@interface BestsongsAPI : NSObject

+ (BestsongsAPI *)sharedInstance;

- (NSMutableArray *)getBannersArrayFromJSON: (NSDictionary *)bannersArray;
- (NSMutableArray *)getAlbumsArrayFromJSON: (NSDictionary *)albumsArray;
- (NSMutableArray *)getVideosArrayFromJSON: (NSDictionary *)videosArray;
- (NSMutableArray *)getArtistsArrayFromJSON: (NSDictionary *)artistArray;
- (NSMutableArray *)getTracksArrayFromJSON: (NSDictionary *)tracksArray;
- (NSMutableArray *)getTracksArrayFromJSON: (NSDictionary *)tracksArray album:(Album *)album;
- (NSMutableArray *)getPlaylistsArrayFromJSON: (NSDictionary *)playlistsArray;

- (void)fetchHome:(void(^)(id response))successBlock
        onFailure:(void(^)(NSError * error)) failureBlock;

- (void)fetchBanner:(void(^)(id response))successBlock
        onFailure:(void(^)(NSError * error)) failureBlock;

- (void)fetchAlbumTracks:(NSNumber *)ID
        onSuccess:(void(^)(id response))successBlock
        onFailure:(void(^)(NSError * error)) failureBlock;

- (void)fetchBollywood:(NSNumber *)page
        onSuccess:(void(^)(id response))successBlock
        onFailure:(void(^)(NSError * error)) failureBlock;

- (void)fetchBollywoodAlbum:(NSString *)alphabet
        page:(NSNumber *)page
        onSuccess:(void(^)(id response))successBlock
        onFailure:(void(^)(NSError * error)) failureBlock;

- (void)fetchArtists:(NSNumber *)page
        onSuccess:(void(^)(id response))successBlock
        onFailure:(void(^)(NSError * error)) failureBlock;

- (void)fetchArtistAlbums:(NSNumber *)ID
        page:(NSNumber *)page
        onSuccess:(void(^)(id response))successBlock
        onFailure:(void(^)(NSError * error)) failureBlock;

- (void)fetchArtistAlphabet:(NSString *)alphabet
        page:(NSNumber *)page
        onSuccess:(void(^)(id response))successBlock
        onFailure:(void(^)(NSError * error)) failureBlock;

- (void)fetchMashup:(NSNumber *)page
        onSuccess:(void(^)(id response))successBlock
        onFailure:(void(^)(NSError * error)) failureBlock;

- (void)fetchPakistani:(NSNumber *)page
        onSuccess:(void(^)(id response))successBlock
        onFailure:(void(^)(NSError * error)) failureBlock;

- (void)fetchPakistaniAlbum:(NSString *)alphabet
        page:(NSNumber *)page
        onSuccess:(void(^)(id response))successBlock
        onFailure:(void(^)(NSError * error)) failureBlock;

- (void)fetchDiscover:(NSString *)permalink
        page:(NSNumber *)page
        onSuccess:(void(^)(id response))successBlock
        onFailure:(void(^)(NSError * error)) failureBlock;

- (void)getSearchResult:(NSString *)text
        onSuccess:(void(^)(id response))successBlock
        onFailure:(void(^)(NSError * error)) failureBlock;

- (void)fetchVideo:(NSString *)permalink
        onSuccess:(void(^)(id response))successBlock
        onFailure:(void(^)(NSError * error)) failureBlock;

- (void)fetchAlbum:(NSString *)permalink
         onSuccess:(void(^)(id response))successBlock
         onFailure:(void(^)(NSError * error)) failureBlock;

- (void)fetchPlaylistTracks:(NSString *)bestsongID
         onSuccess:(void(^)(id response))successBlock
         onFailure:(void(^)(NSError * error)) failureBlock;

- (void)createPlaylist:(NSString *)playlistName
        onSuccess:(void(^)(id response))successBlock
        onFailure:(void(^)(NSError * error)) failureBlock;

- (void)updatePlaylist:(NSString *)bestsongID
        playlistName:(NSString *)playlistName
        onSuccess:(void(^)(id response))successBlock
        onFailure:(void(^)(NSError * error)) failureBlock;

- (void)deletePlaylist:(NSString *)bestsongID
        onSuccess:(void(^)(id response))successBlock
        onFailure:(void(^)(NSError * error)) failureBlock;

- (void)fetchPlaylists:(void(^)(id response))successBlock
        onFailure:(void(^)(NSError * error)) failureBlock;

- (void)addTrackToPlaylist:(NSString *)bestsongID
        trackID : (NSString *)trackID
        onSuccess:(void(^)(id response))successBlock
        onFailure:(void(^)(NSError * error)) failureBlock;

- (void)deleteTrackFromPlaylist:(NSString *)bestsongID
        trackID : (NSString *)trackID
        onSuccess:(void(^)(id response))successBlock
        onFailure:(void(^)(NSError * error)) failureBlock;

- (void)likeTrack:(NSString *)trackID
        onSuccess:(void(^)(id response))successBlock
        onFailure:(void(^)(NSError * error)) failureBlock;

- (void)unLikeTrack:(NSString *)trackID
        onSuccess:(void(^)(id response))successBlock
        onFailure:(void(^)(NSError * error)) failureBlock;

- (void)createUser:(User *)user
        onSuccess:(void(^)(id response))successBlock
        onFailure:(void(^)(NSError * error)) failureBlock;

- (void)createShareLink:(NSString *)title
        message:(NSString *)message
        posterURL:(NSString *)posterURL
        link:(NSString *)link
        onSuccess:(void(^)(id response))successBlock
        onFailure:(void(^)(NSError * error)) failureBlock;

@end
