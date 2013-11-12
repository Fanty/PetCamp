//
//  TCBlogUserInfoParser.m
//  PetNews
//
//  Created by GT mac_5 on 13-8-25.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "TCBlogUserInfoParser.h"
#import "PetUser.h"

@implementation TCBlogUserInfoParser

-(void)onParser:(NSDictionary*)jsonMap{


    if(jsonMap == nil){
    
        return;
    }

    if([[jsonMap objectForKey:@"data"] isKindOfClass:[NSDictionary class]]){

        PetUser* user = [[PetUser alloc] init];
        
        NSDictionary* userInfo = [jsonMap objectForKey:@"data"];
        user.nickname = [userInfo objectForKey:@"nick"];
        user.account = [userInfo objectForKey:@"name"];
        user.sex = [[userInfo objectForKey:@"sex"] boolValue];
        user.uid = [userInfo objectForKey:@"openid"];
        user.bind_email = [userInfo objectForKey:@"email"];
        user.imageHeadUrl = [userInfo objectForKey:@"head"];
        user.address = [userInfo objectForKey:@"location"];
        user.online = [[userInfo objectForKey:@"online_status"] boolValue];
        
        [result release];
        result = [user retain];
        [user release];
    }

}


@end
