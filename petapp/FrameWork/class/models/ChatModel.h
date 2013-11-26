//
//  ChatModel.h
//  PetNews
//
//  Created by Fanty on 13-11-26.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PetUser;
@interface ChatModel : NSObject

@property(nonatomic,retain) NSString* cid;
@property(nonatomic,retain) PetUser* petUser;
@property(nonatomic,retain) NSString* content;
@property(nonatomic,retain) NSDate* createtime;
@property(nonatomic,assign) BOOL isImage;

@end
