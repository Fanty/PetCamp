//
//  MarketTableView.h
//  PetNews
//
//  Created by Grace Lai on 8/8/13.
//  Copyright (c) 2013 fanty. All rights reserved.
//

#import "PullTableView.h"

@class AsyncTask;
@class BaseViewController;
@interface MarketTableView : PullTableView{
    NSMutableArray* list;
    AsyncTask* task;
    
    int pageOffset;

}

@property(nonatomic,retain) NSString* type_id;

@property(assign,nonatomic) BaseViewController* parentViewController;

-(void)clear;

-(void)triggerRefresh;

@end
