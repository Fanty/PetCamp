//
//  LoginViewController.h
//  PetNews
//
//  Created by fanty on 13-8-2.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "BaseViewController.h"

@class TCWBEngine;
@class SignUpViewController;
@class MBProgressHUD;
@class AsyncTask;

@class LoginViewController;

@protocol LoginViewControllerDelegate <NSObject>
@optional
-(void)didLoginCancel:(LoginViewController*)controller;
-(void)didLoginFinish:(LoginViewController*)controller;

@end


@interface LoginViewController : BaseViewController{
    
    TCWBEngine *engine;
    UITextField* userNameField;
    UITextField* psdField;
    
    UITextField* currentField;
    
    SignUpViewController* signUpViewController;
    
    MBProgressHUD* hud;
    
    AsyncTask* task;
}
@property(nonatomic,assign) BOOL noAnimateToPop;
@property(nonatomic,assign) id<LoginViewControllerDelegate> delegate;

@end
