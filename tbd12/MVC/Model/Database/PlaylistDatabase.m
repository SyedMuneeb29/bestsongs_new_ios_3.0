//
//  PlaylistDatabase.m
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 10/13/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import "PlaylistDatabase.h"

@implementation PlaylistDatabase{
    NSString *baseURL;
    NSString *playlistURL;
    NSString *playlistEntriesURL;
}

- (void)loadVaraibles{
    self.DBName = @"bestsongsDB.sql";
    /************************************
                  Playlist
     ************************************/
    self.PlaylistTableName = @"playlist";
    self.PlaylistID = @"id";
    self.PlaylistName = @"name";
    self.PlaylistCurrentRevision = @"currentRevision";
    self.PlaylistBestsongID = @"bestsongID";
    self.PlaylistTotalTracks = @"totalTracks";
    
    /************************************
                 Tracks
     ************************************/
    self.TracksTableName = @"playlistTracks";
    self.TrackID = @"id";
    self.TrackPlaylistID = @"playlistID";
    self.SongID = @"trackID";
    self.TrackName = @"title";
    self.Poster = @"poster";
    self.MP3URL = @"mp3";
    self.VideoURL = @"videoUrl";
    self.ShareURL = @"shareUrl";
    self.VideoShareURL = @"videoShareUrl";
    self.AlbumID = @"albumID";
    self.AlbumName = @"albumName";
    self.IsTrackFromBestsong = @"isTrackFromBestsong";
    baseURL = @"https://bestsongs-156307.appspot.com/";
    playlistURL = @"v1/playlists";
    playlistEntriesURL = @"v1/playlistentries";
}

- (void)loadDatabase{
    [self loadVaraibles];
    //self.ref = [[FIRDatabase database] reference];
    self.dbManager = [[DBManager alloc] initWithDatabaseName:self.DBName];
}

/************************************
                Playlist
 ************************************/

- (void)createPlaylist:(Playlist *)playlist
        onSuccess:(void (^)(id))successBlock
        onFailure:(void (^)(NSError *))failureBlock{
    @try {
        if([playlist.Title isEqualToString:@""]){
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Playlist Name Required." };
            NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
            failureBlock(error);
            return;
        }
        if([self checkAlreadyExists:@"" title:playlist.Title] > 0){
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Playlist Name Already Exists" };
            NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
            failureBlock(error);
            return;
        }
        [[BestsongsAPI sharedInstance] createPlaylist:playlist.Title
            onSuccess:^(id response) {
                if ([response isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dataDictionary = (NSDictionary *) response;
                    NSDictionary *responseData = [dataDictionary objectForKey:@"playlists"];
                    for (NSDictionary *data in responseData){
                        NSNumber *bestsongID = [data objectForKey:@"id"] == NULL ? [NSNumber numberWithInt:0] : @([[data objectForKey:@"id"] integerValue]);
                        if([bestsongID intValue] > 0){
                            Playlist *newPlaylist = [[Playlist alloc] initWithID:0 bestsongID:bestsongID totalTracks:playlist.TotalTracks currentRevision:playlist.CurrentRevision title:playlist.Title];
                            int r = [self createPlaylist:newPlaylist];
                            if (r > 0) {
                                successBlock(response);
                            } else{
                                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Error Occured While Creating Playlist. Try Again Later.." };
                                NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
                                failureBlock(error);
                            }
                            return;
                        }
                    }
                    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Error Occured While Creating Playlist. Try Again Later.." };
                    NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
                    failureBlock(error);
                } else{
                    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Error Occured While Creating Playlist. Try Again Later.." };
                    NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
                    failureBlock(error);
                }
        } onFailure:^(NSError *error) {
            failureBlock(error);
        }];
    } @catch (NSException *exception) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
        failureBlock(error);
    } @finally {
    }
}

