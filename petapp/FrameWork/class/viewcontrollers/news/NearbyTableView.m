//
//  NearbyTableView.m
//  PetNews
//
//  Created by fanty on 13-8-6.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "NearbyTableView.h"
#import "AsyncTask.h"
#import "PullToRefresh.h"
#import "ContactCell.h"
#import "PetUser.h"
#import "ContactDetailViewController.h"
#import "AppDelegate.h"
#import "ContactGroupManager.h"
#import "AlertUtils.h"
#import "DataCenter.h"
#import "NoCell.h"
#import "BaseViewController.h"


@interface NearbyTableView()<UITableViewDataSource,UITableViewDelegate>
-(void)loadData:(BOOL)loadMore;

@end

@implementation NearbyTableView
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
            [self loadData:NO];
        }];
        [self.pullToRefreshView triggerRefresh:YES];
    }
    return self;
}

-(void)dealloc{
    [list release];
    [task cancel];
    [super dealloc];
}


#pragma mark table delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(task==nil && self.dragging && !self.decelerating)
        [self checkLoadMoreScrollingState];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(task==nil && self.loadMoreState==PullTableViewLoadMoreStateDragStartLoad){
        self.loadMoreState=PullTableViewLoadMoreStateDragLoading;
        [self loadData:YES];
    }
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(task==nil &&  self.loadMoreState==PullTableViewLoadMoreStateDragUp){
        self.loadMoreState=PullTableViewLoadMoreStateDragStartLoad;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor clearColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([list count]<1 && task==nil)
        return 1;
    else
        return [list count];
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([list count]<1 && task==nil){
        return 44.0f;
    }
    else{
        return [ContactCell height];
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
        ContactCell *cell = (ContactCell*)[_tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell == nil){
            cell = [[[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        
        PetUser* model=[list objectAtIndex:[indexPath row]];
        
        [cell headUrl:model.imageHeadUrl];
        [cell name:model.nickname];
        [cell desc:model.person_desc];
        [cell tip:model.dictance];
        [cell sex:model.sex];
        
        return cell;
    }
}


-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([list count]<1 && task==nil){
        [self.pullToRefreshView triggerRefresh:YES];
    }
    else{
        PetUser* model=[list objectAtIndex:[indexPath row]];
        
        ContactDetailViewController* controller=[[ContactDetailViewController alloc] init];
        controller.title=model.nickname;
        controller.uid=model.uid;
        [self.parentViewController checkIsLoginAndPushTempViewController:controller];
        [controller release];

    }
}


#pragma mark method

-(void)clear{
    [task cancel];
    task=nil;
    [self releasePullToRefresh];
}

-(void)loadData:(BOOL)loadMore{
    [task cancel];
    
    int temp_pageOffset=pageOffset;

    if(!loadMore){
        NSDate* date = [NSDate date];
        [self.pullToRefreshView setLastUpdatedDate:date];
        temp_pageOffset=0;
    }
    else{
        temp_pageOffset++;
    }
    
    task=[[AppDelegate appDelegate].contactGroupManager nearUser:[DataCenter sharedInstance].longitude latitude:[DataCenter sharedInstance].latitude offset:temp_pageOffset];
    [task setFinishBlock:^{
        [self.pullToRefreshView stopAnimating];
        self.loadMoreState=PullTableViewLoadMoreStateNone;
        
        if([task result]==nil){            
            [self releaseLoadMoreFooter];
            if(![task status]){
                [AlertUtils showAlert:[task errorMessage] view:self];
            }

        }
        else{
            pageOffset=temp_pageOffset;

            NSArray* array=[task result];
            
            if(list==nil){
                list=[[NSMutableArray alloc] initWithCapacity:2];
            }
            
            if(!loadMore)
                [list removeAllObjects];
            if([array count]>0)
                [list addObjectsFromArray:array];
            
            if([array count]<HTTP_PAGE_SIZE){
                [self releaseLoadMoreFooter];
            }
            else{
                [self createLoadMoreFooter];
            }
        }
        task=nil;
        [self reloadData];

    }];
    
}

@end
