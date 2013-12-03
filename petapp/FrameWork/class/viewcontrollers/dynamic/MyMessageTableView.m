//
//  MyMessageTableView.m
//  PetNews
//
//  Created by fanty on 13-8-15.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "MyMessageTableView.h"

#import "AsyncTask.h"
#import "PullToRefresh.h"
#import "MessageModel.h"
#import "PetUser.h"
#import "MessageCell.h"
#import "AppDelegate.h"
#import "ContactGroupManager.h"
#import "AlertUtils.h"

#import "GTGZThemeManager.h"
#import "DataCenter.h"

#import "ContactDetailViewController.h"
#import "Utils.h"

@interface MyMessageTableView()<UITableViewDataSource,UITableViewDelegate>

-(void)loadData:(BOOL)loadMore;

@end

@implementation MyMessageTableView
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
    
    return [list count];
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MessageCell height];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MessageCell *cell = (MessageCell*)[_tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell == nil){
            cell = [[[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
        }
        
        MessageModel* model=[list objectAtIndex:[indexPath row]];
        [cell headUrl:model.friendUser.imageHeadUrl];
        [cell title:model.friendUser.nickname];
        [cell content:model.content];
        [cell date:model.createdate];
        
        
        return cell;
}


-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
        MessageModel* model=[list objectAtIndex:[indexPath row]];

        ContactDetailViewController* controller=[[ContactDetailViewController alloc] init];
        controller.title=model.friendUser.nickname;
        controller.uid=model.friendUser.uid;
        [self.parentViewController.navigationController pushViewController:controller animated:YES];
        [controller release];
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
    
    task=[[AppDelegate appDelegate].contactGroupManager myBoardList:temp_pageOffset];
    [task setFinishBlock:^{
        [self.pullToRefreshView stopAnimating];
        self.loadMoreState=PullTableViewLoadMoreStateNone;
        
        if([task error]!=nil){
            [AlertUtils showAlert:[task errorMessage] view:self];
            [self releaseLoadMoreFooter];
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
            [self reloadData];
            
        }
        task=nil;
        
    }];
    
}

@end
