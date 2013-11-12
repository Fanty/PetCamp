//
//  WeiboEngine.h
//  iOS_SDK_Demo
//
//  Created by fanty on 13-8-1.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WeiboAuthentication;

@protocol WeiboEngineDelegate <NSObject>

@optional

-(void)onSuccessLogin;
-(void)onFailureLogin:(NSError *)error;

@end



@interface WeiboEngine : NSObject{
    WeiboAuthentication* weiboAuthentication;
 
    NSString* content;
}
@property(nonatomic,readonly) WeiboAuthentication* weiboAuthentication;
@property(nonatomic,assign)id<WeiboEngineDelegate> webboDelegate;

+(WeiboEngine*)defaultWebboEngine;

-(void)share:(NSString*)_content;
-(void)signupInView:(UIView*)view;

-(void)onSuccessLogin;
-(void)onFailureLogin:(NSError *)error;

@end
