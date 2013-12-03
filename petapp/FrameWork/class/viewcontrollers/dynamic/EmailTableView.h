//
//  EmailTableView.h
//  PetNews
//
//  Created by Fanty on 13-11-24.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "PullTableView.h"


@class AsyncTask;

@interface EmailTableView : PullTableView{
    NSMutableArray* list;
    AsyncTask* task;
    int pageOffset;
}


@property(assign,nonatomic) UIViewController* parentViewController;

-(void)clear;

@end
