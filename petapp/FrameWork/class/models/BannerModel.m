//
//  BannerModel.m
//  PetNews
//
//  Created by fanty on 13-8-12.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "BannerModel.h"

@implementation BannerModel
@synthesize bid;
@synthesize imageUrl;
@synthesize link;
@synthesize target_id;

-(void)dealloc{
    self.bid=nil;
    self.imageUrl=nil;
    self.link=nil;
    self.target_id=nil;
    [super dealloc];
}

@end
