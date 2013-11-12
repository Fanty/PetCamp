//
//  PullTableView.h
//  PetNews
//
//  Created by fanty on 13-2-26.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTGZScroller.h"

typedef enum {
    PullTableViewLoadMoreStateNone = 0,
	PullTableViewLoadMoreStateDragUp,
    PullTableViewLoadMoreStateDragStartLoad,
    PullTableViewLoadMoreStateDragLoading,
}PullTableViewLoadMoreState;


@interface  PullTableView : GTGZTableView
@property(nonatomic,assign) PullTableViewLoadMoreState loadMoreState;
-(void)createLoadMoreFooter;
-(void)releaseLoadMoreFooter;
-(void)checkLoadMoreScrollingState;

@end

