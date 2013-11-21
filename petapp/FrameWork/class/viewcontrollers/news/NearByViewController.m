//
//  NearByViewController.m
//  PetNews
//
//  Created by fanty on 13-8-19.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "NearByViewController.h"
#import "NearbyTableView.h"
@interface NearByViewController ()
@end

@implementation NearByViewController

-(id)init{
    self=[super init];
    self.title=lang(@"vicinity");
    [self backNavBar];
    self.navigationItem.rightBarButtonItem=nil;
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    NearbyTableView* tableView = [[NearbyTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 88)];
    tableView.parentViewController=self;
    [self.view addSubview: tableView];
    [tableView release];

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark method


@end
