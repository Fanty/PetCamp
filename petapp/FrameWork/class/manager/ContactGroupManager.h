//
//  ContactGroupManager.h
//  PetNews
//
//  Created by fanty on 13-8-22.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncTask.h"

@interface ContactGroupManager : NSObject

-(AsyncTask*)createGroup:(NSString*)groupName;

-(AsyncTask*)myBoardList:(int)offset;

-(AsyncTask*)createBoard:(NSString*)friend_id content:(NSString*)content;

-(AsyncTask*)friendList:(NSString*)groupId;

-(AsyncTask*)makeFriend:(NSString*)friend_id;

-(AsyncTask*)userDetail:(NSString*)uid;

-(AsyncTask*)nearUser:(float)longitude latitude:(float)latitude offset:(int)offset;

-(AsyncTask*)groupList;

-(AsyncTask*)addGroupUser:(NSString*)group_id friend_id:(NSString*)friend_id;

-(AsyncTask*)addGroupUsers:(NSString*)group_id friends:(NSArray*)friends;


-(AsyncTask*)searchGroup:(NSString*)keyword offset:(int)offset;

-(AsyncTask*)searchUser:(NSString*)keyword offset:(int)offset;


@end
