//
//  StoreType.m
//  PetNews
//
//  Created by Fanty on 13-11-17.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "StoreType.h"

@implementation StoreType

@synthesize sid;
@synthesize name;
@synthesize code;
@synthesize ordering;
@synthesize logo_path;
@synthesize desc;

- (void)dealloc{
    self.sid=nil;
    self.name=nil;
    self.code=nil;
    self.desc=nil;
    self.ordering=nil;
    self.logo_path=nil;
    [super dealloc];
}

@end
