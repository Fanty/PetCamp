//
//  PetNewsModel.h
//  PetNews
//
//  Created by fanty on 13-8-6.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PetUser;

@interface PetNewsModel : NSObject

@property(nonatomic,retain) NSString* pid;
@property(nonatomic,retain) PetUser* petUser;
@property(nonatomic,retain) NSString* title;
@property(nonatomic,retain) NSString* desc;
@property(nonatomic,retain) NSArray* imageUrls;
@property(nonatomic,assign) int command_count;
@property(nonatomic,assign) int laudCount;
@property(nonatomic,retain) NSDate* createdate;
@property(nonatomic,retain) NSDate* updatedate;

@property(nonatomic,retain) PetNewsModel* scr_post;

@end