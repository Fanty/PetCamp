//
//  GroupMessage.h
//  PetNews
//
//  Created by Fanty on 13-11-28.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PetUser;
@interface GroupMessage : NSObject

@property(nonatomic,retain) NSString* msgId;
@property(nonatomic,retain) NSString* content;
@property(nonatomic,retain) PetUser* sender;
@property(nonatomic,retain) NSDate* createtime;
@property(nonatomic,assign) BOOL isImage;

@end
