//
//  PetNewsTableView.m
//  PetNews
//
//  Created by fanty on 13-8-6.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "PetNewsTableView.h"
#import "AsyncTask.h"
#import "PullToRefresh.h"
#import "PetCell.h"
#import "PetNewsModel.h"
#import "PetUser.h"
#import "PetNewsDetailViewController.h"
#import "GTGZThemeManager.h"
#import "GTGZImageDownloadedView.h"
#import "PetNewsAndActivatyManager.h"
#import "AppDelegate.h"
#import "AlertUtils.h"
#import "DataCenter.h"
#import "NoCell.h"
#import "BaseViewController.h"
#import "ContactDetailViewController.h"
#import "DataCenter.h"
#import "PetNewsViewController.h"

#import "Utils.h"
#define   BANNER_HEIGHT   120.0f
#define   IPAD_BANNER_HEIGHT  326.0f

@interface PetNewsTableView()<UITableViewDataSource,UITableViewDelegate,PetCellDelegate>
-(void)loadData:(BOOL)loadMore;
-(void)updateNotification;
@end

@implementation PetNewsTableView
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
        return [PetCell height];
    
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
        PetCell *cell = (PetCell*)[_tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell == nil){
            cell = [[[PetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        cell.delegate=self;
        cell.tag=[indexPath row];
        PetNewsModel* model=[list objectAtIndex:[indexPath row]];
        
        [cell headUrl:model.petUser.imageHeadUrl];
        [cell nickName:model.petUser.nickname];
        if([model.scr_post.desc length]>0){
            NSString* content=model.desc;
            if([content length]>0)
                content=[content stringByAppendingString:@" "];
            content=[content stringByAppendingString:[NSString stringWithFormat:lang(@"forward_content"),model.scr_post.petUser.nickname,model.scr_post.desc]];
            [cell content:content];
        }
        else{
            [cell content:model.desc];
        }
        [cell createDate:model.createdate];
        [cell like:model.laudCount comment:model.command_count];
        [cell images:model.imageUrls];
        return cell;
    }
}


-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([list count]<1 && task==nil){
        [self.pullToRefreshView triggerRefresh:YES];
    }
    else{
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        PetNewsModel* model=[list objectAtIndex:[indexPath row]];
        
        PetNewsDetailViewController* controller=[[PetNewsDetailViewController alloc] init];
        controller.pid=model.pid;
        [self.parentViewController checkIsLoginAndPushTempViewController:controller];
        [controller release];
    }
}


#pragma mark petcell delegate

-(void)petCellDidClickUserHeader:(PetCell*)cell{
    PetNewsModel* model=[list objectAtIndex:cell.tag];
    [parentViewController redirectToContactDetailPage:model.petUser.nickname uid:model.petUser.uid];
}



#pragma mark method

-(void)updateNotification{
    [self.pullToRefreshView triggerRefresh:YES];
    
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
    
    task=[[AppDelegate appDelegate].petNewsAndActivatyManager petNewsList:temp_pageOffset];
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
            
            DataCenter* dataCenter=[DataCenter sharedInstance];

            if(!loadMore && [list count]>0 && !dataCenter.showUpdatePetNews){
                PetNewsModel* model=[list objectAtIndex:0];
                NSString* compareId=model.pid;
                if(![compareId isEqualToString:dataCenter.lastestUpdatePetNewsId]){
                    dataCenter.lastestUpdatePetNewsId=compareId;
                    dataCenter.showUpdatePetNews=YES;
                }
                [parentViewController updateIcon];
                [dataCenter save];
            }
        }
        task=nil;
        [self reloadData];

    }];

}

@end
