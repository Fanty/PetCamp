//
//  MarketTypeListViewController.m
//  PetNews
//
//  Created by Fanty on 13-11-17.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "MarketTypeListViewController.h"
#import "GTGZThemeManager.h"
#import "MarketViewController.h"
#import "PullTableView.h"
#import "AsyncTask.h"
#import "AppDelegate.h"
#import "MarketManager.h"
#import "PullToRefresh.h"
#import "AlertUtils.h"
#import "NoCell.h"
#import "MarketTypeCell.h"
#import "StoreType.h"

@interface MarketTypeListViewController ()<UITableViewDataSource,UITableViewDelegate>
-(void)loadData;
@end

@implementation MarketTypeListViewController

- (id)init{
    self = [super init];
    if (self) {
        self.title=lang(@"type");
        // Custom initialization
        self.tabBarItem=[[[UITabBarItem alloc] initWithTitle:lang(@"type") image:[[GTGZThemeManager sharedInstance] imageByTheme:@"tab_market.png"] tag:0] autorelease];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    first=YES;
    
    tableView = [[PullTableView alloc] initWithFrame:self.view.bounds];
    tableView.dataSource=self;
    tableView.delegate=self;
    tableView.backgroundColor=[UIColor clearColor];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [tableView addPullToRefreshWithActionHandler:^{
        DLog(@"refresh dataSource");
        [self loadData];
    }];

    
    [self.view addSubview: tableView];
    [tableView release];
    
    [tableView.pullToRefreshView triggerRefresh:YES];
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];

    [tableView releasePullToRefresh];

    [list release];
    list=nil;
    [task cancel];
    task=nil;
}

-(void)dealloc{
    [list release];
    [task cancel];
    task=nil;

    [tableView releasePullToRefresh];
    [tableView release];
    [super dealloc];
}

#pragma mark method

-(void)loadData{
    [task cancel];
    
    NSDate* date = [NSDate date];
    [tableView.pullToRefreshView setLastUpdatedDate:date];
    
    task=[[AppDelegate appDelegate].marketManager storeTypeList];
    [task setFinishBlock:^{
        first=NO;
        [tableView.pullToRefreshView stopAnimating];

        if([task result]==nil){
            if(![task status]){
                [AlertUtils showAlert:[task errorMessage] view:self.view];
            }
            
        }
        else{
            [list release];
            list=[[task result] retain];
        }
        task=nil;
        [tableView reloadData];
        
    }];
    
}

#pragma mark table delegate


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor clearColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(first)return 0;
    if([list count]<1 && task==nil)
        return 1;
    else{
        return [list count];
    }
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([list count]<1 && task==nil){
        return 44.0f;
    }
    else{
        return [MarketTypeCell height];
    }
}


- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([list count]<1 && task==nil){
        NoCell *cell = (NoCell*)[_tableView dequeueReusableCellWithIdentifier:@"nocell"];
        if(cell == nil){
            cell = [[[NoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nocell"] autorelease];
        }
        return cell;
    }
    else{
        MarketTypeCell *cell = (MarketTypeCell*)[_tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell == nil){
            cell = [[[MarketTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
        }
        StoreType* storeType=[list objectAtIndex:[indexPath row]];
        [cell headerUrl:storeType.logo_path title:storeType.name desc:storeType.desc];
        
        return cell;
    }
}


-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(first)return;
    if([list count]<1 && task==nil){
        [tableView.pullToRefreshView triggerRefresh:YES];
        
    }
    else{
        StoreType* storeType=[list objectAtIndex:[indexPath row]];
        MarketViewController* controller=[[MarketViewController alloc] init];
        controller.type_id=storeType.sid;
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    
}


@end