- (int)createPlaylist:(Playlist *)playlist{
    NSString *title = playlist.Title;
    title = [title stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    NSString *currentRevision = [NSString stringWithFormat:@"%@",playlist.CurrentRevision];
    NSString *bestsongID = [NSString stringWithFormat:@"%@",playlist.BestsongID];
    int totalTracks = [playlist.TotalTracks intValue];
    NSString *query = [[NSString alloc]initWithFormat:@"INSERT INTO %@ (%@,%@,%@,%@) VALUES ('%@','%@','%@',%d)",self.PlaylistTableName,self.PlaylistName,self.PlaylistCurrentRevision,self.PlaylistBestsongID,self.PlaylistTotalTracks,title,currentRevision,bestsongID,totalTracks];
    [self.dbManager executeQuery:query];
    return (int)[self.dbManager lastInsertedRowID];
}

- (void)updatePlaylist:(Playlist *)playlist
        onSuccess:(void (^)(id))successBlock
        onFailure:(void (^)(NSError *))failureBlock{
    @try {
        if(!([playlist.ID intValue] > 0)){
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Playlist Doesnot Exists." };
            NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
            failureBlock(error);
            return;
        }
        if([playlist.Title isEqualToString:@""]){
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Playlist Name Required." };
            NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
            failureBlock(error);
            return;
        }
        if([self checkAlreadyExists:[NSString stringWithFormat:@"%@",playlist.ID] title:playlist.Title] > 0){
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Playlist Name Already Exists" };
            NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
            failureBlock(error);
            return;
        }
        [[BestsongsAPI sharedInstance] updatePlaylist:[NSString stringWithFormat:@"%@",playlist.BestsongID] playlistName:playlist.Title onSuccess:^(id response) {
            int currentRevision = [playlist.CurrentRevision intValue];
            currentRevision++;
            Playlist *updatePlaylist = [[Playlist alloc] initWithID:playlist.ID bestsongID:playlist.BestsongID totalTracks:playlist.TotalTracks currentRevision:[NSNumber numberWithInt:currentRevision] title:playlist.Title];
            int r = [self updatePlaylist:updatePlaylist];
            if(r > 0){
                successBlock(response);
            } else {
                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Error Occured While Updating Playlist Title. Try Again Later.." };
                NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
                failureBlock(error);
            }
        } onFailure:^(NSError *error) {
            failureBlock(error);
        }];
    } @catch (NSException *exception) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
        failureBlock(error);
    } @finally {
    }
}

- (int)updatePlaylist:(Playlist *)playlist {
    NSString *playlistID = [NSString stringWithFormat:@"%@",playlist.ID];
    NSString *title = playlist.Title;
    title = [title stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    NSString *currentRevision = [NSString stringWithFormat:@"%@",playlist.CurrentRevision];
    
    NSString *query = [[NSString alloc]initWithFormat:@"UPDATE %@ SET %@ = '%@' , %@ = '%@' , %@ = %i WHERE %@ = '%@'",self.PlaylistTableName,self.PlaylistName,title,self.PlaylistCurrentRevision,currentRevision,self.PlaylistTotalTracks,[playlist.TotalTracks intValue],self.PlaylistID,playlistID];
    [self.dbManager executeQuery:query];
    return [self.dbManager affectedRows];
}

- (void)deletePlaylist:(Playlist *)playlist
        onSuccess:(void (^)(id))successBlock
        onFailure:(void (^)(NSError *))failureBlock{
    @try {
        if(!([playlist.ID intValue] > 0)){
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Playlist Doesnot Exists." };
            NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
            failureBlock(error);
            return;
        }
        if([self checkAlreadyExists:[NSString stringWithFormat:@"%@",playlist.ID] title:@""] > 0){
            [[BestsongsAPI sharedInstance] deletePlaylist:[NSString stringWithFormat:@"%@",playlist.BestsongID] onSuccess:^(id response) {
                int r = [self deletePlaylist:playlist];
                if(r > 0){
                    successBlock(response);
                } else {
                    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Playlist Already Deleted." };
                    NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
                    failureBlock(error);
                }
            } onFailure:^(NSError *error) {
                failureBlock(error);
            }];
        } else {
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Playlist Already Deleted." };
            NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
            failureBlock(error);
        }
    } @catch (NSException *exception) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
        failureBlock(error);
    } @finally {
    }
}

