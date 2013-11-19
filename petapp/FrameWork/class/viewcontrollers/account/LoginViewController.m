//
//  LoginViewController.m
//  PetNews
//
//  Created by fanty on 13-8-2.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "GTGZThemeManager.h"
#import "QQHelper.h"
#import "TCWBEngine.h"
#import "PetUser.h"
#import "WeiboEngine.h"
#import "WeiboAuthentication.h"
#import "SignUpViewController.h"
#import "Utils.h"
#import "MBProgressHUD.h"
#import "AccountManager.h"
#import "AsyncTask.h"
#import "ApiManager.h"
#import "ContactGroupManager.h"

#import "TCBlogUserInfoParser.h"
#import "QQUserInfoParser.h"

#import "DataCenter.h"


#import <QuartzCore/QuartzCore.h>

@interface LoginViewController ()<QQDelegate,WeiboEngineDelegate,UITextFieldDelegate>

-(void)redirectToRoot:(id)sender;
-(void)goHome;
-(void)loginSocial:(NSString*)account type:(NSString*)type;
-(void)signupSocial:(NSString*)account type:(NSString*)type nickname:(NSString*)nickname image:(NSString *)image;
-(void)login:(NSString*)phone password:(NSString*)password;
-(void)loginSocial:(NSString*)account type:(NSString*)type nickname:(NSString*)nickname image:(NSString*)image;

-(void)backDisClick;
-(void)redirecttoForgetPassword;
@end

@implementation LoginViewController
@synthesize delegate;
@synthesize noAnimateToPop;
-(id)init{
    self=[super init];
    if(self){
        self.title=lang(@"login");
        [self leftNavBar:@"back_header.png" target:self action:@selector(backDisClick)];
    }
    return  self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    CGRect rect=self.view.bounds;
    rect.origin.y-=44.0f;
    UIImage* img = [[GTGZThemeManager sharedInstance] imageResourceByTheme:@"login_bg.png"];
    UIImageView* bgView = [[UIImageView alloc] initWithFrame:rect];
    
    bgView.image = img;
    [self.view addSubview:bgView];
    [bgView release];
    
    //

    img = [[GTGZThemeManager sharedInstance] imageResourceByTheme:@"input_mobile.png"];
    UIImageView* userNameFieldBgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - img.size.width)*0.5, ([Utils isIPad]?250.0f:100.0f), img.size.width, img.size.height)];
    userNameFieldBgView.image = img;
    userNameFieldBgView.userInteractionEnabled = YES;
    
    float field_orginX = 80.0f;
    float field_orginY = 8;
    
    float field_width=200.0f;
    if([Utils isIPad]){
        field_orginX = field_orginX*1.5;
        field_orginY = field_orginY*2;
        field_width=350.0f;
    }
    
    
    userNameField = [[UITextField alloc] initWithFrame:CGRectMake(field_orginX, field_orginY, field_width, userNameFieldBgView.frame.size.height - field_orginY*2)];
    userNameField.textColor = [UIColor whiteColor];
    userNameField.placeholder = lang(@"mobileNum");
    userNameField.delegate = self;
    if([Utils isIPad]){
        [userNameField setFont:[UIFont systemFontOfSize:33.0f]];
    }
    userNameField.keyboardType = UIKeyboardTypePhonePad;
    [userNameFieldBgView addSubview: userNameField];
    [userNameField release];
    
    [self.view addSubview:userNameFieldBgView];
    [userNameFieldBgView release];
    
    
    
    
    
    img = [[GTGZThemeManager sharedInstance] imageResourceByTheme:@"input_psd.png"];
    UIImageView* psdBgView = [[UIImageView alloc] initWithFrame:CGRectMake(userNameFieldBgView.frame.origin.x, CGRectGetMaxY(userNameFieldBgView.frame)+2, img.size.width, img.size.height)];
    psdBgView.image = img;
    psdBgView.userInteractionEnabled = YES;
    
    
    psdField = [[UITextField alloc] initWithFrame:CGRectMake(field_orginX, field_orginY, field_width*0.5f, userNameFieldBgView.frame.size.height - field_orginY*2)];
    psdField.textColor = [UIColor whiteColor];
    psdField.placeholder = lang(@"password");
    psdField.delegate = self;
    psdField.secureTextEntry = YES;
    if([Utils isIPad]){
        [psdField setFont:[UIFont systemFontOfSize:33.0f]];
    }
    psdField.returnKeyType = UIReturnKeyDone;
    [psdBgView addSubview:psdField];
    [psdField release];
    
    [self.view addSubview:psdBgView];
    [psdBgView release];
    
    
    img = [[GTGZThemeManager sharedInstance] imageResourceByTheme:@"input_foreget.png"];

    UIButton* forgetButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [forgetButton setImage:img forState:UIControlStateNormal];
    [forgetButton addTarget:self action:@selector(redirecttoForgetPassword) forControlEvents:UIControlEventTouchUpInside];
    forgetButton.frame=CGRectMake(CGRectGetMaxX(userNameFieldBgView.frame)-img.size.width, psdBgView.frame.origin.y, img.size.width, img.size.height);
    [self.view addSubview:forgetButton];
    
    
    
    float orginY = CGRectGetMaxY(psdBgView.frame)+10;
    img = [[GTGZThemeManager sharedInstance] imageResourceByTheme:@"btn_login.png"];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 1001;
    [button addTarget:self action:@selector(redirectToRoot:) forControlEvents:UIControlEventTouchUpInside];
    button.frame=CGRectMake(psdBgView.frame.origin.x, orginY,img.size.width , img.size.height);
    [button  setImage:img forState:UIControlStateNormal];
