//
//  MyPetNewsTableView.m
//  PetNews
//
//  Created by fanty on 13-8-15.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "MyPetNewsTableView.h"
#import "AsyncTask.h"
#import "PullToRefresh.h"
#import "PetCell.h"
#import "PetNewsModel.h"
#import "PetUser.h"
#import "ProfileTab.h"
#import "AppDelegate.h"
#import "PetNewsAndActivatyManager.h"
#import "AlertUtils.h"
#import "PetNewsEditViewController.h"
#import "PetNewsDetailViewController.h"
#import "PetNewsNavigationController.h"
#import "MyListsViewController.h"
#import "GTGZThemeManager.h"
#import "UserProfileView.h"
#import "DataCenter.h"
#import "Utils.h"

@interface MyPetNewsTableView()<UITableViewDataSource,UITableViewDelegate,UserProfileViewDelegate,ProfileTabDelegate>
-(void)initHeader;
-(void)loadData:(BOOL)loadMore;
-(void)retryButtonClick;
-(void)noButtonClick;
-(void)updateNotification;
@end

@implementation MyPetNewsTableView
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotification) name:UpdatePetNewsListNotification object:nil];
        
    }
    return self;
}

-(void)dealloc{
    [profileView release];
    [profileTab release];
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
    
    return [list count]+1;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row]==0){
        [self initHeader];
        return CGRectGetMaxY(profileTab.frame);
    }
    else{
        return [PetCell height];
    }
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row]==0){
        UITableViewCell* cell=[_tableView dequeueReusableCellWithIdentifier:@"first_cell"];
        if(cell==nil){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"first_cell"] autorelease];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        [self initHeader];
        
        [profileView headUrl:[DataCenter sharedInstance].user.imageHeadUrl];
        [profileView title:[DataCenter sharedInstance].user.nickname];
        [profileView desc:[DataCenter sharedInstance].user.person_desc];
        [profileView sex:[DataCenter sharedInstance].user.sex];
        [profileView showAddPetNew];
        
        
        [profileTab petNumber:0 friendNumber:0 fansNumber:0 addNumber:0 messageNumber:0];

        [cell addSubview:profileView];
        [cell addSubview:profileTab];
        return cell;
    }
    else{
        PetCell *cell = (PetCell*)[_tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell == nil){
            cell = [[[PetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        
        PetNewsModel* model=[list objectAtIndex:[indexPath row]-1];
        
        [cell headUrl:model.petUser.imageHeadUrl];
        [cell nickName:model.petUser.nickname];
        [cell content:model.desc];
        [cell like:model.laudCount comment:model.command_count];
        [cell createDate:model.createdate];
        //[cell images:[NSArray arrayWithObjects:model.petUser.imageHeadUrl,model.petUser.imageHeadUrl,model.petUser.imageHeadUrl,model.petUser.imageHeadUrl, nil]];

        return cell;
    }
    
}


-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([indexPath row]>0){
        PetNewsModel* model=[list objectAtIndex:[indexPath row]-1];
        
        PetNewsDetailViewController* controller=[[PetNewsDetailViewController alloc] init];
        controller.pid=model.pid;
        
        [self.parentViewController.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}


#pragma mark  userprofile delegate

-(void)profileDidSendPetNews:(UserProfileView *)profileView{
    PetNewsEditViewController* controller=[[PetNewsEditViewController alloc] init];
    PetNewsNavigationController* navController=[[PetNewsNavigationController alloc] initWithRootViewController:controller];
    [controller release];
    [[AppDelegate appDelegate].rootViewController presentModalViewController:navController animated:YES];
    
    [navController release];
    
}

#pragma mark profiletab delegate

-(void)profileTab:(ProfileTab *)profileTab click:(int)clickIndex{
    if(clickIndex>0){
        MyListsViewController* controller=[[MyListsViewController alloc] init];
        controller.showIndex=clickIndex;
        [self.parentViewController.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}


#pragma mark method

-(void)initHeader{
    if(profileView!=nil)return;

    
    profileView=[[UserProfileView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 0.0f)];
    profileView.delegate=self;
    
    profileTab=[[ProfileTab alloc] init];
    profileTab.delegate=self;
    
    CGRect rect=profileTab.frame;
    rect.origin.y=CGRectGetMaxY(profileView.frame);
    profileTab.frame=rect;

}

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

    task=[[AppDelegate appDelegate].petNewsAndActivatyManager myPetNewsList];
    [task setFinishBlock:^{
        [self.pullToRefreshView stopAnimating];
        self.loadMoreState=PullTableViewLoadMoreStateNone;
        
        if([task result]==nil){
            [self releaseLoadMoreFooter];
        }
        else{
            
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

-(void)retryButtonClick{
    [self.pullToRefreshView triggerRefresh:YES];

}

-(void)noButtonClick{
    PetNewsEditViewController* controller=[[PetNewsEditViewController alloc] init];
    PetNewsNavigationController* navController=[[PetNewsNavigationController alloc] initWithRootViewController:controller];
    [controller release];
    [[AppDelegate appDelegate].rootViewController presentModalViewController:navController animated:YES];
    
    [navController release];

}

@end