- (int)deletePlaylist:(Playlist *)playlist {
    NSString *playlistID = [NSString stringWithFormat:@"%@",playlist.ID];
    NSString *query = [[NSString alloc]initWithFormat:@"DELETE FROM %@ WHERE %@ = '%@'",self.TracksTableName, self.TrackPlaylistID, playlistID];
    [self.dbManager executeQuery:query];
    query = [[NSString alloc]initWithFormat:@"DELETE FROM %@ WHERE %@ = '%@'",self.PlaylistTableName, self.PlaylistID, playlistID];
    [self.dbManager executeQuery:query];
    return [self.dbManager affectedRows];
}

- (NSUInteger)checkAlreadyExists:(NSString *)playlistID title:(NSString *)title{
    NSString *query;
    if([playlistID isEqualToString:@""] || playlistID.length <= 0){
       query = [[NSString alloc]initWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'",self.PlaylistTableName,self.PlaylistName,title];
    } else if([title isEqualToString:@""] || title.length <= 0){
        query = [[NSString alloc]initWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'",self.PlaylistTableName,self.PlaylistID,playlistID];
    } else {
        query = [[NSString alloc]initWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@' AND %@ != '%@'",self.PlaylistTableName,self.PlaylistName,title,self.PlaylistID,playlistID];
    }
    NSArray *playlist = [[NSArray alloc]initWithArray:[self.dbManager loadDataFromDB:query]];
    return playlist.count;
}

- (Playlist *)getPlaylist:(NSString *)ID isBestsongID:(BOOL)isBestsongID{
    
    
    
    NSString *query = [[NSString alloc]initWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'",self.PlaylistTableName,self.PlaylistID,ID];
    if(isBestsongID)
        query = [[NSString alloc]initWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'",self.PlaylistTableName,self.PlaylistBestsongID,ID];
    
    NSArray *array = [[NSArray alloc]initWithArray:[self.dbManager loadDataFromDB:query]];
    self.columnNames = [[NSMutableArray alloc]initWithArray:self.dbManager.arrColumnNames];
    
    if(array.count > 0){
        NSNumber *playlistID = [NSNumber numberWithInt:[[[array objectAtIndex:0] objectAtIndex:[self.columnNames indexOfObject:self.PlaylistID]] intValue]];
        NSNumber *bestsongID = [NSNumber numberWithInt:[[[array objectAtIndex:0] objectAtIndex:[self.columnNames indexOfObject:self.PlaylistBestsongID]] intValue]];
        NSNumber *totalTracks = [NSNumber numberWithInt:[[[array objectAtIndex:0] objectAtIndex:[self.columnNames indexOfObject:self.PlaylistTotalTracks]] intValue]];
        NSNumber *currentRevision = [NSNumber numberWithInt:[[[array objectAtIndex:0] objectAtIndex:[self.columnNames indexOfObject:self.PlaylistCurrentRevision]] intValue]];
        NSString *title = [NSString stringWithFormat:@"%@",[[array objectAtIndex:0] objectAtIndex:[self.columnNames indexOfObject:self.PlaylistName]]];
        
        Playlist *playlist = [[Playlist alloc] initWithID:playlistID bestsongID:bestsongID totalTracks:totalTracks currentRevision:currentRevision title:title];
        return playlist;
    } else{
        Playlist *playlist = nil;
        return playlist;
    }
}

//- (NSArray *)getPlaylistByBestsongID:(NSString *)bestsongID{
//    NSString *query = [[NSString alloc]initWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'",self.PlaylistTableName,self.PlaylistBestsongID,bestsongID];
//    NSArray *playlistDetails = [[NSArray alloc]initWithArray:[self.dbManager loadDataFromDB:query]];
//    self.columnNames = [[NSMutableArray alloc]initWithArray:self.dbManager.arrColumnNames];
//    return playlistDetails;
//}

//- (NSArray *)getPlaylist:(NSString *)playlistID{
//    NSString *query = [[NSString alloc]initWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'",self.PlaylistTableName,self.PlaylistID,playlistID];
//    NSArray *playlistDetails = [[NSArray alloc]initWithArray:[self.dbManager loadDataFromDB:query]];
//    self.columnNames = [[NSMutableArray alloc]initWithArray:self.dbManager.arrColumnNames];
//    return playlistDetails;
//}

- (NSMutableArray *)getAllPlaylist{
    NSMutableArray *playlists = [[NSMutableArray alloc] init];
    NSString *query = [[NSString alloc]initWithFormat:@"SELECT * FROM %@",self.PlaylistTableName];
    NSArray *array = [[NSArray alloc]initWithArray:[self.dbManager loadDataFromDB:query]];
    self.columnNames = [[NSMutableArray alloc]initWithArray:self.dbManager.arrColumnNames];
    
    for (int i = 0; i < array.count; i++) {
        NSNumber *ID = [NSNumber numberWithInt:[[[array objectAtIndex:i] objectAtIndex:[self.columnNames indexOfObject:self.PlaylistID]] intValue]];
        NSNumber *bestsongID = [NSNumber numberWithInt:[[[array objectAtIndex:i] objectAtIndex:[self.columnNames indexOfObject:self.PlaylistBestsongID]] intValue]];
        NSNumber *totalTracks = [NSNumber numberWithInt:[[[array objectAtIndex:i] objectAtIndex:[self.columnNames indexOfObject:self.PlaylistTotalTracks]] intValue]];
        NSNumber *currentRevision = [NSNumber numberWithInt:[[[array objectAtIndex:i] objectAtIndex:[self.columnNames indexOfObject:self.PlaylistCurrentRevision]] intValue]];
        NSString *title = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectAtIndex:[self.columnNames indexOfObject:self.PlaylistName]]];
        
        Playlist *playlist = [[Playlist alloc] initWithID:ID bestsongID:bestsongID totalTracks:totalTracks currentRevision:currentRevision title:title];
        [playlists addObject:playlist];
    }
    return playlists;
}

- (void)getAllPlaylistAfterLogin:(void (^)(id))successBlock
                       onFailure:(void (^)(NSError *))failureBlock{
    @try {
        [self removeAllData];
        [[BestsongsAPI sharedInstance] fetchPlaylists:^(id response) {
            if ([response isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dataDictionary = (NSDictionary *) response;
                NSMutableArray *playlistArray = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getPlaylistsArrayFromJSON:[dataDictionary objectForKey:@"playlists"]]];
                for (int i = 0; i < playlistArray.count; i++) {
                    Playlist *playlist = [playlistArray objectAtIndex:i];
                    int playlistID = [self createPlaylist:playlist];
                    if(playlistID > 0){
                        [[BestsongsAPI sharedInstance] fetchPlaylistTracks:[NSString stringWithFormat:@"%@",playlist.BestsongID] onSuccess:^(id response) {
                            NSDictionary *trackDictionary = (NSDictionary *) response;
                            Album *album = [[Album alloc] initWithID:[NSNumber numberWithInteger:0] title:playlist.Title poster:@"" permalink:@""];
                            NSMutableArray *tracks = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getTracksArrayFromJSON:trackDictionary[@"tracks"] album:album]];
                            for (int j = 0; j < tracks.count; j++) {
                                Song *track = [tracks objectAtIndex:j];
                                [self addPlaylistTrack:[NSString stringWithFormat:@"%d",playlistID] track:track isTrackFromBestsong:[NSString stringWithFormat:@"YES"]];
                            }
                        } onFailure:^(NSError *error) {
                        }];
                    }
                }
                successBlock(response);
                
                
            } else {
                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Error Occured While Creating Playlist. Try Again Later.." };
                NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
                failureBlock(error);
            }
        } onFailure:^(NSError *error) {
            failureBlock(error);
        }];
    } @catch (NSException *exception) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
        failureBlock(error);
    } @finally {
    }
}