//    [button setTitle:lang(@"login") forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    
    
    
    float orginX= CGRectGetMaxX(button.frame)+5;
    img = [[GTGZThemeManager sharedInstance] imageResourceByTheme:@"btn_register.png"];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 1006;
    [button addTarget:self action:@selector(redirectToRoot:) forControlEvents:UIControlEventTouchUpInside];
    button.frame=CGRectMake(orginX, orginY,img.size.width ,img.size.height);
//    [button setTitle:lang(@"regist") forState:UIControlStateNormal];
    [button setImage:img forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    
    
    
    orginY = CGRectGetMaxY(button.frame)+37;
    img = [[GTGZThemeManager sharedInstance] imageResourceByTheme:@"login_sinaBlog.png"];
    button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 1002;
    [button addTarget:self action:@selector(redirectToRoot:) forControlEvents:UIControlEventTouchUpInside];
    button.frame=CGRectMake((self.view.bounds.size.width - img.size.width)*0.5f, orginY,img.size.width, img.size.height);
    [button setImage:img forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    
    
    orginY = CGRectGetMaxY(button.frame)+2;
    img = [[GTGZThemeManager sharedInstance] imageResourceByTheme:@"login_qqBlog.png"];
    button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 1003;
    [button addTarget:self action:@selector(redirectToRoot:) forControlEvents:UIControlEventTouchUpInside];
    button.frame=CGRectMake((self.view.bounds.size.width - img.size.width)*0.5f, orginY,img.size.width, img.size.height);
    [button setImage:img forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    
    
    orginY = CGRectGetMaxY(button.frame)+2;
    img = [[GTGZThemeManager sharedInstance] imageResourceByTheme:@"login_qq.png"];
    button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 1004;
    [button addTarget:self action:@selector(redirectToRoot:) forControlEvents:UIControlEventTouchUpInside];
    button.frame=CGRectMake((self.view.bounds.size.width - img.size.width)*0.5f, orginY,img.size.width, img.size.height);
    [button setImage:img forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.removeFromSuperViewOnHide=NO;
    [self.view addSubview:hud];
    [hud release];
    
    
#ifdef DEV_VERSION
    userNameField.text=@"13660392546";
    psdField.text=@"123456";
#endif
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [task cancel];
    [engine release];
    
    [super dealloc];
}

#pragma mark method


-(void)redirecttoForgetPassword{
    [[UIApplication sharedApplication] openURL:[ApiManager forgetPasswordApi]];
}

-(void)backDisClick{
    if([self.delegate respondsToSelector:@selector(didLoginCancel:)])
        [self.delegate didLoginCancel:self];
    [self dismissModalViewControllerAnimated:YES];
}

-(void)redirectToRoot:(id)sender{
    UIButton* button = (UIButton*)sender;
    
    if(button.tag == 1004){
        QQHelper* qqHelper = [QQHelper defaultHelper];
        qqHelper.qqDelegate = self;
        [qqHelper login];
        return;
    }
    else if(button.tag == 1003){
        engine = [[TCWBEngine alloc] initWithAppKey:WiressSDKDemoAppKey andSecret:WiressSDKDemoAppSecret andRedirectUrl:@"http://www.ying7wang7.com"];
        [engine setRootViewController:self];
        [engine logInWithDelegate:self
                        onSuccess:@selector(qqWebOnSuccessLogin)
                        onFailure:@selector(qqWebOnFailureLogin:)];
        return;
        
    }
    else if(button.tag == 1002){
        WeiboEngine* wbEngine = [WeiboEngine defaultWebboEngine];
        wbEngine.webboDelegate = self;
        [wbEngine signupInView:self.view];
        return ;
    
    }
    else if(button.tag == 1006){
        signUpViewController = [[SignUpViewController alloc] init];
        [self.navigationController pushViewController:signUpViewController animated:YES] ;
        [signUpViewController release];
        return;
    }
    else if(button.tag == 1001){
        NSString* mobile = userNameField.text;
        if(mobile.length < 1){
            hud.mode = MBProgressHUDModeText;
            hud.labelText = lang(@"mobileEmpty");
            [hud show:YES];
            [hud hide:YES afterDelay:1];
            return;
        }
        else if([psdField.text length]<1){
            hud.mode = MBProgressHUDModeText;
            hud.labelText = lang(@"passwordEmpty");
            [hud show:YES];
            [hud hide:YES afterDelay:1];
            return;
        }
        else if(![Utils isPureInt:mobile]){
            hud.mode = MBProgressHUDModeText;
            hud.labelText = lang(@"checkMobile");
            [hud show:YES];
            [hud hide:YES afterDelay:1];
             return;
        }
        hud.mode=MBProgressHUDModeIndeterminate;
        hud.labelText=lang(@"loading");
        [hud show:YES];
        [self login:mobile password:psdField.text];
    }
    
}

-(void)signupSocial:(NSString*)account type:(NSString*)type nickname:(NSString*)nickname image:(NSString *)image{
    [task cancel];
    task=[[AppDelegate appDelegate].accountManager signupSocial:account type:type nickname:nickname image:image];
    [task setFinishBlock:^{
        task=nil;
        [self loginSocial:account type:type];
    }];
}

-(void)loginSocial:(NSString*)account type:(NSString*)type{
    [task cancel];
    task=[[AppDelegate appDelegate].accountManager loginSocial:account type:type latitude:[DataCenter sharedInstance].latitude longitude:[DataCenter sharedInstance].longitude];
    
    [task setFinishBlock:^{
        [hud hide:NO];
        if([task error]!=nil){
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [task errorMessage];
            [hud show:YES];
            [hud hide:YES afterDelay:1.0f];
        }
        else{
            PetUser* petUser=[task result];
            [DataCenter sharedInstance].user=petUser;
            petUser.account=account;
            petUser.accountType=type;
            [self goHome];
        }
        task=nil;
    }];
}

-(void)login:(NSString*)phone password:(NSString*)password{
    [task cancel];
    task=[[AppDelegate appDelegate].accountManager login:phone password:password latitude:[DataCenter sharedInstance].latitude longitude:[DataCenter sharedInstance].longitude];
    
    [task setFinishBlock:^{
        [hud hide:NO];
        if([task error]!=nil){
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [task errorMessage];
            [hud show:YES];
            [hud hide:YES afterDelay:1.0f];
        }
        else{
            PetUser* petUser=[task result];
            petUser.bind_phone=phone;
            petUser.password=password;
            [DataCenter sharedInstance].user=petUser;
            [self goHome];
        }
        task=nil;
    }];
}


-(void)loginSocial:(NSString*)account type:(NSString*)type nickname:(NSString*)nickname image:(NSString*)image{
    hud.mode=MBProgressHUDModeIndeterminate;
    hud.labelText=lang(@"loading");
    [hud show:YES];

    [self signupSocial:account type:type nickname:nickname image:image];
    
}


-(void)goHome{
    if(self.noAnimateToPop)
        [self dismissModalViewControllerAnimated:NO];
    
    
    [[AppDelegate appDelegate].accountManager saveAccount:[DataCenter sharedInstance].user];

    [[AppDelegate appDelegate].contactGroupManager sync];

    if([self.delegate respondsToSelector:@selector(didLoginFinish:)])
        [self.delegate didLoginFinish:self];
    if(!self.noAnimateToPop)
        [self dismissModalViewControllerAnimated:YES];

}

-(void)selectorKeyBgButton:(UIButton*)button{

    [currentField resignFirstResponder];
    [button removeFromSuperview];

}

#pragma mark QQHelper Delegate

-(void)tencentDidLogin{
    
    [[QQHelper defaultHelper] getUserInfo];
    
}


- (void)tencentDidNotLogin:(BOOL)cancelled{
    
    
}


#pragma mark - qqWeb login callback

////登录成功回调
- (void)qqWebOnSuccessLogin{
    
    [engine getUserInfoWithFormat:@"json"
                        parReserved:nil
                           delegate:self
                          onSuccess:@selector(successCallBack:)
                          onFailure:@selector(failureCallBack:)];
    
    
}
//
//登录失败回调
- (void)qqWebOnFailureLogin:(NSError *)error
{
//   
//    NSString *message = [[NSString alloc] initWithFormat:@"%@",[NSNumber numberWithInteger:[error code]]];
//    
//    
//    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error domain]
//                                                        message:message
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//    [alertView show];
//    [alertView release];
//    [message release];
}


- (void)successCallBack:(id)result{

    NSDictionary* dic = (NSDictionary *)result;
    
    TCBlogUserInfoParser* parser = [[TCBlogUserInfoParser alloc] init];
    [parser onParser:dic];
    
    PetUser* user=(PetUser*)[parser getResult];
        [self loginSocial:user.account type:@"TCBlog" nickname:user.nickname image:user.imageHeadUrl];
    
    [parser release];
    
    
    
}

- (void)failureCallBack:(NSError *)error{
    NSLog(@"error: %@", error);
}


#pragma mark sina login deleagef
-(void)onSuccessLogin{

    WeiboAuthentication* authenication=[WeiboEngine defaultWebboEngine].weiboAuthentication;
    [self loginSocial:authenication.userId type:@"WEIBO" nickname:authenication.nickname image:authenication.headerImageUrl];
}
-(void)onFailureLogin:(NSError *)error{
    
}

- (void)getUserInfoResponse:(NSDictionary*) data{

    NSLog(@"getUserInfoResponse");

    QQUserInfoParser* parser = [[QQUserInfoParser alloc] init];
    [parser onParser:data];
    
    PetUser* user=(PetUser*)[parser getResult];
    [self loginSocial:user.nickname type:@"QQ" nickname:user.nickname image:user.imageHeadUrl];
    
    [parser release];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [currentField resignFirstResponder];
}

#pragma mark UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    currentField = textField;    
    return YES;

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
