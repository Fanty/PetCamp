//
//  ContactDetailViewController.h
//  PetNews
//
//  Created by fanty on 13-8-14.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "NavContentViewController.h"
@class AsyncTask;
@class PullTableView;
@class UserProfileView;
@class PetUser;
@class WriterView;
@interface ContactDetailViewController : NavContentViewController{
    UIActivityIndicatorView* loadingView;
    UserProfileView* profileView;
    PullTableView* tableView;
    AsyncTask* task;
    UIButton* noLabelButton;
    
    NSMutableArray* list;

    PetUser* petUser;
    int offset;
    
    WriterView* writerView;
}

@property(nonatomic,retain) NSString* uid;

@end
