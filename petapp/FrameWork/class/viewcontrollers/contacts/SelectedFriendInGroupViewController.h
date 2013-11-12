//
//  SelectedFriendInGroupViewController.h
//  PetNews
//
//  Created by apple2310 on 13-9-13.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "NavContentViewController.h"
@class PullTableView;
@class AsyncTask;
@interface SelectedFriendInGroupViewController : NavContentViewController{
    NSArray *sortedKeys;
    NSMutableDictionary* dicts;
    NSMutableDictionary* showDicts;
    NSMutableArray* selectedArray;
    AsyncTask* task;
    
    UISearchBar* searchBar;
    
    UIButton* fliterBg;
    
    PullTableView* tableView;

    UIActivityIndicatorView* loadingView;
    
}
@property(nonatomic,retain) NSString* groupId;
@property(nonatomic,retain) NSArray* existsFriends;

@end