- (void)checkAndUpdatePlaylist:(void (^)(id))successBlock
        onFailure:(void (^)(NSError *))failureBlock{
    @try {
        [[BestsongsAPI sharedInstance] fetchPlaylists:^(id response) {
            if ([response isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dataDictionary = (NSDictionary *) response;
                NSMutableArray *playlistArray = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getPlaylistsArrayFromJSON:[dataDictionary objectForKey:@"playlists"]]];
                if(playlistArray.count <= 0){
                    [self removeAllData];
                } else{
                    for (int i = 0; i < playlistArray.count; i++) {
                        Playlist *playlist = [playlistArray objectAtIndex:i];
                        Playlist *oldPlaylist = [self getPlaylist:[NSString stringWithFormat:@"%@",playlist.BestsongID] isBestsongID:YES];
                        if(oldPlaylist != nil){
                            if(playlist.CurrentRevision != oldPlaylist.CurrentRevision){
                                [self deletePlaylist:oldPlaylist];
                                int playlistID = [self createPlaylist:playlist];
                                if(playlistID > 0){
                                    [[BestsongsAPI sharedInstance] fetchPlaylistTracks:[NSString stringWithFormat:@"%@",playlist.BestsongID] onSuccess:^(id response) {
                                        NSDictionary *trackDictionary = (NSDictionary *) response;
                                        Album *album = [[Album alloc] initWithID:[NSNumber numberWithInteger:0] title:playlist.Title poster:@"" permalink:@""];
                                        NSMutableArray *tracks = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getTracksArrayFromJSON:trackDictionary[@"tracks"] album:album]];
                                        for (int j = 0; j < tracks.count; j++) {
                                            Song *track = [tracks objectAtIndex:j];
                                            [self addPlaylistTrack:[NSString stringWithFormat:@"%d",playlistID] track:track isTrackFromBestsong:[NSString stringWithFormat:@"YES"]];
                                        }
                                    } onFailure:^(NSError *error) {
                                    }];
                                }
                            }
                        } else {
                            int playlistID = [self createPlaylist:playlist];
                            if(playlistID > 0){
                                [[BestsongsAPI sharedInstance] fetchPlaylistTracks:[NSString stringWithFormat:@"%@",playlist.BestsongID] onSuccess:^(id response) {
                                    NSDictionary *trackDictionary = (NSDictionary *) response;
                                    Album *album = [[Album alloc] initWithID:[NSNumber numberWithInteger:0] title:playlist.Title poster:@"" permalink:@""];
                                    NSMutableArray *tracks = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getTracksArrayFromJSON:trackDictionary[@"tracks"] album:album]];
                                    for (int j = 0; j < tracks.count; j++) {
                                        Song *track = [tracks objectAtIndex:j];
                                        [self addPlaylistTrack:[NSString stringWithFormat:@"%d",playlistID] track:track isTrackFromBestsong:[NSString stringWithFormat:@"YES"]];
                                    }
                                } onFailure:^(NSError *error) {
                                }];
                            }
                        }
                    }
                    // Delete Playlist Condition Here
                    NSMutableArray *playlists = [[NSMutableArray alloc]initWithArray:[self getAllPlaylist]];
                    for (int i =0; i < playlists.count; i++) {
                        Playlist *playlist = [playlists objectAtIndex:i];
                        NSPredicate *pred = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"BestsongID = %@",playlist.BestsongID]];
                        
                        NSArray *matches = [playlistArray filteredArrayUsingPredicate:pred];
                        if(matches.count <= 0){
                            [self deletePlaylist:playlist];
                        }
                    }
                }
                successBlock(response);
            }
        } onFailure:^(NSError *error) {
            failureBlock(error);
        }];
    } @catch (NSException *exception) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Exception While Getting Updated Playlists :: %@",exception.description] };
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
        failureBlock(error);
    } @finally {
    }
}

