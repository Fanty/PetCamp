//
//  SinaBlogUserInfoParser.m
//  PetNews
//
//  Created by GT mac_5 on 13-8-25.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "SinaBlogUserInfoParser.h"
#import "PetUser.h"

@implementation SinaBlogUserInfoParser


-(void)onParser:(NSDictionary*)jsonMap{

    if(jsonMap == nil){
        return;
    }
    
    if([jsonMap isKindOfClass:[NSDictionary class]]){

        PetUser* user = [[PetUser alloc] init];
        user.uid = [jsonMap objectForKey:@"id"];
        user.nickname = [jsonMap objectForKey:@"screen_name"];
        user.sex = ([[jsonMap objectForKey:@"gender"] isEqualToString:@"m"]?YES:NO);
        user.imageHeadUrl = [jsonMap objectForKey:@"profile_image_url"];
        user.address = [jsonMap objectForKey:@"location"];
        
        [result release];
        result = [user retain];
        [user release];
        
    }


}

@end
