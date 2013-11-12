//
//  ActivatyModel.m
//  PetNews
//
//  Created by fanty on 13-8-7.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "ActivatyModel.h"

@implementation ActivatyModel

@synthesize aid;
@synthesize petUser;
@synthesize title;
@synthesize desc;
@synthesize imageUrls;
@synthesize commandCount;
@synthesize laudCount;
@synthesize createdate;
@synthesize updatedate;
@synthesize startdate;
@synthesize enddate;
@synthesize maxCount;
@synthesize activate_count;

-(void)dealloc{
    self.aid=nil;
    self.petUser=nil;
    self.title=nil;
    self.title=nil;
    self.desc=nil;
    self.imageUrls=nil;
    self.createdate=nil;
    self.updatedate=nil;
    self.startdate=nil;
    self.enddate=nil;
    [super dealloc];
}

@end


@implementation ActivatyPeopleModel

@synthesize petUser;
@synthesize createdate;

-(void)dealloc{
    self.petUser=nil;
    self.createdate=nil;
    [super dealloc];
}

@end


