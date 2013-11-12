//
//  DataCenter.h
//  PetNews
//
//  Created by apple2310 on 13-9-6.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PetUser;
@interface DataCenter : NSObject

+(DataCenter*)sharedInstance;

@property(nonatomic,retain) PetUser* user;

@property(nonatomic,assign) float latitude;
@property(nonatomic,assign) float longitude;

@property(nonatomic,retain) NSArray* petNewsBannerList;
@property(nonatomic,retain) NSArray* marketBannerList;
@property(nonatomic,retain) NSArray* activatyBannerList;

@end
