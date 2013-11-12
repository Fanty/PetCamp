//
//  WeiboSignupView.m
//  iOS_SDK_Demo
//
//  Created by fanty on 13-8-1.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "WeiboSignupView.h"
#import "WeiboAuthentication.h"
#import "JSONKit.h"
#import "WeiboEngine.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface WeiboSignupView()<UIWebViewDelegate>
- (void)didReceiveAuthorizeCode:(NSString *)code;
-(void)cancel;
-(void)doLoginApi:(NSString*)code;
@end

@implementation WeiboSignupView
@synthesize authentication;
@synthesize engine;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UINavigationBar* bar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 44)];
        bar.backgroundColor=[UIColor redColor];
        bar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;

        [self addSubview:bar];
        [bar release];
        UINavigationItem *navItem = [[[UINavigationItem alloc]initWithTitle:@"取消"] autorelease];
        navItem.leftBarButtonItem = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)]autorelease];
        [bar pushNavigationItem:navItem animated:NO];

        
        webView = [[UIWebView alloc]initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(bar.frame), frame.size.width, frame.size.height-CGRectGetMinY(bar.frame))];
        webView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
        | UIViewAutoresizingFlexibleTopMargin
        | UIViewAutoresizingFlexibleRightMargin
        | UIViewAutoresizingFlexibleBottomMargin
        | UIViewAutoresizingFlexibleWidth
        | UIViewAutoresizingFlexibleHeight;
        webView.delegate = self;
        [self addSubview:webView];
        [webView release];
                
        
        loadingView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:loadingView];
        [loadingView release];
    }
    return self;
}

-(void)dealloc{
    [http setCompletionBlock:nil];
    [http setFailedBlock:nil];
    [http cancel];

    self.authentication=nil;
    [super dealloc];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    loadingView.frame=CGRectMake(0.5f*(self.frame.size.width-32.0f), 0.5f*(self.frame.size.height-32.0f), 32.0f, 32.0f);
}


-(void)startRequest{
    NSURL *url = [NSURL URLWithString:self.authentication.authorizeRequestUrl];
    NSLog(@"request url: %@", url);
    NSURLRequest *request =[NSURLRequest requestWithURL:url
                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                        timeoutInterval:60.0];
    [webView loadRequest:request];

}

-(void)show{
    
    CGRect rect=self.frame;
    rect.origin.y=rect.size.height;
    self.frame=rect;
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect rect=self.frame;
        rect.origin.y=0.0f;
        self.frame=rect;

    } completion:^(BOOL finish){
    
    }];
}
-(void)cancel{
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect rect=self.frame;
        rect.origin.y=self.superview.frame.size.height;
        self.frame=rect;
        
    } completion:^(BOOL finish){
        [self removeFromSuperview];

    }];

}

- (void)webViewDidStartLoad:(UIWebView *)aWebView{
    [loadingView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView{
    if(!isLoadingCode)
        [loadingView stopAnimating];
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error{
    [loadingView stopAnimating];
    //
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSRange range = [request.URL.absoluteString rangeOfString:@"code="];
    
    if (range.location != NSNotFound){
        NSString *code = [request.URL.absoluteString substringFromIndex:range.location + range.length];
        NSLog(@"code: %@", code);
        [self didReceiveAuthorizeCode:code];
        //didReceiveAuthorizeCode  code
    }
    return YES;
}

-(void)doNicknameApi{
    NSString* url=[NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?access_token=%@&uid=%@",self.authentication.accessToken,self.authentication.userId];

    http=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    [http setCompletionBlock:^{
        [loadingView stopAnimating];
        
        NSData* data=[http responseData];
        http=nil;
        
        if([data length]<50){
            NSError *error = [NSError errorWithDomain:@"com.zhiweibo.OAuth2"
                                                 code:kWeiboOAuth2ErrorAuthorizationFailed
                                             userInfo:nil];
            NSLog(@"failed to auth: %@", error);
            if(self.engine != nil){
                [self.engine onFailureLogin:error];
            }

            return;
        }
        
        JSONDecoder *decoder = [JSONDecoder decoder];
        id jsonObject = [decoder mutableObjectWithData:data];
        if ([jsonObject isKindOfClass:[NSDictionary class]]){
            NSDictionary *dict = (NSDictionary *)jsonObject;
            
            self.authentication.nickname = [dict objectForKey:@"screen_name"];
            self.authentication.headerImageUrl = [dict objectForKey:@"avatar_large"];
            
            //finish
            if(self.engine != nil){
                [self.engine onSuccessLogin];
            }
            
            [self cancel];
        }
    }];
    
    [http setFailedBlock:^{
        [http setCompletionBlock:nil];
        NSError* error=[http error];
        http=nil;
        [loadingView stopAnimating];
        //failed
        if(self.engine != nil){
            [self.engine onFailureLogin:error];
        }

    }];
    
    [http startAsynchronous];

}

-(void)doLoginApi:(NSString*)code{
    [http setCompletionBlock:nil];
    [http setFailedBlock:nil];
    [http cancel];
    ASIFormDataRequest* request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:self.authentication.accessTokenURL]];
    
    [request setPostValue:self.authentication.appKey forKey:@"client_id"];
    [request setPostValue:self.authentication.appSecret forKey:@"client_secret"];
    [request setPostValue:self.authentication.redirectURI forKey:@"redirect_uri"];
    [request setPostValue:code forKey:@"code"];
    [request setPostValue:@"authorization_code" forKey:@"grant_type"];
    http=request;

    [http setCompletionBlock:^{
        [http setFailedBlock:nil];
        NSData* data=[http responseData];
        http=nil;
        JSONDecoder *decoder = [JSONDecoder decoder];
        id jsonObject = [decoder mutableObjectWithData:data];
        if ([jsonObject isKindOfClass:[NSDictionary class]]){
            NSDictionary *dict = (NSDictionary *)jsonObject;
            
            NSString *accessToken = [dict objectForKey:@"access_token"];
            NSString *userId = [dict objectForKey:@"uid"];
            int expiresIn = [[dict objectForKey:@"expires_in"] intValue];
            if (accessToken.length > 0 && userId.length > 0) {
                self.authentication.accessToken = accessToken;
                self.authentication.userId = userId;
                
                self.authentication.expirationDate = [NSDate dateWithTimeIntervalSinceNow:expiresIn];
                [self doNicknameApi];
            }
        }
    
    }];
    [http setFailedBlock:^{
        [http setCompletionBlock:nil];
        NSError* error=[http error];
        http=nil;

        [loadingView stopAnimating];
        if(self.engine != nil){
            [self.engine onFailureLogin:error];
        }

    }];
    [http startAsynchronous];

}

#pragma mark   auther
- (void)didReceiveAuthorizeCode:(NSString *)code{
    // if it was not canceled
    if (![code isEqualToString:@"21330"]){
        isLoadingCode=YES;
        [self doLoginApi:code];
    }
    else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"Access denied", NSLocalizedDescriptionKey,
                                  nil];
        NSError *error = [NSError errorWithDomain:@"com.zhiweibo.OAuth2"
                                             code:kWeiboOAuth2ErrorAccessDenied
                                         userInfo:userInfo];

        NSLog(@"failed to auth: %@", error);
        
        if(self.engine != nil){
            [self.engine onFailureLogin:error];
        }

    }
}



@end
