//
//  ChatMainViewController.m
//  PetNews
//
//  Created by Fanty on 13-11-22.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "ChatMainViewController.h"
#import "GroupDetailViewController.h"
@interface ChatMainViewController ()

-(void)groupDetail;
@end

@implementation ChatMainViewController

@synthesize groupModel;

-(id)init{
    self=[super init];
    if(self){
        [self backNavBar];
        [self rightNavBarWithTitle:lang(@"groupDetail") target:self action:@selector(groupDetail)];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    UILabel* label=[[UILabel alloc] initWithFrame:self.view.bounds];
    label.textAlignment=NSTextAlignmentCenter;
    label.text=@"群组聊天主界面";
    [self.view addSubview:label];
    [label release];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    self.groupModel=nil;
    [super dealloc];
}

#pragma mark method


-(void)groupDetail{
    GroupDetailViewController* controller=[[GroupDetailViewController alloc] init];
    controller.groupModel=self.groupModel;
    controller.title=self.title;
    [self.navigationController pushViewController:controller animated:YES];
    
    [controller release];
}

@end
