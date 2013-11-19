//
//  MarketTypeListViewController.h
//  PetNews
//
//  Created by Fanty on 13-11-17.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "NavContentViewController.h"
@class PullTableView;
@class AsyncTask;
@interface MarketTypeListViewController : NavContentViewController{
    PullTableView* tableView;
    NSArray* list;
    AsyncTask* task;

    BOOL first;
}

@end
