//
//  AreaModel.m
//  PetNews
//
//  Created by Grace Lai on 14/8/13.
//  Copyright (c) 2013 fanty. All rights reserved.
//

#import "AreaModel.h"

@implementation AreaModel

@synthesize areaId;
@synthesize name;
@synthesize list;

-(void)dealloc{

    self.name = nil;
    self.list = nil;
    [super dealloc];
}


@end
