//
//  PersonDynamicViewController.m
//  PetNews
//
//  Created by fanty on 13-8-15.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "MyActivatyViewController.h"
#import "GTGZThemeManager.h"
#import "ImageDownloadedView.h"
#import "PetUser.h"
#import "AppDelegate.h"

#import "HeadTabView.h"
#import "MyJoinActivatyTableView.h"
#import "MyFaviorActivatyTableView.h"

@interface MyActivatyViewController ()<HeadTabViewDelegte>
-(void)initTabBar;
-(void)initTableView:(int)tab;

@end

@implementation MyActivatyViewController

- (id)init{
    self = [super init];
    if (self) {
        self.title=lang(@"my_activaty");
        // Custom initialization
        
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
    [headTab setTabNameArray:[NSArray arrayWithObjects:lang(@"join_activaty"),lang(@"favior_activaty") ,nil]];
    [self.view addSubview:headTab];
    [headTab release];
}

-(void)initTableView:(int)tab{
    myJoinActivatyTableView.hidden=YES;
    myFaviorActivatyTableView.hidden=YES;
    if(tab==0){
        if(myJoinActivatyTableView==nil){
            myJoinActivatyTableView=[[MyJoinActivatyTableView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(headTab.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(headTab.frame)) style:UITableViewStylePlain];
            myJoinActivatyTableView.parentViewController=self;
            [self.view addSubview:myJoinActivatyTableView];
            [myJoinActivatyTableView release];
        }
        myJoinActivatyTableView.hidden=NO;
    }
    else{
        if(myFaviorActivatyTableView==nil){
            myFaviorActivatyTableView=[[MyFaviorActivatyTableView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(headTab.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(headTab.frame)) style:UITableViewStylePlain];
            myFaviorActivatyTableView.parentViewController=self;
            [self.view addSubview:myFaviorActivatyTableView];
            [myFaviorActivatyTableView release];
        }
        myFaviorActivatyTableView.hidden=NO;
    }
}


#pragma mark headtab delegate

-(void)tabDidSelected:(HeadTabView*)tabView index:(int)index{
    [self initTableView:index];
}

@end
