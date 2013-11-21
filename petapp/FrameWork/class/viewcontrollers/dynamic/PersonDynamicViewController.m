//
//  PersonDynamicViewController.m
//  PetNews
//
//  Created by fanty on 13-8-15.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "PersonDynamicViewController.h"
#import "GTGZThemeManager.h"
#import "ImageDownloadedView.h"
#import "PetUser.h"
#import "AppDelegate.h"

#import "HeadTabView.h"
#import "MyPetNewsTableView.h"
#import "MyJoinActivatyTableView.h"
#import "MyFaviorActivatyTableView.h"
#import "MyMessageTableView.h"
#import "PetNewsEditViewController.h"
#import "PetNewsNavigationController.h"
#import "RightNavContactViewController.h"

@interface PersonDynamicViewController ()<HeadTabViewDelegte>
-(void)initTabBar;
-(void)initTableView:(int)tab;

@end

@implementation PersonDynamicViewController

- (id)init{
    self = [super init];
    if (self) {
        self.title=lang(@"my");
        // Custom initialization
        self.tabBarItem=[[[UITabBarItem alloc] initWithTitle:lang(@"person_activaty") image:[[GTGZThemeManager sharedInstance] imageByTheme:@"tab_my.png"] tag:0] autorelease];
        
        [self backNavBar];

    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    


    [self initTabBar];
    
    [self initTableView:0];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark method

-(void)initTabBar{
    headTab=[[HeadTabView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 0.0f)];
    headTab.delegate=self;
    [headTab setTabNameArray:[NSArray arrayWithObjects:lang(@"petnews"),lang(@"join_activaty"),lang(@"favior_activaty"),lang(@"message") ,nil]];
    [self.view addSubview:headTab];
    [headTab release];
}

-(void)initTableView:(int)tab{
    myPetNewsTableView.hidden=YES;
    myJoinActivatyTableView.hidden=YES;
    myFaviorActivatyTableView.hidden=YES;
    myMessageTableView.hidden=YES;
    if(tab==0){
        if(myPetNewsTableView==nil){
            myPetNewsTableView=[[MyPetNewsTableView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(headTab.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(headTab.frame)) style:UITableViewStylePlain];
            myPetNewsTableView.parentViewController=self;
            [self.view addSubview:myPetNewsTableView];
            [myPetNewsTableView release];
        }
        myPetNewsTableView.hidden=NO;
    }
    else if(tab==1){
        if(myJoinActivatyTableView==nil){
            myJoinActivatyTableView=[[MyJoinActivatyTableView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(headTab.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(headTab.frame)) style:UITableViewStylePlain];
            myJoinActivatyTableView.parentViewController=self;
            [self.view addSubview:myJoinActivatyTableView];
            [myJoinActivatyTableView release];
        }
        myJoinActivatyTableView.hidden=NO;
    }
    else if(tab==2){
        if(myFaviorActivatyTableView==nil){
            myFaviorActivatyTableView=[[MyFaviorActivatyTableView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(headTab.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(headTab.frame)) style:UITableViewStylePlain];
            myFaviorActivatyTableView.parentViewController=self;
            [self.view addSubview:myFaviorActivatyTableView];
            [myFaviorActivatyTableView release];
        }
        myFaviorActivatyTableView.hidden=NO;
    }
    else if(tab==3){
        if(myMessageTableView==nil){
            myMessageTableView=[[MyMessageTableView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(headTab.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(headTab.frame)) style:UITableViewStylePlain];
            myMessageTableView.parentViewController=self;
            [self.view addSubview:myMessageTableView];
            [myMessageTableView release];
        }
        myMessageTableView.hidden=NO;
    }

}


#pragma mark headtab delegate

-(void)tabDidSelected:(HeadTabView*)tabView index:(int)index{
    [self initTableView:index];
}

-(void)profileDidAddFriend:(UserProfileView *)profileView{
    RightNavContactViewController* controller=[[RightNavContactViewController alloc] init];
    
    [self.navigationController pushViewController:controller animated:YES];
    
    [controller release];

}

@end
