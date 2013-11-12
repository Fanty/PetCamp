//
//  CommentModel.m
//  PetNews
//
//  Created by fanty on 13-8-20.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel
@synthesize cid;
@synthesize petUser;
@synthesize content;
@synthesize createdate;

-(void)dealloc{
    self.cid=nil;
    self.petUser=nil;
    self.content=nil;
    self.createdate=nil;
    [super dealloc];
}


@end
