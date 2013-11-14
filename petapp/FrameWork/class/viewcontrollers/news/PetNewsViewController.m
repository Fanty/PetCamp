//
//  PetNewsViewController.m
//  PetNews
//
//  Created by fanty on 13-8-3.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "PetNewsViewController.h"
#import "GTGZThemeManager.h"
#import "HeadTabView.h"

#import "PetNewsTableView.h"
#import "NearbyTableView.h"
#import "DailyPicksTableView.h"
#import "ActivityTableView.h"
#import "ActivatyEditMainViewController.h"
#import "NearByViewController.h"
#import "PetNewsNavigationController.h"
#import "PetNewsEditViewController.h"
#import "DataCenter.h"

@interface PetNewsViewController ()<HeadTabViewDelegte>
-(void)initTabBar;
-(void)initTableView:(int)tab;

-(void)edit;
-(void)openNearby;

-(void)bannerUpdateNotification:(NSNotification*)notify;
@end

@implementation PetNewsViewController

- (id)init{
    self = [super init];
    if (self) {
        // Custom initialization
        self.tabBarItem=[[[UITabBarItem alloc] initWithTitle:lang(@"home") image:[[GTGZThemeManager sharedInstance] imageByTheme:@"tab_dog.png"] tag:0] autorelease];
        
        [self rightNavBar:@"gps_header.png" target:self action:@selector(openNearby)];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bannerUpdateNotification:) name:BannerUpdateNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self initTabBar];
    [self initTableView:2];
    [self initTableView:1];

    [self initTableView:0];
    
    [self updateIcon];
}

-(void)willShowViewController{
    UIImageView* imageView=[[UIImageView alloc] initWithImage:[[GTGZThemeManager sharedInstance] imageByTheme:@"header_title.png"]];
    imageView.contentMode=UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = imageView;
    [imageView release];
    
    [self updateIcon];

}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [petNewsTableView clear];
    [dailyPicksTableView clear];
    [activityTableView clear];
    petNewsTableView=nil;
    dailyPicksTableView=nil;
    activityTableView=nil;
}

-(void)dealloc{
    [petNewsTableView clear];
    [dailyPicksTableView clear];
    [activityTableView clear];
    [super dealloc];
}


#pragma mark headtab delegate

-(void)tabDidSelected:(HeadTabView*)tabView index:(int)index{
    [self initTableView:index];
    if(index==0){
        [DataCenter sharedInstance].showUpdatePetNews=NO;
    }
    else if(index==1){
        [DataCenter sharedInstance].showUpdateMarket=NO;
    }
    else if(index==2){
        [DataCenter sharedInstance].showUpdateActivaty=NO;
    }
    [self updateIcon];
    [[DataCenter sharedInstance] save];
}


#pragma mark method
-(void)initTabBar{
    headTab=[[HeadTabView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 0.0f)];
    headTab.delegate=self;
    [headTab setTabNameArray:[NSArray arrayWithObjects:lang(@"petnews"),lang(@"daily_specials"),lang(@"active") ,nil]];
    [self.view addSubview:headTab];
    [headTab release];    
}

-(void)updateIcon{
    DataCenter* dataCenter=[DataCenter sharedInstance];
    [headTab showNewTip:dataCenter.showUpdatePetNews index:0];
    [headTab showNewTip:dataCenter.showUpdateMarket index:1];
    [headTab showNewTip:dataCenter.showUpdateActivaty index:2];
    

    
}

-(void)initTableView:(int)tab{
    petNewsTableView.hidden=YES;
    dailyPicksTableView.hidden=YES;
    activityTableView.hidden=YES;
    
    if(tab==0){
        if(petNewsTableView==nil){
            petNewsTableView=[[PetNewsTableView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(headTab.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(headTab.frame)) style:UITableViewStylePlain];
            petNewsTableView.parentViewController=self;
            [self.view addSubview:petNewsTableView];
            [petNewsTableView release];
        }
        petNewsTableView.hidden=NO;
        [self leftNavBar:@"writer_header.png" target:self action:@selector(edit)];

    }
    else if(tab==1){
        if(dailyPicksTableView==nil){
            dailyPicksTableView=[[DailyPicksTableView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(headTab.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(headTab.frame)) style:UITableViewStylePlain];
            dailyPicksTableView.parentViewController=self;
            [self.view addSubview:dailyPicksTableView];
            [dailyPicksTableView release];

        }
        dailyPicksTableView.hidden=NO;
        self.navigationItem.leftBarButtonItem=nil;
    }
    else if(tab==2){
        if(activityTableView==nil){
            activityTableView=[[ActivityTableView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(headTab.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(headTab.frame)) style:UITableViewStylePlain];
            activityTableView.parentViewController=self;
            [self.view addSubview:activityTableView];
            [activityTableView release];
        }
        activityTableView.hidden=NO;
        [self leftNavBar:@"writer_header.png" target:self action:@selector(edit)];

    }
}

-(void)edit{
    if(!petNewsTableView.hidden){
        PetNewsEditViewController* controller=[[PetNewsEditViewController alloc] init];
        PetNewsNavigationController* navController=[[PetNewsNavigationController alloc] initWithRootViewController:controller];
        [controller release];
        [self checkIsLoginAndPushTempViewController:navController];
        
        [navController release];
    }
    else if(!activityTableView.hidden){
        ActivatyEditMainViewController* controller=[[ActivatyEditMainViewController alloc] init];
        
        PetNewsNavigationController* navController=[[PetNewsNavigationController alloc] initWithRootViewController:controller];
        [controller release];
        [self checkIsLoginAndPushTempViewController:navController];
        
        [navController release];
    }
}

-(void)openNearby{
    NearByViewController* controller=[[NearByViewController alloc] init];
    [self checkIsLoginAndPushTempViewController:controller];
    [controller release];
}

-(void)bannerUpdateNotification:(NSNotification*)notify{
    if([notify.object isEqual:@"petnews"]){
        [petNewsTableView updateBanner];
    }
    else if([notify.object isEqual:@"market"]){
        [dailyPicksTableView updateBanner];
    }
    else{
        [activityTableView updateBanner];
    }
}

@end
