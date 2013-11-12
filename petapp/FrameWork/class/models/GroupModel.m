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

-(void)dealloc{
    self.groupId=nil;
    self.groupName=nil;
    self.petUser=nil;
    [super dealloc];
}

@end
