//
//  MyMainViewController.m
//  PetNews
//
//  Created by Fanty on 13-11-12.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "MyMainViewController.h"
#import "GTGZThemeManager.h"
@interface MyMainViewController ()

@end

@implementation MyMainViewController

- (id)init{
    self = [super init];
    if (self) {
        self.title=lang(@"my");
        // Custom initialization
        self.tabBarItem=[[[UITabBarItem alloc] initWithTitle:lang(@"my") image:[[GTGZThemeManager sharedInstance] imageByTheme:@"tab_my.png"] tag:0] autorelease];
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
