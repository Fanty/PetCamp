//
//  SearchFGViewController.h
//  PetNews
//
//  Created by fanty on 13-8-22.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "NavContentViewController.h"
@class PullTableView;
@class AsyncTask;
@interface SearchFGViewController : NavContentViewController{
    UISearchBar* searchBar;

    PullTableView* tableView;
    
    NSMutableArray*  list;
    
    AsyncTask* task;
    
    int pageOffset;

}


@property(nonatomic,assign) BOOL isSearchGroup;

@end
