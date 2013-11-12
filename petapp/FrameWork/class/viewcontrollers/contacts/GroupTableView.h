//
//  GroupTableView.h
//  PetNews
//
//  Created by fanty on 13-8-7.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "PullTableView.h"
@class AsyncTask;

@interface GroupTableView : PullTableView{
    NSMutableArray* list;
    NSMutableArray* showList;
    AsyncTask* task;

}
@property(assign,nonatomic) UIViewController* parentViewController;

-(void)clear;

-(void)search:(NSString*)title;

@end
