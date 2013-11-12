//
//  GroupModel.h
//  PetNews
//
//  Created by fanty on 13-8-9.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PetUser;
typedef enum _GroupModelType{
    GroupModelSelf=0,
    GroupModelOffical
}GroupModelType;

@interface GroupModel : NSObject

@property(nonatomic,retain) NSString* groupId;
@property(nonatomic,retain) NSString* groupName;
@property(nonatomic,retain) PetUser* petUser;
@property(nonatomic,assign) int user_count;
@property(nonatomic,assign) GroupModelType type;

@end
