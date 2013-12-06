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
#import "MyActivatyViewController.h"

#import "MyPetNewsTableView.h"

#import "PetNewsEditViewController.h"
#import "PetNewsNavigationController.h"
#import "RightNavContactViewController.h"
#import "AsyncTask.h"
#import "PetNewsAndActivatyManager.h"
#import "SummaryModel.h"

@interface PersonDynamicViewController ()
-(void)rightClick;
-(void)updateSummary;
@end

@implementation PersonDynamicViewController

- (id)init{
    self = [super init];
    if (self) {
        self.title=lang(@"my");
        // Custom initialization
        self.tabBarItem=[[[UITabBarItem alloc] initWithTitle:lang(@"person_activaty") image:[[GTGZThemeManager sharedInstance] imageByTheme:@"tab_my.png"] tag:0] autorelease];
        
        [self backNavBar];
        
        [self rightNavBarWithTitle:lang(@"active") target:self action:@selector(rightClick)];

    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    myPetNewsTableView=[[MyPetNewsTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    myPetNewsTableView.parentViewController=self;
    [self.view addSubview:myPetNewsTableView];
    [myPetNewsTableView release];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateSummary];
    [myPetNewsTableView reloadData];
}

#pragma mark method

-(void)rightClick{
    MyActivatyViewController* controller=[[MyActivatyViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

-(void)updateSummary{
    [task cancel];
    task=[[AppDelegate appDelegate].petNewsAndActivatyManager summary];
    [task setFinishBlock:^{
        if([task result]!=nil){
            SummaryModel* model=[task result];
            [myPetNewsTableView petNumber:0 friendNumber:model.focus_count fansNumber:model.fans_count addNumber:model.at_count messageNumber:model.board_count];

        }
        task=nil;
    
    }];
}

@end
