//
//  AreaModel.h
//  PetNews
//
//  Created by Grace Lai on 14/8/13.
//  Copyright (c) 2013 fanty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaModel : NSObject

@property(nonatomic,assign)NSInteger areaId;
@property(nonatomic,retain)NSString* name;
@property(nonatomic,retain)NSArray* list;

@end
