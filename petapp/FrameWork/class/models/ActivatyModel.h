//
//  ActivatyModel.h
//  PetNews
//
//  Created by fanty on 13-8-7.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PetUser;

@interface ActivatyModel : NSObject

@property(nonatomic,retain) NSString* aid;
@property(nonatomic,retain) PetUser* petUser;
@property(nonatomic,retain) NSString* title;
@property(nonatomic,retain) NSString* desc;
@property(nonatomic,retain) NSArray* imageUrls;
@property(nonatomic,assign) int commandCount;
@property(nonatomic,assign) int laudCount;
@property(nonatomic,retain) NSDate* createdate;
@property(nonatomic,retain) NSDate* updatedate;
@property(nonatomic,retain) NSDate* startdate;
@property(nonatomic,retain) NSDate* enddate;
@property(nonatomic,assign) int maxCount;
@property(nonatomic,assign) int activate_count;

@end

@interface ActivatyPeopleModel : NSObject

@property(nonatomic,retain) PetUser* petUser;
@property(nonatomic,retain) NSDate* createdate;


@end


