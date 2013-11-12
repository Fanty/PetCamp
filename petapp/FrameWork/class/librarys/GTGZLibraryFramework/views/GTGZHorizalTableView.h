//
//  GTGZHorizalTableView.h
//  GTGZLibrary
//
//  Created by fanty on 13-4-23.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "GTGZScroller.h"

@class GTGZHorizalTableView;

@interface GTGZHorizalTableViewCell:UIButton{
    
}
@end


@protocol GTGZHorizalTableViewDataSource <NSObject>
@required
- (GTGZHorizalTableViewCell *)dataView:(GTGZHorizalTableView *)tableView rowIndex:(int)rowIndex;
-(int)dataViewRowsCount:(GTGZHorizalTableView*)tableView;
@optional
-(float)dataViewWidth:(GTGZHorizalTableView*)tableView rowIndex:(int)rowIndex;
-(void)dataViewWillBegin:(GTGZHorizalTableView*)tableView decelerating:(BOOL)decelerating;
-(void)dataViewScrolling:(GTGZHorizalTableView*)tableView;
-(void)dataViewEndDraging:(GTGZHorizalTableView*)tableView;
@end


@interface GTGZHorizalTableView : GTGZScrollView{
    NSMutableArray*  cells;
    int pageIndex;
    int pageCount;
    NSTimer* delayReloadTimer;
    
    float lastestPointX;
    BOOL leftOrRight;
}
@property(nonatomic,assign) id<GTGZHorizalTableViewDataSource> dataSource;
-(void)reloadData;
-(GTGZHorizalTableViewCell*)dequeueReusableCell;
-(GTGZHorizalTableViewCell*)cellForRowIndex:(int)rowIndex;
@end

