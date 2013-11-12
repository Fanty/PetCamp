//
//  MessageModel.m
//  PetNews
//
//  Created by fanty on 13-8-12.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "MessageModel.h"



@implementation MessageModel

@synthesize friendUser;
@synthesize content;
@synthesize createdate;

-(void)dealloc{
    self.friendUser=nil;
    self.content=nil;
    self.createdate=nil;
    [super dealloc];
}

@end
