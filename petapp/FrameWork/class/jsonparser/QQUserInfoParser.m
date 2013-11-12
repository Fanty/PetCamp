//
//  QQUserInfoParser.m
//  PetNews
//
//  Created by GT mac_5 on 13-8-25.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "QQUserInfoParser.h"
#import "PetUser.h"

@implementation QQUserInfoParser

-(void)onParser:(NSDictionary*)jsonMap{


    if(jsonMap == nil)
        return;
    
    if([jsonMap isKindOfClass:[NSDictionary class]]){
            
        PetUser* user = [[PetUser alloc] init];

        user.nickname = [jsonMap objectForKey:@"nickname"];
        user.sex = ([[jsonMap objectForKey:@"gender"] isEqualToString:@"男"]?YES:NO);
        user.imageHeadUrl = [jsonMap objectForKey:@"figureurl_qq_2"];

        
        [result release];
        result = [user retain];
        [user release];
            
    }    
    
}


@end
