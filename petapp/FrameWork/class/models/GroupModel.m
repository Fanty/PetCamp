//
//  GroupModel.m
//  PetNews
//
//  Created by fanty on 13-8-9.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "GroupModel.h"

@implementation GroupModel
@synthesize groupId;
@synthesize groupName;
@synthesize petUser;
@synthesize user_count;
@synthesize type;
@synthesize location;
@synthesize desc;
@synthesize createtime;
-(void)dealloc{
    self.desc=nil;
    self.location=nil;
    self.groupId=nil;
    self.groupName=nil;
    self.petUser=nil;
    self.createtime=nil;
    [super dealloc];
}

@end
