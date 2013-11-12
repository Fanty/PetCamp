//
//  WeiboSignupView.h
//  iOS_SDK_Demo
//
//  Created by fanty on 13-8-1.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    kWeiboOAuth2ErrorWindowClosed          = -1000,
    kWeiboOAuth2ErrorAuthorizationFailed   = -1001,
    kWeiboOAuth2ErrorTokenExpired          = -1002,
    kWeiboOAuth2ErrorTokenUnavailable      = -1003,
    kWeiboOAuth2ErrorUnauthorizableRequest = -1004,
    kWeiboOAuth2ErrorAccessTokenRequestFailed = -1005,
    kWeiboOAuth2ErrorAccessDenied = -1006,
};


@class WeiboAuthentication;
@class ASIHTTPRequest;
@class WeiboEngine;
@interface WeiboSignupView : UIView{
    UIWebView* webView;
    UIActivityIndicatorView* loadingView;
    
    ASIHTTPRequest* http;
    BOOL isLoadingCode;
}
-(void)show;
-(void)startRequest;
@property (nonatomic, retain) WeiboAuthentication *authentication;
@property (nonatomic, assign) WeiboEngine* engine;

@end
