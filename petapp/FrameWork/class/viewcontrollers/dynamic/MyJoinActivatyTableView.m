//
//  MyJoinActivatyTableView.m
//  PetNews
//
//  Created by fanty on 13-8-15.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "MyJoinActivatyTableView.h"

#import "AsyncTask.h"
#import "PullToRefresh.h"
#import "ActivatyModel.h"
#import "PetUser.h"
#import "ActivatyCell.h"
#import "ActivityDetailViewController.h"
#import "ActivatyEditMainViewController.h"
#import "PetNewsNavigationController.h"
#import "AppDelegate.h"
#import "PetNewsAndActivatyManager.h"
#import "GTGZThemeManager.h"
#import "DataCenter.h"
#import "Utils.h"
#import "PetNewsEditViewController.h"

@interface MyJoinActivatyTableView()<UITableViewDataSource,UITableViewDelegate>

-(void)loadData:(BOOL)loadMore;
-(void)retryButtonClick;
-(void)noButtonClick;
-(void)updateNotification;

@end

@implementation MyJoinActivatyTableView
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotification) name:UpdateActivatyListNotification object:nil];

        
    }
    return self;
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];

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
    return [ActivatyCell height];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        ActivatyCell *cell = (ActivatyCell*)[_tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell == nil){
            cell = [[[ActivatyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        
        ActivatyModel* model=[list objectAtIndex:[indexPath row]];
        
        [cell headUrl:model.petUser.imageHeadUrl];
        [cell title:model.petUser.nickname];
        [cell desc:model.title];
        
        
        return cell;
}


-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
        ActivatyModel* model=[list objectAtIndex:[indexPath row]];
        
        ActivityDetailViewController* controller=[[ActivityDetailViewController alloc] init];
        controller.aid=model.aid;
        controller.contentTitle=model.title;
        [self.parentViewController.navigationController pushViewController:controller animated:YES];
        [controller release];
    
}

#pragma mark method

-(void)clear{
    [task cancel];
    task=nil;
    [self releasePullToRefresh];
}

-(void)updateNotification{
    [self.pullToRefreshView triggerRefresh:YES];
    
}


-(void)loadData:(BOOL)loadMore{
    [task cancel];
    if(!loadMore){
        NSDate* date = [NSDate date];
        [self.pullToRefreshView setLastUpdatedDate:date];
    }
    [noButton removeFromSuperview];
    noButton=nil;
    
    int tempOffset=offset;
    if(loadMore)
        tempOffset++;
    else
        tempOffset=0;
    
    task=[[AppDelegate appDelegate].petNewsAndActivatyManager myJoinActivaty:tempOffset];
    [task setFinishBlock:^{
        [self.pullToRefreshView stopAnimating];
        self.loadMoreState=PullTableViewLoadMoreStateNone;
        
        if([task result]==nil){
            [self releaseLoadMoreFooter];
            
            noButton=[UIButton buttonWithType:UIButtonTypeCustom];
            noButton.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
            noButton.titleLabel.textAlignment=NSTextAlignmentCenter;
            [noButton addTarget:self action:@selector(retryButtonClick) forControlEvents:UIControlEventTouchUpInside];
            noButton.frame=CGRectMake(0.0f, ([Utils isIPad]?100.0f:40.0f), self.frame.size.width, self.frame.size.height);
            [self addSubview:noButton];
            [noButton theme:@"noLael"];
            [noButton setTitle:lang(@"error_http_dropdown") forState:UIControlStateNormal];
        }
        else{
            offset=tempOffset;
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
            
            if([list count]<1){
                noButton=[UIButton buttonWithType:UIButtonTypeCustom];
                noButton.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
                noButton.titleLabel.textAlignment=NSTextAlignmentCenter;
                [noButton addTarget:self action:@selector(noButtonClick) forControlEvents:UIControlEventTouchUpInside];
                noButton.frame=CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
                [self addSubview:noButton];
                [noButton theme:@"noLael"];
                [noButton setTitle:lang(@"noMyPetNews") forState:UIControlStateNormal];
            }
        }
        task=nil;
    }];
    
}

-(void)retryButtonClick{
    [self.pullToRefreshView triggerRefresh:YES];
    
}

-(void)noButtonClick{
    ActivatyEditMainViewController* controller=[[ActivatyEditMainViewController alloc] init];
    
    PetNewsNavigationController* navController=[[PetNewsNavigationController alloc] initWithRootViewController:controller];
    [controller release];
    [[AppDelegate appDelegate].rootViewController presentModalViewController:navController animated:YES];
    
    [navController release];
    
}

@end
