//
//  ChoiceModel.h
//  PetNews
//
//  Created by Grace Lai on 6/8/13.
//  Copyright (c) 2013 fanty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChoiceModel : NSObject

@property(nonatomic,retain) NSString* mid;
@property(nonatomic,retain) NSString* title;
@property(nonatomic,retain) NSString* type;
@property(nonatomic,retain) NSString* imageUrl;
@property(nonatomic,assign) float price;
@property(nonatomic,retain) NSString* link;
@property(nonatomic,retain) NSDate* createdate;
@end
