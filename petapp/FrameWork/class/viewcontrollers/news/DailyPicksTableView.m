//
//  DailyPicksTableView.m
//  PetNews
//
//  Created by fanty on 13-8-6.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "DailyPicksTableView.h"
#import "AsyncTask.h"
#import "PullToRefresh.h"
#import "ChoiceBigView.h"
#import "ChoiceModel.h"
#import "MarketWebViewController.h"
#import "ImageViewer.h"
#import "BannerModel.h"
#import "GTGZThemeManager.h"
#import "GTGZImageDownloadedView.h"
#import "DataCenter.h"
#import "NoCell.h"
#import "MarketManager.h"
#import "AppDelegate.h"
#import "AlertUtils.h"
#import "BaseViewController.h"
#import "Utils.h"
#define   BANNER_HEIGHT   120.0f
#define   IPAD_BANNER_HEIGHT  326.0f
#define  CELL_TAG   233

@interface DailyPicksTableView()<UITableViewDataSource,UITableViewDelegate,ImageViewerDelegate>
-(void)initBanner;
-(void)loadData;

-(void)marketClick:(ChoiceBigView*)view;

@end


@implementation DailyPicksTableView
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
    }
    return self;
}


-(void)dealloc{
    [carouselBanner release];

    [list release];
    [task cancel];
    
    [super dealloc];
}

#pragma mark method

-(void)clear{
    [task cancel];
    task=nil;
    [self releasePullToRefresh];
}



-(void)initBanner{
    if(carouselBanner!=nil)return;
    float bannerHeight=([Utils isIPad]?IPAD_BANNER_HEIGHT:BANNER_HEIGHT);

    carouselBanner=[[ImageViewer alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, [[DataCenter sharedInstance].marketBannerList count]>0?bannerHeight:0.0f)];
    carouselBanner.delegate=self;
    [carouselBanner setList:[DataCenter sharedInstance].marketBannerList];

}

-(void)updateBanner{
    float bannerHeight=([Utils isIPad]?IPAD_BANNER_HEIGHT:BANNER_HEIGHT);

    [carouselBanner setList:[DataCenter sharedInstance].marketBannerList];
    
    CGRect rect=carouselBanner.frame;
    rect.size.height=[[DataCenter sharedInstance].marketBannerList count]>0?bannerHeight:0.0f;
    carouselBanner.frame=rect;
    
    NSIndexPath* path=[NSIndexPath indexPathForRow:0 inSection:0];
    [self reloadRowsAtIndexPaths:[NSArray arrayWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationBottom];
}


-(void)loadData{
    [task cancel];
    
    NSDate* date = [NSDate date];
    [self.pullToRefreshView setLastUpdatedDate:date];
    
    task=[[AppDelegate appDelegate].marketManager storeItemList:0];
    [task setFinishBlock:^{
        [self.pullToRefreshView stopAnimating];
        self.loadMoreState=PullTableViewLoadMoreStateNone;
        
        if([task result]==nil){
            if(![task status]){
                [AlertUtils showAlert:[task errorMessage] view:self];
            }

        }
        else{
            NSArray* array=[task result];
            
            if(list==nil){
                list=[[NSMutableArray alloc] initWithCapacity:2];
            }
            if([array count]>0){
                [list removeAllObjects];
                [list addObjectsFromArray:array];
            }
        }
        task=nil;
        [self reloadData];
        
    }];
    
}

#pragma mark table delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(task==nil && self.dragging && !self.decelerating)
        [self checkLoadMoreScrollingState];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(task==nil && self.loadMoreState==PullTableViewLoadMoreStateDragStartLoad){
        self.loadMoreState=PullTableViewLoadMoreStateDragLoading;
        [self loadData];
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
    else{
        int count=[list count]/2;
        if(count*2<[list count])
            count++;
        return count+1;
    }
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
            return [ChoiceBigView height];
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
            UITableViewCell *cell = (UITableViewCell*)[_tableView dequeueReusableCellWithIdentifier:@"cell"];
            if(cell == nil){
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
                cell.accessoryType=UITableViewCellAccessoryNone;

            }
            
            
            ChoiceBigView* view1=(ChoiceBigView*)[cell viewWithTag:CELL_TAG];
            if(view1==nil){
                view1=[[ChoiceBigView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.frame.size.width*0.5f, [ChoiceBigView height])];
                [view1 addTarget:self action:@selector(marketClick:) forControlEvents:UIControlEventTouchUpInside];
                view1.tag=CELL_TAG;
                [cell addSubview:view1];
                [view1 release];
            }
            ChoiceBigView* view2=(ChoiceBigView*)[cell viewWithTag:CELL_TAG+1];
            if(view2==nil){
                view2=[[ChoiceBigView alloc] initWithFrame:CGRectMake(_tableView.frame.size.width*0.5f, 0.0f, _tableView.frame.size.width*0.5f, [ChoiceBigView height])];
                [view2 addTarget:self action:@selector(marketClick:) forControlEvents:UIControlEventTouchUpInside];
                view2.tag=CELL_TAG+1;
                [cell addSubview:view2];
                [view2 release];
            }
            view2.hidden=YES;
            int index=([indexPath row]-1)*2;
            
            ChoiceModel* model=[list objectAtIndex:index];
            view1.index=index;
            [view1 headUrl:model.imageUrl];
            [view1 title:model.title];
            [view1 shopTitle:model.type];
            [view1 setPriceLabel:model.price];
            
            index++;
            if(index<[list count]){
                model=[list objectAtIndex:index];
                view2.hidden=NO;
                view2.index=index;
                [view2 headUrl:model.imageUrl];
                [view2 title:model.title];
                [view2 shopTitle:model.type];
                [view2 setPriceLabel:model.price];

            }
            
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
        ChoiceModel* model=[list objectAtIndex:[indexPath row]-1];
        
        MarketWebViewController* controller=[[MarketWebViewController alloc] init];
        controller.url=model.link;
        controller.title=model.title;
        [self.parentViewController.navigationController pushViewController:controller animated:YES];
        [controller release];
        
        
        [[AppDelegate appDelegate].marketManager addStoreItemPageview:model.mid];
    }
    
}

#pragma mark imageview delegate

-(void)didImageViewerSelected:(ImageViewer*)imageViewer index:(int)index{
    BannerModel* model=[imageViewer.list objectAtIndex:index];
    MarketWebViewController* controller=[[MarketWebViewController alloc] init];
    controller.url=model.link;
    controller.title=lang(@"daily_specials");
    [self.parentViewController.navigationController pushViewController:controller animated:YES];
    [controller release];

}

-(void)marketClick:(ChoiceBigView*)view{
    ChoiceModel* model=[list objectAtIndex:view.index];
    MarketWebViewController* controller=[[MarketWebViewController alloc] init];
    controller.url=model.link;
    controller.title=model.title;
    [self.parentViewController.navigationController pushViewController:controller animated:YES];
    [controller release];
    
    [[AppDelegate appDelegate].marketManager addStoreItemPageview:model.mid];
    
    
}



@end
