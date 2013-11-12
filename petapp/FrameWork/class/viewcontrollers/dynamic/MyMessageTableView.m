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
#import "UserProfileView.h"
#import "DataCenter.h"

#import "PetNewsEditViewController.h"
#import "PetNewsNavigationController.h"
#import "ContactDetailViewController.h"
#import "Utils.h"

@interface MyMessageTableView()<UITableViewDataSource,UITableViewDelegate,UserProfileViewDelegate>

-(void)initHeader;
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
    [profileView release];
    [bgView release];
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
        return [MessageCell height];
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
        MessageCell *cell = (MessageCell*)[_tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell == nil){
            cell = [[[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
        }
        
        MessageModel* model=[list objectAtIndex:[indexPath row]-1];
        [cell headUrl:model.friendUser.imageHeadUrl];
        [cell title:model.friendUser.nickname];
        [cell content:model.content];
        [cell date:model.createdate];
        
        
        return cell;
    }

}


-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([indexPath row]>0){
        MessageModel* model=[list objectAtIndex:[indexPath row]-1];

        ContactDetailViewController* controller=[[ContactDetailViewController alloc] init];
        controller.title=model.friendUser.nickname;
        controller.uid=model.friendUser.uid;
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
    [profileView showAddPetNew:NO];

  //  if([Utils isIPad])
        [profileView allWhite];

}

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
