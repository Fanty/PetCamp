//
//  AlertUtils.m
//  PetNews
//
//  Created by fanty on 13-8-27.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "AlertUtils.h"
#import "MBProgressHUD.h"

@implementation AlertUtils

+(MBProgressHUD*)showAlert:(NSString*)message view:(UIView*)view{
    MBProgressHUD* hud=[[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    [hud release];
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide=YES;
    hud.labelText = message;
    [hud show:YES];
    [hud hide:YES afterDelay:0.7f];
    return hud;
}

+(MBProgressHUD*)showLoading:(NSString*)message view:(UIView*)view{
    MBProgressHUD* hud=[[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    [hud release];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide=YES;
    hud.labelText = message;
    return hud;
}

+(UIAlertView*)showStandAlert:(NSString*)message{
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:lang(@"confirm") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    
    return alert;
}

@end
