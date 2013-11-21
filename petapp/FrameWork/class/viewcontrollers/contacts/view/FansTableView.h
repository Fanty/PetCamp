//
//  FansTableView.h
//  PetNews
//
//  Created by Fanty on 13-11-18.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "PullTableView.h"
@class AsyncTask;

@interface FansTableView : PullTableView{
    NSMutableArray* list;
    NSMutableArray* showList;
    AsyncTask* task;
}
@property(assign,nonatomic) UIViewController* parentViewController;

-(void)clear;

-(void)search:(NSString*)title;

@end
