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

@synthesize type_id;
- (id)init{
    self = [super init];
    if (self) {
        self.title=lang(@"market");
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    markerTableView = [[MarketTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height )];
    markerTableView.type_id=self.type_id;
    markerTableView.parentViewController=self;
    [self.view addSubview: markerTableView];
    [markerTableView release];
    
    [markerTableView triggerRefresh];
    
}



- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    self.type_id=nil;
    [super dealloc];
}

@end