/************************************
                Tracks
 ************************************/
- (void)addTrack:(Playlist *)playlist
        track:(Song *)track
        onSuccess:(void (^)(id))successBlock
        onFailure:(void (^)(NSError *))failureBlock{
    @try {
        if(!([playlist.ID intValue] > 0)){
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Playlist Doesnot exists." };
            NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
            failureBlock(error);
            return;
        }
        if([track.ID intValue] <= 0){
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Track Cannot exists." };
            NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
            failureBlock(error);
            return;
        }
        if([self checkTrackAlreadyExists:[NSString stringWithFormat:@"%@",playlist.ID] trackID:[NSString stringWithFormat:@"%@",track.ID]] > 0) {
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Track Already Exists in Playlist." };
            NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
            failureBlock(error);
            return;
        }
        
        [[BestsongsAPI sharedInstance] addTrackToPlaylist:[NSString stringWithFormat:@"%@",playlist.BestsongID] trackID:[NSString stringWithFormat:@"%@",track.ID] onSuccess:^(id response) {
            int r = [self addPlaylistTrack:[NSString stringWithFormat:@"%@",playlist.ID] track:track isTrackFromBestsong:@"YES"];
            if(r > 0 ){
                int totalTracks = [playlist.TotalTracks intValue];
                totalTracks++;
                int currentRevision = [playlist.CurrentRevision intValue];
                currentRevision++;
                
                Playlist *updatePlaylist = [[Playlist alloc] initWithID:playlist.ID bestsongID:playlist.BestsongID totalTracks:[NSNumber numberWithInt:totalTracks] currentRevision:[NSNumber numberWithInt:currentRevision] title:playlist.Title];
                [self updatePlaylist:updatePlaylist];
                successBlock(response);
            } else {
                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Error Occured While Adding Track in Playlist. Try Again Later.." };
                NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
                failureBlock(error);
            }
        } onFailure:^(NSError *error) {
            failureBlock(error);
        }];
        
    } @catch (NSException *exception) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
        failureBlock(error);
    } @finally {
    }
}

