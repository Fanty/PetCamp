//
//  GroupTableView.m
//  PetNews
//
//  Created by fanty on 13-8-7.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "GroupTableView.h"
#import "AsyncTask.h"
#import "PullToRefresh.h"
#import "ContactGroupCell.h"
#import "PetUser.h"
#import "GroupModel.h"
#import "ContactByGropuViewController.h"
#import "AppDelegate.h"
#import "ContactGroupManager.h"
#import "AlertUtils.h"
#import "NoCell.h"

@interface GroupTableView()<UITableViewDataSource,UITableViewDelegate>
-(void)loadData;
-(void)retryClick;
-(void)notificationUpdate;
@end

@implementation GroupTableView
@synthesize parentViewController;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self=[super initWithFrame:frame style:style];
    if(self){
        self.dataSource=self;
        self.delegate=self;
        self.backgroundColor=[UIColor clearColor];
        self.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self addPullToRefreshWithActionHandler:^{
            DLog(@"refresh dataSource");
            [self loadData];
        }];
        [self.pullToRefreshView triggerRefresh:YES];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationUpdate) name:GroupUpdateNotification object:nil];

    }
    return self;
}

-(void)dealloc{
    [showList release];
    [list release];
    [task cancel];
    [super dealloc];
}

-(void)search:(NSString*)title{
    [showList removeAllObjects];
    for(GroupModel* model in list){
        if([title length]<1 || [model.groupName rangeOfString:title].length>0){
            [showList addObject:model];
        }
    }
    [self reloadData];
}

#pragma mark table delegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor clearColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([list count]<1 && task==nil)
        return 1;
    else
        return [showList count];
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([list count]<1 && task==nil){
        return 44.0f;
    }
    else{
        return [ContactGroupCell height];
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
        ContactGroupCell *cell = (ContactGroupCell*)[_tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell == nil){
            cell = [[[ContactGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        
        
        GroupModel* model=[showList objectAtIndex:[indexPath row]];
        
        [cell headUrl:model.petUser.imageHeadUrl];
        [cell name:model.groupName];
        [cell desc:[NSString stringWithFormat:lang(@"group_count"),model.user_count]];
        return cell;
    }

}


-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([list count]<1 && task==nil){
        [self.pullToRefreshView triggerRefresh:YES];
    }
    else{
        GroupModel* model=[showList objectAtIndex:[indexPath row]];
        
        ContactByGropuViewController* controller=[[ContactByGropuViewController alloc] init];
        controller.groupId=model.groupId;
        controller.uid=model.petUser.uid;
        controller.title=model.groupName;
        [parentViewController.navigationController pushViewController:controller animated:YES];
        [controller release];

    }
}


#pragma mark method

-(void)clear{
    [task cancel];
    task=nil;
    [self releasePullToRefresh];
}

-(void)notificationUpdate{
    [self.pullToRefreshView triggerRefresh:YES];

}

-(void)retryClick{
    [self.pullToRefreshView triggerRefresh:YES];
}

-(void)loadData{
    [task cancel];
    
    NSDate* date = [NSDate date];
    [self.pullToRefreshView setLastUpdatedDate:date];
    
    task=[[AppDelegate appDelegate].contactGroupManager groupList];
    [task setFinishBlock:^{
        [self.pullToRefreshView stopAnimating];
        
        if([task result]==nil){
            if(![task status]){
                [AlertUtils showAlert:[task errorMessage] view:self];
            }
        }
        else{
            [list release];
            list=[[task result] retain];
        }
        [showList release];
        showList=[[NSMutableArray alloc] initWithArray:list];
        task=nil;
        [self reloadData];

    }];
    
}

@end
