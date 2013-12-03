//
//  GroupMessage.m
//  PetNews
//
//  Created by Fanty on 13-11-28.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "GroupMessage.h"

@implementation GroupMessage

@synthesize msgId;
@synthesize content;
@synthesize sender;
@synthesize createtime;
@synthesize isImage;
- (void)dealloc{
    self.msgId=nil;
    self.content=nil;
    self.sender=nil;
    self.createtime=nil;
    [super dealloc];
}

@end
