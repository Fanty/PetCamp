//
//  WeiboEngine.m
//  iOS_SDK_Demo
//
//  Created by fanty on 13-8-1.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "WeiboEngine.h"
#import "WeiboAuthentication.h"
#import "WeiboSignupView.h"
#import "WeiboSharedContentView.h"

#import "AppDelegate.h"
#import "RootViewController.h"

#define kAppKey @"3326691039"
#define kAppSecret @"75dd27596a081b28651d214e246c1b15"

#define kWeiboAuthorizeURL          @"https://api.weibo.com/oauth2/authorize"
#define kWeiboAccessTokenURL        @"https://api.weibo.com/oauth2/access_token"
#define kWeiboAPIBaseUrl            @"https://api.weibo.com/2/"


static WeiboEngine* weboEngine;

@implementation WeiboEngine

@synthesize webboDelegate;
@synthesize weiboAuthentication;

+(WeiboEngine*)defaultWebboEngine{

    @synchronized(self){
        
        if(weboEngine == nil)
            weboEngine = [[WeiboEngine alloc] init];
        
        return weboEngine;
        
    }

}


-(id)init{
    self=[super init];
    
    if(self){        
        weiboAuthentication = [[WeiboAuthentication alloc]initWithAuthorizeURL:kWeiboAuthorizeURL accessTokenURL:kWeiboAccessTokenURL AppKey:kAppKey appSecret:kAppSecret];

    }
    
    return self;
}

-(void)dealloc{
    [content release];
    [weiboAuthentication release];
    [super dealloc];
}

-(void)share:(NSString*)_content{
    [content release];
    content=nil;
    

    UIView* rootview=[AppDelegate appDelegate].rootViewController.view;
    
    if([weiboAuthentication.accessToken length]<3){
        content=[_content retain];
        [self signupInView:rootview];
        
    }
    else{

        WeiboSharedContentView* view=[[WeiboSharedContentView alloc] initWithFrame:rootview.bounds];
        [view sharedContent:_content];
        [view show];
        [rootview addSubview:view];
        [view release];
    }
}

-(void)signupInView:(UIView*)view{
    WeiboSignupView* __view=[[WeiboSignupView alloc] initWithFrame:view.bounds];
    __view.authentication=weiboAuthentication;
    __view.engine = self;
    [__view startRequest];
    [__view show];
    [view addSubview:__view];
    
    [__view release];
}


-(void)onSuccessLogin{
    if([content length]>0){
        NSString* p=[content retain];
        [self share:p];
        [p release];
    }
    else{
        if(self.webboDelegate != nil){
            [self.webboDelegate onSuccessLogin];
        }
    }

    [content release];
    content=nil;
}

-(void)onFailureLogin:(NSError *)error{
    [content release];
    content=nil;
    if(self.webboDelegate != nil){
        [self.webboDelegate onFailureLogin:error];
    }
}
@end
