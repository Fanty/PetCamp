//
//  ChatModel.m
//  PetNews
//
//  Created by Fanty on 13-11-26.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "ChatModel.h"

@implementation ChatModel

@synthesize cid;
@synthesize petUser;
@synthesize content;
@synthesize createtime;
@synthesize isImage;
- (void)dealloc{
    self.cid=nil;
    self.petUser=nil;
    self.content=nil;
    self.createtime=nil;
    [super dealloc];
}

@end
