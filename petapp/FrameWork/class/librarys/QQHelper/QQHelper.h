//
//  QQHelper.h
//  PetNews
//
//  Created by Grace Lai on 4/8/13.
//  Copyright (c) 2013 fanty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TencentOpenAPI/TencentOAuth.h"

@protocol QQDelegate <NSObject>

@optional

-(void)tencentDidLogin;
- (void)tencentDidNotLogin:(BOOL)cancelled;
- (void)getUserInfoResponse:(NSDictionary*) data;

@end



@interface QQHelper : NSObject<TencentSessionDelegate>{
    TencentOAuth* _tencentOAuth;
    
    NSArray* _permissions;
}

@property(nonatomic, assign) id<QQDelegate> qqDelegate;

+(QQHelper*)defaultHelper;
-(void)login;
-(void)logout;
-(void)getUserInfo;

@end



