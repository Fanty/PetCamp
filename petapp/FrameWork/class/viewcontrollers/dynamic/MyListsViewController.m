//
//  MyListsViewController.m
//  PetNews
//
//  Created by Fanty on 13-11-24.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "MyListsViewController.h"
#import "MyMessageTableView.h"
#import "MyContactsPetListTableView.h"
#import "EmailTableView.h"

@interface MyListsViewController ()

@end

@implementation MyListsViewController

-(id)init{
    self=[super init];
    if(self){
        [self backNavBar];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if(self.showIndex<3){
        self.title=(self.showIndex==1?lang(@"activaty"):lang(@"fans"));
        MyContactsPetListTableView* tableView=[[MyContactsPetListTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.parentViewController=self;
        [self.view addSubview:tableView];
        [tableView release];

    }
    else if(self.showIndex==3){
        self.title=lang(@"addMy");
        EmailTableView* tableView=[[EmailTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.parentViewController=self;
        [self.view addSubview:tableView];
        [tableView release];

    }
    else {
        self.title=lang(@"message");
        MyMessageTableView* tableView=[[MyMessageTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.parentViewController=self;
        [self.view addSubview:tableView];
        [tableView release];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
