//
//  CommentModel.h
//  PetNews
//
//  Created by fanty on 13-8-20.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PetUser;
@interface CommentModel : NSObject
@property(nonatomic,retain) NSString* cid;
@property(nonatomic,retain) PetUser* petUser;
@property(nonatomic,retain) NSString* content;
@property(nonatomic,retain) NSDate* createdate;

@end
