//
//  MessageModel.h
//  PetNews
//
//  Created by fanty on 13-8-12.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PetUser;

@interface MessageModel : NSObject

@property(nonatomic,retain) PetUser* friendUser;
@property(nonatomic,retain) NSString* content;
@property(nonatomic,retain) NSDate* createdate;

@end
