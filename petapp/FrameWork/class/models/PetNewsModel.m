//
//  PetNewsModel.m
//  PetNews
//
//  Created by fanty on 13-8-6.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "PetNewsModel.h"

@implementation PetNewsModel

@synthesize pid;
@synthesize petUser;
@synthesize title;
@synthesize desc;
@synthesize imageUrls;
@synthesize command_count;
@synthesize laudCount;
@synthesize createdate;
@synthesize updatedate;
-(void)dealloc{
    self.pid=nil;
    self.petUser=nil;
    self.title=nil;
    self.desc=nil;
    self.imageUrls=nil;
    self.createdate=nil;
    self.updatedate=nil;
    [super dealloc];
}

@end

