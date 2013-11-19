//
//  MarketTableView.m
//  PetNews
//
//  Created by Grace Lai on 8/8/13.
//  Copyright (c) 2013 fanty. All rights reserved.
//

#import "MarketTableView.h"
#import "AsyncTask.h"
#import "PullToRefresh.h"
#import "ChoiceBigView.h"
#import "ChoiceModel.h"
#import "MarketWebViewController.h"

#import "AppDelegate.h"
#import "MarketManager.h"
#import "NoCell.h"
#import "AlertUtils.h"
#import "BaseViewController.h"

#define  CELL_TAG   233

@interface MarketTableView() <UITableViewDataSource,UITableViewDelegate>

-(void)loadData:(BOOL)loadMore;

-(void)marketClick:(ChoiceBigView*)view;

@end

@implementation MarketTableView

@synthesize type_id;
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
    }
    return self;
}

-(void)triggerRefresh{
    [self.pullToRefreshView triggerRefresh:YES];

}

-(void)dealloc{
    self.type_id=nil;
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
    
    task=[[AppDelegate appDelegate].marketManager storeItemList:self.type_id offset:temp_pageOffset];
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
    else{
        int count=[list count]/2;
        if(count*2<[list count])
            count++;
        return count;
    }
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([list count]<1 && task==nil){
        return 44.0f;
    }
    else{
        return [ChoiceBigView height];
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
        UITableViewCell *cell = (UITableViewCell*)[_tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell == nil){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
            cell.accessoryType=UITableViewCellAccessoryNone;
            
        }
        
        ChoiceBigView* view1=(ChoiceBigView*)[cell viewWithTag:CELL_TAG];
        if(view1==nil){
            view1=[[ChoiceBigView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.frame.size.width*0.5f, [ChoiceBigView height])];
            view1.tag=CELL_TAG;
            [view1 addTarget:self action:@selector(marketClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:view1];
            [view1 release];
        }
        ChoiceBigView* view2=(ChoiceBigView*)[cell viewWithTag:CELL_TAG+1];
        if(view2==nil){
            view2=[[ChoiceBigView alloc] initWithFrame:CGRectMake(_tableView.frame.size.width*0.5f, 0.0f, _tableView.frame.size.width*0.5f, [ChoiceBigView height])];
            view2.tag=CELL_TAG+1;
            [view2 addTarget:self action:@selector(marketClick:) forControlEvents:UIControlEventTouchUpInside];

            [cell addSubview:view2];
            [view2 release];
        }
        view2.hidden=YES;
        int index=([indexPath row])*2;
        
        ChoiceModel* model=[list objectAtIndex:index];
        view1.index=index;
        [view1 headUrl:model.imageUrl];
        [view1 title:model.title];
        [view1 shopTitle:model.sold_count];
        [view1 setPriceLabel:model.price];
        
        index++;
        if(index<[list count]){
            model=[list objectAtIndex:index];
            view2.hidden=NO;
            view2.index=index;
            [view2 headUrl:model.imageUrl];
            [view2 title:model.title];
            [view2 shopTitle:model.sold_count];
            [view2 setPriceLabel:model.price];
            
        }
        
        return cell;
    }
}


-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([list count]<1 && task==nil){
        [self.pullToRefreshView triggerRefresh:YES];
    }
    else{
    }
    
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
