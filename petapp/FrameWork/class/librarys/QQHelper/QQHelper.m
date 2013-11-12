//
//  QQHelper.m
//  PetNews
//
//  Created by Grace Lai on 4/8/13.
//  Copyright (c) 2013 fanty. All rights reserved.
//

#import "QQHelper.h"
#import "TencentOpenAPI/sdkdef.h"


static QQHelper* qq_helper;

@implementation QQHelper

@synthesize qqDelegate;

+(QQHelper*)defaultHelper{

    @synchronized(self){
    
        if(qq_helper == nil)
            qq_helper = [[QQHelper alloc] init];
        
        return qq_helper;

    }

}

-(id)init{

    if(self = [super init]){
        [self setupQQ];
    }
    return self;
}

-(void)setupQQ{
    [_tencentOAuth release];
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"222222"
                 andDelegate:self];
    
    [_permissions release];
    _permissions = [[NSArray arrayWithObjects:
                     kOPEN_PERMISSION_GET_USER_INFO,
                     kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                     kOPEN_PERMISSION_ADD_ALBUM,
                     kOPEN_PERMISSION_ADD_IDOL,
                     kOPEN_PERMISSION_ADD_ONE_BLOG,
                     kOPEN_PERMISSION_ADD_PIC_T,
                     kOPEN_PERMISSION_ADD_SHARE,
                     kOPEN_PERMISSION_ADD_TOPIC,
                     kOPEN_PERMISSION_CHECK_PAGE_FANS,
                     kOPEN_PERMISSION_DEL_IDOL,
                     kOPEN_PERMISSION_DEL_T,
                     kOPEN_PERMISSION_GET_FANSLIST,
                     kOPEN_PERMISSION_GET_IDOLLIST,
                     kOPEN_PERMISSION_GET_INFO,
                     kOPEN_PERMISSION_GET_OTHER_INFO,
                     kOPEN_PERMISSION_GET_REPOST_LIST,
                     kOPEN_PERMISSION_LIST_ALBUM,
                     kOPEN_PERMISSION_UPLOAD_PIC,
                     kOPEN_PERMISSION_GET_VIP_INFO,
                     kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                     kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
                     kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                     nil] retain];

}

-(void)dealloc{

    [_permissions release];
    [_tencentOAuth release];
    [super dealloc];
}

-(void)login{
    
    [_tencentOAuth authorize:_permissions inSafari:NO];

}

-(void)logout{
    
    [_tencentOAuth logout:self];

}


-(void)getUserInfo{
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(analysisResponse:) name:kGetUserInfoResponse object:[_tencentOAuth getinstance]];
    
    
    if(![_tencentOAuth getUserInfo]){
        [self showInvalidTokenOrOpenIDMessage];
    }

}

- (void)showInvalidTokenOrOpenIDMessage{
    UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:@"api调用失败" message:@"可能授权已过期，请重新获取" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] autorelease];
    [alert show];
}


#pragma mark TencentSessionDelegate


/**
 * Called when the user successfully logged in.
 */
- (void)tencentDidLogin {

    if (_tencentOAuth.accessToken
        && 0 != [_tencentOAuth.accessToken length])
    {
         //"登录成功 获取accesstoken";
        [self.qqDelegate tencentDidLogin];

    }
    else
    {
        //"登录不成功 没有获取accesstoken";
    }
    
}


/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
//	if (cancelled){
//		//"用户取消登录";
//	}
//	else {
//		//"登录失败";
//	}
    
    [self.qqDelegate tencentDidNotLogin:cancelled];
	
}

/**
 * Called when the notNewWork.
 */
-(void)tencentDidNotNetWork
{
	//@"无网络连接，请设置网络";
}

/**
 * Called when the logout.
 */
-(void)tencentDidLogout
{
	//"退出登录成功，请重新登录";
}

/**
 * Called when the get_user_info has response.
 */
- (void)getUserInfoResponse:(APIResponse*) response {
	if (response.retCode == URLREQUEST_SUCCEED)
	{
		if(self.qqDelegate != nil){
        
            [self.qqDelegate getUserInfoResponse:response.jsonResponse];
        }

	}
	else
    {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[NSString stringWithFormat:@"%@", response.errorMsg]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
        [alert release];
	}
	//"获取个人信息完成";
}


@end
