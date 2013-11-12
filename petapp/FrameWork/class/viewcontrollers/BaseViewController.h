//
//  BaseViewController.h
//  PetNews
//
//  Created by fanty on 13-8-2.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController



-(void)willShowViewController;

-(void)backNavBar;

-(void)leftNavBar:(NSString*)image target:(id)target action:(SEL)action;

-(void)rightNavBar:(NSString*)image target:(id)target action:(SEL)action;


-(void)leftNavBarWithTitle:(NSString*)title target:(id)target action:(SEL)action;

-(void)rightNavBarWithTitle:(NSString*)title target:(id)target action:(SEL)action;


-(UIBarButtonItem*)loadBarButtonItem:(NSString*)title image:(NSString*)image target:(id)target action:(SEL)action left:(BOOL)left;


-(void)backClick;

-(BOOL)checkIsLoginAndPushTempViewController:(UIViewController*)viewController;

-(void)redirectToContactDetailPage:(NSString*)title uid:(NSString*)uid;

@end