- (int)addPlaylistTrack:(NSString *)playlistID
                  track:(Song *)track
   isTrackFromBestsong : (NSString *)isTrackFromBestsong {
    NSString *title = track.Title;
    title = [title stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    
    NSString *albumTitle = track.AlbumTitle;
    albumTitle = [albumTitle stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    
    NSString *poster = track.Poster;
    poster = [poster stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    
    NSString *audioURL = track.AudioURL;
    audioURL = [audioURL stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    
    NSString *videoURL = track.VideoURL;
    videoURL = [videoURL stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    
    NSString *permalink = track.Permalink;
    permalink = [permalink stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    
    NSString *videoPermalink = track.VideoPermalink;
    videoPermalink = [videoPermalink stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    
    NSString *query = [[NSString alloc]initWithFormat:@"INSERT INTO %@ (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",self.TracksTableName,self.TrackPlaylistID,self.SongID,self.TrackName,self.Poster,self.MP3URL,self.VideoURL,self.ShareURL,self.VideoShareURL,self.AlbumID,self.AlbumName,self.IsTrackFromBestsong,playlistID,[NSString stringWithFormat:@"%@",track.ID],title,poster,audioURL,videoURL,permalink,videoPermalink,[NSString stringWithFormat:@"%@",track.AlbumID],albumTitle,isTrackFromBestsong];
    [self.dbManager executeQuery:query];
    return [self.dbManager affectedRows];
}

- (NSUInteger)checkTrackAlreadyExists:(NSString *)playlistID trackID:(NSString *)trackID{
    
    NSString *query = [[NSString alloc]initWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@' AND %@ = '%@'",self.TracksTableName,self.SongID,trackID,self.TrackPlaylistID,playlistID];
    
    
//    NSString *query = [[NSString alloc]initWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@' ",self.TracksTableName,self.SongID,trackID];
    NSArray *playlist = [[NSArray alloc]initWithArray:[self.dbManager loadDataFromDB:query]];
    
//    NSInteger total_count;
//
//
//    NSString *querys;
//    NSArray *playlists;
//
//    if(playlist.count <= 0)
//    {
//
//        querys = [[NSString alloc]initWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'",self.TracksTableName,self.SongID,trackID];
//        playlists = [[NSArray alloc]initWithArray:[self.dbManager loadDataFromDB:querys]];
//
//        total_count = playlists.count;
//    }
//    else
//    {
//        total_count = playlist.count;
//    }
//
//    printf("Test2");
//    printf("%ld", (long)total_count);
    
    return playlist.count;
    
//    playlists = nil;
//    playlist = nil;
}

- (void)deleteTrack:(Playlist *)playlist
        track:(Song *)track
        onSuccess:(void (^)(id))successBlock
        onFailure:(void (^)(NSError *))failureBlock{
    @try {
        if(!([playlist.ID intValue] > 0)){
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Playlist Doesnot exists." };
            NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
            failureBlock(error);
            return;
        }
        if([track.ID intValue] <= 0){
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Track Doesnot exists." };
            NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
            failureBlock(error);
            return;
        }
        [[BestsongsAPI sharedInstance] deleteTrackFromPlaylist:[NSString stringWithFormat:@"%@",playlist.BestsongID] trackID:[NSString stringWithFormat:@"%@",track.ID] onSuccess:^(id response) {
            int r = [self deleteTrack:[NSString stringWithFormat:@"%@",playlist.ID] trackID:[NSString stringWithFormat:@"%@",track.ID]];
            if(r >= 0 ){
                Playlist *playlistDetails = [self getPlaylist:[NSString stringWithFormat:@"%@",playlist.ID] isBestsongID:NO];
                int totalTracks = [playlistDetails.TotalTracks intValue];
                totalTracks--;
                int currentRevision = [playlistDetails.CurrentRevision intValue];
                currentRevision++;
                Playlist *updatePlaylist = [[Playlist alloc] initWithID:playlist.ID bestsongID:playlist.BestsongID totalTracks:[NSNumber numberWithInt:totalTracks] currentRevision:[NSNumber numberWithInt:currentRevision] title:playlist.Title];
                [self updatePlaylist:updatePlaylist];
                successBlock(response);
            } else {
                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Error Occured While Deleting Track from Playlist. Try Again Later.." };
                NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
                failureBlock(error);
            }
        } onFailure:^(NSError *error) {
            failureBlock(error);
        }];
    } @catch (NSException *exception) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
        NSError *error = [NSError errorWithDomain:@"pk.bestsongs" code:-101 userInfo:userInfo];
        failureBlock(error);
    } @finally {
    }
}

- (int)deleteTrack:(NSString *)playlistID trackID:(NSString *)trackID{
    NSString *query = [[NSString alloc] initWithFormat:@"DELETE FROM %@ WHERE %@ = '%@' AND %@ = '%@'",self.TracksTableName,self.SongID,trackID,self.TrackPlaylistID,playlistID];
    [self.dbManager executeQuery:query];
    return [self.dbManager affectedRows];
}

-(NSArray *)getTrack:(NSString *)trackID{
    NSString *query = [[NSString alloc]initWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'",self.TracksTableName,self.SongID,trackID];
    return [[NSArray alloc]initWithArray:[self.dbManager loadDataFromDB:query]];
}

-(NSArray *)getTrack:(NSString *)trackID playlistID:(NSString *)playlistID{
    NSString *query = [[NSString alloc]initWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@' AND %@ = '%@'",self.TracksTableName,self.SongID,trackID,self.TrackPlaylistID,playlistID];
    return [[NSArray alloc]initWithArray:[self.dbManager loadDataFromDB:query]];
}

-(NSArray *)getAllTracks:(NSString *)playlistID{
    NSString *query = [[NSString alloc]initWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'",self.TracksTableName,self.TrackPlaylistID,playlistID];
    NSArray *array = [[NSArray alloc]initWithArray:[self.dbManager loadDataFromDB:query]];
    self.columnNames = [[NSMutableArray alloc]initWithArray:self.dbManager.arrColumnNames];
    return array;
}

- (void)removeAllData{
    NSString *query = [[NSString alloc]initWithFormat:@"DELETE FROM %@",self.PlaylistTableName];
    [self.dbManager executeQuery:query];
    query = [[NSString alloc]initWithFormat:@"DELETE FROM %@",self.TracksTableName];
    [self.dbManager executeQuery:query];
}

@end
