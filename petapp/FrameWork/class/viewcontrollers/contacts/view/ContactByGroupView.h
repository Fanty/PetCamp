//
//  ContactTableView.h
//  PetNews
//
//  Created by fanty on 13-8-7.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "PullTableView.h"

@class AsyncTask;

@interface ContactByGroupView : PullTableView{
    NSArray* list;
    AsyncTask* task;
    
}
@property(assign,nonatomic) UIViewController* parentViewController;
@property(nonatomic,retain) NSString* groupId;

-(void)clear;
-(void)triggerRefresh;
-(void)loadData;

-(NSArray*)contacts;

@end
