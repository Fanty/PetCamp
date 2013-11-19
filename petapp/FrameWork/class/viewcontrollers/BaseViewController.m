//
//  BaseViewController.m
//  PetNews
//
//  Created by fanty on 13-8-2.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "BaseViewController.h"
#import "GTGZThemeManager.h"
#import "AppDelegate.h"
#import "DataCenter.h"
#import "PetUser.h"
#import "RootViewController.h"
#import "LoginViewController.h"
#import "ContactDetailViewController.h"
#import "PersonDynamicViewController.h"
#import "Utils.h"

@interface BaseViewController ()<LoginViewControllerDelegate>

@property(nonatomic,retain) UIViewController* svSnewNViewController;

-(BOOL)canBackNav;

@end

@implementation BaseViewController

@synthesize svSnewNViewController;


-(id)init{
    self=[super init];
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=7){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }

    
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0f){
        CGRect rect=self.view.frame;
        rect.size.height-=20.0f;
        self.view.frame=rect;
    }
    

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden{
    return NO;
}


-(void)dealloc{
    self.svSnewNViewController=nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)willShowViewController{

    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}


-(void)backNavBar{
    [self leftNavBar:@"back_header.png" target:self action:@selector(backClick)];
}



-(void)leftNavBar:(NSString*)image target:(id)target action:(SEL)action{
    UIImage* img=[[GTGZThemeManager sharedInstance] imageByTheme:image];
    UIView* bgView=[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, img.size.width, img.size.height)];
    bgView.backgroundColor=[UIColor clearColor];
    bgView.userInteractionEnabled=YES;
    
    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    button.frame=CGRectMake(-6.0f, 0.0f, img.size.width, img.size.height);
    [button setImage:img forState:UIControlStateNormal];
    [bgView addSubview:button];
    
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:bgView] autorelease];
    
    [bgView release];
}

-(void)rightNavBar:(NSString*)image target:(id)target action:(SEL)action{
    UIImage* img=[[GTGZThemeManager sharedInstance] imageByTheme:image];
    UIView* bgView=[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, img.size.width, img.size.height)];
    bgView.backgroundColor=[UIColor clearColor];
    bgView.userInteractionEnabled=YES;
    
    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame=CGRectMake(6.0f, 0.0f, img.size.width, img.size.height);
    [button setImage:img forState:UIControlStateNormal];
    [bgView addSubview:button];
    
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:bgView] autorelease];
    
    [bgView release];
}

-(void)leftNavBarWithTitle:(NSString*)title target:(id)target action:(SEL)action{
    self.navigationItem.leftBarButtonItem=[self loadBarButtonItem:title image:@"left_header.png" target:target action:action left:YES];

}

-(void)rightNavBarWithTitle:(NSString*)title target:(id)target action:(SEL)action{
    self.navigationItem.rightBarButtonItem=[self loadBarButtonItem:title image:@"right_header.png" target:target action:action left:NO];
    

}

-(UIBarButtonItem*)loadBarButtonItem:(NSString*)title image:(NSString*)image target:(id)target action:(SEL)action left:(BOOL)left{
    UIImage* img=[[GTGZThemeManager sharedInstance] imageByTheme:image];
    UIView* bgView=[[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, img.size.width, img.size.height)] autorelease];
    bgView.backgroundColor=[UIColor clearColor];
    bgView.userInteractionEnabled=YES;
    
    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:15.0f];
    button.frame=CGRectMake(left?-6.0f:6.0f, 0.0f, img.size.width, img.size.height);
    [button setBackgroundImage:img forState:UIControlStateNormal];
    [bgView addSubview:button];
    
    return [[[UIBarButtonItem alloc] initWithCustomView:bgView] autorelease];
}

-(void)backClick{
    if([self canBackNav])
        [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)canBackNav{
    return YES;
}

-(BOOL)checkIsLoginAndPushTempViewController:(UIViewController*)viewController{
    if([[DataCenter sharedInstance].user.token length]<1){
        self.svSnewNViewController=viewController;
        [[AppDelegate appDelegate] redirectLoginPage:self noAnimateToPop:[viewController isKindOfClass:[UINavigationController class]]];
        return NO;
    }
    else{
        if([viewController isKindOfClass:[UINavigationController class]])
            [[AppDelegate appDelegate].rootViewController presentModalViewController:viewController animated:YES];
        else
            [self.navigationController pushViewController:viewController animated:YES];
        
    }
    return YES;
}

-(void)redirectToContactDetailPage:(NSString*)title uid:(NSString*)uid{
    if([[DataCenter sharedInstance].user.uid isEqualToString:uid]){
        PersonDynamicViewController* controller=[[PersonDynamicViewController alloc] init];
        [self checkIsLoginAndPushTempViewController:controller];
        [controller release];
    }
    else{
        ContactDetailViewController* controller=[[ContactDetailViewController alloc] init];
        controller.title=title;
        controller.uid=uid;
        [self checkIsLoginAndPushTempViewController:controller];
        [controller release];
    }

}

#pragma mark  logindelegate

-(void)didLoginCancel:(LoginViewController*)controller{
    self.svSnewNViewController=nil;
}

-(void)didLoginFinish:(LoginViewController*)controller{
    if([self.svSnewNViewController isKindOfClass:[UINavigationController class]]){
        [self presentModalViewController:self.svSnewNViewController animated:YES];
    }
    else{
        [self.navigationController pushViewController:self.svSnewNViewController animated:YES];
    }
    self.svSnewNViewController=nil;
}


@end
