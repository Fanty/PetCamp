//
//  ContactGroupManager.h
//  PetNews
//
//  Created by fanty on 13-8-22.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncTask.h"

@interface ContactGroupManager : NSObject{
    
    AsyncTask* friendAsyncTask;
    AsyncTask* groupAsynTask;
    AsyncTask* fansAsyncTask;
    NSTimer* syncTimer;
}


@property(nonatomic,assign) BOOL syncingFriend;
@property(nonatomic,assign) BOOL syncingGroup;
@property(nonatomic,assign) BOOL syncingFans;

-(void)sync;

-(AsyncTask*)createGroup:(NSString*)groupName location:(NSString*)location desc:(NSString*)desc;

-(AsyncTask*)myBoardList:(int)offset;

-(AsyncTask*)createBoard:(NSString*)friend_id content:(NSString*)content;

-(AsyncTask*)friendList:(NSString*)groupId;

-(AsyncTask*)makeFriend:(NSString*)friend_id;

-(AsyncTask*)userDetail:(NSString*)uid;

-(AsyncTask*)nearUser:(float)longitude latitude:(float)latitude offset:(int)offset;



-(AsyncTask*)addGroupUser:(NSString*)group_id friend_id:(NSString*)friend_id;

-(AsyncTask*)addGroupUsers:(NSString*)group_id friends:(NSArray*)friends;


-(AsyncTask*)searchGroup:(NSString*)keyword offset:(int)offset;

-(AsyncTask*)searchUser:(NSString*)keyword offset:(int)offset;


@end
