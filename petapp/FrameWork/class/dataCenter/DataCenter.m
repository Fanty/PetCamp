//
//  DataCenter.m
//  PetNews
//
//  Created by apple2310 on 13-9-6.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "DataCenter.h"

static DataCenter* instance=nil;

@implementation DataCenter

@synthesize user;

@synthesize latitude;
@synthesize longitude;

@synthesize petNewsBannerList;
@synthesize marketBannerList;
@synthesize activatyBannerList;


+(DataCenter*)sharedInstance{
    if(instance==nil)
        instance=[[DataCenter alloc] init];
    
    return  instance;
}

-(void)dealloc{
    self.user=nil;
    self.petNewsBannerList=nil;
    self.marketBannerList=nil;
    self.activatyBannerList=nil;
    [super dealloc];
}

@end
