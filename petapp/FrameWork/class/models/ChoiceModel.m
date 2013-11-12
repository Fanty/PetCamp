//
//  ChoiceModel.m
//  PetNews
//
//  Created by Grace Lai on 6/8/13.
//  Copyright (c) 2013 fanty. All rights reserved.
//

#import "ChoiceModel.h"

@implementation ChoiceModel


@synthesize mid;
@synthesize title;
@synthesize type;
@synthesize imageUrl;
@synthesize link;
@synthesize price;
@synthesize createdate;

-(void)dealloc{

    self.mid = nil;
    self.title = nil;
    self.type=nil;
    self.imageUrl = nil;
    self.link=nil;
    self.createdate = nil;
    [super dealloc];
}

@end
