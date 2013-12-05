//
//  TalkManager.h
//  PetNews
//
//  Created by Fanty on 13-11-28.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AsyncTask;

@interface TalkManager : NSObject

-(AsyncTask*)syncTalk:(NSString*)groupId;

-(AsyncTask*)sendChat:(NSString*)groupId content:(NSString*)content image:(NSString*)image;

@end
