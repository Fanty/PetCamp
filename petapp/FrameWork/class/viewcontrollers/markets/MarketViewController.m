//
//  MarketViewController.m
//  PetNews
//
//  Created by fanty on 13-8-3.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "MarketViewController.h"
#import "GTGZThemeManager.h"
#import "MarketTableView.h"
@interface MarketViewController ()

@end

@implementation MarketViewController

- (id)init{
    self = [super init];
    if (self) {
        self.title=lang(@"market");
        // Custom initialization
        self.tabBarItem=[[[UITabBarItem alloc] initWithTitle:lang(@"market") image:[[GTGZThemeManager sharedInstance] imageByTheme:@"tab_market.png"] tag:0] autorelease];
    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    markerTableView = [[MarketTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 88)];
    markerTableView.parentViewController=self;
    [self.view addSubview: markerTableView];
    [markerTableView release];
    
}



- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
