//
//  HomeViewController.m
//  PetNews
//
//  Created by fanty on 13-8-3.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "HomeViewController.h"
#import "GTGZThemeManager.h"
#import "PetNewsNavigationController.h"
#import "PetNewsViewController.h"
#import "MarketTypeListViewController.h"
#import "ContactViewController.h"
#import "SettingInfoMainViewController.h"
#import "DataCenter.h"
#import "PetUser.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "PersonDynamicViewController.h"
#import "UserSplashView.h"
#import "Utils.h"

#define CHECK_LOGIN_TAG   333

@interface HomeViewController ()<UITabBarControllerDelegate,LoginViewControllerDelegate,UserSplashViewDelegate>

@end

@implementation HomeViewController

-(id)init{
    self=[super init];
    if(self){
        self.delegate=self;
    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIImageView* imageView=[[UIImageView alloc] initWithImage:[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"line_shadow.png"] ];
    CGRect rect=imageView.frame;
    rect.origin.x=self.view.frame.size.width;
    rect.size.height=self.view.frame.size.height;
    imageView.frame=rect;
    [self.view addSubview:imageView];
    [imageView release];

    
    //self.view.backgroundColor=[UIColor colorWithPatternImage:[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"bg.png"]];

    rect=self.view.bounds;
    if([Utils systemVersion]>=7.0f){
        rect.origin.y=20.0f;
    }
    NSString* currentVersion=[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];    
    NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
    
    NSString* savedVersion=[userDefaults objectForKey:@"savedVersion"];
    if(![currentVersion isEqualToString:savedVersion]){
        [userDefaults setObject:currentVersion forKey:@"savedVersion"];
        [userDefaults synchronize];
        
        
        UserSplashView* splashView=[[UserSplashView alloc] initWithFrame:rect];
        splashView.touchDelegate=self;
        [self.view addSubview:splashView];
        [splashView release];
        
    }
    

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark method

-(void)loadTabBar{
    
    PetNewsViewController* petNewsViewController=[[PetNewsViewController alloc] init];
    
    PetNewsNavigationController* petNewsNav=[[PetNewsNavigationController alloc] initWithRootViewController:petNewsViewController];
    [petNewsViewController release];

    
    MarketTypeListViewController* marketViewController=[[MarketTypeListViewController alloc] init];
    
    PetNewsNavigationController* marketNav=[[PetNewsNavigationController alloc] initWithRootViewController:marketViewController];
    [marketViewController release];
    
    
    ContactViewController* contactViewController=[[ContactViewController alloc] init];
    
    PetNewsNavigationController* contactNav=[[PetNewsNavigationController alloc] initWithRootViewController:contactViewController];
    contactNav.view.tag=CHECK_LOGIN_TAG;
    [contactViewController release];
    
    
    PersonDynamicViewController* personDynamicViewController=[[PersonDynamicViewController alloc] init];
    personDynamicViewController.navigationItem.leftBarButtonItem=nil;
    PetNewsNavigationController* myMainNav=[[PetNewsNavigationController alloc] initWithRootViewController:personDynamicViewController];
    myMainNav.view.tag=CHECK_LOGIN_TAG;
    [personDynamicViewController release];

    
    
    SettingInfoMainViewController* settingViewController=[[SettingInfoMainViewController alloc] init];
    
    PetNewsNavigationController* settingNav=[[PetNewsNavigationController alloc] initWithRootViewController:settingViewController];
    settingNav.view.tag=CHECK_LOGIN_TAG;
    [settingViewController release];
    

    [self setViewControllers:[NSArray arrayWithObjects:petNewsNav,marketNav,contactNav,myMainNav,settingNav,nil]];
    
    [petNewsNav release];
    [marketNav release];
    [contactNav release];
    [myMainNav release];
    [settingNav release];
}


-(void)setViewControllers:(NSArray*)array{
    [super setViewControllers:array];
    // self.selectedIndex=0;
    /*
    for(UIView *view in self.view.subviews){
		if([view isKindOfClass:[UITabBar class]]){
            CGRect rect=view.frame;
            rect.size.height+=100.0f;
            rect.origin.y-=100.0f;
            view.frame=rect;
            
            
            UIView * transitionView = [[self.view subviews] objectAtIndex:0];
            
            rect=transitionView.frame;
            rect.size.height -=100.0f;
            
            transitionView.frame = rect;

            
            
			break;
		}
        
	}
    */
    /*
     
     CGRect frame=self.view.bounds;
     homeViewController=[[HomeViewController alloc] init];
     homeViewController.view.frame=frame;
     
     homeViewController.tabBar.frame = CGRectMake(0, frame.size.height-60.0f, frame.size.width, 60.0f);
     
     UIView * transitionView = [[homeViewController.view subviews] objectAtIndex:0];
     
     frame.size.height = frame.size.height-60.0f;
     
     transitionView.frame = frame;

     */
}


#pragma mark tabbar delegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if(viewController.view.tag==CHECK_LOGIN_TAG){
        if([[DataCenter sharedInstance].user.token length]<1){
            newIndex=0;
            [self.viewControllers enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL* stop){
            
                if([obj isEqual:viewController]){
                    newIndex=index;
                    *stop=YES;
                    return;
                }
            }];
            [[AppDelegate appDelegate] redirectLoginPage:self noAnimateToPop:NO];
            return  NO;
        }
    }
    return YES;
}

#pragma mark login delegate

-(void)didLoginFinish:(LoginViewController*)controller{
    self.selectedIndex=newIndex;
}

#pragma mark splashview delegate

-(void)didSplashEnd:(UserSplashView *)userSplashView{
    userSplashView.alpha=1.0f;
    userSplashView.userInteractionEnabled=NO;
    [UIView animateWithDuration:0.7f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        userSplashView.alpha=0.0f;
    } completion:^(BOOL finish){
        [userSplashView removeFromSuperview];
    }];
}

@end
