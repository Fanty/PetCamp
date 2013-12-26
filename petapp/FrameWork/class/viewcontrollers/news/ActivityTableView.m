//
//  ActivityTableView.m
//  PetNews
//
//  Created by fanty on 13-8-6.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "ActivityTableView.h"
#import "AsyncTask.h"
#import "PullToRefresh.h"
#import "ActivatyModel.h"
#import "PetUser.h"
#import "ActivityDetailViewController.h"
#import "ImageViewer.h"
#import "BannerModel.h"
#import "GTGZThemeManager.h"
#import "ActivatyCell.h"
#import "AppDelegate.h"
#import "PetNewsAndActivatyManager.h"
#import "GTGZImageDownloadedView.h"
#import "AlertUtils.h"
#import "DataCenter.h"
#import "NoCell.h"
#import "ContactDetailViewController.h"
#import "PetNewsViewController.h"
#import "Utils.h"
#define   BANNER_HEIGHT   206.0f
#define   IPAD_BANNER_HEIGHT  458.0f


@interface ActivityTableView()<UITableViewDataSource,UITableViewDelegate,ActivatyCellDelegate,ImageViewerDelegate>
-(void)initBanner;
-(void)loadData:(BOOL)loadMore;
-(void)updateNotification;
@end

@implementation ActivityTableView
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
    [carouselBanner release];

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
        return [list count]+1;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([list count]<1 && task==nil){
        return 44.0f;
    }
    else{
        if([indexPath row]==0){
            [self initBanner];
            return carouselBanner.frame.size.height;
        }
        else{
            return [ActivatyCell height];
        }
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
        if([indexPath row]==0){
            UITableViewCell* cell=[_tableView dequeueReusableCellWithIdentifier:@"firstcell"];
            if(cell==nil){
                cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"firstcell"] autorelease];
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
            [self initBanner];
            [cell addSubview:carouselBanner];
            return cell;
        }
        else{
            ActivatyCell *cell = (ActivatyCell*)[_tableView dequeueReusableCellWithIdentifier:@"cell"];
            if(cell == nil){
                cell = [[[ActivatyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
            cell.tag=[indexPath row]-1;
            cell.delegate=self;
            ActivatyModel* model=[list objectAtIndex:[indexPath row]-1];
            
            [cell headUrl:model.petUser.imageHeadUrl];
            [cell title:model.petUser.nickname];
            [cell desc:model.title];
            [cell laud:model.activate_count];
            
            return cell;
        }
    }
}


-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([list count]<1 && task==nil){
        [self.pullToRefreshView triggerRefresh:YES];
    }
    else{
        
                
        ActivatyModel* model=[list objectAtIndex:[indexPath row]-1];
        
        ActivityDetailViewController* controller=[[ActivityDetailViewController alloc] init];
        controller.aid=model.aid;
        controller.contentTitle=model.title;
        [self.parentViewController checkIsLoginAndPushTempViewController:controller];
        [controller release];
    }

}

#pragma mark activaty table cell delegate

-(void)activatyCellDelegate:(ActivatyCell*)cell{
    ActivatyModel* model=[list objectAtIndex:cell.tag];
    [parentViewController redirectToContactDetailPage:model.petUser.nickname uid:model.petUser.uid];
}

#pragma mark imageview delegate

-(void)didImageViewerSelected:(ImageViewer*)imageViewer index:(int)index{
    BannerModel* bannerModel=[imageViewer.list objectAtIndex:index];
    if([bannerModel.target_id length]>0){
        ActivityDetailViewController* controller=[[ActivityDetailViewController alloc] init];
        controller.aid=bannerModel.target_id;
//        controller.contentTitle=model.title;
        [self.parentViewController checkIsLoginAndPushTempViewController:controller];
        [controller release];

        return;
    }
    else if([bannerModel.link length]>0){
        
    }

}


#pragma mark method

-(void)updateNotification{
    [self.pullToRefreshView triggerRefresh:YES];
}


-(void)initBanner{
    if(carouselBanner!=nil)return;
    float bannerHeight=([Utils isIPad]?IPAD_BANNER_HEIGHT:BANNER_HEIGHT);

    carouselBanner=[[ImageViewer alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, [[DataCenter sharedInstance].activatyBannerList count]>0?bannerHeight:0.0f)];
    carouselBanner.delegate=self;
    [carouselBanner setList:[DataCenter sharedInstance].activatyBannerList];

}



-(void)clear{
    [task cancel];
    task=nil;
    [self releasePullToRefresh];
}

-(void)updateBanner{
    [carouselBanner setList:[DataCenter sharedInstance].activatyBannerList];
    float bannerHeight=([Utils isIPad]?IPAD_BANNER_HEIGHT:BANNER_HEIGHT);

    CGRect rect=carouselBanner.frame;
    rect.size.height=[[DataCenter sharedInstance].activatyBannerList count]>0?bannerHeight:0.0f;
    carouselBanner.frame=rect;
    
    
    NSIndexPath* path=[NSIndexPath indexPathForRow:0 inSection:0];
    [self reloadRowsAtIndexPaths:[NSArray arrayWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationBottom];
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
    
    task=[[AppDelegate appDelegate].petNewsAndActivatyManager activityList:temp_pageOffset];
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

            if(!loadMore && [list count]>0 && !dataCenter.showUpdateActivaty){
                ActivatyModel* model=[list objectAtIndex:0];
                NSString* compareId=model.aid;
                if(![compareId isEqualToString:dataCenter.lastestUpdateActivatyId]){
                    dataCenter.lastestUpdateActivatyId=compareId;
                    dataCenter.showUpdateActivaty=YES;
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
