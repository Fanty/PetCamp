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
#import "AppDelegate.h"
#import "PetNewsAndActivatyManager.h"
#import "AlertUtils.h"
#import "PetNewsEditViewController.h"
#import "PetNewsDetailViewController.h"
#import "PetNewsNavigationController.h"
#import "GTGZThemeManager.h"
#import "UserProfileView.h"
#import "DataCenter.h"
#import "Utils.h"

@interface MyPetNewsTableView()<UITableViewDataSource,UITableViewDelegate,UserProfileViewDelegate>
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
    [bgView release];
    [profileView release];
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
        return CGRectGetMaxY(profileView.frame);
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
        [cell addSubview:bgView];
        [cell addSubview:profileView];
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


#pragma mark method

-(void)initHeader{
    if(bgView!=nil)return;
    bgView=[[UIImageView alloc] initWithImage:[[GTGZThemeManager sharedInstance] imageByTheme:@"default_myprofile.png"]];
    bgView.contentMode=UIViewContentModeTop;
    bgView.clipsToBounds=YES;
    CGRect rect=bgView.frame;
    if(![Utils isIPad])
        rect.size.height=180.0f;
    bgView.frame=rect;
    
    profileView=[[UserProfileView alloc] initWithFrame:CGRectMake(0.0f, ([Utils isIPad]?bgView.frame.size.height-120.0f:115.0f), self.frame.size.width, 0.0f)];
    profileView.delegate=self;
    [profileView headUrl:[DataCenter sharedInstance].user.imageHeadUrl];
    [profileView title:[DataCenter sharedInstance].user.nickname];
    [profileView desc:[DataCenter sharedInstance].user.person_desc];
    [profileView sex:[DataCenter sharedInstance].user.pet_sex];
    [profileView showAddFriend:NO];
    
 //   if([Utils isIPad])
        [profileView allWhite];

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
    PetNewsEditViewController* controller=[[PetNewsEditViewController alloc] init];
    PetNewsNavigationController* navController=[[PetNewsNavigationController alloc] initWithRootViewController:controller];
    [controller release];
    [[AppDelegate appDelegate].rootViewController presentModalViewController:navController animated:YES];
    
    [navController release];

}

@end
